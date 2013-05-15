<#import "*/gen-options.ftl" as opt>
package ${opt.hotPackage};
<#assign entityName = tableName?replace("_", " ")?capitalize?replace(" ", "")>
<#assign entityNameMixedCase = entityName?uncap_first>
<#assign injectedHomeNames = "" />
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Vector;

import javax.persistence.PersistenceException;
import javax.faces.model.SelectItem;
<#assign lovColumns = [] />
<#if (opt.lovTables?? && opt.lovTables?seq_contains(tableName))>
	<#if (opt.lovTables[opt.lovTables?seq_index_of(tableName) + 1]?is_sequence)>
		<#assign lovColumns = opt.lovTables[opt.lovTables?seq_index_of(tableName) + 1] />
	</#if>
</#if>
<#if (opt.masterDetailTables?? && opt.masterDetailTables?seq_contains(tableName))>
	<#if (opt.masterDetailTables[opt.masterDetailTables?seq_index_of(tableName) + 1]?is_sequence)>
		<#list opt.masterDetailTables[opt.masterDetailTables?seq_index_of(tableName) + 1] as detTableName>
import ${opt.entityPackage}.${opt.camelCaseStr(detTableName)};
		</#list>		
	</#if>
</#if>

import org.jboss.seam.ScopeType;
import org.jboss.seam.annotations.Factory;
import org.jboss.seam.annotations.In;
import org.jboss.seam.annotations.Name;
import org.jboss.seam.faces.FacesMessages;
import org.jboss.seam.framework.EntityHome;

import ${opt.enumPackage}.*;
import ${opt.factoriesPackage}.${entityName}Factories;

import ${opt.entityPackage}.${entityName};
<#if opt.auditUserTable?exists>
import ${opt.entityPackage}.${opt.camelCaseStr(opt.auditUserTable)};
</#if>
<#if !opt.useFactoriesForSelectItems>
	<#list columns as column>
		<#if !column.primaryKey>
			<#assign fk = opt.getFk(column) />
			<#if (fk?size > 0)>
				<#list tables as t>
					<#if t.tableName == fk.pktableName>
						<#assign javaType = opt.camelCaseStr(fk.pktableName) />
import ${opt.entityPackage}.${javaType};
						<#break />
					</#if>
				</#list>
			</#if>
		</#if>
	</#list>
</#if>

@Name("${entityName?uncap_first}Home")
public class ${entityName}Home extends EntityHome<${entityName}> {
	
	private static final long serialVersionUID = 1L;
	
	@In
	protected FacesMessages facesMessages;
	
	<#if opt.auditUserTable?exists>
	@In(required=false)
	protected ${opt.camelCaseStr(opt.auditUserTable)} user;
	
	</#if>
	<#if (opt.lovTables?? && opt.lovTables?seq_contains(tableName))>
		<#if (opt.lovTables[opt.lovTables?seq_index_of(tableName) + 1]?is_sequence)>
			<#list opt.lovTables[opt.lovTables?seq_index_of(tableName) + 1] as lovColumn>
				<#list columns as column>
					<#if (lovColumn == column.columnName)>
						<#assign fk = opt.getFk(column) />
						<#if (fk?size > 0)>
							<#assign entityHomeName = opt.camelCaseStr(fk.pktableName) + "Home" />
							<#assign injectedHomeNames = injectedHomeNames + " " + opt.camelCaseStr(fk.pktableName) />
	@In(create=true)
	protected ${entityHomeName} ${entityHomeName?uncap_first};
						</#if>
						<#break />
					</#if>
				</#list>
			</#list>
		</#if>
	</#if>
	<#if (opt.masterDetailTables?? && opt.masterDetailTables?seq_contains(tableName))>
		<#if (opt.masterDetailTables[opt.masterDetailTables?seq_index_of(tableName) + 1]?is_sequence)>
			<#list opt.masterDetailTables[opt.masterDetailTables?seq_index_of(tableName) + 1] as detTableName>
				<#assign entityHomeName = opt.camelCaseStr(detTableName) + "Home" />
	@In(create=true)
	protected ${entityHomeName} ${entityHomeName?uncap_first};
			</#list>
		</#if>
	</#if>
	<#if !opt.useFactoriesForSelectItems>
	@Override
	protected ${entityName} loadInstance() {
		${entityName} o = super.loadInstance();
		<#assign attrNames = "" />
		<#list columns as column>
			<#if !lovColumns?seq_contains(column.columnName)>
				<#assign attrname = opt.mixedCase(column) />
				<#assign foreignPKColumn = "" />
				<#assign fk = opt.getFk(column) />
				<#if (fk?size > 0)>
					<#list tables as t>
						<#if t.tableName == fk.pktableName>
							<#if !opt.attributesFromColumnNames>
								<#assign attrname = opt.mixedCaseStr(fk.pktableName) />
							</#if>
							<#assign foreignPKColumn = fk.pkcolumnName />
							<#break />
						</#if>
					</#list>
					<#assign res = attrNames?matches(attrname)?size />
					<#assign attrNames = attrNames + " " + attrname />
					<#if res &gt; 0>
					  <#assign attrname = attrname + res />
					</#if>
		if(o.get${attrname?cap_first}() != null)
			this.${opt.mixedCase(column)} = o.get${attrname?cap_first}().get${opt.camelCaseStr(foreignPKColumn)}();
				</#if>
			</#if>
		</#list>
		return o;
	}

