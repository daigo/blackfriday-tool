#!/bin/bash
#
# Copyright 2016 The Kubernetes Authors.
# Copyright 2016 Daigo Moriwaki <daigo debian dot org>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Reference: https://github.com/thockin/go-build-template


set -o errexit
set -o nounset
set -o pipefail

if [ -z "${BIN}" ]; then
    echo "BIN must be set"
    exit 1
fi
if [ -z "${PKG}" ]; then
    echo "PKG must be set"
    exit 1
fi
if [ -z "${VERSION}" ]; then
    echo "VERSION must be set"
    exit 1
fi
if [ -z "${TIMESTAMP}" ]; then
    echo "TIMESTAMP must be set"
    exit 1
fi

#export CGO_ENABLED=0

export GIT_COMMITTER_NAME="Daigo Moriwaki"
export GIT_COMMITTER_EMAIL="daigo@debian.org"

go get -t -d ./...
go get golang.org/x/tools/cmd/cover
echo "Build for $GOOS-$GOARCH"
#go install -installsuffix "static" -v -ldflags "-X ${PKG}/pkg/version.VERSION=${VERSION} -X ${PKG}/pkg/version.TIMESTAMP=${TIMESTAMP}" ./...
go install -v -ldflags "-X ${PKG}/pkg/version.VERSION=${VERSION} -X ${PKG}/pkg/version.TIMESTAMP=${TIMESTAMP}" ./...
if [ -d "/go/bin/${GOOS}_${GOARCH}" ]; then
  mv /go/bin/${GOOS}_${GOARCH}/* /go/bin
  rm -rf "/go/bin/${GOOS}_${GOARCH}"
fi
