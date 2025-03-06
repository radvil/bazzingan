# Using Bazzite variants as base images
# renovate: datasource=github-releases depName=ublue-os/bazzite

ARG BASE_IMAGE="bazzite-asus-nvidia"
ARG BASE_IMAGE_TAG="${BASE_IMAGE_TAG:-stable}"

FROM ghcr.io/ublue-os/${BASE_IMAGE}:${BASE_IMAGE_TAG} as bazzingan

ARG BASE_IMAGE
ARG IS_GNOME_VARIANT
ARG IS_OPEN_DRIVER
ENV BASE_IMAGE=${BASE_IMAGE} \
  IS_GNOME_VARIANT=${IS_GNOME_VARIANT:-0} \
  IS_OPEN_DRIVER=${IS_OPEN_DRIVER:-0}

COPY --chmod=644 root /

COPY runners /runners

# set executable permissions for scripts
RUN find /runners -type f -name "*.sh" -exec chmod +x {} \;

COPY --chmod=755 /builders/gh.sh /tmp/init.sh

RUN /tmp/init.sh || { echo "Init script failed"; exit 1; }
