#!/usr/bin/env bash
set -euo pipefail

MAX_ITEMS="${MAX_ITEMS:-3}"
MAX_TITLE_LEN="${MAX_TITLE_LEN:-120}"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not inside a git repository." >&2
  exit 1
fi

if ! git show-ref --verify --quiet refs/heads/main; then
  echo "Local branch 'main' not found." >&2
  exit 1
fi

if ! git show-ref --verify --quiet refs/heads/staging; then
  echo "Local branch 'staging' not found." >&2
  exit 1
fi

subjects=()
while IFS= read -r line; do
  subjects+=("${line}")
done < <(git log --pretty=%s main..staging)

if [[ ${#subjects[@]} -eq 0 ]]; then
  echo "No commits in staging that are not in main. Nothing to promote." >&2
  exit 0
fi

title_suffix="$(
python - <<'PY'
import os
import re
import sys
from collections import Counter

max_items = int(os.environ.get("MAX_ITEMS", "3"))

subjects = [line.strip() for line in sys.stdin if line.strip()]
if not subjects:
    sys.exit(0)

stop = {
    "the","a","an","and","or","to","of","for","in","on","with","by","from","into",
    "is","are","be","as","at","this","that","these","those","it","its","via",
    "add","adds","added","adding","fix","fixes","fixed","fixing","update","updates",
    "updated","updating","bump","bumps","bumped","remove","removes","removed",
    "refactor","refactors","refactored","refactoring","chore","docs","doc","tests",
}

scopes = []
keywords = []

for s in subjects:
    # Drop leading tags like "[infra]" or "[ci]" and conventional commit type.
    s = re.sub(r"^\[[^\]]+\]\s*", "", s)
    m = re.match(r"^([a-zA-Z]+)(\(([^)]+)\))?:\s+(.*)$", s)
    if m:
        scope = m.group(3)
        if scope:
            scopes.append(scope.strip().lower())
        s = m.group(4)
    # Split into tokens
    tokens = re.split(r"[^a-zA-Z0-9]+", s.lower())
    for t in tokens:
        if len(t) < 3 or t in stop:
            continue
        keywords.append(t)

def top_items(items):
    counts = Counter(items)
    return [w for w, _ in counts.most_common(max_items)]

topics = top_items(scopes) if scopes else top_items(keywords)

if not topics:
    # Fallback to trimmed subjects
    topics = subjects[:max_items]

print(", ".join(topics))
PY
<<<"$(printf '%s\n' "${subjects[@]}")"
)"

if [[ -z "${title_suffix}" ]]; then
  title_suffix="$(IFS=", "; echo "${subjects[@]:0:${MAX_ITEMS}}")"
fi

if [[ ${#title_suffix} -gt ${MAX_TITLE_LEN} ]]; then
  title_suffix="${title_suffix:0:$((MAX_TITLE_LEN-3))}..."
fi

title="Promote: ${title_suffix}"

body_commits=$(git log --pretty="- %s (%h)" main..staging)
body="Automated promotion from staging to main.\n\nCommits:\n${body_commits}"

if [[ "${DRY_RUN:-}" == "1" ]]; then
  echo "[DRY_RUN] Title: ${title}"
  echo "[DRY_RUN] Body:"
  echo "${body}"
  exit 0
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI not found. Install it and retry." >&2
  exit 1
fi

gh pr create --base main --head staging --title "${title}" --body "${body}"
