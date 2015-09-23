package Lunchtime::Restaurant;

use Modern::Perl '2014';

use Data::Dumper;
use Moo;

has name => (
  is => 'ro',
  isa => sub {
    die "'name' is mandatory!" unless $_[0];
  },
);

has url => (
  is => 'ro',
);

has menu_data => (
  is => 'ro',
);

sub TO_JSON {
  my $self = shift;
  return { 
    name      => $self->name,
    url       => $self->url,
    menu_data => $self->menu_data,
  };
};
1;
