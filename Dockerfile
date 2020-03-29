# - ----------------------------------------------------------------------------
# - Dockerfile
# - ----------------------------------------------------------------------------
# - Builds an Ansible container with the Molecule test package using the Python
# - Alpine image.
# - ----------------------------------------------------------------------------

FROM python:3.8.2-alpine3.11

# Define environment variables to be used in the build and available within
# the container.
# Based on the Ansible recommended directory structure.
# https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html#alternative-directory-layout

ENV ANSIBLE_VERSION="2.9.6" \
    MOLECULE_VERSION="3.0.2" \
    ANSIBLE_USER="ansible" \
    ANSIBLE_GROUP="ansible" \
    ANSIBLE_BASE_DIR="/data/ansible" \
    ANSIBLE_INVENTORY="/data/ansible/inventories" \
    ANSIBLE_ROLES_PATH="/data/ansible/roles" \
    ANSIBLE_HOST_KEY_CHECKING="False" \
    ANSIBLE_LIBRARY="/data/ansible/library" \
    ANSIBLE_MODULE_UTILS="/data/ansible/module_utils" \
    ANSIBLE_FILTER_PLUGINS="/data/ansible/filter_plugins" 


# Update package repositories and install required packages.
RUN apk update && \
    apk add --no-cache \
      curl \
      gcc \
      libffi-dev \
      libressl-dev \
      linux-headers \
      make \
      musl-dev \
      openssh-client \
      openssl \
      rsync \
      sudo \
      wget \
      zsh


# Update pip, install Ansible, Molecule and passlib
RUN pip install pip --upgrade && \
    pip install --no-cache-dir ansible==${ANSIBLE_VERSION} && \
    pip install --no-cache-dir molecule==${MOLECULE_VERSION}
    #pip install --no-cachedir passlib


# Create Ansible user and group.
RUN addgroup ${ANSIBLE_GROUP} && \
    adduser --gecos "Ansible User" \
      --shell /usr/bin/zsh \
      --disabled-password \
      --ingroup ${ANSIBLE_GROUP} ${ANSIBLE_USER}


# Grant sudo access to the Ansible user.
# Not really required since Ansible will not be doing anything on this
# container as root, but we'll add it for any testing.
RUN echo "${ANSIBLE_USER}    ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers


# Create the Ansible base directory
RUN mkdir -p ${ANSIBLE_BASE_DIR} && \
    chown -R ${ANSIBLE_USER}:${ANSIBLE_GROUP} ${ANSIBLE_BASE_DIR}


# Switch to the Ansible user and ...
USER ${ANSIBLE_USER}
# generate RSA key
RUN ssh-keygen -t rsa -b 4096 -q -N '' -f ~/.ssh/id_rsa 2> /dev/null


# Define the inventory and role volumes.
VOLUME ["${ANSIBLE_BASE_DIR}"]


# Since there is no process to keep running, just run a tail.
ENTRYPOINT ["tail", "-f", "/dev/null"]

