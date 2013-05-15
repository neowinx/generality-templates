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
XCOPY /Y /E /I "server\htdocs\FlexCrud" "${opt.serverDir}"
ECHO =========================
ECHO Compiling Flex sources...
ECHO =========================
CD "project\FlexCrud"
${opt.flexSDKHome}\bin\mxmlc -load-config+=obj\FlexCrudConfig.xml -debug=true -incremental=true -benchmark=false -static-link-runtime-shared-libraries=true -link-report exclude.xml -o obj\FlexCrud634382418912941706
MOVE /Y obj\FlexCrud634382418912941706 bin\FlexCrud.swf
DIR /B obj\*Module*.xml > modules.tmp
CSCRIPT //NoLogo ..\..\sed.vbs s/Config.xml// <modules.tmp >parsedModules.tmp
FOR /F "tokens=*" %%I IN (parsedModules.tmp) DO ( 
  ${opt.flexSDKHome}\bin\mxmlc -load-config+=obj\%%IConfig.xml -debug=true -incremental=true -benchmark=false -static-link-runtime-shared-libraries=true -load-externs=exclude.xml -o obj\%%I634382418913336756
  MOVE /Y obj\%%I634382418913336756 bin\%%I.swf 
)
ECHO =====================
ECHO Copying Flex files...
ECHO =====================
XCOPY /Y /E bin "${opt.serverDir}"
ECHO ==============
ECHO Opening url...
ECHO ==============
FlexCrud.url
ECHO "END?"
PAUSE