<#import "*/gen-options.ftl" as opt>
<#if (opt.permissionData?size > 0)>
	<#list tables as t>
inset into ${opt.permissionData[0]}(${opt.permissionData[1]}) VALUES ('${t.tableName}_list');
inset into ${opt.permissionData[0]}(${opt.permissionData[1]}) VALUES ('${t.tableName}_create');
inset into ${opt.permissionData[0]}(${opt.permissionData[1]}) VALUES ('${t.tableName}_edit');
inset into ${opt.permissionData[0]}(${opt.permissionData[1]}) VALUES ('${t.tableName}_delete');
	</#list>
</#if>