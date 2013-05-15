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
XCOPY /Y /E /I "main\*.java" "${opt.mainPathEjb}"
ECHO ====================
ECHO Copying hot classes
ECHO ====================
XCOPY /Y /E /I "hot\*.java" "${opt.hotPathEjb}"
ECHO ============================
ECHO Copying messsages properties
ECHO ============================
XCOPY /Y /E /I "resources\*.properties" "${opt.projectDir + "\\src\\"}"
ECHO ==================
ECHO Copying view files
ECHO ==================
<#if opt.dirPerTable>
	<#list tables as t>
		<#assign thaDir = opt.projectDir + "\\WebContent\\${opt.dirPerTablePrefix}\\" + opt.mixedCaseStr(t.tableName) />
XCOPY /Y /I "view\${opt.camelCaseStr(t.tableName)}Edit.*" "${thaDir}"
XCOPY /Y /I "view\${opt.camelCaseStr(t.tableName)}List.*" "${thaDir}"
	</#list>
<#else>
XCOPY /Y /E /I "view\*.*" "${opt.projectDir + "\\WebContent\\"}"
</#if>
ECHO ============
ECHO Copying menu
ECHO ============
XCOPY /Y /E /I "view\layout\menu.xhtml" "${opt.projectDir + "\\WebContent\\layout\\"}"
ECHO =================================
ECHO Adding classes to persistence.xml
ECHO =================================
IF EXIST "${opt.ejbProjectDir + "\\" + opt.ejbModuleName + "\\META-INF\\persistence.xml.bk"}" (
  ECHO "${opt.ejbProjectDir + "\\" + opt.ejbModuleName + "\\META-INF\\persistence.xml.bk"}" already exist.. skipping 
) ELSE ( 
  COPY "${opt.ejbProjectDir + "\\" + opt.ejbModuleName + "\\META-INF\\persistence.xml"}" "${opt.ejbProjectDir + "\\" + opt.ejbModuleName + "\\META-INF\\persistence.xml.bk"}"
  CSCRIPT //NoLogo sed.vbs s/"<(.)jta-data-source>[\s\S]*"/"<$1jta-data-source>"/ < "${opt.ejbProjectDir + "\\" + opt.ejbModuleName + "\\META-INF\\persistence.xml"}" > "${opt.ejbProjectDir + "\\" + opt.ejbModuleName + "\\META-INF\\arriba.dat"}"
  CSCRIPT //NoLogo sed.vbs s/"[\s\S]*<.jta-data-source>"// < "${opt.ejbProjectDir + "\\" + opt.ejbModuleName + "\\META-INF\\persistence.xml"}" > "${opt.ejbProjectDir + "\\" + opt.ejbModuleName + "\\META-INF\\abajo.dat"}"
  TYPE classes >> "${opt.ejbProjectDir + "\\" + opt.ejbModuleName + "\\META-INF\\arriba.dat"}"
  TYPE "${opt.ejbProjectDir + "\\" + opt.ejbModuleName + "\\META-INF\\abajo.dat"}" >> "${opt.ejbProjectDir + "\\" + opt.ejbModuleName + "\\META-INF\\arriba.dat"}"
  DEL /Q "${opt.ejbProjectDir + "\\" + opt.ejbModuleName + "\\META-INF\\persistence.xml"}" "${opt.ejbProjectDir + "\\" + opt.ejbModuleName + "\\META-INF\\abajo.dat"}"
  MOVE "${opt.ejbProjectDir + "\\" + opt.ejbModuleName + "\\META-INF\\arriba.dat"}" "${opt.ejbProjectDir + "\\" + opt.ejbModuleName + "\\META-INF\\persistence.xml"}"
)
ECHO "END"
PAUSE