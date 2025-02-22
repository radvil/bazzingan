# BAZZINGAN

My custom Universal Blue Linux Image based on Bazzite.

## Local Development

### Building Locally

The repository includes a `build-local.sh` script that helps you build and manage images locally. This is useful for testing changes before pushing them to GitHub.

```bash
# Show help and available commands
./build-local.sh

# Build specific variants
./build-local.sh build kde-nvidia        # Build KDE variant with NVIDIA drivers
./build-local.sh build kde-nvidia-open   # Build KDE variant with NVIDIA open drivers
./build-local.sh build gnome-nvidia      # Build GNOME variant with NVIDIA drivers
./build-local.sh build gnome-nvidia-open # Build GNOME variant with NVIDIA open drivers

# Manage local images
./build-local.sh list                    # List all built images
./build-local.sh clean kde-nvidia        # Remove specific variant
./build-local.sh clean-all              # Remove all variants
```

The script will build the following images:

- `bazzingan-kde-nvidia` (based on `bazzite-asus-nvidia`)
- `bazzingan-kde-nvidia-open` (based on `bazzite-asus-nvidia-open`)
- `bazzingan-gnome-nvidia` (based on `bazzite-gnome-asus-nvidia`)
- `bazzingan-gnome-nvidia-open` (based on `bazzite-gnome-asus-nvidia-open`)
- `bazzingan` (based on `bazzingan-kde-nvidia` as the default image)

When building the KDE NVIDIA variant, it will also create the default `bazzingan` image automatically.

### Testing Built Images

To test a built image, you can either:

1. Run it in a container:

```bash
podman run -it localhost/bazzingan-kde-nvidia:latest bash
```

2. Rebase your system to it:

```bash
rpm-ostree rebase ostree-unverified-registry:localhost/bazzingan-kde-nvidia:latest
```

Remember to use `sudo` with the commands if you're using rootful Podman.
