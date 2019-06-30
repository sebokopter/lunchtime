# lunchtime

It's lunch time in Karlsruhe-Durlach

## Description

This program intents to help you with your choice which restaurant you want to go to for lunch time in Karlsruhe-Durlach.

## Dependencies

The following perl modules are required:
- Config::General
- Encode
- File::Slurp
- File::Temp
- HTML::Template
- JSON
- Moo
- Modern::Perl
- URI
- Web::Scraper
(debian packages: libconfig-general-perl libencode-perl libfile-slurp-perl libfile-temp-perl libhtml-template-perl libjson-perl libmoo-perl libmodern-perl-perl liburi-perl libweb-scraper-perl)

The following system binaries are required:
- /usr/bin/pdftotext (debian package: poppler-utils)
- /usr/bin/lessc (debian package: node-less; or npm install -g lessc)

## Installation

    mkdir out
    lessc src/less/lunchtime.less out/lunchtime.css
    bin/gather_json_data.pl && bin/fill_template.pl

## Restaurants in Karlsruhe-Durlach

The following restaurants are currently covered:

- Alte Durlacher Brauerei
- American Diner
- Aslan
- Bambusgarten
- Borsalino
- Cafe Galerie
- Chickenhouse
- Da Pino
- Festhalle
- Hanoi
- Indian Rasoi
- Maharani
- Metzgerei Sack
- Pavarotti
- Romulus et Remus
- Villa Durla
- Vogelbräu

## Config file

The config file is written in perl's Config::General style. Every restaurant has to be enclosed with an unique tag like <rimelin>...</rimelin>.

### Configuration Options

#### name

Name of the restaurant which is displayed in the HTML output file.

#### url

URL to either an HTML or PDF location which should be parsed for lunchtime menus.

#### type

Either "html" or "pdf" has to be defined here. This changes the parsing, so wether pdf2txt or an HTML scraper is invoked.

#### xpath

If the type is "html" then you have to define xpaths where to find the "menu", "description" (optional) and "comment" (optional) from the given URL.

#### spacer

After lines matching this regular expression there is an new line injected in the output.

#### filter

Here is room to write your own perl sub/function which is run over the parsed input just before writing the output to the HTML file.

## TODO

- spacer line which inserts new line in front of given regex
- get pictures from xpaths like: .//div[@class='fbStarGrid']/div[1]/a (for Cafe Galerie, from: https://www.facebook.com/pages/Cafe-Galerie/181267271890905?sk=photos_stream&ref=page_internal)
