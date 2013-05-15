<#-- We recommend you not touch this file, unless you know what you are doing -->
<#include "project.opt" />
<#include "gen-include.ftl" />
<#assign projectDir = workspaceDir + pathSeparator + warProjectName />
<#assign mainPath = projectDir + pathSeparator + "src" + pathSeparator + "main" + pathSeparator + packageToPath(entityPackage) />
<#assign hotPath = projectDir + pathSeparator + "src" + pathSeparator + "hot" + pathSeparator + packageToPath(hotPackage) />
<#assign ejbProjectDir = workspaceDir + pathSeparator + ejbProjectName />
<#assign mainPathEjb = ejbProjectDir + pathSeparator + ejbModuleName + pathSeparator + packageToPath(entityPackage) />
<#assign hotPathEjb = ejbProjectDir + pathSeparator + ejbModuleName + pathSeparator + packageToPath(hotPackage) />
<#assign enumPackagePath = ejbProjectDir + pathSeparator + ejbModuleName + pathSeparator + packageToPath(enumPackage) />
<#if !(defaultContextForFactories?? && ["Application","Session","Event"]?seq_contains(defaultContextForFactories))>
	<#assign defaultContextForFactories = "Event" />
</#if>