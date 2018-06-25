# Download rancher-compose
FROM alpine:3.7 AS rancher_compose

ARG RANCHER_COMPOSE_VERSION=0.12.5
ENV RANCHER_COMPOSE_URL=https://releases.rancher.com/compose/v${RANCHER_COMPOSE_VERSION}/rancher-compose-linux-amd64-v${RANCHER_COMPOSE_VERSION}.tar.gz

RUN apk add --no-cache curl
RUN curl -SL "${RANCHER_COMPOSE_URL}" | tar -xzC /tmp
RUN mv /tmp/rancher-compose-v${RANCHER_COMPOSE_VERSION}/rancher-compose /usr/bin/
RUN chmod +x /usr/bin/rancher-compose

# Download rancher CLI
FROM alpine:3.7 AS rancher_cli

ARG RANCHER_CLI_VERSION=0.6.9
ENV RANCHER_CLI_URL=https://releases.rancher.com/cli/v${RANCHER_CLI_VERSION}/rancher-linux-amd64-v${RANCHER_CLI_VERSION}.tar.gz

RUN apk add --no-cache curl
RUN curl -SL "${RANCHER_CLI_URL}" | tar -xzC /tmp
RUN mv /tmp/rancher-v${RANCHER_CLI_VERSION}/rancher /usr/bin/
RUN chmod +x /usr/bin/rancher

# Download jet CLI
FROM alpine:3.7 AS jet

ARG JET_VERSION=1.19.3
ENV JET_URL=https://s3.amazonaws.com/codeship-jet-releases/${JET_VERSION}/jet-linux_amd64_${JET_VERSION}.tar.gz

RUN apk add --no-cache curl
RUN curl -SL "${JET_URL}" | tar -xzC /usr/bin
RUN chmod +x /usr/bin/jet

# Add all CLIs and additional scripts
FROM alpine:3.7

RUN apk add --no-cache ca-certificates expect

COPY --from=rancher_compose /usr/bin/rancher-compose /usr/bin/
COPY --from=rancher_cli /usr/bin/rancher /usr/bin/
COPY --from=jet /usr/bin/jet /usr/bin/
COPY scripts/ /usr/bin/

WORKDIR /workbench
