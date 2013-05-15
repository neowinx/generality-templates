<#import "*/gen-options.ftl" as opt>
@ECHO OFF & setLocal
COLOR 70
TITLE DEPLOYING GenGen
ECHO ====================================================
ECHO      Deploying Multi Configuration Project
ECHO This will replace the files of your current project.
ECHO Press CTRl+C to cancel.
ECHO ====================================================
PAUSE
ECHO ====================
ECHO Discarding .svn's...
ECHO ====================
FOR /F "tokens=*" %%G IN ('DIR /B /AD /S *.svn*') DO RMDIR /S /Q "%%G"
ECHO =======================
ECHO Generating enum classes
ECHO =======================
<#list tables as table>
	<#if (opt.staticValuesFields?? && opt.staticValuesFields?seq_contains(table.tableName))>
		<#assign svfTableIndex = -1 />
		<#list opt.staticValuesFields as staticValuesField>
			<#assign svfTableIndex = svfTableIndex + 1 />
			<#if (staticValuesField?is_string)> 
				<#assign svfColumns = opt.staticValuesFields[svfTableIndex + 1] />
				<#assign svfColumnIndex = -1 />
				<#list svfColumns as svfColumn>
					<#assign svfColumnIndex = svfColumnIndex + 1 />
					<#if (svfColumn?is_string)>
						<#assign enumName = opt.camelCaseStr(staticValuesField) + opt.camelCaseStr(svfColumn) />
	ECHO package ${opt.enumPackage};  > enums\${enumName}.java
	ECHO public enum ${enumName} {  >> enums\${enumName}.java
						<#assign svfs = svfColumns[svfColumnIndex + 1] />
						<#assign columna = columns?first />
						<#list table.columns as column>
							<#if (column.columnName == svfColumn)>
								<#assign columna = column />
								<#break />
							</#if>
						</#list>
						<#list svfs as svf>
	ECHO 	${svf[1]?upper_case?replace(" ", "_")}(<#if opt.sqlStringTypes?seq_contains(columna.dataType)><#else>new ${opt.insertJavaType(columna)}(${svf[0]})</#if>,"${svf[1]}")<#if svfs?last[0] == svf[0]>;<#else>,</#if>  >> enums\${enumName}.java
						</#list>
	ECHO 	private final ${opt.insertJavaType(columna)} id;  >> enums\${enumName}.java
	ECHO 	private final String descripcion;  >> enums\${enumName}.java
	
	ECHO 	private ${enumName}(${opt.insertJavaType(columna)} id, String descripcion) {  >> enums\${enumName}.java
	ECHO 		this.id = id;  >> enums\${enumName}.java
	ECHO 		this.descripcion = descripcion;  >> enums\${enumName}.java
	ECHO 	}  >> enums\${enumName}.java
	
	ECHO 	public ${opt.insertJavaType(columna)} getId() {  >> enums\${enumName}.java
	ECHO 		return id;  >> enums\${enumName}.java
	ECHO 	}  >> enums\${enumName}.java

	ECHO 	public String getDescripcion() {  >> enums\${enumName}.java
	ECHO 		return descripcion;  >> enums\${enumName}.java
	ECHO 	}  >> enums\${enumName}.java
	
	ECHO }  >> enums\${enumName}.java
					</#if>
				</#list>
			</#if>
		</#list>
	</#if>
</#list>
ECHO ====================
ECHO Copying enum classes
ECHO ====================
XCOPY /Y /E /I "enums\*.java" "${opt.ejbProjectDir + "\\src\\main\\java\\" + opt.packageToPath(opt.enumPackage)}"
ECHO =======================
ECHO Copying factory classes
ECHO =======================
XCOPY /Y /E /I "factories\*.java" "${opt.ejbProjectDir + "\\src\\main\\java\\" + opt.packageToPath(opt.factoriesPackage)}"
ECHO ====================
ECHO Copying main classes
ECHO ====================
XCOPY /Y /E /I "main\*.java" "${opt.ejbProjectDir + "\\src\\main\\java\\" + opt.packageToPath(opt.entityPackage)}"
ECHO ====================
ECHO Copying hot classes
ECHO ====================
XCOPY /Y /E /I "hot\*.java" "${opt.ejbProjectDir + "\\src\\main\\java\\" + opt.packageToPath(opt.hotPackage)}"
ECHO ============================
ECHO Copying messsages properties
ECHO ============================
XCOPY /Y /E /I "resources\*.properties" "${opt.projectDir + "\\src\\main\\resources\\"}"
ECHO ==================
ECHO Copying view files
ECHO ==================
<#if opt.dirPerTable>
	<#list tables as t>
		<#assign thaDir = opt.projectDir + "\\src\\main\\webapp\\${opt.dirPerTablePrefix}\\" + opt.mixedCaseStr(t.tableName) />
XCOPY /Y /I "view\${opt.camelCaseStr(t.tableName)}Edit.*" "${thaDir}"
XCOPY /Y /I "view\${opt.camelCaseStr(t.tableName)}List.*" "${thaDir}"
	</#list>
<#else>
XCOPY /Y /E /I "view\*.*" "${opt.projectDir + "\\src\\main\\webapp\\"}"
</#if>
ECHO ============
ECHO Copying menu
ECHO ============
XCOPY /Y /E /I "view\layout\menu.xhtml" "${opt.projectDir + "\\src\\main\\webapp\\layout\\"}"
ECHO =================================
ECHO Adding classes to persistence.xml
ECHO =================================
IF EXIST "${opt.ejbProjectDir + "\\src\\main\\resources\\META-INF\\persistence.xml.bk"}" (
  ECHO "${opt.ejbProjectDir + "\\src\\main\\resources\\META-INF\\persistence.xml.bk"}" already exist.. skipping 
) ELSE ( 
  COPY "${opt.ejbProjectDir + "\\src\\main\\resources\\META-INF\\persistence.xml"}" "${opt.ejbProjectDir + "\\src\\main\\resources\\META-INF\\persistence.xml.bk"}"
  CSCRIPT //NoLogo sed.vbs s/"<(.)jta-data-source>[\s\S]*"/"<$1jta-data-source>"/ < "${opt.ejbProjectDir + "\\src\\main\\resources\\META-INF\\persistence.xml"}" > "${opt.ejbProjectDir + "\\src\\main\\resources\\META-INF\\arriba.dat"}"
  CSCRIPT //NoLogo sed.vbs s/"[\s\S]*<.jta-data-source>"// < "${opt.ejbProjectDir + "\\src\\main\\resources\\META-INF\\persistence.xml"}" > "${opt.ejbProjectDir + "\\src\\main\\resources\\META-INF\\abajo.dat"}"
  TYPE classes >> "${opt.ejbProjectDir + "\\src\\main\\resources\\META-INF\\arriba.dat"}"
  TYPE "${opt.ejbProjectDir + "\\src\\main\\resources\\META-INF\\abajo.dat"}" >> "${opt.ejbProjectDir + "\\src\\main\\resources\\META-INF\\arriba.dat"}"
  DEL /Q "${opt.ejbProjectDir + "\\src\\main\\resources\\META-INF\\persistence.xml"}" "${opt.ejbProjectDir + "\\src\\main\\resources\\META-INF\\abajo.dat"}"
  MOVE "${opt.ejbProjectDir + "\\src\\main\\resources\\META-INF\\arriba.dat"}" "${opt.ejbProjectDir + "\\src\\main\\resources\\META-INF\\persistence.xml"}"
)
ECHO "END"
PAUSE