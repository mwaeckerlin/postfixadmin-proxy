# Changelog

- 2026-10-23 **1.11.1**
    - The version line 1 is built and published again as `mwaeckerlin/postfixadmin-proxy:1`, for amd64 and arm64, on every push to the branch `1` and every week from the run on master, so it gets the security fixes of its base image
    - A test checks that the image contains no shell, busybox or perl, starts, hands PHP requests for PostfixAdmin to the FastCGI host and answers 404 for a missing file
