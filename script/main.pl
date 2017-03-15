#!env perl

#ログモジュール読み込み
require "common/log.pl";

#警告関係モジュール読み込み
use strict;
use warnings;

#設定ファイル関係モジュール読み込み
use Config::Tiny;

#HTTP通信関係モジュール読み込み
use HTTP::Daemon;

#文字コード関係モジュール読み込み
use utf8;

#設定ファイル読み込み
my $conf_file = "../configuration.ini";
my $config = Config::Tiny->new->read( $conf_file );

print $config->{AccessPoint}->{Port}."\n";

&debug_log( "やったぜ" );