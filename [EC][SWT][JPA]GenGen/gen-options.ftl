<#-- We recommend you not touch this file, unless you know what you are doing -->
<#include "project.opt">
<#include "gen-include.ftl">
<#assign projectDir = workspaceDir + "\\" + projectName />
<#assign mainPath = projectDir + "\\src\\" + packageToPath(mainPackage) />
<#assign entitiesPath = projectDir + "\\src\\" + packageToPath(entityPackage) />
<#assign dialogsPath = projectDir + "\\src\\" + packageToPath(dialogsPackage) />