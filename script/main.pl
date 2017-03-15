#!env perl

require "common/log.pl";

use strict;
use warnings;

use Config::Tiny;

use utf8;



my $conf_file = "../configuration.ini";
my $c = Config::Tiny->new->read( $conf_file );

print $c->{AccessPoint}->{Port}."\n";

&debug_log( "やったぜ" );