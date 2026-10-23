#!/usr/bin/env bash
# Serve contract: the image starts nginx and serves PostfixAdmin from
# /app/public, handing PHP to the FastCGI host PHP_FPM_HOST.
#
#   - a PHP request for index.php is passed on to FastCGI: without a
#     PostfixAdmin container the host does not resolve and nginx answers 502;
#     a document root without index.php would answer 404
#   - a missing static asset answers 404
#
# The container runs in a network of its own, so docker's resolver answers the
# missing host at once and nothing outside the runner is asked.
#
# Usage: tests/serve-contract.sh IMAGE

set -uo pipefail

IMAGE="${!#}"
NAME="postfixadmin-proxy-serve-$$"
PASS=0
FAIL=0
declare -a FAILED_NAMES

_pass() { PASS=$((PASS + 1)); echo "  PASS  $1"; }
_fail() { FAIL=$((FAIL + 1)); FAILED_NAMES+=("$1"); echo "  FAIL  $1: $2"; }

_cleanup() {
    docker rm -f "${NAME}" > /dev/null 2>&1
    docker network rm "${NAME}" > /dev/null 2>&1
}
trap _cleanup EXIT

_status() {
    curl -s -o /dev/null -w '%{http_code}' --max-time 10 "http://127.0.0.1:${PORT}$1"
}

echo "==> Serve contract: ${IMAGE}"

docker network create "${NAME}" > /dev/null
if ! docker run -d --pull=never --name "${NAME}" --network "${NAME}" -p 127.0.0.1::8080 "${IMAGE}" > /dev/null; then
    _fail "container_starts" "docker run failed"
else
    PORT=$(docker port "${NAME}" 8080/tcp | head -n 1 | sed 's,.*:,,')
    STATUS=000
    for _ in $(seq 1 30); do
        STATUS=$(_status /index.php)
        [[ ${STATUS} != 000 ]] && break
        sleep 1
    done
    if [[ ${STATUS} == 000 ]]; then
        _fail "container_starts" "nginx did not answer within 30 tries: $(docker logs "${NAME}" 2>&1 | tail -n 20)"
    else
        _pass "container_starts"
        if [[ ${STATUS} == 502 ]]; then
            _pass "php_passed_to_fastcgi"
        else
            _fail "php_passed_to_fastcgi" "/index.php answered ${STATUS}, expected 502 without a FastCGI host"
        fi
        STATUS=$(_status /missing-asset.css)
        if [[ ${STATUS} == 404 ]]; then
            _pass "missing_asset_404"
        else
            _fail "missing_asset_404" "/missing-asset.css answered ${STATUS}"
        fi
    fi
fi

echo ""
echo "==> Serve contract results: ${PASS} passed, ${FAIL} failed"
if [[ ${FAIL} -gt 0 ]]; then
    echo "==> Failed contracts: ${FAILED_NAMES[*]}"
    exit 1
fi
