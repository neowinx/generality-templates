<#import "*/gen-options.ftl" as opt>
@echo OFF & setLocal
color 70
title DEPLOYING GenGen
echo ====================================================
echo This will replace the files of your current project.
echo Press CTRl+C to cancel.
echo ====================================================
echo Press [Enter] key to start backup...
pause >nul
echo *********************************
echo INIT
echo *********************************
echo.
ECHO ====================
ECHO Discarding .svn's...
ECHO ====================
FOR /F "tokens=*" %%G IN ('DIR /B /AD /S *.svn*') DO RMDIR /S /Q "%%G"
echo.
echo ====================
echo Copying main classes
echo ====================
rem Verificamos si existe el directorio o paquete, de lo contrario lo creamos
set MAIN_PATH=${opt.mainPath}
if exist %MAIN_PATH% (
	echo Already exist main...
) else (
	echo Creanting main...
	mkdir %MAIN_PATH%
)
rem #Verificamos si existe un .bk y en caso contrario copiamos o sobreescribimos los archivos
for /f %%f in ('dir /b main\*.java') do (
	if exist %MAIN_PATH%\%%f.bk (
		echo * Already exist %%f.bk, can not be replaced.
	) else (
		echo * File %%f.bk does not exist, was copied and/or replaced.
		xCOPY /Y /E /I main\%%f %MAIN_PATH%
	)
)
echo.
echo ========================
echo Copying entities classes
echo ========================
set ENTITY_PATH=${opt.entitiesPath}
if exist %ENTITY_PATH% (
	echo Already exist entity...
	
) else (
	echo Creanting entity...
	mkdir %ENTITY_PATH%
)
rem #Verificamos si existe un .bk y en caso contrario copiamos o sobreescribimos los archivos
for /f %%f in ('dir /b entity\*.java') do (
	if exist %ENTITY_PATH%\%%f.bk (
		echo * Already exist %%f.bk, can not be replaced.
	) else (
		echo * File %%f.bk does not exist, was copied and/or replaced.
		xCOPY /Y /E /I entity\%%f %ENTITY_PATH%
	)
)
echo.
echo ======================
echo Copying dialog classes
echo ======================
set DIALOG_PATH=${opt.dialogsPath}
if exist %DIALOG_PATH% (
	echo Already exist dialog...
) else (
	echo Creanting dialog...
	mkdir %DIALOG_PATH%
)
rem #Verificamos si existe un .bk y en caso contrario copiamos o sobreescribimos los archivos
for /f %%f in ('dir /b dialog\*.java') do (
	if exist %DIALOG_PATH%\%%f.bk (
		echo * Already exist %%f.bk, can not be replaced.
	) else (
		echo * File %%f.bk does not exist, was copied and/or replaced.
		XCOPY /Y /E /I dialog\%%f %DIALOG_PATH%
	)
)
ECHO =================================
ECHO Adding classes to persistence.xml
ECHO =================================
IF EXIST "${opt.projectDir + "\\src\\META-INF\\persistence.xml.bk"}" (
  ECHO "${opt.projectDir + "\\src\\META-INF\\persistence.xml.bk"}" already exist.. skipping 
) ELSE ( 
  COPY "${opt.projectDir + "\\src\\META-INF\\persistence.xml"}" "${opt.projectDir + "\\src\\META-INF\\persistence.xml.bk"}"
  CSCRIPT //NoLogo sed.vbs s/"transaction-type=(.)RESOURCE_LOCAL(.)>[\s\S]*"/"transaction-type=$1RESOURCE_LOCAL$2>"/ < "${opt.projectDir + "\\src\\META-INF\\persistence.xml"}" > "${opt.projectDir + "\\src\\META-INF\\arriba.dat"}"
  CSCRIPT //NoLogo sed.vbs s/"[\s\S]*transaction-type=.RESOURCE_LOCAL.>"// < "${opt.projectDir + "\\src\\META-INF\\persistence.xml"}" > "${opt.projectDir + "\\src\\META-INF\\abajo.dat"}"
  TYPE classes >> "${opt.projectDir + "\\src\\META-INF\\arriba.dat"}"
  TYPE "${opt.projectDir + "\\src\\META-INF\\abajo.dat"}" >> "${opt.projectDir + "\\src\\META-INF\\arriba.dat"}"
  DEL /Q "${opt.projectDir + "\\src\\META-INF\\persistence.xml"}" "${opt.projectDir + "\\src\\META-INF\\abajo.dat"}"
  MOVE "${opt.projectDir + "\\src\\META-INF\\arriba.dat"}" "${opt.projectDir + "\\src\\META-INF\\persistence.xml"}"
)
echo *********************************
echo END
echo *********************************
PAUSE