		<#assign commentGenerated = false />
		<#list columns as column>
			<#assign fk = opt.getFk(column) />
			<#if (fk?size > 0)>
				<#if !lovColumns?seq_contains(column.columnName)>
					<#if !commentGenerated>
	//Value holders for selectItems
						<#assign commentGenerated = true />
					</#if>
	private ${opt.insertJavaType(column)} ${opt.mixedCase(column)};
				</#if>
			</#if>
		</#list>
	</#if>

	public void set${entityName}${opt.camelCase(opt.keyColumn)}(${opt.insertJavaType(opt.keyColumn)} id) {
		setId(id);
	}

	public ${opt.insertJavaType(opt.keyColumn)} get${entityName}${opt.camelCase(opt.keyColumn)}() {
		return (${opt.insertJavaType(opt.keyColumn)}) getId();
	}

	@Override
	protected ${entityName} createInstance() {
		${entityName} ${entityNameMixedCase} = new ${entityName}();
		return ${entityNameMixedCase};
	}

	public void load() {
		if (isIdDefined()) {
			wire();
		}
	}

	public void wire() {
		getInstance();
	<#if (opt.lovTables?? && opt.lovTables?seq_contains(tableName))>
		<#if (opt.lovTables[opt.lovTables?seq_index_of(tableName) + 1]?is_sequence)>
			<#assign lovColumns = opt.lovTables[opt.lovTables?seq_index_of(tableName) + 1] />
			
			<#assign attrNames = "" />
			<#list columns as column>
				<#assign attrname = opt.mixedCase(column) />
				<#assign foreignPKColumn = "" />
				<#assign fk = opt.getFk(column) />
				<#if (fk?size > 0)>
					<#assign entityOfAttr = opt.camelCaseStr(fk.pktableName) />
					<#assign entityHomeName = opt.camelCaseStr(fk.pktableName) + "Home" />
					<#list tables as t>
						<#if t.tableName == fk.pktableName>
							<#if !opt.attributesFromColumnNames>
								<#assign attrname = opt.mixedCaseStr(fk.pktableName) />
							</#if>
							<#assign foreignPKColumn = fk.pkcolumnName />
							<#break />
						</#if>
					</#list>
					<#assign res = attrNames?matches(attrname)?size />
					<#assign attrNames = attrNames + " " + attrname />
					<#if res &gt; 0>
					  <#assign attrname = attrname + res />
					</#if>
					<#if lovColumns?seq_contains(column.columnName)>
		${entityOfAttr} ${entityOfAttr?uncap_first} = ${entityHomeName?uncap_first}.getDefinedInstance();
		if(${entityOfAttr?uncap_first} != null)
			getInstance().set${attrname?cap_first}(${entityOfAttr?uncap_first});
					</#if>
				</#if>
			</#list>
			
		</#if>
	</#if>
	<#if (opt.masterDetailTables?? && opt.masterDetailTables?seq_contains(tableName))>
		<#if (opt.masterDetailTables[opt.masterDetailTables?seq_index_of(tableName) + 1]?is_sequence)>
			<#list opt.masterDetailTables[opt.masterDetailTables?seq_index_of(tableName) + 1] as detTableName>
				<#assign detailEntity = opt.camelCaseStr(detTableName) />
				<#assign detailEntityHomeName = detailEntity  + "Home" />
		${detailEntity} ${detailEntity?uncap_first} = ${detailEntityHomeName?uncap_first}.getDefinedInstance();
		if(${detailEntity?uncap_first} != null && !getInstance().get${detailEntity}s().contains(${detailEntity?uncap_first}))
			getInstance().get${detailEntity}s().add(${detailEntity?uncap_first});
			</#list>
		</#if>
	</#if>
	}

