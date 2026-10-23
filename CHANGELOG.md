# Changelog

- 2026-10-23 **3.5.2**
    - The version line 3 is built and published as `mwaeckerlin/postfixadmin-proxy:3`, for amd64 and arm64, on every push to the branch `3` and every week from the run on master, so it gets the security fixes of its base image
    - A test starts the image and checks that it hands PHP requests for PostfixAdmin to the FastCGI host and answers 404 for a missing file

- 2026-09-26 **3.5.1**
    - The image is published for amd64 and arm64 under one tag, built, tested and published automatically on every change and every week
    - A test verifies that the shipped image contains no shell, busybox or perl
    - Image build no longer emits warnings (modernized instruction format)
