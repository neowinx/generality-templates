<#import "*/gen-options.ftl" as opt />
<#if opt.listValue??>
	<#if (!opt.keyColumn??)>
//ESTE TEMPLATE SOLO MANEJA TABLAS CON PRIMARY KEYS DEFINIDOS
	<#else>
		<#assign entityName = tableName?replace("_", " ")?capitalize?replace(" ", "") />
		<#list opt.listValue as picker>
			<#if picker== entityName>
package ${opt.dialogsPackage};

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.Persistence;
import javax.persistence.Query;

import org.eclipse.swt.widgets.Dialog;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Group;
import org.eclipse.swt.widgets.MessageBox;
import org.eclipse.swt.widgets.Monitor;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Table;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.widgets.TableColumn;
import org.eclipse.swt.widgets.TableItem;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.events.KeyAdapter;
import org.eclipse.swt.events.KeyEvent;
import org.eclipse.swt.events.MouseAdapter;
import org.eclipse.swt.events.MouseEvent;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.graphics.Rectangle;
import org.eclipse.swt.widgets.Text;

import ${opt.mainPackage}.Main;

import ${opt.entityPackage}.${entityName};
import ${opt.mainPackage}.PersistenceHelper;

public class ${entityName}ListValueDialog extends Dialog {

	protected ${entityName} value;
	protected Shell shlPickerFieldPopup;
	private Table table;
	private TableItem tableItem;

	private int firstResult;
	private Long countResult;
	Label lblPage;

	<#if (opt.filterColumns?? && opt.filterColumns?size == 0) >
		<#list columns as column>
			<#if opt.sqlStringTypes?seq_contains(column.dataType)>
	private Text txt${opt.camelCase(column)}Filter;
			</#if>
		</#list>
	<#elseif (opt.filterColumns?? && opt.filterColumns?size > 0) >
	//Custom filters not implemented yet.. sorry :)
	</#if>

	public ${entityName}ListValueDialog(Shell parent) {
		super(parent);
		setText("${entityName}ListValueDialog");
	}

	/**
	 * Open the dialog.
	 * 
	 * @return the result
	 */
	public ${entityName} open() {
		createContents();
		shlPickerFieldPopup.open();
		shlPickerFieldPopup.layout();
		Display display = getParent().getDisplay();
		while (!shlPickerFieldPopup.isDisposed()) {
			if (!display.readAndDispatch()) {
				display.sleep();
			}
		}
		return value;
	}

