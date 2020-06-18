FROM registry.svc.ci.openshift.org/openshift/release:golang-1.13 AS builder

WORKDIR /src/ovirt-csi-driver-operator
COPY . .
RUN make build

ENV OPERATOR=/usr/local/bin/ovirt-csi-driver-operator \
    USER_UID=1001 \
    USER_NAME=ovirt-csi-driver-operator

FROM registry.svc.ci.openshift.org/openshift/origin-v4.0:base

COPY --from=builder /src/ovirt-csi-driver-operator/bin/ovirt-csi-driver-operator ${OPERATOR}
COPY --from=builder /src/ovirt-csi-driver-operator/manifests /manifests

USER ${USER_UID}
ENTRYPOINT ["/usr/local/bin/entrypoint"]

