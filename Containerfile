# Using Bazzite variants as base images
# renovate: datasource=github-releases depName=ublue-os/bazzite
# Default to bazzite-asus-nvidia if not specified

ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-bazzite-asus-nvidia}"
ARG BASE_IMAGE_TAG="${BASE_IMAGE_TAG:-stable}"

FROM ghcr.io/ublue-os/${BASE_IMAGE_NAME}:${BASE_IMAGE_TAG} as bazzingan

ARG BASE_IMAGE_NAME
ENV BASE_IMAGE_NAME=${BASE_IMAGE_NAME} \
    IS_GNOME_VARIANT=0 \
    IS_OPEN_DRIVER=0

RUN if [[ "${BASE_IMAGE_NAME}" == *"gnome"* ]]; then \
      echo "Setting GNOME variant flag" && \
      echo "IS_GNOME_VARIANT=1" >> /etc/environment && \
      sed -i 's/^ENV IS_GNOME_VARIANT=.*/ENV IS_GNOME_VARIANT=1/' /Containerfile; \
    fi && \
    if [[ "${BASE_IMAGE_NAME}" == *"-open"* ]]; then \
      echo "Setting open driver flag" && \
      echo "IS_OPEN_DRIVER=1" >> /etc/environment && \
      sed -i 's/^ENV IS_OPEN_DRIVER=.*/ENV IS_OPEN_DRIVER=1/' /Containerfile; \
    fi

COPY root /
COPY runners /runners
COPY /builders/gh.sh /tmp/init.sh
RUN /tmp/init.sh
