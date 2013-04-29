
FILES = ../www/index.html ../www/app.js ../www/style.css ../www/conversions.js

all: $(FILES)

clean:
	rm -f $(FILES)


../www/index.html: index.jade
	jade -P -o ../www index.jade

../www/app.js: app.coffee
	coffee -b -c -o ../www app.coffee

../www/conversions.js: conversions.coffee
	coffee -b -c -o ../www conversions.coffee

../www/style.css: style.styl
	stylus -o ../www style.styl

