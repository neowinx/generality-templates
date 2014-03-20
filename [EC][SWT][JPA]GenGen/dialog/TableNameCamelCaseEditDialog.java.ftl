<#import "*/gen-options.ftl" as opt>
<#if (!opt.keyColumn??)>
//ESTE TEMPLATE SOLO MANEJA TABLAS CON PRIMARY KEYS DEFINIDOS
<#else>
<#assign entityName = opt.camelCaseStr(tableName) />
package ${opt.dialogsPackage};

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import javax.persistence.EntityManager;
import javax.persistence.Persistence;
import javax.persistence.Query;

import org.eclipse.swt.widgets.Dialog;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Group;
import org.eclipse.swt.widgets.MessageBox;
import org.eclipse.swt.widgets.Monitor;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.layout.FillLayout;
import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.ScrolledComposite;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Text;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.widgets.DateTime;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.graphics.Point;
import org.eclipse.swt.graphics.Rectangle;
import org.eclipse.swt.widgets.Table;
import org.eclipse.swt.widgets.TableColumn;
import org.eclipse.swt.widgets.TableItem;

import swing2swt.layout.BorderLayout;

import ${opt.entityPackage}.${entityName};
import ${opt.mainPackage}.PersistenceHelper;
<#-- Verificamos si la entidad en cuestion posee claves foraneas-->
<#list columns as column>
	<#assign itemGenerated = false />
	<#assign ccc = opt.camelCase(column) />
	<#assign javatype = opt.insertJavaType(column) />
	<#assign fk = opt.getFk(column) />
	<#-- Importamos las entidades que son clave foranea-->
	<#if (fk?size > 0)>
		<#list tables as t>
			<#if t.tableName == fk.pktableName>
				<#assign itemGenerated = true />
				<#assign javatype = opt.camelCaseStr(fk.pktableName) />
import ${opt.entityPackage}.${javatype};
				<#break />
			</#if>
		</#list>
	</#if>
</#list>
<#--Verificamos si la entidad posee detalles-->
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
import ${opt.entityPackage}.${detail};
					</#if>
				</#list>		
			</#if>
		</#if>
	</#list>
</#if>			

public class ${entityName}EditDialog extends Dialog {
	<#-- -->
	protected ${entityName} result;
	
	<#-- Ventana del formulario-->
	protected Shell shlNuevo${entityName};
	
	<#-- -->
	private ${entityName} entityHolder;
	
	<#-- Definimos un field para cada propiedad de la entidad -->
	<#list columns as column>
		<#if column != opt.keyColumn>
		<#assign itemGenerated = false />
		<#assign ccc = opt.camelCase(column) />
		<#assign javatype = opt.insertJavaType(column) />
		<#assign fk = opt.getFk(column) />
		
		<#-- Si es un fk definimos un combo -->
		<#if (fk?size > 0)>
			<#list tables as t>
				<#if t.tableName == fk.pktableName>
					<#assign itemGenerated = true />
					<#assign javatype = opt.camelCaseStr(fk.pktableName) />
					<#--Verificamos si el fk es una cabecera, es decir la entidad actual es su detalle-->
					<#assign valid =true/>
					<#if opt.masterDetail??>
						<#assign index = 0/>
						<#--entity es cada maestro-->
						<#list opt.masterDetail as entity>
							<#assign index = index + 1 />
							<#if entity?is_string>
								<#if entity == ccc>
									<#assign idx = opt.masterDetail?seq_index_of(entity) + 1 />
									<#list opt.masterDetail[idx] as detail>
										<#if detail?is_string>
										<#--Y si la tabla en cuestion es un detalle de la cabecera no agregamos el combo-->
											<#if detail==entityName>
												<#assign valid =false/>
											</#if>
										</#if>
									</#list>		
								</#if>
							</#if>
						</#list>
					</#if>
					<#if valid >
						<#assign isListValue =false/>
						<#if opt.listValue??>
							<#list opt.listValue as picker>
								<#if picker==ccc>
									<#assign isListValue =true/>
									<#break />
								</#if>
							</#list>
						</#if>
						<#if !isListValue>
	private Combo cmb${ccc};
	private List<${javatype}> cmb${ccc}Values = new Vector<${javatype}>();
						<#else>
	private Text txt${ccc};
	private ${ccc} value${ccc};
						</#if>
					</#if>
					<#break />
				</#if>
			</#list>
		</#if>
		<#-- Si tiene asociada una lista de constantes-->
		<#if opt.staticValuesFields??>
			<#assign svfTableIndex = -1 />
			<#list opt.staticValuesFields as staticValuesField>
				<#assign svfTableIndex = svfTableIndex + 1 />
				<#if (staticValuesField?is_string && staticValuesField == tableName)>
					<#assign svfColumns = opt.staticValuesFields[svfTableIndex + 1] />
					<#assign svfColumnIndex = -1 />
					<#list svfColumns as svfColumn>
						<#assign svfColumnIndex = svfColumnIndex + 1 />
						<#if (svfColumn?is_string && svfColumn == column.columnName)>
							<#assign itemGenerated = true />
	private Combo cmb${ccc};
	private List<${javatype}> cmb${ccc}Values = new Vector<${javatype}>();
							<#break />
						</#if>
					</#list>
					<#break />
				</#if>
			</#list>
		</#if>
		<#--Si es una fecha -->
		<#if !itemGenerated>
			<#if (opt.sqlDateTypes?seq_contains(column.dataType) || opt.sqlTimestampTypes?seq_contains(column.dataType))>
	private DateTime dt${ccc};
			<#else>
			<#--Si es un texto normal -->
	private Text txt${ccc};
			</#if>
		</#if>
		</#if>
	</#list>
<#--Verificamos si la entidad posee detalles-->
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
					
