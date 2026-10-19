#!/usr/bin/env bash
# Submit all sitemap URLs to IndexNow. Run after deploying.
set -euo pipefail
cd "$(dirname "$0")/.."
HOST="store.frankfor.you"
KEY="95274db61ca17481e83fc80d8c5cda4d"
URLS=$(grep -o '<loc>[^<]*</loc>' sitemap.xml | sed -e 's/<loc>//' -e 's/<\/loc>//')
[ -n "$URLS" ] || { echo "no URLs found in sitemap.xml" >&2; exit 1; }
LIST=$(printf '%s\n' "$URLS" | sed 's/.*/"&"/' | paste -sd, -)
BODY="{\"host\":\"$HOST\",\"key\":\"$KEY\",\"keyLocation\":\"https://$HOST/$KEY.txt\",\"urlList\":[$LIST]}"
echo "Submitting $(printf '%s\n' "$URLS" | wc -l) URLs to IndexNow..."
curl -sS -o /dev/null -w 'HTTP %{http_code}\n' -X POST https://api.indexnow.org/IndexNow \
  -H 'Content-Type: application/json; charset=utf-8' -d "$BODY"
