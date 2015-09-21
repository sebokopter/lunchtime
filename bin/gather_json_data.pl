#!/usr/bin/env perl

use Modern::Perl '2015';

=head1 NAME

gather_json_data.pl

=head1 DESCRIPTION

Return JSON file with name and url of given restaurants. Optionally parse (read PDF files) or scrape (read HTML files) also menus of the day/week from the given restaurants.

 @author: Sebastian Heil <mail+git@sebastianheil.de>

=head1 SYNOPSIS

Use defaults
 gather_json_data.pl

Use custom values
 gather_json_data.pl --conf src/restaurants.conf --json out/lunchtime.json

=head1 PARAMETERS

 @params $conf|c        Path to config file in Config::General format which contains every restaurant url to be parsed or scraped.
 @params $json|j        Path to JSON file where the results are written to.

=cut

use Config::General;
use Data::Dumper;
use Encode;
use Getopt::Long;
use JSON;

use lib 'lib';
use Lunchtime::Restaurant::Parser;
use Lunchtime::Restaurant::Scraper;

# TODO: implement debug output

my $p_json = 'out/lunchtime.json';
my $p_conf = 'src/restaurants.conf';

GetOptions(
  'json|j=s'    => \$p_json,
  'conf|c=s'    => \$p_conf,
);

my %config = Config::General->new( -ConfigFile => $p_conf, -UTF8 => 1 )->getall();

my %restaurant = ();

while ( my ($key, $value) = each %config ) {
  my $restaurant_data = {
    name => $value->{name},
    url  => $value->{url},
    xpath => {
      menu        => $value->{xpath}{menu},
      description => $value->{xpath}{description},
      comment     => $value->{xpath}{comment},
    },
  };
  $restaurant_data->{filter} = eval $value->{filter} if exists $value->{filter};
  $restaurant_data->{spacer} = eval $value->{spacer} if exists $value->{spacer};

  my $restaurant;
  if ( exists $value->{type} ) {
    if ( $value->{type} eq 'html' ) {
      $restaurant = Lunchtime::Restaurant::Scraper->new($restaurant_data);
      $restaurant->scrape;
    };
    if ( $value->{type} eq 'pdf' ) {
      $restaurant = Lunchtime::Restaurant::Parser->new($restaurant_data);
      $restaurant->parse_pdf;
    };
  }
  else {
    $restaurant = Lunchtime::Restaurant->new($restaurant_data);
  };
  $restaurant{$key} = $restaurant;
};

my $json = JSON->new->utf8->convert_blessed();

my $json_data = {
  last_update => time(),
  version     => 1,
  restaurants => \%restaurant,
};

my $json_binary = $json->encode($json_data);
open( my $fh, '>', $p_json) or die("Cannot open $p_json");
print $fh $json_binary;
close($fh);
