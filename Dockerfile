FROM fedora:35

ARG VENVBASE="/opt/molecule"

WORKDIR /github/workspace

COPY files/ /opt

RUN dnf install -y docker \
        gcc \
        git-core \
        python3-devel \
        python3-pip \
        python3-libselinux \
        python3-jmespath.noarch \
        findutils \
    && dnf clean all

RUN set -eux \
    # Ansible previous (2.11)
    && python3 -m venv "${VENVBASE}/previous" \
    && source "${VENVBASE}/previous/bin/activate" \
    && python -m pip install --upgrade pip \
    && pip3 install --no-cache-dir --no-compile -r /opt/requirements.previous.txt \
    # Ansible current (2.12)
    && python3 -m venv "${VENVBASE}/current" \
    && source "${VENVBASE}/current/bin/activate" \
    && python -m pip install --upgrade pip \
    && pip3 install --no-cache-dir --no-compile -r /opt/requirements.current.txt \
    # Ansible next (2.1X) - latest/greatest
    && python3 -m venv "${VENVBASE}/next" \
    && source "${VENVBASE}/next/bin/activate" \
    && python -m pip install --upgrade pip \
    && pip3 install --no-cache-dir --no-compile -r /opt/requirements.next.txt \
    # SmokeTests
    && echo "###################################" \
    && source "${VENVBASE}/previous/bin/activate" \
    && ansible --version \
    && ansible-lint --version \
    && yamllint --version \
    && echo "###################################" \
    && python3 -m venv "${VENVBASE}/current" \
    && ansible --version \
    && ansible-lint --version \
    && yamllint --version \
    && echo "###################################" \
    && source "${VENVBASE}/next/bin/activate" \
    && ansible --version \
    && ansible-lint --version \
    && yamllint --version \
    && echo "###################################" \
    && find /usr/lib/ -name '__pycache__' -print0 | xargs -0 -n1 rm -rf \
    && find /usr/lib/ -name '*.pyc' -print0 | xargs -0 -n1 rm -rf \
    && mkdir /workspace

CMD /opt/molecule.sh
