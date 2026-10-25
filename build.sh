#!/bin/sh
# Pack the movoa CLI (the Go source in movoa-docker) into one snap per architecture.
# No snapcraft or LXD: cross-compile with go, write meta/snap.yaml, mksquashfs in a container.
#   SRC=path/to/movoa-docker ./build.sh   (default ../movoa-docker; cloned from GitHub if absent)
set -e
cd "$(dirname "$0")"
V=0.1.0
SRC=${SRC:-../movoa-docker}
[ -f "$SRC/main.go" ] || { SRC=build/src; rm -rf "$SRC"; git clone -q --depth 1 https://github.com/hanshs474/movoa-docker "$SRC"; }
SRC=$(cd "$SRC" && pwd)
rm -rf build/amd64 build/arm64 build/*.snap
for a in amd64 arm64; do
  mkdir -p build/$a/meta build/$a/bin
  sed -e "s/ARCH/$a/" -e "s/VERSION/$V/" snap.yaml > build/$a/meta/snap.yaml
  (cd "$SRC" && CGO_ENABLED=0 GOOS=linux GOARCH=$a go build -trimpath -ldflags "-s -w" -o "$OLDPWD/build/$a/bin/movoa" .)
  chmod 755 build/$a/bin/movoa
done
docker run --rm -v "$PWD/build:/b" node:22-alpine sh -c 'apk add -q squashfs-tools &&
  for a in amd64 arm64; do mksquashfs /b/$a /b/movoa_'$V'_$a.snap -noappend -comp xz -all-root -no-xattrs -no-fragments -quiet; done'
ls -la build/*.snap
