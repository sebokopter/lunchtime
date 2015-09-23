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
- MOO
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

- Abseits
- Alte Durlacher Brauerei
- American Diner
- Aslan
- Bambusgarten
- Borsalino
- Cafe Galerie
- Curry'n'Roll
- Da Pino
- Große Linde
- Hanoi
- Indian Rasoi
- Maharani
- Metzgerei Sack
- Pavarotti
- Rimelin
- Romulus et Remus
- Sol i Luna
- Vogelbräu

## TODO

- spacer line which inserts new line in front of given regex
- insert <pre> tags for metzgerei sack output
