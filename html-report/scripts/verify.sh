#!/usr/bin/env bash
# HTML 보고서 렌더링 검증 (macOS).
# 사용: verify.sh <html 절대경로> [출력 디렉터리] [섹션id ...]
#  - 출력 디렉터리를 생략하면 임시 디렉터리를 만든다.
#  - 섹션 id를 생략하면 HTML의 <section id="..."> 전부를 쓴다.
#  1) Mermaid 다이어그램이 전부 렌더링됐는지(오류 다이어그램 0개)
#  2) 페이지 높이와 섹션별 y 좌표 (스크린샷 crop 위치 계산용)
#  3) 전체 페이지 스크린샷 + 섹션별 crop (sips)
#  4) 400px 폭에서 화면 밖으로 넘치는 요소
# Chrome은 CHROME 환경 변수, /Applications, ~/Applications 순서로 찾는다.
set -euo pipefail

if [ $# -lt 1 ]; then echo "사용: verify.sh <html 절대경로> [출력 디렉터리] [섹션id ...]"; exit 1; fi
HTML="$1"; shift
if [ ! -f "$HTML" ]; then echo "!! HTML 파일 없음: $HTML"; exit 1; fi
if [ $# -gt 0 ]; then OUT="$1"; shift; else OUT=$(mktemp -d -t html-report-verify); fi
SECTIONS=("$@")
if [ ${#SECTIONS[@]} -eq 0 ]; then
  while IFS= read -r id; do SECTIONS+=("$id"); done < <(grep -o '<section id="[^"]*"' "$HTML" | sed 's/<section id="//; s/"$//' || true)
fi
mkdir -p "$OUT"
echo "출력 디렉터리: $OUT"
echo "검사 섹션: ${SECTIONS[*]-(없음)}"
URL="file://$HTML"
SKIPPED=()

CHROME=""
for c in "${CHROME:-}" \
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  "$HOME/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"; do
  if [ -n "$c" ] && [ -x "$c" ]; then CHROME="$c"; break; fi
done

total=$( { grep -o 'class="mermaid"' "$HTML" || true; } | wc -l | tr -d ' ')

if [ -z "$CHROME" ]; then
  echo "!! Chrome 없음. CHROME 환경 변수로 실행 파일 경로를 지정할 수 있다."
  echo "== 1. Mermaid 정의 (렌더링 확인 불가)"
  echo "정의된 다이어그램: $total"
  SKIPPED+=("Mermaid 렌더링" "섹션 좌표" "스크린샷" "400px 넘침")
else
  echo "== 1. Mermaid 렌더링"
  "$CHROME" --headless=new --disable-gpu --virtual-time-budget=25000 --window-size=1400,3000 \
    --dump-dom "$URL" 2>/dev/null > "$OUT/dom.html"
  echo "정의된 다이어그램: $total"
  grep -o 'aria-roledescription="[^"]*"' "$OUT/dom.html" | sort | uniq -c || true
  [ "$total" = "0" ] && echo "(다이어그램 없음)"
  if grep -q 'aria-roledescription="error"' "$OUT/dom.html"; then echo "!! 오류 다이어그램 있음"; fi

  echo "== 2. 섹션 좌표"
  cp "$HTML" "$OUT/probe.html"
  ids=$(printf "'%s'," ${SECTIONS[@]+"${SECTIONS[@]}"})
  cat >> "$OUT/probe.html" <<EOF
<script>setTimeout(function(){var r=[${ids%,}].map(function(i){var e=document.getElementById(i);return i+':'+(e?Math.round(e.getBoundingClientRect().top+scrollY):-1)});
var d=document.createElement('pre');d.id='OFF';d.textContent=r.join(' ')+' H:'+document.documentElement.scrollHeight;document.body.appendChild(d)},6000)</script>
EOF
  "$CHROME" --headless=new --disable-gpu --virtual-time-budget=25000 --window-size=1400,3000 \
    --dump-dom "file://$OUT/probe.html" 2>/dev/null | { grep -o 'id="OFF">[^<]*' || true; } | sed 's/id="OFF">//' | tee "$OUT/offsets.txt"

  echo "== 3. 스크린샷"
  H=$(grep -o 'H:[0-9]*' "$OUT/offsets.txt" | cut -d: -f2 || true)
  if [ -z "$H" ]; then
    echo "!! 페이지 높이를 얻지 못함"
    SKIPPED+=("스크린샷")
  else
    "$CHROME" --headless=new --disable-gpu --virtual-time-budget=25000 --window-size=1400,$((H+100)) \
      --screenshot="$OUT/full.png" "$URL" 2>/dev/null
    for pair in $(tr ' ' '\n' < "$OUT/offsets.txt" | { grep -v '^H:' || true; }); do
      id=${pair%%:*}; y=${pair##*:}
      if [ "$y" -lt 0 ]; then echo "!! 섹션 id 없음: $id"; SKIPPED+=("sec-$id.png (id 없음)"); continue; fi
      sips -c 1800 1400 --cropOffset "$y" 0 "$OUT/full.png" --out "$OUT/sec-$id.png" >/dev/null 2>&1 \
        || { echo "!! 자르기 실패: $id"; SKIPPED+=("sec-$id.png"); }
    done
    ls "$OUT"/sec-*.png 2>/dev/null || true
  fi

  echo "== 4. 400px 넘침"
  cp "$HTML" "$OUT/narrow.html"
  cat >> "$OUT/narrow.html" <<'EOF'
<script>setTimeout(function(){document.body.style.width="400px";var W=400,o=[];
document.querySelectorAll('body *').forEach(function(el){var r=el.getBoundingClientRect();if(r.right>W+2&&r.width>0){var p=el.parentElement,s=false;
while(p){if(getComputedStyle(p).overflowX==='auto'){s=true;break}p=p.parentElement}
if(!s&&getComputedStyle(el).position!=='fixed'&&!el.closest('#toc-panel'))o.push(el.tagName+'.'+String(el.className).slice(0,30)+' '+(el.textContent||'').trim().slice(0,30))}});
var d=document.createElement('pre');d.id='NARROW';d.textContent=o.slice(0,20).join('\n')||'none';document.body.appendChild(d)},4000)</script>
EOF
  sed -i '' 's#src="https://cdn.jsdelivr.net/npm/mermaid@[^"]*"#src="about:blank"#' "$OUT/narrow.html"
  "$CHROME" --headless=new --disable-gpu --virtual-time-budget=8000 --window-size=500,900 \
    --dump-dom "file://$OUT/narrow.html" 2>/dev/null | sed -n '/id="NARROW"/,/<\/pre>/p' | sed 's/<[^>]*>//g' || true
fi

echo "== 건너뛴 검사"
if [ ${#SKIPPED[@]} -eq 0 ]; then echo "none"; else printf '%s\n' "${SKIPPED[@]}"; fi
