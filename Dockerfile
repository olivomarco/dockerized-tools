FROM alpine:latest

RUN sed -i -e 's/http:\/\/dl-cdn/https:\/\/dl-3/g' /etc/apk/repositories 

RUN apk add ca-certificates curl ansible git wget vim zip gzip mlocate rsync \
  unzip openssl restic jq openssh-client bash bash-completion py3-pip \
  zsh grep sed perl-utils tar coreutils tzdata && \
  apk add --virtual=build gcc libffi-dev musl-dev openssl-dev python3-dev make \ 
  gcc libc-dev libffi-dev openssl-dev perl perl-utils && \
  pip3 --no-cache-dir install -U pip && \
  pip3 --no-cache-dir install azure-cli && \
  pip3 --no-cache-dir install awscli && \
  rm -f /var/cache/apk/*

RUN curl -sSL https://sdk.cloud.google.com | bash

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
  chmod +x kubectl && \
  mv kubectl /usr/bin

RUN export HELM_VERSION=3.3.0 && \
  curl -LO https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
  tar xzf helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
  mv linux-amd64/helm /usr/bin/helm3 && \
  rm helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
  rm -rf linux-amd64 && \
  helm3 plugin install https://github.com/helm/helm-2to3

RUN export VELERO_VERSION=1.4.0 && \
  curl -LO https://github.com/heptio/velero/releases/download/v${VELERO_VERSION}/velero-v${VELERO_VERSION}-linux-amd64.tar.gz && \
  tar xzf velero-v${VELERO_VERSION}-linux-amd64.tar.gz && \
  mv velero-v${VELERO_VERSION}-linux-amd64/velero /usr/bin && \
  rm velero-v${VELERO_VERSION}-linux-amd64.tar.gz && \
  rm -rf velero-v${VELERO_VERSION}-linux-amd64

RUN TERRAFORM_VERSION=0.13.0 && \
  curl -sSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o /tmp/terraform.zip && \
  unzip /tmp/terraform.zip -d /usr/bin && \
  rm /tmp/terraform.zip && \
  rm -rf /var/cache/apk/* && \
  mv /usr/bin/terraform /usr/bin/terraform13 && \
  ln -s /usr/bin/terraform13 /usr/bin/terraform

RUN POPEYE_VERSION=0.8.8 && \
  curl -sSL https://github.com/derailed/popeye/releases/download/v${POPEYE_VERSION}/popeye_Linux_x86_64.tar.gz \
  -o /tmp/popeye.tgz && \
  tar xzf /tmp/popeye.tgz -C /usr/local/bin popeye && \
  rm /tmp/popeye.tgz

RUN KUBEDEBUG_VERSION=0.1.1 && \
  curl -Lo kubectl-debug.tar.gz https://github.com/aylei/kubectl-debug/releases/download/v${KUBEDEBUG_VERSION}/kubectl-debug_${KUBEDEBUG_VERSION}_linux_amd64.tar.gz && \
  tar -zxvf kubectl-debug.tar.gz kubectl-debug && \
  mv kubectl-debug /usr/local/bin/ && \
  rm kubectl-debug.tar.gz

RUN curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip && \
  unzip rclone-current-linux-amd64.zip && \
  cd rclone-*-linux-amd64 && \
  cp rclone /usr/bin/ && \
  cd - && \
  rm -rf rclone-*-linux-amd64 && \
  rm rclone-current-linux-amd64.zip && \
  chown root:root /usr/bin/rclone && \
  chmod 755 /usr/bin/rclone

RUN YQ_VERSION=3.3.2 && \
  curl -LO https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 && \
  mv yq_linux_amd64 /usr/bin/yq && \
  chown root:root /usr/bin/yq && \
  chmod 755 /usr/bin/yq

RUN K9S_VERSION=0.21.7 && \
  curl -LO https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_x86_64.tar.gz && \
  tar -zxvf k9s_Linux_x86_64.tar.gz && \
  mv k9s /usr/bin/k9s && \
  chown root:root /usr/bin/k9s && \
  chmod 755 /usr/bin/k9s && \
  rm k9s_Linux_x86_64.tar.gz

WORKDIR /home

CMD ["bash"]
