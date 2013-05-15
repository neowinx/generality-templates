<#import "*/gen-options.ftl" as opt>
@ECHO OFF & setLocal
COLOR 70
TITLE DEPLOYING FlexCrud
ECHO ====================
ECHO Discarding .svn's...
ECHO ====================
FOR /F "tokens=*" %%G IN ('DIR /B /AD /S *.svn*') DO RMDIR /S /Q "%%G"
ECHO ====================
ECHO Copying to htdocs...
ECHO ====================
XCOPY /Y /E /I "server\htdocs\AmfPHPFlexCrud" "${opt.serverDir}"
ECHO =========================
ECHO Compiling Flex sources...
ECHO =========================
CD "project\AmfPHPFlexCrud"
"${opt.flexSDKHome}\bin\mxmlc" -load-config+=obj\AmfPHPFlexCrudConfig.xml -debug=true -incremental=true -benchmark=false -static-link-runtime-shared-libraries=true -link-report exclude.xml -o obj\AmfPHPFlexCrud634382418912941706
MOVE /Y obj\AmfPHPFlexCrud634382418912941706 bin\AmfPHPFlexCrud.swf
DIR /B obj\*Module*.xml > modules.tmp
CSCRIPT //NoLogo ..\..\sed.vbs s/Config.xml// <modules.tmp >parsedModules.tmp
FOR /F "tokens=*" %%I IN (parsedModules.tmp) DO ( 
  "${opt.flexSDKHome}\bin\mxmlc" -load-config+=obj\%%IConfig.xml -debug=true -incremental=true -benchmark=false -static-link-runtime-shared-libraries=true -load-externs=exclude.xml -o obj\%%I634382418913336756
  MOVE /Y obj\%%I634382418913336756 bin\%%I.swf 
)
ECHO =====================
ECHO Copying Flex files...
ECHO =====================
XCOPY /Y /E bin "${opt.serverDir}"
ECHO =======================================
ECHO Modifying amfphp configuration files...
ECHO =======================================
IF EXIST ${opt.serverDir}\gateway.php.bk (
  ECHO ${opt.serverDir}\gateway.php.bk already exist.. skipping 
) ELSE ( 
  COPY ${opt.serverDir}\gateway.php ${opt.serverDir}\gateway.php.bk
  CSCRIPT //NoLogo ..\..\sed.vbs s/"PRODUCTION_SERVER(.), true"/"PRODUCTION_SERVER$1, false"/ <${opt.serverDir}\gateway.php > ${opt.serverDir}\gateway.php.dat
  DEL /Q ${opt.serverDir}\gateway.php
  MOVE ${opt.serverDir}\gateway.php.dat ${opt.serverDir}\gateway.php 
) 
IF EXIST ${opt.serverDir}\globals.php.bk ( 
  ECHO ${opt.serverDir}\globals.php.bk already exist.. skipping 
) ELSE (
  COPY ${opt.serverDir}\globals.php ${opt.serverDir}\globals.php.bk
  CSCRIPT //NoLogo ..\..\sed.vbs s/"\?>"// < ${opt.serverDir}\globals.php > ${opt.serverDir}\globals.php.dat
  DEL /Q ${opt.serverDir}\globals.php
  MOVE ${opt.serverDir}\globals.php.dat ${opt.serverDir}\globals.php
  TYPE ..\..\globals.php >> ${opt.serverDir}\globals.php
)
ECHO ==============
ECHO Opening url...
ECHO ==============
AmfPHPFlexCrud.url
ECHO "END?"
PAUSE