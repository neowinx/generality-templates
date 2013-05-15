<#import "*/gen-options.ftl" as opt>
<?xml version="1.0" encoding="utf-8"?>
<project>
  <!-- Output SWF options -->
  <output>
    <movie disabled="False" />
    <movie input="" />
    <movie path="bin\${tableName}Module.swf" />
    <movie fps="30" />
    <movie width="800" />
    <movie height="600" />
    <movie version="10" />
    <movie background="#FFFFFF" />
  </output>
  <!-- Other classes to be compiled into your SWF -->
  <classpaths>
    <class path="src" />
  </classpaths>
  <!-- Build options -->
  <build>
    <option accessible="False" />
    <option allowSourcePathOverlap="False" />
    <option benchmark="False" />
    <option es="False" />
    <option locale="" />
    <option loadConfig="" />
    <option optimize="True" />
    <option showActionScriptWarnings="True" />
    <option showBindingWarnings="True" />
    <option showInvalidCSS="True" />
    <option showDeprecationWarnings="True" />
    <option showUnusedTypeSelectorWarnings="True" />
    <option strict="True" />
    <option useNetwork="True" />
    <option useResourceBundleMetadata="True" />
    <option warnings="True" />
    <option verboseStackTraces="False" />
    <option linkReport="" />
    <option loadExterns="exclude.xml" />
    <option staticLinkRSL="True" />
    <option additional="" />
    <option compilerConstants="" />
    <option customSDK="" />
  </build>
  <!-- SWC Include Libraries -->
  <includeLibraries>
    <!-- example: <element path="..." /> -->
  </includeLibraries>
  <!-- SWC Libraries -->
  <libraryPaths>
    <!-- example: <element path="..." /> -->
  </libraryPaths>
  <!-- External Libraries -->
  <externalLibraryPaths>
    <!-- example: <element path="..." /> -->
  </externalLibraryPaths>
  <!-- Runtime Shared Libraries -->
  <rslPaths>
    <!-- example: <element path="..." /> -->
  </rslPaths>
  <!-- Intrinsic Libraries -->
  <intrinsics>
    <element path="Library\AS3\frameworks\Flex3" />
  </intrinsics>
  <!-- Assets to embed into the output SWF -->
  <library>
    <!-- example: <asset path="..." id="..." update="..." glyphs="..." mode="..." place="..." sharepoint="..." /> -->
  </library>
  <!-- Class files to compile (other referenced classes will automatically be included) -->
  <compileTargets>
    <compile path="src\modules\${tableName}Module.mxml" />
  </compileTargets>
  <!-- Paths to exclude from the Project Explorer tree -->
  <hiddenPaths>
    <!-- example: <hidden path="..." /> -->
  </hiddenPaths>
  <!-- Executed before build -->
  <preBuildCommand />
  <!-- Executed after build -->
  <postBuildCommand alwaysRun="False">xcopy /Y /I /E $(OutputDir) "${opt.serverDir}"</postBuildCommand>
  <!-- Other project options -->
  <options>
    <option showHiddenPaths="False" />
    <option testMovie="OpenDocument" />
    <option testMovieCommand="bin\FlexCrud.swf" />
  </options>
</project>