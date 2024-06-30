hugo.pid:
hugo.log:
	(hugo server >> $@; rm -f hugo.pid $@) & pgrep -P $$! > hugo.pid

node_modules/chrome-headless-render-pdf/cli/chrome-headless-render-pdf.js:
	npm install chrome-headless-render-pdf

render.sh: node_modules/chrome-headless-render-pdf/cli/chrome-headless-render-pdf.js

cv.pdf: hugo.log render.sh FORCE
	URL=$$(tail -f hugo.log | sed -En '/http:\/\//{s|.*(http:\/\/.+\/).*|\1|p;q}')
	./render.sh --pdf=$@ --url="`grep -o 'http://.*/' $<`"

stop:
	if test -e "hugo.pid"; then kill `<hugo.pid`; fi

clean: stop
	hugo --gc --ignoreCache
	rm -rf public

FORCE:

