#!/usr/bin/env sh
# Ensure the artifact CLI is on PATH. Installs from the Worker install script
# when missing. Prints the absolute path to the binary on success.
set -eu

BASE_URL="${ARTIFACT_INSTALL_BASE_URL:-https://artifact.9by2.workers.dev}"
INSTALL_DIR="${ARTIFACT_INSTALL_DIR:-${HOME}/.local/bin}"

resolve_artifact() {
  if command -v artifact >/dev/null 2>&1; then
    command -v artifact
    return 0
  fi
  if [ -x "${INSTALL_DIR}/artifact" ]; then
    printf '%s\n' "${INSTALL_DIR}/artifact"
    return 0
  fi
  return 1
}

if ARTIFACT_BIN="$(resolve_artifact)"; then
  # Keep an existing install current when `artifact update` is available.
  if "$ARTIFACT_BIN" update -h >/dev/null 2>&1; then
    "$ARTIFACT_BIN" update >/dev/null 2>&1 || true
  fi
  printf '%s\n' "$ARTIFACT_BIN"
  exit 0
fi

echo "artifact CLI not found; installing from ${BASE_URL}/install.sh" >&2
curl -fsSL "${BASE_URL}/install.sh" | sh

# install.sh may leave INSTALL_DIR off PATH in this shell
export PATH="${INSTALL_DIR}:${PATH}"

if ARTIFACT_BIN="$(resolve_artifact)"; then
  "$ARTIFACT_BIN" --version >&2 || true
  printf '%s\n' "$ARTIFACT_BIN"
  exit 0
fi

echo "artifact: install finished but binary is still missing from PATH" >&2
echo "expected ${INSTALL_DIR}/artifact — add that directory to PATH" >&2
exit 1
