package Lunchtime::Restaurant::Parser;

use Modern::Perl '2015';

use Data::Dumper;
use Encode;
use File::Slurp;
use File::Temp qw(tempfile tempdir);
use LWP::Simple;
use Moo;

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

has substitute => (
  is => 'ro',
);

has menu_data => (
  is => 'ro',
);

sub parse_pdf {
  my $self = shift;

  my $tmpdir = tempdir( CLEANUP => 1 );
  my ($fh_pdf, $tmpfile_pdf) = tempfile( DIR => $tmpdir );
  my ($fh_txt, $tmpfile_txt) = tempfile( DIR => $tmpdir );

  getstore($self->{url}, $tmpfile_pdf);

  system("pdftotext -layout -enc UTF-8 $tmpfile_pdf $tmpfile_txt");

  my $menu = ();
  my $text = decode_utf8(read_file($tmpfile_txt));
  if ( $self->{substitute} ) {
    eval( '$text =~ ' . $self->{substitute} );
  };
  @{$menu} = split('\n', $text);
  $self->{menu_data}{menu} = $menu;
};

1;
