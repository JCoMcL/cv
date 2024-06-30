'CV-Jordan-Conway-McLaughlin.pdf': cl.pdf cv.pdf
	gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -sOutputFile=$@ $^

hugo.pid:
hugo.log:
	(hugo server >> $@; rm -f hugo.pid $@) & pgrep -P $$! > hugo.pid

hugo-url: hugo.log
	tail -n +0 -F $< | sed -En '/http:\/\//{s|.*(http:\/\/.+\/).*|\1|p;q}' > $@

node_modules/chrome-headless-render-pdf/cli/chrome-headless-render-pdf.js:
	npm install chrome-headless-render-pdf

render.sh: node_modules/chrome-headless-render-pdf/cli/chrome-headless-render-pdf.js

# I could not be bothered figuring out how to add a second page to Hugo, I'm so done with that framework.
# As a final act of spite, Hugo has built-in symlink awareness which it uses to ignore all symlinks. Hence the hardlinks.
# I should have moved to a new framework a long time ago
cv.pdf: render.sh
	ln -f `realpath layouts/cv.html` `realpath -m layouts/index.html`
	${MAKE} restart-hugo
	${MAKE} hugo-url
	./render.sh --pdf=$@ --url=`<hugo-url`

cl.pdf: render.sh
	ln -f `realpath layouts/cl.html` `realpath -m layouts/index.html`
	${MAKE} restart-hugo
	${MAKE} hugo-url
	./render.sh --pdf=$@ --url=`<hugo-url`

stop:
	if test -e "hugo.pid"; then kill `<hugo.pid`; fi
	while test -e "hugo.log"; do sleep 0.1; done

clean-hugo: stop
	#hugo --gc --ignoreCache
	rm -rf public hugo-url

restart-hugo: clean-hugo hugo.pid
	sleep 1

clean: clean-hugo
	rm -rf cv.pdf cl.pdf CV-Jordan-Conway-McLaughlin.pdf

.PHONY: clean restart-hugo clean-hugo stop

