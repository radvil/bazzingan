# Using Bazzite variants as base images
# renovate: datasource=github-releases depName=ublue-os/bazzite
# Default to bazzite-asus-nvidia if not specified
ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-bazzite-asus-nvidia}"

# Pin to a specific version for stability
# ARG BASE_IMAGE_TAG="${BASE_IMAGE_TAG:-39.20240201.0}"
ARG BASE_IMAGE_TAG="${BASE_IMAGE_TAG:-stable}"

FROM ghcr.io/ublue-os/${BASE_IMAGE_NAME}:${BASE_IMAGE_TAG} as bazzingan

ARG BASE_IMAGE_NAME
ENV BASE_IMAGE_NAME=${BASE_IMAGE_NAME} \
  IS_GNOME_VARIANT=0 \
  IS_OPEN_DRIVER=0

# error handling for variant detection
RUN set -eo pipefail && \
  if [[ "${BASE_IMAGE_NAME}" == *"gnome"* ]]; then \
  echo "Setting GNOME variant flag" && \
  echo "IS_GNOME_VARIANT=1" >> /etc/environment && \
  sed -i 's/^ENV IS_GNOME_VARIANT=.*/ENV IS_GNOME_VARIANT=1/' /Containerfile; \
  fi && \
  if [[ "${BASE_IMAGE_NAME}" == *"-open"* ]]; then \
  echo "Setting open driver flag" && \
  echo "IS_OPEN_DRIVER=1" >> /etc/environment && \
  sed -i 's/^ENV IS_OPEN_DRIVER=.*/ENV IS_OPEN_DRIVER=1/' /Containerfile; \
  fi

COPY --chmod=644 root /

COPY runners /runners

# set executable permissions for scripts
RUN find /runners -type f -name "*.sh" -exec chmod +x {} \;

COPY --chmod=755 /builders/gh.sh /tmp/init.sh

RUN /tmp/init.sh || { echo "Init script failed"; exit 1; }
