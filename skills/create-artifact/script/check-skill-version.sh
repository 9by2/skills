#!/usr/bin/env sh
# Check whether this installed copy of the skill is the latest published
# version. Compares the local frontmatter `metadata.version` in SKILL.md with
# the version on the repo's main branch. Non-fatal: warns on stale, and skips
# silently when the remote is unreachable (offline / private-repo without
# credentials). Exit codes: 0 = current or check skipped, 3 = update available.
set -eu

SKILL_DIR="$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)"
SKILL_MD="${SKILL_DIR}/SKILL.md"

REPO_URL="${SKILLS_REPO_URL:-git@github.com:9by2/skills.git}"
RAW_BASE="${SKILLS_REPO_RAW_BASE:-https://raw.githubusercontent.com/9by2/skills/main}"

extract_version() {
  # Reads `version: "x.y.z"` (under metadata:) from a SKILL.md frontmatter.
  sed -n 's/^[[:space:]]*version:[[:space:]]*"\{0,1\}\([0-9][0-9A-Za-z.-]*\)"\{0,1\}.*/\1/p' "$1" | head -1
}

extract_name() {
  sed -n 's/^name:[[:space:]]*//p' "$1" | head -1
}

[ -f "$SKILL_MD" ] || { echo "check-skill-version: SKILL.md not found at ${SKILL_MD}" >&2; exit 0; }

SKILL_NAME="$(extract_name "$SKILL_MD")"
LOCAL_VERSION="$(extract_version "$SKILL_MD")"

if [ -z "$LOCAL_VERSION" ]; then
  echo "check-skill-version: no metadata.version in local SKILL.md; skipping check" >&2
  exit 0
fi

TMP_REMOTE="$(mktemp)"
trap 'rm -f "$TMP_REMOTE"' EXIT

REMOTE_VERSION=""
REMOTE_FETCHED=0
if curl -fsSL --max-time 10 "${RAW_BASE}/skills/${SKILL_NAME}/SKILL.md" -o "$TMP_REMOTE" 2>/dev/null; then
  REMOTE_FETCHED=1
  REMOTE_VERSION="$(extract_version "$TMP_REMOTE")"
elif command -v git >/dev/null 2>&1; then
  # Fallback for private repos: shallow-fetch just the SKILL.md blob.
  REMOTE_VERSION="$(git archive --remote="$REPO_URL" main "skills/${SKILL_NAME}/SKILL.md" 2>/dev/null \
    | tar -xO 2>/dev/null | sed -n 's/^[[:space:]]*version:[[:space:]]*"\{0,1\}\([0-9][0-9A-Za-z.-]*\)"\{0,1\}.*/\1/p' | head -1 || true)"
fi

if [ -z "$REMOTE_VERSION" ]; then
  if [ "$REMOTE_FETCHED" = 1 ]; then
    echo "check-skill-version: published SKILL.md has no metadata.version; local v${LOCAL_VERSION} assumed current" >&2
  else
    echo "check-skill-version: could not reach ${RAW_BASE} or ${REPO_URL}; skipping check" >&2
  fi
  exit 0
fi

if [ "$LOCAL_VERSION" = "$REMOTE_VERSION" ]; then
  echo "skill '${SKILL_NAME}' is current (v${LOCAL_VERSION})"
  exit 0
fi

NEWEST="$(printf '%s\n%s\n' "$LOCAL_VERSION" "$REMOTE_VERSION" | sort -V | tail -1)"
if [ "$NEWEST" = "$LOCAL_VERSION" ]; then
  echo "skill '${SKILL_NAME}' local v${LOCAL_VERSION} is ahead of published v${REMOTE_VERSION} (working copy?)"
  exit 0
fi

cat >&2 <<EOF
skill '${SKILL_NAME}' is OUTDATED: local v${LOCAL_VERSION}, latest v${REMOTE_VERSION}
Update with:
  bunx --bun skills add ${REPO_URL} --skill ${SKILL_NAME}
EOF
exit 3
