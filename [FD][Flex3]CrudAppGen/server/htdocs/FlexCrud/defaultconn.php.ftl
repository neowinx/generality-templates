<#import "*/gen-options.ftl" as opt>
<?php
/**
 * connection settings
 * replace with your own hostname, database, username and password 
 */
<@opt.connectionSettings />
$conn = mysql_pconnect($hostname_conn, $username_conn, $password_conn) or trigger_error(mysql_error(),E_USER_ERROR);
mysql_select_db($database_conn, $conn);
mysql_query("SET NAMES 'utf8'");
?>
