<#import "*/gen-options.ftl" as opt>
<#if (!opt.keyColumn??)>
//ESTE TEMPLATE SOLO MANEJA TABLAS CON PRIMARY KEYS DEFINIDOS
<#else>
package ${opt.entityPackage};

<#assign entityName = tableName?replace("_", " ")?capitalize?replace(" ", "") />

import java.math.BigDecimal;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.Vector;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * ${entityName} generated by Generality
 */
@Entity
@Table(name = "${tableName}"<#if tableSchema??>, schema = "${tableSchema!}"</#if>)
public class ${entityName} implements java.io.Serializable {

	private static final long serialVersionUID = 1L;

<#assign attrNames = "" />
<#list columns as column>
  <#assign javatype = opt.insertJavaType(column) />
  <#assign attrname = opt.mixedCase(column) />
  <#if !column.primaryKey>
	<#assign fk = opt.getFk(column) />
	<#if (fk?size > 0)>
		<#list tables as t>
			<#if t.tableName == fk.pktableName>
				<#assign javatype = opt.camelCaseStr(fk.pktableName) />
				<#assign attrname = opt.mixedCaseStr(fk.pktableName) />
				<#break />
			</#if>
		</#list>
	</#if>
  </#if>
  <#assign res = attrNames?matches(attrname)?size />
  <#assign attrNames = attrNames + " " + attrname />
  <#if res &gt; 0>
    <#assign attrname = attrname + res />
  </#if>
	private ${javatype} ${attrname};
</#list>

<#--Verificamos si la entidad posee detalles y realizarmos los imports necesarios-->
<#if opt.masterDetail??>
	<#assign index = 0/>
	<#--entity es cada maestro-->
	<#list opt.masterDetail as entity>
		<#assign index = index + 1 />
		<#if entity?is_string>
			<#if entity == entityName>
				<#assign idx = opt.masterDetail?seq_index_of(entity) + 1 />
				<#list opt.masterDetail[idx] as detail>
					<#if detail?is_string>
	private List<${detail}> ${detail?uncap_first};
					</#if>
				</#list>		
			</#if>
		</#if>
	</#list>
</#if>		

	public ${entityName}() {
	}

	public ${entityName}(${opt.insertJavaType(opt.keyColumn)} ${opt.mixedCase(opt.keyColumn)}) {
		this.${opt.mixedCase(opt.keyColumn)} = ${opt.mixedCase(opt.keyColumn)};
	}

<#assign attrNames = "" />	
<#list columns as column>
  <#assign javatype = opt.insertJavaType(column) />
  <#assign attrname = opt.mixedCase(column) />
  <#if opt.keyColumn == column>
	@Id
	@GeneratedValue(generator="${tableName?upper_case}_GENERATOR", strategy=GenerationType.SEQUENCE)
	@SequenceGenerator(name="${tableName?upper_case}_GENERATOR",sequenceName="<#if tableSchema??>${tableSchema!}.</#if>${tableName}_seq",allocationSize=1)
  </#if>
  <#if !column.primaryKey>
	<#assign fk = opt.getFk(column) />
	<#if (fk?size > 0)>
		<#list tables as t>
		<#assign itemGenerated = false />
			<#if t.tableName == fk.pktableName>
				<#assign itemGenerated = true />
				<#assign javatype = opt.camelCaseStr(fk.pktableName) />
				<#assign attrname = opt.mixedCaseStr(fk.pktableName) />
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "${column.columnName}")
				<#break />
			</#if>
		</#list>
		<#if !itemGenerated>
<@opt.insertColumnAnnotation column />
		</#if>
	<#else>
<@opt.insertColumnAnnotation column />
	</#if>
  <#else>
<@opt.insertColumnAnnotation column />
  </#if>
  <#assign res = attrNames?matches(attrname)?size />
  <#assign attrNames = attrNames + " " + attrname />
  <#if res &gt; 0>
    <#assign attrname = attrname + res />
  </#if>
	public ${javatype} get${attrname?cap_first}() {
		return this.${attrname};
	}

	public void set${attrname?cap_first}(${javatype} ${attrname}) {
		this.${attrname} = ${attrname};
	}
</#list>
<#--Verificamos si la entidad posee detalles y realizamos las configuraciones necesarias-->
<#if opt.masterDetail??>
	<#assign index = 0/>
	<#--entity es cada maestro-->
	<#list opt.masterDetail as entity>
		<#assign index = index + 1 />
		<#if entity?is_string>
			<#if entity == entityName>
				<#assign idx = opt.masterDetail?seq_index_of(entity) + 1 />
				<#list opt.masterDetail[idx] as detail>
					<#if detail?is_string>
	@OneToMany(fetch=FetchType.LAZY,mappedBy="${entityName?uncap_first}",cascade=CascadeType.ALL)
	public List<${detail}> get${detail?cap_first}() {
		return this.${detail?uncap_first};
	}
	public void set${detail?cap_first}(List<${detail}> ${detail?uncap_first}) {
		this.${detail?uncap_first} = ${detail?uncap_first};
	}
					</#if>
				</#list>		
			</#if>
		</#if>
	</#list>
</#if>		
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((${opt.mixedCase(opt.keyColumn)} == null) ? 0 : ${opt.mixedCase(opt.keyColumn)}.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		${entityName} other = (${entityName}) obj;
		if (${opt.mixedCase(opt.keyColumn)} == null) {
			if (other.${opt.mixedCase(opt.keyColumn)} != null)
				return false;
		} else if (!${opt.mixedCase(opt.keyColumn)}.equals(other.${opt.mixedCase(opt.keyColumn)}))
			return false;
		return true;
	}
}
</#if>
