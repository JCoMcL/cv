#!/usr/bin/env sh

node node_modules/chrome-headless-render-pdf/cli/chrome-headless-render-pdf.js --scale=0.86 --no-margins  --include-background $@
