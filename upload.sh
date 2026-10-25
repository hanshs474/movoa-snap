#!/bin/sh
# Push + release build/movoa_0.1.0_{amd64,arm64}.snap to the stable channel.
# Needs the Ubuntu One login of the Snap Store account that owns the name "movoa":
#   UBUNTU_ONE_EMAIL=... UBUNTU_ONE_PASSWORD=... [UBUNTU_ONE_OTP=123456] ./upload.sh
# Runs in the local node:22-alpine image (pulling python images can hang here).
set -e
[ -f build/movoa_0.1.0_amd64.snap ] || ./build.sh
docker run --rm -e UBUNTU_ONE_EMAIL -e UBUNTU_ONE_PASSWORD -e UBUNTU_ONE_OTP \
  -v "$PWD/build:/b" -v "$PWD/upload.py:/upload.py" node:22-alpine \
  sh -c 'apk add -q python3 py3-pip >/dev/null && pip install -q --break-system-packages --root-user-action=ignore craft-store && python3 /upload.py'
