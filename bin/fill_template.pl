#!/usr/bin/env perl

use Modern::Perl '2015';

=head1 NAME

fill_template.pl

=head1 DESCRIPTION

Create HTML from template file (written in HTML::Template format) and fill it with JSON data from various Restaurants.

 @author: Sebastian Heil <mail+git@sebastianheil.de>

=head1 SYNOPSIS

Use custom files
 fill_template --json out/lunchtime.json --template src/lunchtime.tmpl --html out/lunchtime.html --title 'Menus'

Use defaults
 fill_template

=head1 PARAMETERS

 @params $json|j              path to JSON file
                              needs following structure:
 {version: $version, last_update: $last_update, restaurants: { key: { name: $name, url: $url, menu_data: { description: @description, comment: @comment, menu: @menu } } } }
 @params $template            path to HTML::TEMPLATE formated file with all the above JSON keys
 @params $html|h              path where the generated HTML is going to be written
 @params $title|t             title of the generated HTML

=cut

use Data::Dumper;
use Encode;
use File::Slurp;
use Getopt::Long;
use JSON;
use HTML::Template;

my $p_template    = 'src/lunchtime.tmpl';
my $p_json        = 'out/lunchtime.json';
my $p_html        = 'out/lunchtime.html';
my $p_title       = 'Tages- und Wochenkarten';

GetOptions(
  'template=s'    => \$p_template,
  'json|j=s'      => \$p_json,
  'html|h=s'      => \$p_html,
  'title|t=s'     => \$p_title,
);

my $template = HTML::Template->new(
  filename => $p_template,
  utf8 => 1,
);

my $json        = JSON->new;
my $json_data   = decode_utf8( read_file( $p_json ) );
my $data        = $json->decode( $json_data );

$template->param( TITLE  => $p_title );
$template->param( LAST_UPDATE => localtime($data->{last_update}) . "");

my @toc = ();

my @loopdata = ();
while (my ($key,$value) = each %{$data->{restaurants}}) {
  my %restaurant_data;
  $restaurant_data{ANCHOR}   = $key;
  $restaurant_data{NAME}     = $value->{name};
  push(
    @toc, 
    { 
      name => $restaurant_data{NAME},
      href => $restaurant_data{ANCHOR}, 
    }
  );

  $restaurant_data{URL}      = $value->{url};
  $restaurant_data{URL_NAME} = $value->{url} // "Keine Website bekannt.";

  while ( my ($menu_key, $menu_value) = each %{$value->{menu_data}} ) {
    foreach my $item ( @{$menu_value} ) {
      my %description_data;
      $description_data{ITEM} = $item;
      push(@{$restaurant_data{uc $menu_key}}, \%description_data);
    };
  };
  push(@loopdata,\%restaurant_data);
};

@loopdata = sort { $a->{NAME} cmp $b->{NAME} } @loopdata;
$template->param(RESTAURANTS => \@loopdata);
@toc = sort { $a->{name} cmp $b->{name} } @toc;
$template->param(TOC => \@toc);

open( my $fh, '>', $p_html );
print $fh encode_utf8( $template->output() );
close( $fh );