	private List<${detail}> list${detail};
	<#--El tipo de dato para representar el id siempre es Long ver como asignar el tipo correcto-->
	private Long idTemp${detail};
					</#if>
				</#list>		
			</#if>
		</#if>
	</#list>
</#if>	
	
	private Button btnAccept;
	private Button btnCancelar;
	private boolean delete;
	
<#--Verificamos si la entidad posee detalles-->
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
	private Table table${detail};
	private Button btnNew${detail};
	private Button btnEdit${detail};
	private Button btnDelete${detail};
					<#assign aux =detail/>	
					<#else>
						<#list detail as column>
	private TableColumn column${aux}${column};
						</#list>
					</#if>
				</#list>		
			</#if>
		</#if>
	</#list>
</#if>

	/**
	 * Create the dialog.
	 * @param parent
	 * @param style
	 * @wbp.parser.constructor
	 */
	public ${entityName}EditDialog(Shell parent) {
		super(parent);
		setText("${entityName}EditDialog");
	}
	
	public ${entityName}EditDialog(Shell parent, ${entityName} entityHolder) {
		super(parent);
		setText("${entityName}EditDialog");
		this.entityHolder = entityHolder;
	}

	/**
	 * Open the dialog.
	 * @return the result
	 */
	public ${entityName} open(String title) {
		createContents(title);
		<#--Seteamos los valores en el entityHolder solo si no es pk ya que dicho valor no se visualiza-->
		if(entityHolder != null){
			<#assign attrNames = "" />
			<#list columns as column>
				<#if !column.primaryKey>
				<#assign itemGenerated = false />
					<#assign ccc = opt.camelCase(column) />
					<#assign javatype = opt.insertJavaType(column) />
					<#assign attrname = opt.mixedCase(column) />
					<#assign fk = opt.getFk(column) />
					<#-- Si tiene un fk cargamos el combo-->
					<#if (fk?size > 0)>
						<#list tables as t>
							<#if t.tableName == fk.pktableName>
								<#assign itemGenerated = true />
								<#assign javatype = opt.camelCaseStr(fk.pktableName) />
								<#assign attrname = opt.mixedCaseStr(fk.pktableName) />
								<#break />
							</#if>
						</#list>
					</#if>
					<#assign res = attrNames?matches(attrname)?size />
					<#assign attrNames = attrNames + " " + attrname />
					<#if res &gt; 0>
						<#assign attrname = attrname + res />
					</#if>
					<#if itemGenerated>
						<#--Verificamos si el fk es una cabecera-->
						<#assign valid =true/>
						<#if opt.masterDetail??>
							<#assign index = 0/>
							<#--entity es cada maestro-->
							<#list opt.masterDetail as entity>
								<#assign index = index + 1 />
								<#if entity?is_string>
									<#if entity == ccc>
										<#assign idx = opt.masterDetail?seq_index_of(entity) + 1 />
										<#list opt.masterDetail[idx] as detail>
											<#if detail?is_string>
											<#--Y si la tabla en cuestion es un detalle de la cabecera no agregamos el combo-->
												<#if detail==entityName>
													<#assign valid =false/>
												</#if>
											</#if>
										</#list>		
									</#if>
								</#if>
							</#list>
						</#if>
						<#if valid>
							<#assign isListValue =false/>
							<#if opt.listValue??>
								<#list opt.listValue as picker>
									<#if picker==ccc>
										<#assign isListValue =true/>
										<#break />
									</#if>
								</#list>
							</#if>
							<#if !isListValue>
				cmb${ccc}.select(cmb${ccc}Values.indexOf(entityHolder.get${attrname?cap_first}()));
							<#else>
				value${ccc} = entityHolder.get${ccc}();
				txt${ccc}.setText(value${ccc}.getDescripcion());
							</#if>
				
						</#if>
					<#else>
						<#if opt.staticValuesFields??>
							<#assign svfTableIndex = -1 />
							<#list opt.staticValuesFields as staticValuesField>
								<#assign svfTableIndex = svfTableIndex + 1 />
								<#if (staticValuesField?is_string && staticValuesField == tableName)>
									<#assign svfColumns = opt.staticValuesFields[svfTableIndex + 1] />
									<#assign svfColumnIndex = -1 />
									<#list svfColumns as svfColumn>
										<#assign svfColumnIndex = svfColumnIndex + 1 />
										<#if (svfColumn?is_string && svfColumn == column.columnName)>
											<#assign itemGenerated = true />
				cmb${ccc}.select(cmb${ccc}Values.indexOf(entityHolder.get${attrname?cap_first}()));
											<#break />
										</#if>
									</#list>
									<#break />
								</#if>
							</#list>
						</#if>
						<#if !itemGenerated>
						    <#--Si es una fecha inicializamos con la fecha del dia -->
							<#if (opt.sqlDateTypes?seq_contains(column.dataType) || opt.sqlTimestampTypes?seq_contains(column.dataType))>
				dt${ccc}.setDay(entityHolder.get${ccc}().getDay());
				dt${ccc}.setMonth(entityHolder.get${ccc}().getMonth() - 1);
				dt${ccc}.setYear(entityHolder.get${ccc}().getYear());
							<#--Un simple text-->
							<#elseif opt.sqlStringTypes?seq_contains(column.dataType)>
				txt${ccc}.setText(entityHolder.get${ccc}() == null ? "" : "" + entityHolder.get${ccc}());
							<#else>
				txt${ccc}.setText(entityHolder.get${ccc}() == null ? "" : "" + entityHolder.get${ccc}());
							</#if>
						</#if>
					</#if>
				</#if>
			</#list>
			}
			<#--Verificamos si la entidad posee detalles-->
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
			refreshGrid${detail}();
								</#if>
							</#list>		
						</#if>
					</#if>
				</#list>
			</#if>
		
		shlNuevo${entityName}.open();
		shlNuevo${entityName}.layout();
		Display display = getParent().getDisplay();
		while (!shlNuevo${entityName}.isDisposed()) {
			if (!display.readAndDispatch()) {
				display.sleep();
			}
		}
		return result;
	}

