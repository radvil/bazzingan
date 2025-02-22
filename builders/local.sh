#!/bin/bash

set -euo pipefail

# Function to show help
show_help() {
  echo "Bazzingan Image Builder"
  echo "========================="
  echo
  echo "Usage: $0 [COMMAND] [VARIANT] [TAG]"
  echo
  echo "Commands:"
  echo "  build          - Build specified variant"
  echo "  clean          - Remove specified variant"
  echo "  clean-all      - Remove all bazzingan images"
  echo "  list           - List all bazzingan images"
  echo "  help           - Show this help message"
  echo
  echo "Variants:"
  echo "  kde-nvidia         - KDE Plasma with NVIDIA proprietary drivers"
  echo "  kde-nvidia-open    - KDE Plasma with NVIDIA open source drivers"
  echo "  gnome-nvidia       - GNOME with NVIDIA proprietary drivers"
  echo "  gnome-nvidia-open  - GNOME with NVIDIA open source drivers"
  echo
  echo "Tag:"
  echo "  latest (default) or specify a custom tag"
  echo
  echo "Examples:"
  echo "  $0 list                    # List all variants"
  echo "  $0 build kde-nvidia        # Build KDE variant with NVIDIA drivers"
  echo "  $0 build gnome-nvidia      # Build GNOME variant with NVIDIA drivers"
  echo "  $0 clean kde-nvidia        # Remove KDE NVIDIA variant"
  echo "  $0 clean-all               # Remove all variants"
}

# Function to list bazzingan images
list_images() {
  echo "Local bazzingan images:"
  podman images | grep "bazzingan" || echo "No bazzingan images found"
}

# Function to remove specific variant
clean_variant() {
  local variant=$1
  local tag=${2:-"latest"}
  echo "Removing bazzingan-$variant:$tag..."
  podman rmi "localhost/bazzingan-$variant:$tag" 2>/dev/null || echo "Image bazzingan-$variant:$tag not found"
  
  # If removing kde-nvidia, also remove the default image
  if [ "$variant" = "kde-nvidia" ]; then
    echo "Removing bazzingan:$tag..."
    podman rmi "localhost/bazzingan:$tag" 2>/dev/null || echo "Image bazzingan:$tag not found"
  fi
}

# Function to remove all bazzingan images
clean_all() {
  echo "Removing all bazzingan images..."
  podman images | grep "bazzingan" | awk '{print $3}' | xargs -r podman rmi 2>/dev/null || echo "No bazzingan images found"
}

# Show help if no arguments provided
if [ $# -eq 0 ]; then
  show_help
  exit 0
fi

# Parse command
COMMAND=$1
shift

case "$COMMAND" in
  "build")
    # Default values for build
    VARIANT=${1:-"kde-nvidia"}
    TAG=${2:-"latest"}

    # Map variant to base image
    case "$VARIANT" in
      "kde-nvidia")
        BASE_IMAGE_NAME="bazzite-asus-nvidia"
        ;;
      "kde-nvidia-open")
        BASE_IMAGE_NAME="bazzite-asus-nvidia-open"
        ;;
      "gnome-nvidia")
        BASE_IMAGE_NAME="bazzite-gnome-asus-nvidia"
        ;;
      "gnome-nvidia-open")
        BASE_IMAGE_NAME="bazzite-gnome-asus-nvidia-open"
        ;;
      *)
        echo "Error: Unknown variant '$VARIANT'"
        echo
        show_help
        exit 1
        ;;
    esac

    echo "Building bazzingan-$VARIANT..."
    echo "Using base image: $BASE_IMAGE_NAME"

    # Build the image
    podman build \
      --build-arg="BASE_IMAGE_NAME=$BASE_IMAGE_NAME" \
      --tag="localhost/bazzingan-$VARIANT:$TAG" \
      .

    # If this is kde-nvidia, also build the default image
    if [ "$VARIANT" = "kde-nvidia" ]; then
      echo "Building default bazzingan image..."
      podman build \
        --build-arg="BASE_IMAGE_NAME=localhost/bazzingan-kde-nvidia:$TAG" \
        --tag="localhost/bazzingan:$TAG" \
        .
    fi

    echo "Done! Images built:"
    list_images
    ;;

  "clean")
    VARIANT=${1:-"kde-nvidia"}
    TAG=${2:-"latest"}
    clean_variant "$VARIANT" "$TAG"
    list_images
    ;;

  "clean-all")
    clean_all
    list_images
    ;;

  "list")
    list_images
    ;;

  "help"|"-h"|"--help")
    show_help
    ;;

  *)
    echo "Error: Unknown command '$COMMAND'"
    echo
    show_help
    exit 1
    ;;
esac 
