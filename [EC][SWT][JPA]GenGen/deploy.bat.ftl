<#import "*/gen-options.ftl" as opt>
@ECHO OFF & setLocal
COLOR 70
TITLE DEPLOYING GenGen
ECHO ====================================================
ECHO This will replace the files of your current project.
ECHO Press CTRl+C to cancel.
ECHO ====================================================
PAUSE
ECHO ====================
ECHO Discarding .svn's...
ECHO ====================
FOR /F "tokens=*" %%G IN ('DIR /B /AD /S *.svn*') DO RMDIR /S /Q "%%G"
ECHO ====================
ECHO Copying main classes
ECHO ====================
XCOPY /Y /E /I "main\*.java" "${opt.mainPath}"
ECHO ========================
ECHO Copying entities classes
ECHO ========================
XCOPY /Y /E /I "entity\*.java" "${opt.entitiesPath}"
ECHO ======================
ECHO Copying dialog classes
ECHO ======================
XCOPY /Y /E /I "dialog\*.java" "${opt.dialogsPath}"
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
ECHO "END"
PAUSE