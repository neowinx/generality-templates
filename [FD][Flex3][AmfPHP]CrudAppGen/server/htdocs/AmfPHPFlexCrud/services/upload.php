<?php
$fp = fopen( $_REQUEST["id"], "wb" );
fwrite( $fp, $GLOBALS[ 'HTTP_RAW_POST_DATA' ] );
fclose( $fp );
if($_REQUEST["idOld"] != null){
	unlink($_REQUEST["idOld"]);
}
?>