FROM ubuntu:22.04 AS builder

LABEL maintainer="mullholland"
LABEL build_update="2022-06-19"

ARG DEBIAN_FRONTEND=noninteractive
ARG VENVBASE="/opt/molecule"

ENV container docker

# default to bash instead of sh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Enable apt repositories.
RUN sed -i 's/# deb/deb/g' /etc/apt/sources.list

# Enable systemd.
RUN apt-get update ; \
    apt-get install -y systemd systemd-cron systemd-sysv ; \
    apt-get clean ; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ; \
    cd /lib/systemd/system/sysinit.target.wants/ ; \
    ls | grep -v systemd-tmpfiles-setup | xargs rm -f $1 ; \
    rm -f /lib/systemd/system/multi-user.target.wants/* ; \
    rm -f /etc/systemd/system/*.wants/* ; \
    rm -f /lib/systemd/system/local-fs.target.wants/* ; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev* ; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl* ; \
    rm -f /lib/systemd/system/basic.target.wants/* ; \
    rm -f /lib/systemd/system/anaconda.target.wants/* ; \
    rm -f /lib/systemd/system/plymouth* ; \
    rm -f /lib/systemd/system/systemd-update-utmp*

# Install requirements.
RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install -y \
    python3 \
    python3-apt \
    python3-dev \
    python3-setuptools \
    python3-pip \
    python3-venv \
    apt-transport-https \
    apt-utils \
    sudo \
    gnupg \
    git \
    curl \
    ca-certificates \
    build-essential \
    locales \
    libffi-dev \
    libssl-dev \
    libyaml-dev \
    software-properties-common \
    rsyslog \
    iproute2 \
    python-dev \
    libsasl2-dev \
    libldap2-dev \
    libssl-dev \
    jq \
    vim \
    && apt-get clean

# install docker
RUN curl -fsSL https://get.docker.com -o get-docker.sh \
    && sh ./get-docker.sh \
    # Fix potential UTF-8 errors with ansible-test.
    locale-gen en_US.UTF-8

# Copy ansible requirements files
COPY files/ /opt/

RUN set -eux \
    # Previous Ansible Version (ATM = 2.11)
    && python3 -m venv "${VENVBASE}/previous" \
    && source "${VENVBASE}/previous/bin/activate" \
    && python -m pip install --upgrade pip \
    && pip3 install --no-cache-dir --no-compile -r /opt/requirements.previous.txt \
    && ansible-galaxy install -r /opt/requirements.previous.yml \
    # Current Ansible Version (ATM = 2.13)
    && python3 -m venv "${VENVBASE}/current" \
    && source "${VENVBASE}/current/bin/activate" \
    && python -m pip install --upgrade pip \
    && pip3 install --no-cache-dir --no-compile -r /opt/requirements.current.txt \
    && ansible-galaxy install -r /opt/requirements.current.yml \
    # Development Ansible Version
    && python3 -m venv "${VENVBASE}/development" \
    && source "${VENVBASE}/development/bin/activate" \
    && python -m pip install --upgrade pip \
    && pip3 install --no-cache-dir --no-compile -r /opt/requirements.development.txt \
    && ansible-galaxy install -r /opt/requirements.development.yml \
    # SmokeTest
    # Previous Ansible Version (ATM = 2.12)
    && source "${VENVBASE}/previous/bin/activate" \
    && pipdeptree \
    && ansible --version \
    && ansible-lint --version \
    && yamllint --version \
    # Current Ansible Version (ATM = 2.13)
    && source "${VENVBASE}/current/bin/activate" \
    && pipdeptree \
    && ansible --version \
    && ansible-lint --version \
    && yamllint --version \
    # Development Ansible Version
    && source "${VENVBASE}/development/bin/activate" \
    && pipdeptree \
    && ansible --version \
    && ansible-lint --version \
    && yamllint --version \
    && find /usr/lib/ -name '__pycache__' -print0 | xargs -0 -n1 rm -rf \
    && find /usr/lib/ -name '*.pyc' -print0 | xargs -0 -n1 rm -rf

# Update scripts
RUN mv /opt/.bashrc /root/.bashrc \
    && mv /opt/.vimrc /root/.vimrc \
    && chmod +x /opt/batch.sh \
    && chmod +x /opt/molecule.sh \
    && chmod +x /opt/pull_update_images.sh

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/lib/systemd/systemd"]