	public boolean isWired() {
		return true;
	}

	public ${entityName} getDefinedInstance() {
		return isIdDefined() ? getInstance() : null;
	}
	
	@Override
	public String persist() {
	<#list opt.auditColumns as ac>
		<#list columns as column>
			<#if column.columnName == ac.columnName>
				<#if ac.auditType?contains("Date")>
		getInstance().set${opt.camelCase(column)}(new Date());
				<#elseif ac.auditType?contains("User")>
					<#assign itemGenerated = false />
					<#assign fk = opt.getFk(column) />
					<#if (fk?size > 0)>
						<#list tables as t>
							<#if t.tableName == fk.pktableName>
		if(user != null)
			getInstance().set${opt.camelCase(column)}(user);
								<#assign itemGenerated = true />
								<#break />
							</#if>
						</#list>
					</#if>
					<#if !itemGenerated>
						<#assign javaType = opt.insertJavaType(column) />
		getInstance().set${opt.camelCase(column)}(<@opt.newInstance column />);		
					</#if>
				</#if>
			</#if>
		</#list>
	</#list>
		return doSave("persisted");
	}

	@Override
	public String update() {
	<#list opt.auditColumns as ac>
		<#list columns as column>
			<#if column.columnName == ac.columnName>
				<#if ac.auditType?contains("updateDate")>
		getInstance().set${opt.camelCase(column)}(new Date());
				<#elseif ac.auditType?contains("updateUser")>
					<#assign itemGenerated = false />
					<#assign fk = opt.getFk(column) />
					<#if (fk?size > 0)>
						<#list tables as t>
							<#if t.tableName == fk.pktableName>
		if(user != null)
			getInstance().set${opt.camelCase(column)}(user);
								<#break />
								<#assign itemGenerated = true />
							</#if>
						</#list>
					</#if>
					<#if !itemGenerated>
						<#assign javaType = opt.insertJavaType(column) />
		getInstance().set${opt.camelCase(column)}(<@opt.newInstance column />);		
					</#if>
				</#if>
			</#if>
		</#list>
	</#list>
		return doSave("updated");
	}
	
	private String doSave(String outcome) {
		if(!preSaveOperations()) 
			return null;
		if(!validate()) 
			return null;
		String result = AppHelper.removeFromContext(outcome, outcome.equals("persisted") ? super.persist() : super.update(), ${entityName}Factories.CONTEXT_VAR_NAMES, ${entityName}Factories.CONTEXTS);
		if(!postSaveOperations(result))
			return null;
		return result;
	}
	
	private boolean validate(){
		//Put validation code here
		return true;
	}
	
	private boolean preSaveOperations() {
		//Pre-save operations goes here
	<#if !opt.useFactoriesForSelectItems>
		<#list columns as column>
			<#if (!column.primaryKey && !lovColumns?seq_contains(column.columnName))>
				<#assign fk = opt.getFk(column) />
				<#if (fk?size > 0)>
					<#list tables as t>
						<#if t.tableName == fk.pktableName>
							<#assign javaType = opt.camelCaseStr(fk.pktableName) />
							<#if !opt.attributesFromColumnNames>
								<#assign attrName = opt.mixedCaseStr(fk.pktableName) />
		if(this.${opt.mixedCase(column)} != null)
			getInstance().set${attrName?cap_first}(getEntityManager().find(${javaType}.class,this.${opt.mixedCase(column)}));
							</#if>
							<#break />
						</#if>
					</#list>
				</#if>
			</#if>
		</#list>
	</#if>
		return true;
	}
	
	private boolean postSaveOperations(String result){
		//Post-save operations (some may depend of the result) goes here
		return true;
	}
	
	<#if !opt.useFactoriesForSelectItems>
		<#assign commentGenerated = false />
		<#list columns as column>
			<#if !lovColumns?seq_contains(column.columnName)>
			<#assign fk = opt.getFk(column) />
			<#if (fk?size > 0)>
				<#if !commentGenerated>
	//Public getters and setters
	
					<#assign commentGenerated = true />
				</#if>
				<#assign AttrName = opt.camelCase(column) />
				<#assign attrName = AttrName?uncap_first />
				<#assign javaType = opt.insertJavaType(column) />
	public ${javaType} get${AttrName}(){
		return this.${attrName};
	}
	
	public void set${AttrName}(${javaType} ${attrName}){
		this.${attrName} = ${attrName};
	}
	
			</#if>
			</#if>
		</#list>
	</#if>
}