	/**
	 * Create contents of the dialog.
	 */
	private void createContents(String title) {
		<#--Configuracion de la ventana-->
		shlNuevo${entityName} = new Shell(getParent(), SWT.SHELL_TRIM | SWT.BORDER | SWT.APPLICATION_MODAL);
		<#--Configuracion del tamanho-->
		<#--Verificamos si la entidad posee detalles-->
		<#assign cont = 0>
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
								<#assign cont = cont + 1 />
							</#if>
						</#list>		
					</#if>
				</#if>
			</#list>
		</#if>	
		<#if (columns?size <= 10)>
			shlNuevo${entityName}.setSize(600, ${81 + columns?size * 28 +(210*cont)});
		<#else>
			shlNuevo${entityName}.setSize(600, ${250 +(100*cont)});
		</#if>
		shlNuevo${entityName}.setText(title);
		centerDialog();
		shlNuevo${entityName}.setLayout(new GridLayout(1, false));
		centerDialog();
		
		Composite cmpFields = new Composite(shlNuevo${entityName}, SWT.NONE);
		cmpFields.setLayout(new GridLayout(1, false));
		cmpFields.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true, 2,
				1));

		Group groupForm = new Group(cmpFields, SWT.NONE);
		groupForm.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, false,
				1, 1));
		groupForm.setText("Datos generales");
		groupForm.setLayout(new GridLayout(3, false));
		
		<#list columns as column>
			<#-- Si no es la clave primaria generamos el label o etiqueta del field -->
			<#if !column.primaryKey>
				<#assign itemGenerated = false />
				<#assign ccc = opt.camelCase(column) />
				<#assign javatype = opt.insertJavaType(column) />
				<#assign fk = opt.getFk(column) />
				<#if (fk?size > 0)>
					<#list tables as t>
						<#if t.tableName == fk.pktableName>
							<#assign itemGenerated = true />
							<#assign javatype = opt.camelCaseStr(fk.pktableName) />
							<#--Verificamos si el fk es una cabecera-->
							<#assign valid =true/>
							<#if opt.masterDetail??>
								<#assign index = 0/>
								<#--entity es cada maestro-->
								<#list opt.masterDetail as entity>
									<#assign index = index + 1 />
									<#if entity?is_string>
										<#if entity == ccc>
											<#assign idx = opt.masterDetail?seq_index_of(entity) + 1 />
											<#list opt.masterDetail[idx] as detail>
												<#if detail?is_string>
												<#--Y si la tabla en cuestion es un detalle de la cabecera no agregamos el combo-->
													<#if detail==entityName>
														<#assign valid =false/>
													</#if>
												</#if>
											</#list>		
										</#if>
									</#if>
								</#list>
							</#if>
							<#if valid>
		Label lbl${ccc} = new Label(groupForm, SWT.NONE);
		lbl${ccc}.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		lbl${ccc}.setText("${fk.pktableName?replace("_", " ")?capitalize}");
		
		<#-- Si es un fk, se define un combo o un picker-->
								<#assign isListValue =false/>
								<#if opt.listValue??>
									<#list opt.listValue as picker>
										<#if picker==ccc>
											<#assign isListValue =true/>
											<#break />
										</#if>
									</#list>
								</#if>
								<#if !isListValue>
		cmb${ccc} = new Combo(groupForm, SWT.READ_ONLY);
		cmb${ccc}.setEnabled(getEnableField());
		cmb${ccc}.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		new Label(groupForm, SWT.NONE);
								<#else>
		txt${ccc} = new Text(groupForm, SWT.READ_ONLY | SWT.BORDER);
		txt${ccc}.setEnabled(getEnableField());
		txt${ccc}.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		
		Button btnPicker = new Button(groupForm, SWT.NONE);
		btnPicker.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				${ccc}ListValueDialog sd = new ${ccc}ListValueDialog(shlNuevo${entityName});
				value${ccc} = sd.open();
				if (value${ccc} != null) {
					txt${ccc}.setText(value${ccc}.getDescripcion());
				}
			}
		});
		btnPicker.setText("&Elegir");
		btnPicker.setEnabled(getEnableField());
								</#if>
							</#if>
							<#break />
						</#if>
					</#list>
				</#if>
				<#if opt.staticValuesFields??>
					<#assign svfTableIndex = -1 />
					<#list opt.staticValuesFields as staticValuesField>
						<#assign svfTableIndex = svfTableIndex + 1 />
						<#if (staticValuesField?is_string && staticValuesField == tableName)>
							<#assign svfColumns = opt.staticValuesFields[svfTableIndex + 1] />
							<#assign svfColumnIndex = -1 />
							<#list svfColumns as svfColumn>
								<#assign svfColumnIndex = svfColumnIndex + 1 />
								<#if (svfColumn?is_string && svfColumn == column.columnName)>
									<#assign itemGenerated = true />
		<#--Si posee una lista de constantes asociada tambien es un combo-->
		Label lbl${ccc} = new Label(groupForm, SWT.NONE);
		lbl${ccc}.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		lbl${ccc}.setText("${column.columnName?replace("_", " ")?capitalize}");
		
		cmb${ccc} = new Combo(groupForm, SWT.NONE);
		cmb${ccc}.setEnabled(getEnableField());
		cmb${ccc}.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		new Label(groupForm, SWT.NONE);

									<#break />
								</#if>
							</#list>
							<#break />
						</#if>
					</#list>
				</#if>
				<#if !itemGenerated>
		<#--si no es un combo ni una lista de constantes-->
		Label lbl${ccc} = new Label(groupForm, SWT.NONE);
		lbl${ccc}.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		lbl${ccc}.setText("${column.columnName?replace("_", " ")?capitalize}");
		
					<#if (opt.sqlDateTypes?seq_contains(column.dataType) || opt.sqlTimestampTypes?seq_contains(column.dataType))>
		<#--Puede ser una fecha-->
		dt${ccc} = new DateTime(groupForm, SWT.BORDER | SWT.DROP_DOWN);
		dt${ccc}.setEnabled(getEnableField());
		new Label(groupForm, SWT.NONE);
					<#else>
						<#assign indexof = opt.passwordFields?seq_index_of(tableName) />
						<#assign pass = "" />
						<#if (indexof > -1)>
							<#if opt.passwordFields[indexof + 1]?seq_contains(column.columnName)>
								<#assign pass = " | SWT.PASSWORD" />
							</#if>
						</#if>
		<#--O un simple text-->
		txt${ccc} = new Text(groupForm, SWT.BORDER${pass});
		txt${ccc}.setEnabled(getEnableField());
		txt${ccc}.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		new Label(groupForm, SWT.NONE);
		
					</#if>
				</#if>
			</#if>
		</#list>
		
		try{
			EntityManager em = PersistenceHelper.getEmf().createEntityManager();
			<#list columns as column>
				<#assign itemGenerated = false />
				<#assign ccc = opt.camelCase(column) />
				<#assign javatype = opt.insertJavaType(column) />
				<#assign fk = opt.getFk(column) />
				<#if (fk?size > 0)>
					<#list tables as t>
						<#if t.tableName == fk.pktableName>
							<#assign itemGenerated = true />
							<#assign javatype = opt.camelCaseStr(fk.pktableName) />
							<#assign descCol = opt.camelCaseStr(fk.pkcolumnName) />
							<#list t.columns as col>
								<#if opt.sqlStringTypes?seq_contains(col.dataType)>
									<#assign descCol = opt.camelCase(col) />
									<#break />
								</#if>
							</#list>
							<#--Verificamos si el fk es una cabecera-->
							<#assign valid =true/>
							<#if opt.masterDetail??>
								<#assign index = 0/>
								<#--entity es cada maestro-->
								<#list opt.masterDetail as entity>
									<#assign index = index + 1 />
									<#if entity?is_string>
										<#if entity == ccc>
											<#assign idx = opt.masterDetail?seq_index_of(entity) + 1 />
											<#list opt.masterDetail[idx] as detail>
												<#if detail?is_string>
												<#--Y si la tabla en cuestion es un detalle de la cabecera no agregamos el combo-->
													<#if detail==entityName>
														<#assign valid =false/>
													</#if>
												</#if>
											</#list>		
										</#if>
									</#if>
								</#list>
							</#if>
							<#if valid>
								<#assign isListValue =false/>
								<#if opt.listValue??>
									<#list opt.listValue as picker>
										<#if picker==ccc>
											<#assign isListValue =true/>
											<#break />
										</#if>
									</#list>
								</#if>
								<#if !isListValue>
			<#--Hacemos la consulta y cargamos el combo-->
			for(${javatype} o : (List<${javatype}>)em.createQuery(" select o from ${javatype} o ").getResultList()){
				cmb${ccc}.add("" + o.get${descCol}());
				cmb${ccc}Values.add(o);
			}
								</#if>
							</#if>
							<#break />
						</#if>
					</#list>
				</#if>
				<#if opt.staticValuesFields??>
					<#assign svfTableIndex = -1 />
					<#list opt.staticValuesFields as staticValuesField>
						<#assign svfTableIndex = svfTableIndex + 1 />
						<#if (staticValuesField?is_string && staticValuesField == tableName)>
							<#assign svfColumns = opt.staticValuesFields[svfTableIndex + 1] />
							<#assign svfColumnIndex = -1 />
							<#list svfColumns as svfColumn>
								<#assign svfColumnIndex = svfColumnIndex + 1 />
								<#if (svfColumn?is_string && svfColumn == column.columnName)>
									<#assign itemGenerated = true />
									<#assign svfs = svfColumns[svfColumnIndex + 1] />
									<#list svfs as svf>
			<#--Inicializamos la lista de elementos al primer elemento-->
			cmb${ccc}.add("${svf[1]}");
			cmb${ccc}Values.add(new ${javatype}("${svf[0]}"));
									</#list>
									<#break />
								</#if>
							</#list>
							<#break />
						</#if>
					</#list>
				</#if>
			</#list>
			em.close();
		}catch(Exception ex){
			createMessageBox(ex.getMessage());
		}
		<#--Ponemos el foco en el primer atributo-->
		<#list columns as column>
			<#if column != opt.keyColumn>

		<#assign itemGenerated = false />
		<#assign ccc = opt.camelCase(column) />
		<#assign javatype = opt.insertJavaType(column) />
		<#assign fk = opt.getFk(column) />
		<#if (fk?size > 0)>
			<#list tables as t>
				<#if t.tableName == fk.pktableName>
					<#assign itemGenerated = true />
					<#assign javatype = opt.camelCaseStr(fk.pktableName) />
		<#--Si es un combo-->
		cmb${ccc}.setFocus();
					<#break />
				</#if>
			</#list>
		</#if>
		<#if opt.staticValuesFields??>
			<#assign svfTableIndex = -1 />
			<#list opt.staticValuesFields as staticValuesField>
				<#assign svfTableIndex = svfTableIndex + 1 />
				<#if (staticValuesField?is_string && staticValuesField == tableName)>
					<#assign svfColumns = opt.staticValuesFields[svfTableIndex + 1] />
					<#assign svfColumnIndex = -1 />
					<#list svfColumns as svfColumn>
						<#assign svfColumnIndex = svfColumnIndex + 1 />
						<#if (svfColumn?is_string && svfColumn == column.columnName)>
							<#assign itemGenerated = true />
		<#--Si es una lista de valores-->
		cmb${ccc}.setFocus();
							<#break />
						</#if>
					</#list>
					<#break />
				</#if>
			</#list>
		</#if>
		<#if !itemGenerated>
			<#if (opt.sqlDateTypes?seq_contains(column.dataType) || opt.sqlTimestampTypes?seq_contains(column.dataType))>
		<#--Si es una fecha-->
		dt${ccc}.setFocus();
			<#else>
		<#--Si es un text simple-->
		txt${ccc}.setFocus();
			</#if>
		</#if>
				<#break />
			</#if>
		</#list>
		<#--Verificamos si la entidad posee detalles-->
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
								
		Group group${detail} = new Group(cmpFields, SWT.NONE);
		group${detail}.setLayoutData(new GridData(SWT.FILL, SWT.FILL, false,
				true, 1, 1));
		group${detail}.setText("${detail}");
		group${detail}.setLayout(new GridLayout(1, false));

		table${detail} = new Table(group${detail}, SWT.BORDER
				| SWT.FULL_SELECTION);
		table${detail}.setLinesVisible(true);
		table${detail}.setHeaderVisible(true);
		table${detail}.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true,
				true, 1, 1));

		Composite cmp${detail}Buttons = new Composite(group${detail}, SWT.NONE);
		cmp${detail}Buttons.setLayout(new GridLayout(3, false));
		cmp${detail}Buttons.setLayoutData(new GridData(SWT.FILL, SWT.FILL,
				true, false, 1, 1));

		btnNew${detail}  = new Button(cmp${detail}Buttons, SWT.NONE);
		btnNew${detail}.setEnabled(getEnableField());
		btnNew${detail}.setText("Nuevo");
		btnNew${detail}.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
			
				${detail}EditDialog editDialog${detail} = new ${detail}EditDialog(shlNuevo${entityName});
				shlNuevo${entityName}.setVisible(false);
				${detail} ${detail?uncap_first} = editDialog${detail}.open("Creando ${detail?uncap_first}");
				shlNuevo${entityName}.setVisible(true);
				if(${detail?uncap_first}!=null){
					${detail?uncap_first}.setId(getIdTemp${detail}());
					list${detail}.add(${detail?uncap_first});
					refreshGrid${detail}();
				}
			}
		});

		btnEdit${detail}  = new Button(cmp${detail}Buttons, SWT.NONE);
		btnEdit${detail}.setEnabled(getEnableField());
		btnEdit${detail}.setText("Editar");
		btnEdit${detail}.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				
				if(table${detail}.getSelection().length > 0){
					try{
						${detail} selected = get${detail}Select();
						${detail}EditDialog ed = new ${detail}EditDialog(
								shlNuevo${entityName}, selected);
						shlNuevo${entityName}.setVisible(false);
						selected = ed.open("Editando ${detail?uncap_first}");
						shlNuevo${entityName}.setVisible(true);
						if (selected != null) {
							refreshGrid${detail}();
						}
					}catch(Exception ex){
						createMessageBox(ex.getMessage());
					}
				}else {
					createMessageBox("Seleccione el registro que desea editar");
				}
			}
		});

		btnDelete${detail}  = new Button(cmp${detail}Buttons, SWT.NONE);
		btnDelete${detail}.setEnabled(getEnableField());
		btnDelete${detail}.setText("Borrar");
		btnDelete${detail}.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				if (table${detail}.getSelection().length > 0) {
					try {
						${detail} selected = get${detail}Select();

						${detail}EditDialog ed = new ${detail}EditDialog(shlNuevo${entityName}, selected);

						ed.setDelete(true);
						shlNuevo${entityName}.setVisible(false);
						ed.open("Eliminando ${detail?uncap_first}");
						shlNuevo${entityName}.setVisible(true);

						if (!isDelete()) {
							list${detail}.remove(selected);
						}

						refreshGrid${detail}();
		
					} catch (Exception ex) {
						createMessageBox(ex.getMessage());
					}
				} else {
					createMessageBox("Seleccione el registro que desea eliminar");
				}
			}
		});
		
								<#assign aux =detail/>
								<#else>
									<#list detail as column>
		column${aux}${column}  = new TableColumn(table${aux}, SWT.NONE);
		column${aux}${column}.setWidth(50);
		column${aux}${column}.setText("${column}");
									</#list>
								</#if>
						</#list>		
					</#if>
				</#if>
			</#list>
		</#if>
		
		Composite cmpButtons = new Composite(shlNuevo${entityName}, SWT.NONE);
		cmpButtons.setLayout(new GridLayout(2, false));
		cmpButtons.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, false,
				1, 1));
		
		btnAccept = new Button(cmpButtons, SWT.NONE);
		btnAccept.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				if (isDelete()) {
				<#--Verificamos si la entidad posee detalles-->
				<#assign isDetail=false />
				<#if opt.masterDetail??>
					<#assign index = 0/>
					<#--entity es cada maestro-->
					<#list opt.masterDetail as entity>
						<#assign index = index + 1 />
						<#if entity?is_string>
							<#assign idx = opt.masterDetail?seq_index_of(entity) + 1 />
							<#list opt.masterDetail[idx] as detail>
								<#if detail?is_string>
									<#--Si es un detalle la persistencia se realiza en el cabecera-->
									<#if detail == entityName>
										<#assign isDetail=true />
									</#if>
								</#if>
							</#list>	
						</#if>
					</#list>
				</#if>
				<#if !isDetail >
					EntityManager em = PersistenceHelper.getEmf()
							.createEntityManager();
					em.getTransaction().begin();
					em.remove(em.find(${entityName}.class,
							new Long(entityHolder.getId())));
					setDelete(false);
					em.getTransaction().commit();
					em.close();
					shlNuevo${entityName}.close();
				<#else>
					setDelete(false);
					shlNuevo${entityName}.close();
				</#if>
				}else{
					if(validateData()){
					<#if !isDetail >
						try{
					</#if>
							<#--Generamos el boton de guardar-->
							SimpleDateFormat sdf = (SimpleDateFormat)SimpleDateFormat.getInstance();
							sdf.applyPattern("dd/MM/yyyy");
							<#if !isDetail >
							EntityManager em = PersistenceHelper.getEmf().createEntityManager();
							em.getTransaction().begin();
							</#if>
							${entityName} o = entityHolder == null ? new ${entityName}() : entityHolder;
							<#--Seteamos los valores seleccionados o ingresados-->
							<#assign attrNames = "" />
							<#assign isHeader=false />
							<#list columns as column>
								<#if !column.primaryKey>
									<#assign itemGenerated = false />
									<#assign ccc = opt.camelCase(column) />
									<#assign javatype = opt.insertJavaType(column) />
									<#assign attrname = opt.mixedCase(column) />
									<#assign fk = opt.getFk(column) />
									<#if (fk?size > 0)>
										<#list tables as t>
											<#if t.tableName == fk.pktableName>
												<#assign itemGenerated = true />
												<#assign javatype = opt.camelCaseStr(fk.pktableName) />
												<#assign attrname = opt.mixedCaseStr(fk.pktableName) />
												<#break />
											</#if>
										</#list>
									</#if>
									<#assign res = attrNames?matches(attrname)?size />
									<#assign attrNames = attrNames + " " + attrname />
									<#if res &gt; 0>
										<#assign attrname = attrname + res />
									</#if>
									<#if itemGenerated>
										<#--Verificamos si el fk es una cabecera-->
										<#assign valid =true/>
										<#if opt.masterDetail??>
											<#assign index = 0/>
											<#--entity es cada maestro-->
											<#list opt.masterDetail as entity>
												<#assign index = index + 1 />
												<#if entity?is_string>
													<#if entity == entityName>
														<#assign isHeader=true />
													</#if>
													<#if entity == ccc>
														<#assign idx = opt.masterDetail?seq_index_of(entity) + 1 />
														<#list opt.masterDetail[idx] as detail>
															<#if detail?is_string>
															<#--Y si la tabla en cuestion es un detalle de la cabecera no agregamos el combo-->
																<#if detail==entityName>
																	<#assign valid =false/>
																</#if>
															</#if>
														</#list>		
													</#if>
												</#if>
											</#list>
										</#if>
										<#if valid>
											<#assign isListValue =false/>
											<#if opt.listValue??>
												<#list opt.listValue as picker>
													<#if picker==ccc>
														<#assign isListValue =true/>
														<#break />
													</#if>
												</#list>
											</#if>
											<#if !isListValue>
							<#--Seteamos el valor seleccionado del combo en la entidad-->
							o.set${attrname?cap_first}(cmb${ccc}Values.get(cmb${ccc}.getSelectionIndex()));
											<#else>
							o.set${attrname?cap_first}(value${ccc});
											</#if>
										</#if>
									<#else>
										<#if opt.staticValuesFields??>
											<#assign svfTableIndex = -1 />
											<#list opt.staticValuesFields as staticValuesField>
												<#assign svfTableIndex = svfTableIndex + 1 />
												<#if (staticValuesField?is_string && staticValuesField == tableName)>
													<#assign svfColumns = opt.staticValuesFields[svfTableIndex + 1] />
													<#assign svfColumnIndex = -1 />
													<#list svfColumns as svfColumn>
														<#assign svfColumnIndex = svfColumnIndex + 1 />
														<#if (svfColumn?is_string && svfColumn == column.columnName)>
															<#assign itemGenerated = true />
							o.set${attrname?cap_first}(cmb${ccc}Values.get(cmb${ccc}.getSelectionIndex()));
															<#break />
														</#if>
													</#list>
													<#break />
												</#if>
											</#list>
										</#if>
										<#if !itemGenerated>
											<#if (opt.sqlDateTypes?seq_contains(column.dataType) || opt.sqlTimestampTypes?seq_contains(column.dataType))>
							<#-- Seteamos la fecha seleccioanda en la entidad-->
							o.set${ccc}(sdf.parse(dt${ccc}.getDay() + "/" + (dt${ccc}.getMonth() + 1) + "/" + dt${ccc}.getYear()));
											<#elseif opt.sqlStringTypes?seq_contains(column.dataType)>
							o.set${ccc}(<#if opt.blankStringsAreNull>txt${ccc}.getText().equals("") ? null :</#if> txt${ccc}.getText());							
											<#else>
							<#--Seteamos el valor de texto ingresado-->
							o.set${ccc}(txt${ccc}.getText().equals("") ? null : new ${opt.insertJavaType(column)}(txt${ccc}.getText()));
											</#if>
										</#if>
									</#if>
								</#if>
							</#list>
							<#if isHeader >
							configureHeader(o);
							</#if>
							<#if !isDetail >
							if(entityHolder == null){
								em.persist(o);
							}else{
								<#--Por cada detalle hacemos el delta de los registros-->
							<#if isHeader >
								<#assign index = 0/>
								<#--entity es cada maestro-->
								<#list opt.masterDetail as entity>
									<#assign index = index + 1 />
									<#if entity?is_string>
										<#if entity == entityName>
											<#assign idx = opt.masterDetail?seq_index_of(entity) + 1 />
											<#list opt.masterDetail[idx] as detail>
												<#if detail?is_string>
								for (${detail} detail : build${detail}()) {
									if (!list${detail}.contains(detail)) {
										em.remove(em.find(${detail}.class,
												new Long(detail.getId())));
									}
								}
												</#if>
											</#list>		
										</#if>
									</#if>
								</#list>
							</#if>
								em.merge(o);
							}
							em.getTransaction().commit();
							em.close();
							</#if>
							
							result = o;
							shlNuevo${entityName}.close();
						<#if !isDetail >
						}catch(Exception ex){
							createMessageBox(ex.getMessage());
						}
						</#if>
					}
				}
			}
		});
		if (delete) {
			btnAccept.setText("&Borrar");
		} else {
			btnAccept.setText("&Guardar");
		}
		btnCancelar = new Button(cmpButtons, SWT.NONE);
		btnCancelar.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				shlNuevo${entityName}.close();
			}
		});
		btnCancelar.setText("&Cancelar");
		
		
	}
	<#--Verificamos si la entidad posee detalles-->
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
	@SuppressWarnings("unchecked")
	private List<${detail}> build${detail}() {
		EntityManager em = PersistenceHelper.getEmf().createEntityManager();
		Query query = em
				.createQuery(" select d from ${detail} d where d.${entityName?uncap_first}=:entity ");
		query.setParameter("entity", entityHolder);

		List<${detail}> aRet = query.getResultList();
		em.close();

		return aRet;
	}
	<#--Ver el tipo de dato LoNG-->
	private ${detail} get${detail}Select() {
		String selected = table${detail}.getSelection()[0].getText(0);
		for (${detail} detail : list${detail}) {
			if (detail.getId().equals(new Long(selected)))
				return detail;
		}
		return null;

	}

	private void refreshGrid${detail}() {
		for (TableItem item : table${detail}.getItems()) {
			item.dispose();
		}
		for (${detail} row : getList${detail}()) {
			TableItem tableItem = new TableItem(table${detail}, SWT.NONE);
			tableItem.setText(new String[] { 		
					<#else>
						<#assign lastCol = detail?last>
						<#list detail as column>
							"" + row.get${column}()<#if column!=lastCol>,</#if>
						</#list>
			});
		}
	}
					</#if>
				</#list>	
			</#if>
		</#if>
	</#list>
