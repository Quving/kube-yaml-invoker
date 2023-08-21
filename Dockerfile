FROM alpine:latest

LABEL maintainer="Vinh Ngu (v.ngu@right-basedonscience.de)"
LABEL createdAt="14.08.2023"
LABEL updatetAt="14.08.2023"

WORKDIR /app

ENV KUBECTL_VERSION="v1.27.4"

# Install dependencies
RUN apk add bash vim curl sudo gettext

# Install kubectl
RUN curl -LO https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl && \
    curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"  && \
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    kubectl version --client

COPY entrypoint.sh .
COPY validate_template_rendering.sh .

CMD ["bash", "entrypoint.sh"]
