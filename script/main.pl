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
use HTTP::Status;

#文字コード関係モジュール読み込み
use utf8;

#設定ファイル読み込み
my $conf_file = "../configuration.ini";
my $config = Config::Tiny->new->read( $conf_file );

&debug_log( "設定ファイル情報" );
&debug_log( "[AccessPoint]" );
&debug_log( "Port:".$config->{AccessPoint}->{Port} );

#接続情報取得
my $http_daemon = HTTP::Daemon->new( LocalAddr => '0.0.0.0' , LocalPort => $config->{AccessPoint}->{Port} ) || die;
my $url = $http_daemon->url;
&debug_log( "URL:".$url );

&info_log( "接続受付開始" );
while( my ( $client_connection , $peer_addr ) = $http_daemon->accept ){
	
	#要求を受け付けた時
	while( my $request = $client_connection->get_request ){
	
		#要求を出したクライアントのIPアドレスを取得
		my ( $port , $ip ) = sockaddr_in( $peer_addr );
		$ip = join( "." , unpack( "C4" , $ip ) );
		
		#パスの取得
		my $path = $request->url->path;
		&debug_log( "パス:".$path );
		
		if( $path =~ /\/aaa\/bbb/ ){
			
			&info_log( $ip."からの要求を受け取りました" );
			
			
			#レスポンスを返す
			&info_log( "レスポンス通知" );
			my $response_header = HTTP::Headers->new( "Content-Type" => "application/json; charset=utf-8" );
			my $response = HTTP::Response->new( 200 , "OK" , $response_header , '{ "result":"0" }' );
			$client_connection->send_response( $response );
			&success_log( "レスポンス通知成功" );
			
		}
		#favicon.ico
		elsif( $path eq "/favicon.ico" ){
			&debug_log( "/favicon.icoについて".$ip."からの要求を受け取りました" );
			$client_connection->send_error( RC_FORBIDDEN );
		}
		#エラー処理
		else {
			&error_log( $ip."から不明なパスの要求を受け取りました" );
			$client_connection->send_error( RC_FORBIDDEN );
		}
		
		#他クライアントからの要求も取れるようにwhileから抜ける
		last;
	
	}
	
	#終了
	$client_connection->close;
	undef( $client_connection );
	
}
