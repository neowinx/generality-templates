<#import "*/gen-options.ftl" as opt>
<#if (!opt.keyColumn??)>
//ESTE TEMPLATE SOLO MANEJA TABLAS CON PRIMARY KEYS DEFINIDOS
<#else>
<#assign entityName = opt.camelCaseStr(tableName) />
package ${opt.dialogsPackage};

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Vector;

import javax.persistence.EntityManager;
import javax.persistence.Persistence;

import org.eclipse.swt.widgets.Dialog;
import org.eclipse.swt.widgets.Display;
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

import swing2swt.layout.BorderLayout;

import ${opt.entityPackage}.${entityName};
import ${opt.mainPackage}.PersistenceHelper;
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
import ${opt.entityPackage}.${javatype};
				<#break />
			</#if>
		</#list>
	</#if>
</#list>

public class ${entityName}EditDialog extends Dialog {

	protected ${entityName} result;
	protected Shell shlNuevo${entityName};
	private ${entityName} entityHolder;
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
	private Combo cmb${ccc};
	private List<${javatype}> cmb${ccc}Values = new Vector<${javatype}>();
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
	private Combo cmb${ccc};
	private List<${javatype}> cmb${ccc}Values = new Vector<${javatype}>();
							<#break />
						</#if>
					</#list>
					<#break />
				</#if>
			</#list>
		</#if>
		<#if !itemGenerated>
			<#if (opt.sqlDateTypes?seq_contains(column.dataType) || opt.sqlTimestampTypes?seq_contains(column.dataType))>
	private DateTime dt${ccc};
			<#else>
	private Text txt${ccc};
			</#if>
		</#if>
	</#list>
	private Button btnGuardar; 

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
	public ${entityName} open() {
		createContents();
		
		if(entityHolder != null){
			<#assign attrNames = "" />
			<#list columns as column>
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
			cmb${ccc}.select(cmb${ccc}Values.indexOf(entityHolder.get${attrname?cap_first}()));
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
						<#if (opt.sqlDateTypes?seq_contains(column.dataType) || opt.sqlTimestampTypes?seq_contains(column.dataType))>
				dt${ccc}.setDay(entityHolder.get${ccc}().getDay());
				dt${ccc}.setMonth(entityHolder.get${ccc}().getMonth() - 1);
				dt${ccc}.setYear(entityHolder.get${ccc}().getYear());
						<#elseif opt.sqlStringTypes?seq_contains(column.dataType)>
				txt${ccc}.setText(entityHolder.get${ccc}() == null ? "" : "" + entityHolder.get${ccc}());
						<#else>
				txt${ccc}.setText(entityHolder.get${ccc}() == null ? "" : "" + entityHolder.get${ccc}());
						</#if>
					</#if>
				</#if>
			</#list>
		}
		
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
	private void createContents() {
		shlNuevo${entityName} = new Shell(getParent(), SWT.SHELL_TRIM | SWT.BORDER | SWT.APPLICATION_MODAL);
		<#if (columns?size <= 10)>
		shlNuevo${entityName}.setSize(600, ${81 + columns?size * 28});
		<#else>
		shlNuevo${entityName}.setSize(600, 250);
		</#if>
		shlNuevo${entityName}.setText("Nuevo ${tableName?replace("_"," ")?capitalize}");
		centerDialog();
		shlNuevo${entityName}.setLayout(new BorderLayout(0, 0));
		
		ScrolledComposite scrolledComposite = new ScrolledComposite(shlNuevo${entityName}, SWT.H_SCROLL | SWT.V_SCROLL);
		scrolledComposite.setLayoutData(BorderLayout.CENTER);
		scrolledComposite.setExpandHorizontal(true);
		scrolledComposite.setExpandVertical(true);
		
		Composite cmpFields = new Composite(scrolledComposite, SWT.NONE);
		cmpFields.setLayout(new GridLayout(2, false));
		
		scrolledComposite.setContent(cmpFields);
		<#if (columns?size <= 10)>
		scrolledComposite.setMinSize(new Point(300, ${6 + columns?size * 28}));
		<#else>
		scrolledComposite.setMinSize(new Point(300, 250));
		</#if>
		
		Composite cmpButtons = new Composite(shlNuevo${entityName}, SWT.NONE);
		cmpButtons.setLayoutData(BorderLayout.SOUTH);
		cmpButtons.setLayout(new GridLayout(1, false));
		
		Label lbl${opt.camelCase(opt.keyColumn)} = new Label(cmpFields, SWT.NONE);
		lbl${opt.camelCase(opt.keyColumn)}.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
		
		txt${opt.camelCase(opt.keyColumn)} = new Text(cmpFields, SWT.BORDER | SWT.READ_ONLY);
		txt${opt.camelCase(opt.keyColumn)}.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		
		<#list columns as column>
			<#if !column.primaryKey>
				<#assign itemGenerated = false />
				<#assign ccc = opt.camelCase(column) />
				<#assign javatype = opt.insertJavaType(column) />
				<#assign fk = opt.getFk(column) />
		Label lbl${ccc} = new Label(cmpFields, SWT.NONE);
		lbl${ccc}.setLayoutData(new GridData(SWT.RIGHT, SWT.CENTER, false, false, 1, 1));
				<#if (fk?size > 0)>
					<#list tables as t>
						<#if t.tableName == fk.pktableName>
							<#assign itemGenerated = true />
							<#assign javatype = opt.camelCaseStr(fk.pktableName) />
		lbl${ccc}.setText("${fk.pktableName?replace("_", " ")?capitalize}");
		
		cmb${ccc} = new Combo(cmpFields, SWT.READ_ONLY);
		cmb${ccc}.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		
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
		lbl${ccc}.setText("${column.columnName?replace("_", " ")?capitalize}");
		
		cmb${ccc} = new Combo(cmpFields, SWT.NONE);
		cmb${ccc}.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));

