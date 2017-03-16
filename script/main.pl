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
&debug_log( "[Request]" );
&debug_log( "Path:".$config->{Request}->{Path} );
&debug_log( "Method:".$config->{Request}->{Method} );
&debug_log( "[Response]" );
&debug_log( "ContentType:".$config->{Response}->{ContentType} );
&debug_log( "Status:".$config->{Response}->{Status} );

#接続情報取得
my $http_daemon = HTTP::Daemon->new( LocalAddr => '0.0.0.0' , LocalPort => $config->{AccessPoint}->{Port} ) || die;
my $url = $http_daemon->url;
&debug_log( "URL:".$url );

&info_log( "接続受付開始" );
while( my ( $client_connection , $peer_addr ) = $http_daemon->accept ){
	
	#要求を受け付けた時
	while( my $request = $client_connection->get_request ){
		&debug_log( "要求を受け付けました" );
		
		#要求を出したクライアントのIPアドレスを取得
		my ( $port , $ip ) = sockaddr_in( $peer_addr );
		$ip = join( "." , unpack( "C4" , $ip ) );
		
		#パスの取得
		my $path = $request->url->path;
		&debug_log( "パス:".$path );
		
		#指定パスだった場合
		if( $path eq $config->{Request}->{Path} ){
			&info_log( $ip."からの要求を受け取りました" );
			
			#メソッド判定
			&debug_log( "指定メソッド:".$config->{Request}->{Method} );
			&debug_log( "受け付けたリクエストのメソッド：".$request->method );
			if( $request->method eq $config->{Request}->{Method} ){
				&success_log( "指定メソッドを受け取りました" );
			}
			else {
				&failed_log( "指定されたメソッドと異なります" );
			}
			
			#レスポンスを返す
			&info_log( "レスポンス通知" );
			my $response_header = HTTP::Headers->new( "Content-Type" => $config->{Response}->{ContentType} );
			my $response = HTTP::Response->new( $config->{Response}->{Status} , "" , $response_header , '{ "result":"0" }' );
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
