# Using Bazzite variants as base images
# renovate: datasource=github-releases depName=ublue-os/bazzite

ARG BASE_IMAGE="bazzite-asus-nvidia"
ARG BASE_IMAGE_TAG="${BASE_IMAGE_TAG:-stable}"

FROM ghcr.io/ublue-os/${BASE_IMAGE}:${BASE_IMAGE_TAG} as bazzingan

ARG BASE_IMAGE
ENV BASE_IMAGE=${BASE_IMAGE}

# COPY Containerfile /Containerfile

# # Set variant flags based on base image name during build
# RUN set -eo pipefail && \
#     if [[ "${BASE_IMAGE}" == *"gnome"* ]]; then \
#         echo "Setting GNOME variant flag" && \
#         echo "IS_GNOME_VARIANT=1" >> /etc/environment && \
#         export IS_GNOME_VARIANT=1; \
#     else \
#         echo "IS_GNOME_VARIANT=0" >> /etc/environment && \
#         export IS_GNOME_VARIANT=0; \
#     fi && \
#     if [[ "${BASE_IMAGE}" == *"-open"* ]]; then \
#         echo "Setting open driver flag" && \
#         echo "IS_OPEN_DRIVER=1" >> /etc/environment && \
#         export IS_OPEN_DRIVER=1; \
#     else \
#         echo "IS_OPEN_DRIVER=0" >> /etc/environment && \
#         export IS_OPEN_DRIVER=0; \
#     fi

ARG IS_GNOME_VARIANT
ARG IS_OPEN_DRIVER
ENV IS_GNOME_VARIANT=${IS_GNOME_VARIANT:-0} \
    IS_OPEN_DRIVER=${IS_OPEN_DRIVER:-0}

COPY --chmod=644 root /

COPY runners /runners

# set executable permissions for scripts
RUN find /runners -type f -name "*.sh" -exec chmod +x {} \;

COPY --chmod=755 /builders/gh.sh /tmp/init.sh

RUN /tmp/init.sh || { echo "Init script failed"; exit 1; }
