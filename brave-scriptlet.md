# Brave Custom Scriptlet: Copy Best Stream

This document explains how to run the `brave-video-stream-capture.scriptlet.js` helper inside Brave without an extension. It uses Brave's custom scriptlet pipeline (desktop 1.75+) described in [Brave's "Custom scriptlets" privacy update](https://brave.com/privacy-updates/32-custom-scriptlets/) and the newer Shields > Content filtering workflow.

Need the Tampermonkey / Firefox-focused userscript instead? See [`video-stream-capture.user.js`](video-stream-capture.user.js) and the main [`README.md`](README.md).

## Prerequisites

- Brave Desktop 1.75 or newer. Custom scriptlets live under `brave://settings/shields/filters`.
- Enable **Developer mode** in `Settings → Shields → Content filtering`. Brave gates scriptlets behind this toggle for safety.
- Familiarity with Shields filter syntax (`example.com##+js(scriptlet-name)`), documented in the Brave Help Center and the linked blog post above.

## Add the scriptlet

1. Open `brave://settings/shields/filters`.
2. Scroll to **Custom scriptlets** (visible after enabling Developer mode) and click **Add new scriptlet**.
3. Name it `video-stream-capture` (Brave automatically stores it as `user-video-stream-capture.js`).
4. Paste the entire contents of [`brave-video-stream-capture.scriptlet.js`](brave-video-stream-capture.scriptlet.js). The script is an IIFE, so no wrapper is needed.
5. Save. The scriptlet now appears in your list.

## Apply it to sites (or globally)

1. Still under Content filtering, locate **Custom filters** and click **Add custom rule**.
2. To run on **all sites**, add the rule:

   ```text
   *##+js(user-video-stream-capture)
   ```

   You can scope the left-hand side to specific domains if needed (e.g., `example.com##+js(user-video-stream-capture)`).
3. Save changes. Reload any tabs where you want the capture helper available.

## Usage in Brave

Once injected, the script mirrors the Tampermonkey userscript:

- Right-click a playing `<video>` to copy the best-quality HLS/DASH URL Brave has observed (master playlists preferred, codec order optimized for ffmpeg/VLC remux).
- Ctrl+right-click copies the raw URL targeted or last seen, bypassing the upgrade step.
- The script hooks fetch/XHR in the page context (per Brave's scriptlet recommendation), so it survives CSP/sandboxing and works inside iframes.
- Clipboard writes rely on the standard Clipboard API or a textarea fallback (no `GM_setClipboard` in this environment).

## Notes & troubleshooting

- Like all Brave scriptlets, code runs with page privileges. Only inject scripts you trust—see the Brave blog linked above for security guidance.
- If Brave blocks clipboard writes on a site, the script falls back to a manual `prompt()` so you can copy the URL yourself.
- To disable, remove the filter rule or the scriptlet entry from `brave://settings/shields/filters`.
- A restart or Shields toggle is sometimes needed after large scriptlet edits; Brave caches them per site.

Refer to Brave's latest Content filtering documentation if UI labels move in future releases. The instructions here match the 2025-11 desktop builds.
