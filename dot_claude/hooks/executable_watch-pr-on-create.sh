#!/bin/bash
# PostToolUse hook — when `gh pr create` succeeds, spawn `gh pr checks --watch`
# in the background so the PR is auto-watched without blocking the agent.
#
# Wired in ~/.claude/settings.json under hooks.PostToolUse with matcher "Bash".
# Logs land in ~/.claude/logs/pr-watch/.
set -euo pipefail

INPUT=$(cat)

# Filter: only react to commands that invoke `gh pr create`.
COMMAND=$(echo "${INPUT}" | jq -r '.tool_input.command // empty')
case "${COMMAND}" in
  *"gh pr create"*) ;;
  *) exit 0 ;;
esac

# Bail on failure, missing gh, or no URL in stdout (e.g. --web mode).
EXIT_CODE=$(echo "${INPUT}" | jq -r '.tool_response.exit_code // 0')
[[ "${EXIT_CODE}" != "0" ]] && exit 0
command -v gh >/dev/null 2>&1 || exit 0

STDOUT=$(echo "${INPUT}" | jq -r '.tool_response.stdout // empty')
PR_URL=$(echo "${STDOUT}" \
  | grep -oE 'https://github\.com/[^/[:space:]]+/[^/[:space:]]+/pull/[0-9]+' \
  | head -n1)
[[ -z "${PR_URL}" ]] && exit 0
PR_ID="${PR_URL##*/}"

# Detach: nohup + disown + redirect all fds so the watcher survives the hook
# returning and never writes to the agent's terminal.
LOG_DIR="${HOME}/.claude/logs/pr-watch"
mkdir -p "${LOG_DIR}"
LOG_FILE="${LOG_DIR}/pr-${PR_ID}-$(date +%Y%m%d-%H%M%S).log"

nohup gh pr checks "${PR_URL}" --watch --interval 30 \
  >"${LOG_FILE}" 2>&1 </dev/null &
disown

echo "Auto-watching PR #${PR_ID} (log: ${LOG_FILE})"
exit 0
