<#import "*/gen-options.ftl" as opt>
<#list tables as t>
      <class>${opt.entityPackage + "." + t.tableName!?replace("_", " ")?capitalize?replace(" ", "")}</class>
</#list>