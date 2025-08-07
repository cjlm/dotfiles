#!/usr/bin/env bash

YT_SUMMARIZE_PROMPT="${YT_SUMMARIZE_PROMPT:-Above are the subtitles from Youtube video. Summarize it in 2-3 paragraphs. Be concise, but do not omit important details.}"
YT_SUMMARIZE_LANG="${YT_SUMMARIZE_LANG:-en}"
YT_TOKENS_LIMIT="${YT_TOKENS_LIMIT:-15000}" # 15K tokens is roughly 1 hour of talking head
URL="${1:-""}"
CONTEXT="${2:-""}"
shift 2 2>/dev/null || shift

if [[ -z "$URL" ]]; then
    echo "Usage: $0 <youtube-url> [context] [yt-dlp options...]"
    echo "  youtube-url: YouTube video URL"
    echo "  context: Optional additional context to focus the summary"
    echo "  yt-dlp options: Additional options passed to yt-dlp"
    echo ""
    echo "Example: $0 'https://youtube.com/watch?v=...' 'technical implementation details'"
    exit
fi

# Build the prompt with optional context
if [[ -n "$CONTEXT" ]]; then
    FINAL_PROMPT="Above are the subtitles from Youtube video. Summarize it in 2-3 paragraphs. Be concise, but do not omit important details. Focus especially on: $CONTEXT"
else
    FINAL_PROMPT="$YT_SUMMARIZE_PROMPT"
fi

if ! which uvx >/dev/null 2>&1; then
    echo "Error: uv tool is requied. Start at https://docs.astral.sh/uv/#getting-started"
    exit 1
fi

for TOOL in ttok yt-dlp llm; do
    uv tool install -q $TOOL;
done

if ! uvx llm keys | grep -q openai; then
    echo "Set your OpenAI API key with the following command: uvx llm keys set openai"
    exit 1
fi

TEMPDIR="$(mktemp -d)"
# To use cookies from your browser, use `--cookies-from-browser ...` (more info in `yt-dlp --help`)
yt-dlp --paths "$TEMPDIR" \
        --quiet --no-warnings --skip-download --write-auto-subs --convert-subs srt \
        --sub-langs "$YT_SUMMARIZE_LANG" \
        "$URL" "$@"

cat "$TEMPDIR/"*.srt \
    | tr -d '\r' \
    | grep -Ev '^[0-9]{2}:.* -->' \
    | grep -Ev '^[0-9]*$' \
    | grep -Ev '^ *$' \
    | uniq \
    | ttok -t "$YT_TOKENS_LIMIT" \
    | llm -s "$FINAL_PROMPT" \
    | fmt -w 70

rm -rf "$TEMPDIR"
