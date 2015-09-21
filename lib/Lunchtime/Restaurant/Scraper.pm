package Web::Scraper::Filter::EncodeUtf8;

use Modern::Perl '2015';

use base qw(Web::Scraper::Filter);
use Encode;

sub filter {
  my($self, $value) = @_;
#  return encode_utf8($value);
  return $value;
};

1;

package Lunchtime::Restaurant::Scraper;

use Modern::Perl '2015';

use Data::Dumper;
use Moo;
use URI;
use Web::Scraper;

extends 'Lunchtime::Restaurant';

has name => (
  is => 'ro',
  isa => sub {
    die "'name' is mandatory!" unless $_[0];
  },
);

has url => (
  is => 'ro',
  isa => sub {
    die "'url' is mandatory!" unless $_[0];
  },
);

has xpath => (
  is => 'ro',
  isa => sub {
    die "$_[0] is not a hashref!" unless ref $_[0] eq 'HASH';
  },
);

has filter => (
  is => 'ro',
  isa => sub {
    die "$_[0] is not a sub!" unless ref $_[0] eq 'CODE'
  },
);

has menu_data => (
  is => 'ro',
);

has spacer => (
  is => 'ro',
);

sub scrape {
  my $self = shift;

  my @processes;
  if ( $self->{xpath}{menu} ) {

    my $extract = [ 'TEXT', 'EncodeUtf8' ];
    if ( $self->{filter} ) {
      push(@$extract, \&{$self->{filter}});
    };
    
    for my $xpath_category ( keys %{$self->{xpath}} ) {
      if ( $self->{xpath}{$xpath_category} ) {
        push(@processes, sub { process $self->{xpath}{$xpath_category}, $xpath_category.'[]' => $extract } );
      };
    };
  };

  my $scraper = scraper {
    for my $process (@processes) {
      $process->();
    };
  };

  my $menu_data = $scraper->scrape( URI->new($self->{url}) );

  if ( defined $self->spacer ) {
    my $filtered_menu_data = {};

    for my $xpath_category ( keys %{$menu_data} ) {
      for my $item (@{$menu_data->{$xpath_category}}) {

        push(@{$filtered_menu_data->{$xpath_category}}, $item);

        my $regex = $self->spacer;
        if ( $item =~ $regex ) {
            push(@{$filtered_menu_data->{$xpath_category}}, "");
        };

      };
    };

    $menu_data = $filtered_menu_data;
  };

  $self->{menu_data} = $menu_data;
};

1;
