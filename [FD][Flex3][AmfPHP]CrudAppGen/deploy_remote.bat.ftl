<#import "*/gen-options.ftl" as opt>
@ECHO OFF & setLocal

set winscpHome=F:\UTILS\winscp432
set remoteHost=oneguysolutions.com
set remotePath=/Files/WWW/Documents/BTC
set remoteUser=myuser
set rempotePw=mypwd
set localPath=${opt.serverDir}
set mysqlDumpExe=F:\xampp\mysql\bin\mysqldump.exe
set database=${opt.databaseName}
::OBS: El locale debe ser es_UN o la fecha se quitara de forma erronea
set hora=%time:~0,2%
set hora=%hora: =0%
set fecha=%date:~-4,4%%date:~-10,2%%date:~-7,2%%hora%%time:~3,2%
set zhome=F:\Program Files\7-Zip\7z.exe

COLOR 70
TITLE DUMPING DATABASE %database%
ECHO DUMPING DATABASE %database%
"%mysqlDumpExe%" -u root -P 3306 %database% > %database%%fecha%.sql
TITLE COMPRESSING FILE %database%%fecha%.sql
ECHO COMPRESSING FILE %database%%fecha%.sql
"%zhome%" -r a %database%%fecha%.zip %database%%fecha%.sql
DEL /S /Q %database%%fecha%.sql
MOVE %database%%fecha%.zip %localPath%
TITLE COPYING %localPath% on %remoteHost%:%remotePath%
ECHO COPYING %localPath% on %remoteHost%:%remotePath%
"%winscpHome%\WinSCP.com" /command "open %remoteUser%:%rempotePw%@%remoteHost%" "synchronize remote %localPath% %remotePath%" "cd %remotePath%" "call unzip %database%%fecha%.zip" "call echo 'DROP DATABASE %database%; CREATE DATABASE %database%;' > create_drop_%database%.sql" "call mysql -B -u root -P 3306 %database% < create_drop_%database%.sql" "call mysql -B -u root -P 3306 %database% < %database%%fecha%.sql" "exit"
ECHO "END?"
PAUSE