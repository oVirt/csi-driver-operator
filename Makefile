# Image URL to use all building/pushing image targets
IMG ?= quay.io/ovirt/csi-driver-operator:latest

BINDIR=bin
#BINDATA=$(BINDIR)/go-bindata
BINDATA=go-bindata

REV=$(shell git describe --long --tags --match='v*' --always --dirty)

all: build

# Run tests
.PHONY: test
test:
	go test ./pkg/... ./cmd/... -coverprofile cover.out

# Build the binary
.PHONY: build
build:
	go build -o $(BINDIR)/ovirt-csi-operator -ldflags '-X version.Version=$(REV) -extldflags "-static"' github.com/ovirt/csi-driver-operator/cmd/manager


.PHONY: verify
verify: fmt vet

fmt:
	hack/verify-gofmt.sh
vet:
	hack/verify-govet.sh

.PHONY: image
image:
	podman build . -f Dockerfile -t ${IMG}

.PHONY: vendor
vendor:
	go mod tidy
	go mod vendor
	go mod verify

$(BINDATA):
	go build -o $(BINDATA) ./vendor/github.com/jteeuwen/go-bindata
