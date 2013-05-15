<#import "*/gen-options.ftl" as opt>
package ${opt.hotPackage};
<#assign entityName = tableName?replace("_", " ")?capitalize?replace(" ", "")>
import java.util.Arrays;
import java.util.List;

import org.jboss.seam.annotations.Name;
import org.jboss.seam.annotations.Out;
import org.jboss.seam.framework.EntityQuery;
import org.jboss.seam.ScopeType;

import ${opt.entityPackage}.${entityName};

@Name("${entityName?uncap_first}List")
public class ${entityName}List extends EntityQuery<${entityName}> {

	private static final long serialVersionUID = 1L;

	@Out(scope = ScopeType.CONVERSATION, required = false)
    private List<${entityName}> lista${entityName}s;
	
	private static final String EJBQL = "select ${entityName?uncap_first} from ${entityName} ${entityName?uncap_first}";

	private static final String[] RESTRICTIONS = {
<#list columns as column>
	<#if !column.primaryKey>
		<#if opt.sqlStringTypes?seq_contains(column.dataType)>
			"lower(${entityName?uncap_first}.${opt.mixedCase(column)}) like lower(concat(${'#'}{${entityName?uncap_first}List.${entityName?uncap_first}.${opt.mixedCase(column)}},'%'))",
		<#elseif opt.sqlIntegerTypes?seq_contains(column.dataType)>
			"lower(cast(${entityName?uncap_first}.${opt.mixedCase(column)} as string)) like lower(concat(cast(${'#'}{${entityName?uncap_first}List.${entityName?uncap_first}.${opt.mixedCase(column)}} as string),'%'))",
		</#if>
	</#if>
</#list>};

	private ${entityName} ${entityName?uncap_first} = new ${entityName}();

	public ${entityName}List() {
		setEjbql(EJBQL);
		setRestrictionExpressionStrings(Arrays.asList(RESTRICTIONS));
		setMaxResults(10);
	}

	public ${entityName} get${entityName}() {
		return ${entityName?uncap_first};
	}
	
	public List<${entityName}> obtenerLista${entityName}s(){
    	lista${entityName}s = getResultList(); 
    	return lista${entityName}s;
    }
	
    public List<${entityName}> getLista${entityName}s() {
		return lista${entityName}s;
	}
}
