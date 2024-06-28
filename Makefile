hugo.log:
	(hugo server >> $@; rm -f hugo.pid $@) & pgrep -P $$! > hugo.pid

node_modules/chrome-headless-render-pdf/cli/chrome-headless-render-pdf.js:
	npm install chrome-headless-render-pdf

render.sh: node_modules/chrome-headless-render-pdf/cli/chrome-headless-render-pdf.js

cv.pdf: hugo.log render.sh FORCE
	./render.sh --pdf=$@ --url="`grep -o 'http://.*/' $<`"
FORCE:

