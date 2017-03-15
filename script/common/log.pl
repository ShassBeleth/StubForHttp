#!env perl

#警告関係のモジュール読み込み
use strict;
use warnings;

#文字コード関係のモジュール読み込み
use utf8;
my $enc_os = 'cp932';
binmode STDIN, ":encoding( $enc_os )";
binmode STDOUT, ":encoding( $enc_os )";
binmode STDERR, ":encoding( $enc_os )";

#現在日時を返す
sub _now_date {
	my ( $sec , $min , $hour , $mday , $month , $year , $wday , $yday , $isdst ) = localtime( time );
	$year += 1900;
	$month += 1;
	return "[".sprintf( "%04d" , $year )."/".sprintf( "%02d" , $month )."/".sprintf( "%02d" , $mday )." ".sprintf( "%02d" , $hour ).":".sprintf( "%02d" , $min ).":".sprintf( "%02d" , $sec )."]";
};

#DEBUGログを表示
sub debug_log {
	my ( $message ) = @_;
	print &_now_date()."-DEBUG-\t$message\n";
}

#INFOログを表示
sub info_log {
	my ( $message ) = @_;
	print &_now_date()."-INFO-\t$message\n";
}

#ERRORログを表示
sub error_log {
	my ( $message ) = @_;
	print &_now_date()."-ERROR-\t$message\n";
}

#成功ログを表示
sub success_log {
	my ( $message ) = @_;
	print &_now_date()."-SUCCESS-\t$message\n";
}

#失敗ログを表示
sub failed_log {
	my ( $message ) = @_;
	print &_now_date()."-FAILED-\t$message\n";
}

#警告ログを表示
sub warning_log {
	my ( $message ) = @_;
	print &_now_date()."-WARNING-\t$message\n";
}

1;