</#if>
<#list columns as column>
		<#if column != opt.keyColumn>
		<#assign itemGenerated = false />
		<#assign ccc = opt.camelCase(column) />
		<#assign javatype = opt.insertJavaType(column) />
		<#assign fk = opt.getFk(column) />
		
		<#-- Si es un fk -->
		<#if (fk?size > 0)>
			<#list tables as t>
				<#if t.tableName == fk.pktableName>
					<#assign itemGenerated = true />
					<#assign javatype = opt.camelCaseStr(fk.pktableName) />
					<#--Verificamos si el fk es una cabecera-->
					<#assign valid =true/>
					<#if opt.masterDetail??>
						<#assign index = 0/>
						<#--entity es cada maestro-->
						<#list opt.masterDetail as entity>
							<#assign index = index + 1 />
							<#if entity?is_string>
								<#if entity == ccc>
									<#assign idx = opt.masterDetail?seq_index_of(entity) + 1 />
									<#list opt.masterDetail[idx] as detail>
										<#if detail?is_string>
										<#--Y si la tabla en cuestion es un detalle de la cabecera no agregamos el combo-->
											<#if detail==entityName>
												<#assign valid =false/>
											</#if>
										</#if>
									</#list>		
								</#if>
							</#if>
						</#list>
					</#if>
					<#break />
				</#if>
			</#list>
		</#if>
		</#if>
	</#list>
	
	protected boolean validateData() {
		//Validate nullity
		<#assign attrNames = "" />
		<#list columns as column>
			<#if !column.primaryKey>
				<#assign itemGenerated = false />
				<#assign ccc = opt.camelCase(column) />
				<#assign javatype = opt.insertJavaType(column) />
				<#assign attrname = opt.mixedCase(column) />
				<#assign title = column.columnName?replace("_"," ")?capitalize />
				<#assign fk = opt.getFk(column) />
				<#if (fk?size > 0)>
					<#list tables as t>
						<#if t.tableName == fk.pktableName>
							<#assign itemGenerated = true />
							<#assign javatype = opt.camelCaseStr(fk.pktableName) />
							<#assign attrname = opt.mixedCaseStr(fk.pktableName) />
							<#assign title = fk.pktableName?replace("_"," ")?capitalize />
							<#break />
						</#if>
					</#list>
				</#if>
				<#assign res = attrNames?matches(attrname)?size />
				<#assign attrNames = attrNames + " " + attrname />
				<#if res &gt; 0>
					<#assign attrname = attrname + res />
				</#if>
				<#if itemGenerated>
				<#--Verificamos si el fk es una cabecera-->
					<#assign valid =true/>
					<#if opt.masterDetail??>
						<#assign index = 0/>
						<#--entity es cada maestro-->
						<#list opt.masterDetail as entity>
							<#assign index = index + 1 />
							<#if entity?is_string>
								<#if entity == ccc>
									<#assign idx = opt.masterDetail?seq_index_of(entity) + 1 />
									<#list opt.masterDetail[idx] as detail>
										<#if detail?is_string>
										<#--Y si la tabla en cuestion es un detalle de la cabecera no agregamos el combo-->
											<#if detail==entityName>
												<#assign valid =false/>
											</#if>
										</#if>
									</#list>		
								</#if>
							</#if>
						</#list>
					</#if>
					<#if valid>
		<#--Hacemos que el combo o picker sea obligatorio-->
						<#assign isListValue =false/>
						<#if opt.listValue??>
							<#list opt.listValue as picker>
								<#if picker==ccc>
									<#assign isListValue =true/>
									<#break />
								</#if>
							</#list>
						</#if>
						<#if !isListValue>
		if(cmb${ccc}.getSelectionIndex() == -1){
			createMessageBox("'${title}' debe tener valor.");
			cmb${ccc}.setFocus();
			return false;
		}
						<#else>
		if (value${ccc} == null) {
			createMessageBox("'${title}' debe tener valor.");
			txt${ccc}.setFocus();
			return false;
		}
						</#if>
					</#if>
		
				<#else>
					<#if opt.staticValuesFields??>
						<#assign svfTableIndex = -1 />
						<#list opt.staticValuesFields as staticValuesField>
							<#assign svfTableIndex = svfTableIndex + 1 />
							<#if (staticValuesField?is_string && staticValuesField == tableName)>
								<#assign svfColumns = opt.staticValuesFields[svfTableIndex + 1] />
								<#assign svfColumnIndex = -1 />
								<#list svfColumns as svfColumn>
									<#assign svfColumnIndex = svfColumnIndex + 1 />
									<#if (svfColumn?is_string && svfColumn == column.columnName)>
										<#assign itemGenerated = true />
		<#--Hacemos que la lista de valores sea obligatoria-->
		if(cmb${ccc}.getSelectionIndex() == -1){
			createMessageBox("'${title}' debe tener valor.");
			cmb${ccc}.setFocus();
			return false;
		}
										<#break />
									</#if>
								</#list>
								<#break />
							</#if>
						</#list>
					</#if>
					<#if !itemGenerated>
						<#if (opt.sqlDateTypes?seq_contains(column.dataType) || opt.sqlTimestampTypes?seq_contains(column.dataType))>
		<#--NO puede ser null, pero no se encuentra la implementacion-->
		//Date fields cannot be null							
						<#else>
							<#if !column.nullable>
		<#--Verificamos si el atributo de texto es obligatorio-->
		if(txt${ccc}.getText() != null && txt${ccc}.getText().equals("")){
			createMessageBox("'${title}' debe tener valor.");
			txt${ccc}.setFocus();
			return false;
		}
							</#if>
							
		<#--Verificamos la longitud de la caja de texto-->
							<#if (column.columnSize > 0)>
								<#assign daSize = ("" + column.columnSize)?replace(",","")?replace(".","") />
		if(txt${ccc}.getText() != null && txt${ccc}.getText().length() > ${daSize}){
			createMessageBox("Tama�o de '${title}' debe ser menor o igual a ${daSize}");
			txt${ccc}.setFocus();
			return false;
		}
							</#if>
						</#if>
					</#if>
				</#if>
			</#if>
		</#list>
			
		return true;
	}