	/**
	 * Create contents of the dialog.
	 */
	private void createContents() {

		shlPickerFieldPopup = new Shell(getParent(), SWT.SHELL_TRIM
				| SWT.BORDER | SWT.APPLICATION_MODAL);
		shlPickerFieldPopup.setSize(600, 403);
		shlPickerFieldPopup.setText("Seleccionar ${tableName?replace("_"," ")?capitalize}");
		centerDialog();
		shlPickerFieldPopup.setLayout(new GridLayout(1, false));

		Composite filtersComposite = new Composite(shlPickerFieldPopup,
				SWT.NONE);
		filtersComposite.setLayoutData(new GridData(SWT.FILL, SWT.CENTER,
				false, false, 1, 1));
		filtersComposite.setLayout(new GridLayout(2, false));

		Group groupFilter = new Group(filtersComposite, SWT.NONE);
		groupFilter.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, false,
				1, 1));
		groupFilter.setSize(395, 197);
		groupFilter.setText("Búsqueda");
		groupFilter.setLayout(new GridLayout(2, false));
		<#list columns as column>
				<#if opt.sqlStringTypes?seq_contains(column.dataType)>
					<#assign camelCaseCol = opt.camelCase(column) />
					<#assign labelCol = column.columnName?replace("_"," ")?capitalize />
					
		Label lbl${camelCaseCol} = new Label(groupFilter, SWT.NONE);
		lbl${camelCaseCol}.setText("${labelCol}");
		
		txt${camelCaseCol}Filter = new Text(groupFilter, SWT.BORDER);
		txt${camelCaseCol}Filter.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, false, 1, 1));
				</#if>
			</#list>

		Button btnBuscar = new Button(groupFilter, SWT.NONE);
		btnBuscar.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				refreshGrid();
			}
		});
		btnBuscar.setText("&Buscar");

		Button btnLimpiar = new Button(groupFilter, SWT.NONE);
		btnLimpiar.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
			<#if (opt.filterColumns?? && opt.filterColumns?size == 0) >
				<#list columns as column>
					<#if opt.sqlStringTypes?seq_contains(column.dataType)>
				txt${opt.camelCase(column)}Filter.setText("");
					</#if>
				</#list>
			<#elseif (opt.filterColumns?? && opt.filterColumns?size > 0) >
				//Custom filters not implemented yet.. sorry :)
			</#if>
				refreshGrid();
			}
		});
		btnLimpiar.setText("&Limpiar Criterios");

		shlPickerFieldPopup.setDefaultButton(btnBuscar);
		new Label(filtersComposite, SWT.NONE);

		table = new Table(shlPickerFieldPopup, SWT.BORDER | SWT.FULL_SELECTION);
		table.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true, 1, 1));
		table.setHeaderVisible(true);
		table.setLinesVisible(true);
		
		<#--Agregamos la columna Id en primer lugar-->
		<#assign label = opt.keyColumn.columnName?replace("_"," ")?capitalize />
		TableColumn tblclmn${opt.camelCase(opt.keyColumn)} = new TableColumn(table, SWT.NONE);
			tblclmn${opt.camelCase(opt.keyColumn)}.setWidth(100);
		tblclmn${opt.camelCase(opt.keyColumn)}.setText("${label}");
		
		<#--Luego agreamos las demas columnas-->
		<#list columns as column>
			<#if !column.primaryKey>
		TableColumn tblclmn${opt.camelCase(column)} = new TableColumn(table, SWT.NONE);
		tblclmn${opt.camelCase(column)}.setWidth(100);
				<#assign label = column.columnName?replace("_"," ")?capitalize />
				<#assign fk = opt.getFk(column) />
				<#if (fk?size > 0)>
					<#list tables as t>
						<#if t.tableName == fk.pktableName>
							<#assign label = fk.pktableName?replace("_"," ")?capitalize />
							<#break />
						</#if>
					</#list>
				</#if>
		tblclmn${opt.camelCase(column)}.setText("${label}");
			</#if>		
		</#list>

		Composite buttonsComposite = new Composite(shlPickerFieldPopup,
				SWT.NONE);
		buttonsComposite.setLayoutData(new GridData(SWT.CENTER, SWT.CENTER,
				false, false, 1, 1));
		buttonsComposite.setLayout(new GridLayout(4, false));

		Button btnAccept = new Button(buttonsComposite, SWT.NONE);
		btnAccept.setSize(43, 23);
		btnAccept.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				if (table.getSelection().length > 0) {
					try {
						EntityManager em = PersistenceHelper.getEmf()
								.createEntityManager();

						value = em.find(${entityName}.class,
								new ${opt.insertJavaType(opt.keyColumn)}(table.getSelection()[0].getText(0)));
						shlPickerFieldPopup.close();
					} catch (Exception ex) {
						createMessageBox(ex.getMessage());
					}
				} else {
					createMessageBox("Seleccione el ${tableName?replace("_"," ")?capitalize} que desea");
				}
			}
		});
		btnAccept.setText("&Aceptar");

		Composite paginationComposite = new Composite(buttonsComposite,
				SWT.NONE);
		paginationComposite.setLayout(new GridLayout(5, false));

		Button btnFirstPage = new Button(paginationComposite, SWT.NONE);
		btnFirstPage.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				firstResult = 0;
				refreshGrid();
			}
		});
		btnFirstPage.setText("<<");

		Button btnPrevPage = new Button(paginationComposite, SWT.NONE);
		btnPrevPage.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				firstResult = firstResult - Main.MAX_PAGE_RESUTLS < 0 ? 0
						: firstResult - Main.MAX_PAGE_RESUTLS;
				refreshGrid();
			}
		});
		btnPrevPage.setText("<");

		Button btnNextPage = new Button(paginationComposite, SWT.NONE);
		btnNextPage.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				firstResult = firstResult + Main.MAX_PAGE_RESUTLS;
				refreshGrid();
			}
		});
		btnNextPage.setText(">");

		Button btnLastPage = new Button(paginationComposite, SWT.NONE);
		btnLastPage.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				firstResult = countResult.intValue() - Main.MAX_PAGE_RESUTLS < 0 ? 0
						: countResult.intValue() - Main.MAX_PAGE_RESUTLS;
				refreshGrid();
			}
		});
		btnLastPage.setText(">>");

		lblPage = new Label(paginationComposite, SWT.NONE);
		GridData gd_lblPage = new GridData(SWT.FILL, SWT.CENTER, true, false,
				1, 1);
		gd_lblPage.widthHint = 250;
		lblPage.setLayoutData(gd_lblPage);
		lblPage.setText("1 al 1 de 1");

		refreshGrid();
	}

	private void centerDialog() {
		Monitor primary = shlPickerFieldPopup.getDisplay().getPrimaryMonitor();
		Rectangle bounds = primary.getBounds();
		Rectangle rect = shlPickerFieldPopup.getBounds();
		int x = bounds.x + (bounds.width - rect.width) / 2;
		int y = bounds.y + (bounds.height - rect.height) / 2;
		shlPickerFieldPopup.setLocation(x, y);
	}

	private Long countQuery(EntityManager em) {
		return (Long) em.createQuery(" select count(o) from Pais o ")
				.getSingleResult();
	}

	@SuppressWarnings("unchecked")
	private void refreshGrid() {
		try {
			EntityManager em = PersistenceHelper.getEmf().createEntityManager();
			for (TableItem ti : table.getItems())
				ti.dispose();

			countResult = countQuery(em);

			lblPage.setText((firstResult + 1) + " al "
					+ (firstResult + Main.MAX_PAGE_RESUTLS) + " de "
					+ countResult);

			String queryStr = " select o from ${entityName} o ";
			String andWord = "where";

			<#if (opt.filterColumns?? && opt.filterColumns?size == 0) >
				<#list columns as column>
					<#if opt.sqlStringTypes?seq_contains(column.dataType)>
			if(!txt${opt.camelCase(column)}Filter.getText().equals("")){
				queryStr += andWord + " lower(o.${opt.mixedCase(column)}) like lower(:${opt.mixedCase(column)}) ";
				andWord = "and";
			}
					</#if>
				</#list>
			<#elseif (opt.filterColumns?? && opt.filterColumns?size > 0) >
				//Custom filters not implemented yet.. sorry :)
			</#if>

			Query q = em.createQuery(queryStr);

			<#if (opt.filterColumns?? && opt.filterColumns?size == 0) >
				<#list columns as column>
					<#if opt.sqlStringTypes?seq_contains(column.dataType)>
			if(!txt${opt.camelCase(column)}Filter.getText().equals(""))
				q.setParameter("${opt.mixedCase(column)}","%" + txt${opt.camelCase(column)}Filter.getText() + "%");
					</#if>
				</#list>
			<#elseif (opt.filterColumns?? && opt.filterColumns?size > 0) >
				//Custom filters not implemented yet.. sorry :)
			</#if>
			
			for(${entityName} p : (List<${entityName}>)q
				.setMaxResults(Main.MAX_PAGE_RESUTLS)
				.setFirstResult(firstResult)
				.getResultList()){
				tableItem = new TableItem(table, SWT.NONE);
				tableItem.setText(new String[] {
				<#assign attrname = opt.mixedCaseStr(opt.keyColumn.columnName) />
						p.get${attrname?cap_first}() == null ? null : "" + p.get${attrname?cap_first}(),
			<#assign attrNames = "" />
			<#list columns as column>
				<#if !column.primaryKey>
					<#assign itemGenerated = false />
					<#assign javatype = opt.insertJavaType(column) />
					<#assign attrname = opt.mixedCase(column) />
					<#assign attrOfattr = "">
					<#assign fk = opt.getFk(column) />
					<#if (fk?size > 0)>
						<#list tables as t>
							<#if t.tableName == fk.pktableName>
								<#assign itemGenerated = true />
								<#assign javatype = opt.camelCaseStr(fk.pktableName) />
								<#assign attrname = opt.mixedCaseStr(fk.pktableName) />
								<#assign attrOfattr = opt.camelCaseStr(fk.pkcolumnName) />
								<#list t.columns as col>
									<#if opt.sqlStringTypes?seq_contains(col.dataType)>
										<#assign attrOfattr = opt.camelCase(col) />
										<#break />
									</#if>
								</#list>
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
							"" + (p.get${attrname?cap_first}() != null ? p.get${attrname?cap_first}().get${attrOfattr}() : "")<#if opt.lastCol != column>,</#if>
					<#else>
						<#if opt.sqlDateTypes?seq_contains(column.dataType)>
								p.get${attrname?cap_first}() != null ? sdf.format(p.get${attrname?cap_first}()) : ""<#if opt.lastCol != column>,</#if>
						<#elseif opt.sqlTimestampTypes?seq_contains(column.dataType)>
								p.get${attrname?cap_first}() != null ? sdf.format(p.get${attrname?cap_first}()) : ""<#if opt.lastCol != column>,</#if>
						<#else>
								p.get${attrname?cap_first}() == null ? null : "" + p.get${attrname?cap_first}()<#if opt.lastCol != column>,</#if>
						</#if>
					</#if>
				</#if>
			</#list>
					});
			}
		} catch (Exception ex) {
			if (ex.getMessage() != null) {
				createMessageBox(ex.getMessage());
			} else {
				ex.printStackTrace();
			}
		}
	}

	private void createMessageBox(String message) {
		MessageBox ms = new MessageBox(shlPickerFieldPopup);
		ms.setMessage(message);
		ms.open();
	}

	
}
			</#if>
		</#list>
	</#if>
</#if>