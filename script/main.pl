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

#接続情報取得
my $http_daemon = HTTP::Daemon->new( LocalAddr => '0.0.0.0' , LocalPort => $config->{AccessPoint}->{Port} ) || die;
my $url = $http_daemon->url;

&info_log( "接続受付開始\n" );
while( my ( $client_connection , $peer_addr ) = $http_daemon->accept ){
	
	#要求を受け付けた時
	while( my $request = $client_connection->get_request ){
	
		#要求を出したクライアントのIPアドレスを取得
		my ( $port , $ip ) = sockaddr_in( $peer_addr );
		$ip = join( "." , unpack( "C4" , $ip ) );
		
		&info_log( $ip."からの要求を受け取りました" );
	
	}
	
}