<#--Si la entidad posee detalles configuramos cada uno de ellos-->
<#if opt.masterDetail??>
	<#assign index = 0/>
	<#list opt.masterDetail as entity>
		<#assign index = index + 1 />
		<#if entity?is_string>
			<#if entity == entityName>
private void configureHeader(${entityName} header) {
				<#assign idx = opt.masterDetail?seq_index_of(entity) + 1 />
				<#list opt.masterDetail[idx] as detail>
					<#if detail?is_string>
	for (${detail} detail : list${detail}) {
		if (detail.getId() < 0) {
			detail.setId(null);
			detail.set${entityName}(header);
		}
	}
	header.set${detail}(list${detail});
					</#if>
				</#list>	
}	
			</#if>
		</#if>
	</#list>
</#if>	
<#--Verificamos si la entidad posee detalles-->
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
	public List<${detail}> getList${detail}() {
		if (list${detail} == null) {
			this.list${detail} = build${detail}();
		}
		return list${detail};
	}
	public void setList${detail}(List<${detail}> ${detail?uncap_first}) {
		this.list${detail} = ${detail?uncap_first};
	}

	private long getIdTemp${detail}() {
		if (idTemp${detail} == null) {
			idTemp${detail} = new Long(0);
		}
		idTemp${detail}--;
		return idTemp${detail};
	}
					</#if>
				</#list>		
			</#if>
		</#if>
	</#list>
</#if>	
	
	private void centerDialog() {
		Monitor primary = shlNuevo${entityName}.getDisplay().getPrimaryMonitor();
		Rectangle bounds = primary.getBounds();
		Rectangle rect = shlNuevo${entityName}.getBounds ();
		int x = bounds.x + (bounds.width - rect.width) / 2;
		int y = bounds.y + (bounds.height - rect.height) / 2;
		shlNuevo${entityName}.setLocation (x, y);
	}
	public boolean isDelete() {
		return delete;
	}

	public void setDelete(boolean delete) {
		this.delete = delete;
	}
	private boolean getEnableField(){
		return !isDelete();
	}
	private void createMessageBox(String message) {
		MessageBox ms = new MessageBox(shlNuevo${entityName});
		ms.setMessage(message);
		ms.open();
	}
}
</#if>