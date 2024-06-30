#!/usr/bin/env sh

echo args = $@
node node_modules/chrome-headless-render-pdf/cli/chrome-headless-render-pdf.js --scale=0.86 --no-margins  --include-background $@
