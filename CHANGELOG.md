# Changelog

- 2026-10-23 **3.5.2**
    - The version lines 1, 2 and 3 are published as `mwaeckerlin/postfixadmin-proxy:1`, `:2` and `:3` from the branches `1`, `2` and `3`, on every push to them and every week from the run on master, so they get the security fixes of their base image
    - A test starts the image and checks that it hands PHP requests for PostfixAdmin to the FastCGI host and answers 404 for a missing file

- 2026-09-26 **3.5.1**
    - The image is published for amd64 and arm64 under one tag, built, tested and published automatically on every change and every week
    - A test verifies that the shipped image contains no shell, busybox or perl
    - Image build no longer emits warnings (modernized instruction format)
