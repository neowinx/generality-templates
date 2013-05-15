<#import "*/gen-options.ftl" as opt>
${'#'}!/bin/bash
echo ====================================================
echo      Deploying Multi Configuration Project
echo This will replace the files of your current project.
echo Press CTRl+C to cancel.
echo ====================================================
read
function cpscr {
  curdir=`pwd`
  mkdir -p $1
  cd $2
  for i in $(ls $3); do
    if [ -f $1/$i.bk ]; then
      echo $i.bk found. Ignoring...
    else
      cp $curdir/$2/$i $1
    fi
  done
  cd $curdir
}
echo ====================
echo Discarding .svn''s...
echo ====================
rm -r `find -type d -name '.svn'`
echo =======================
echo Generating enum classes
echo =======================
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
	echo "package ${opt.enumPackage}; " > enums/${enumName}.java
	echo "public enum ${enumName} { " >> enums/${enumName}.java
						<#assign svfs = svfColumns[svfColumnIndex + 1] />
						<#assign columna = columns?first />
						<#list table.columns as column>
							<#if (column.columnName == svfColumn)>
								<#assign columna = column />
								<#break />
							</#if>
						</#list>
						<#list svfs as svf>
	echo "	${svf[1]?upper_case?replace(" ", "_")}(<#if opt.sqlStringTypes?seq_contains(columna.dataType)><#else>new ${opt.insertJavaType(columna)}(${svf[0]})</#if>,\"${svf[1]}\")<#if svfs?last[0] == svf[0]>;<#else>,</#if> " >> enums/${enumName}.java
						</#list>
	echo "	private final ${opt.insertJavaType(columna)} id; " >> enums/${enumName}.java
	echo "	private final String descripcion; " >> enums/${enumName}.java
	
	echo "	private ${enumName}(${opt.insertJavaType(columna)} id, String descripcion) { " >> enums/${enumName}.java
	echo "		this.id = id; " >> enums/${enumName}.java
	echo "		this.descripcion = descripcion; " >> enums/${enumName}.java
	echo "	} " >> enums/${enumName}.java
	
	echo "	public ${opt.insertJavaType(columna)} getId() { " >> enums/${enumName}.java
	echo "		return id; " >> enums/${enumName}.java
	echo "	} " >> enums/${enumName}.java

	echo "	public String getDescripcion() { " >> enums/${enumName}.java
	echo "		return descripcion; " >> enums/${enumName}.java
	echo "	} " >> enums/${enumName}.java
	
	echo "} " >> enums/${enumName}.java
					</#if>
				</#list>
			</#if>
		</#list>
	</#if>
</#list>
echo ====================
echo Copying enum classes
echo ====================
cpscr ${opt.ejbProjectDir + "/src/main/java/" + opt.enumPackage?replace(".", "/")} enums *.java
echo =======================
echo Copying factory classes
echo =======================
cpscr ${opt.ejbProjectDir + "/src/main/java/" + opt.factoriesPackage?replace(".", "/")} factories *.java
echo ====================
echo Copying main classes
echo ====================
cpscr ${opt.ejbProjectDir + "/src/main/java/" + opt.entityPackage?replace(".", "/")} main *.java
echo ====================
echo Copying hot classes
echo ====================
cpscr ${opt.ejbProjectDir + "/src/main/java/" + opt.hotPackage?replace(".", "/")} hot *.java
echo ============================
echo Copying messsages properties
echo ============================
cpscr ${opt.projectDir + "/src/main/resources/"} resources *.properties
echo ==================
echo Copying view files
echo ==================
<#if opt.dirPerTable>
	<#list tables as t>
		<#assign thaDir = opt.projectDir + "/src/main/webapp/${opt.dirPerTablePrefix}/" + opt.mixedCaseStr(t.tableName) />
cpscr ${thaDir} view ${opt.camelCaseStr(t.tableName)}Edit.*
cpscr ${thaDir} view ${opt.camelCaseStr(t.tableName)}List.*
cpscr ${thaDir} view ${opt.camelCaseStr(t.tableName)}ListPdf.*
	</#list>
<#else>
cpscr ${opt.projectDir + "/src/main/webapp/"} view *.*
</#if>
cpscr ${opt.projectDir + "/src/main/webapp/"} view home.xhtml
cpscr ${opt.projectDir + "/src/main/webapp/"} view login.xhtml
echo ============
echo Copying menu
echo ============
cpscr ${opt.projectDir + "/src/main/webapp/layout/"} view/layout menu.xhtml
echo =================================
echo Adding classes to persistence.xml
echo =================================
echo AUTOGENERATION OF persistence.xml NOT SUPORTTED ON THIS SCRIPT. YOU NEED ADD THE CLASSES BY HAND. YOU CAN COPY THEM FROM THE classes FILE.
echo END