									<#break />
								</#if>
							</#list>
							<#break />
						</#if>
					</#list>
				</#if>
				<#if !itemGenerated>
		lbl${ccc}.setText("${column.columnName?replace("_", " ")?capitalize}");
		
					<#if (opt.sqlDateTypes?seq_contains(column.dataType) || opt.sqlTimestampTypes?seq_contains(column.dataType))>
		dt${ccc} = new DateTime(cmpFields, SWT.BORDER | SWT.DROP_DOWN);
		
					<#else>
						<#assign indexof = opt.passwordFields?seq_index_of(tableName) />
						<#assign pass = "" />
						<#if (indexof > -1)>
							<#if opt.passwordFields[indexof + 1]?seq_contains(column.columnName)>
								<#assign pass = " | SWT.PASSWORD" />
							</#if>
						</#if>
		txt${ccc} = new Text(cmpFields, SWT.BORDER${pass});
		txt${ccc}.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1));
		
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
			for(${javatype} o : (List<${javatype}>)em.createQuery(" select o from ${javatype} o ").getResultList()){
				cmb${ccc}.add("" + o.get${descCol}());
				cmb${ccc}Values.add(o);
			}
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
			messageBox(ex.getMessage());
		}
		
		btnGuardar = new Button(cmpButtons, SWT.NONE);
		btnGuardar.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				if(validateData()){
					try{
						SimpleDateFormat sdf = (SimpleDateFormat)SimpleDateFormat.getInstance();
						sdf.applyPattern("dd/MM/yyyy");
						EntityManager em = PersistenceHelper.getEmf().createEntityManager();
						em.getTransaction().begin();
						${entityName} o = entityHolder == null ? new ${entityName}() : entityHolder;
						<#assign attrNames = "" />
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
						o.set${attrname?cap_first}(cmb${ccc}Values.get(cmb${ccc}.getSelectionIndex()));
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
						o.set${ccc}(sdf.parse(dt${ccc}.getDay() + "/" + (dt${ccc}.getMonth() + 1) + "/" + dt${ccc}.getYear()));
										<#elseif opt.sqlStringTypes?seq_contains(column.dataType)>
						o.set${ccc}(<#if opt.blankStringsAreNull>txt${ccc}.getText().equals("") ? null :</#if> txt${ccc}.getText());							
										<#else>
						o.set${ccc}(txt${ccc}.getText().equals("") ? null : new ${opt.insertJavaType(column)}(txt${ccc}.getText()));
										</#if>
									</#if>
								</#if>
							</#if>
						</#list>
						if(entityHolder == null)
							em.persist(o);
						else
							em.merge(o);
						em.getTransaction().commit();
						em.close();
						result = o;
						shlNuevo${entityName}.close();
					}catch(Exception ex){
						messageBox(ex.getMessage());
					}
				}
			}
		});
		btnGuardar.setText("&Guardar");
		shlNuevo${entityName}.setDefaultButton(btnGuardar);
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
		dt${ccc}.setFocus();
			<#else>
		txt${ccc}.setFocus();
			</#if>
		</#if>

				<#break />
			</#if>
		</#list>
	}
	

	private void messageBox(String str) {
		MessageBox ms = new MessageBox(shlNuevo${entityName});
		ms.setMessage(str);
		ms.open();
	}
	
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
		if(cmb${ccc}.getSelectionIndex() == -1){
			messageBox("'${title}' debe tener valor.");
			cmb${ccc}.setFocus();
			return false;
		}
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
		if(cmb${ccc}.getSelectionIndex() == -1){
			messageBox("'${title}' debe tener valor.");
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
		//Date fields cannot be null							
						<#else>
							<#if !column.nullable>
		if(txt${ccc}.getText() != null && txt${ccc}.getText().equals("")){
			messageBox("'${title}' debe tener valor.");
			txt${ccc}.setFocus();
			return false;
		}
							</#if>
							<#if (column.columnSize > 0)>
								<#assign daSize = ("" + column.columnSize)?replace(",","")?replace(".","") />
		if(txt${ccc}.getText() != null && txt${ccc}.getText().length() > ${daSize}){
			messageBox("Tama�o de '${title}' debe ser menor o igual a ${daSize}");
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
	
	private void centerDialog() {
		Monitor primary = shlNuevo${entityName}.getDisplay().getPrimaryMonitor();
		Rectangle bounds = primary.getBounds();
		Rectangle rect = shlNuevo${entityName}.getBounds ();
		int x = bounds.x + (bounds.width - rect.width) / 2;
		int y = bounds.y + (bounds.height - rect.height) / 2;
		shlNuevo${entityName}.setLocation (x, y);
	}
}
</#if>