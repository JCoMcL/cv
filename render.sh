#!/usr/bin/env sh

echo args = $@
node node_modules/chrome-headless-render-pdf/cli/chrome-headless-render-pdf.js --no-margins  --include-background $@
