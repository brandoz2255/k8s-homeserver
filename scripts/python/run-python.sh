#!/usr/bin/env bash
################################################################################
# run-python.sh – Build **and** run a Python‑based container image in one go 🐍🐳
################################################################################
#
# This helper works from **any directory**: it figures out where it lives,
# builds the Docker image located next to the script (or under ./dockerfile),
# then launches it.
#
# Usage:
#   ./run-python.sh <image_name[:tag]> [-- EXTRA_DOCKER_RUN_ARGS]
#
# Example (your alias):
#   k8m   → run-python.sh k8s_tui:latest
#
# Implementation details:
#   • Uses docker **buildx --load** so the freshly built image is ready for
#     `docker run` without pushing to a registry.
#   • Tries `SCRIPT_DIR/dockerfile` first; if no such directory, builds from
#     `SCRIPT_DIR` (the same location as this script).
#   • Mounts the current working directory to /workspace inside the container
#     so you can live‑edit code during tests.
# -----------------------------------------------------------------------------
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 <image_name[:tag]> [-- extra docker run args]" >&2
  exit 1
fi

IMG="$1"
shift || true

# Directory where this script resides
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Pick build context intelligently
if [[ -d "$SCRIPT_DIR/dockerfile" ]]; then
  BUILD_CTX="$SCRIPT_DIR/dockerfile"
else
  BUILD_CTX="$SCRIPT_DIR"
fi

echo "[+] (run-python) Building $IMG via docker buildx --load in $BUILD_CTX …"
docker buildx build --load -t "$IMG" "$BUILD_CTX"

# Run stage
CTR_NAME="$(basename "$IMG" | tr ':/' '_')_$(date +%s)"

echo "[+] (run-python) Running $IMG as $CTR_NAME …"
docker run -it --rm \
  --name "$CTR_NAME" \
  -v "$(pwd)":/workspace \
  "$IMG" "$@"

echo "[✓] Container exited."
