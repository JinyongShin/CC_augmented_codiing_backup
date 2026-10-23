#!/usr/bin/env python3
"""Static checks for an html-report document.

Usage:
  python3 check_report.py FILE.html [--shared] [--forbid REGEX ...] [--max-words N]

Exit code 1 when an ERROR is found. WARN lines are advisory.
Checks:
  - light theme only (no prefers-color-scheme)
  - <title> exists and is short
  - no <br> inside <p>
  - external scripts/styles only from allowed hosts
  - each <pre class="mermaid"> sits inside <figure class="diagram"> with a <figcaption>
  - --shared: no local paths, no file:// links, plus --forbid patterns
  - long sentences in prose (WARN), hedge words (WARN)
"""
import argparse
import html
import re
import sys

ALLOWED_HOSTS = ("fonts.googleapis.com", "fonts.gstatic.com", "cdn.jsdelivr.net", "cdnjs.cloudflare.com")
LOCAL_PATH = re.compile(r"(/Users/[^\s\"'<]+|/home/[^\s\"'<]+|/private/(?:tmp|var)/[^\s\"'<]+|/tmp/[^\s\"'<]+|~/[^\s\"'<]+|[A-Za-z]:\\\\[^\s\"'<]+|file://[^\s\"'<]+|_worklog/[^\s\"'<]*)")
HEDGES = re.compile(r"(것 같|수도 있|적절히|어느 정도|등등|아마도|\bperhaps\b|\bsomewhat\b|\bvarious\b|\betc\.)")


def strip_tags(s: str) -> str:
    s = re.sub(r"<(script|style|pre|code)\b.*?</\1>", " ", s, flags=re.S | re.I)
    s = re.sub(r"<[^>]+>", " ", s)
    return html.unescape(re.sub(r"\s+", " ", s)).strip()


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("file")
    ap.add_argument("--shared", action="store_true", help="document will be read by others")
    ap.add_argument("--forbid", nargs="*", default=[], help="extra regexes that must not appear (names, codenames)")
    ap.add_argument("--max-words", type=int, default=30, help="warn above this many words per sentence")
    a = ap.parse_args()

    src = open(a.file, encoding="utf-8").read()
    errors, warns = [], []

    if "prefers-color-scheme" in src:
        errors.append("dark-mode media query found (light theme only)")

    m = re.search(r"<title>(.*?)</title>", src, re.S)
    if not m or not m.group(1).strip():
        errors.append("missing <title>")
    elif len(m.group(1).split()) > 6:
        warns.append(f"long <title>: {m.group(1).strip()!r} (use 2-5 words)")

    for p in re.findall(r"<p\b[^>]*>(.*?)</p>", src, re.S):
        if re.search(r"<br\s*/?>", p):
            errors.append("<br> inside a paragraph: " + strip_tags(p)[:60])

    for tag, url in re.findall(r"<(script|link)\b[^>]*(?:src|href)=\"(https?://[^\"]+)\"", src):
        host = re.sub(r"^https?://([^/]+).*", r"\1", url)
        if host not in ALLOWED_HOSTS:
            errors.append(f"external {tag} from non-allowed host: {url}")

    body = src[src.find("<body"):]
    mermaids = re.findall(r"<pre class=\"mermaid\">", body)
    figs = re.findall(r"<figure class=\"diagram\">(.*?)</figure>", body, re.S)
    in_fig = sum(f.count('<pre class="mermaid">') for f in figs)
    if mermaids and in_fig < len(mermaids):
        warns.append(f"{len(mermaids) - in_fig} mermaid block(s) outside figure.diagram")
    for f in figs:
        if "<figcaption" not in f:
            warns.append("diagram without figcaption")
    if mermaids and "mermaid.min.js" not in src:
        errors.append("mermaid blocks present but mermaid script missing")
    if not mermaids:
        warns.append("no Mermaid diagram — consider one for flows, structure, or phases")

    if a.shared:
        visible = re.sub(r"<(script|style)\b.*?</\1>", " ", body, flags=re.S | re.I)
        for hit in sorted(set(LOCAL_PATH.findall(visible))):
            errors.append(f"local reference in shared document: {hit}")
        for pat in a.forbid:
            for hit in sorted(set(re.findall(pat, visible))):
                errors.append(f"forbidden pattern {pat!r}: {hit}")

    for lvl, h in re.findall(r"<h([23])\b[^>]*>(.*?)</h\1>", body, re.S):
        t = strip_tags(h)
        if re.search(r"(다|요|니다|[.!?])$", t) or "," in t:
            warns.append(f"h{lvl} reads like a sentence (use a short label, put the claim in .thesis/.lede): {t}")
    prose = re.findall(r"<(?:p|li)\b[^>]*>(.*?)</(?:p|li)>", body, re.S)
    text = " ".join(strip_tags(x) for x in prose)
    for sent in re.split(r"(?<=[.!?다])\s+", text):
        words = sent.split()
        if len(words) > a.max_words:
            warns.append(f"long sentence ({len(words)} words): {sent[:70]}…")
    for hit in sorted(set(HEDGES.findall(text))):
        warns.append(f"hedge word: {hit}")

    for e in errors:
        print("ERROR", e)
    for w in warns[:40]:
        print("WARN ", w)
    if len(warns) > 40:
        print(f"WARN  … {len(warns) - 40} more")
    print(f"{'FAIL' if errors else 'OK'}: {len(errors)} error(s), {len(warns)} warning(s), {len(mermaids)} diagram(s)")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
