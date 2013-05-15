<#import "*/gen-options.ftl" as opt />
<#if (!opt.keyColumn??)>
//ESTE TEMPLATE SOLO MANEJA TABLAS CON PRIMARY KEYS DEFINIDOS
<#else>
<#assign entityName = opt.camelCaseStr(tableName) />
package ${opt.dialogsPackage};

import java.text.SimpleDateFormat;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.Persistence;
import javax.persistence.Query;

import org.eclipse.swt.widgets.Dialog;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Display;
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

public class ${entityName}ListDialog extends Dialog {

	protected Object result;
	protected Shell shl${entityName};
	private Table table;
	private TableItem tableItem;
	private Button btnNuevo;
	private Composite buttonsComposite;
	
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

	/**
	 * Create the dialog.
	 * @param parent
	 * @param style
	 */
	public ${entityName}ListDialog(Shell parent) {
		super(parent);
		setText("${entityName}ListDialog");
	}

	/**
	 * Open the dialog.
	 * @return the result
	 */
	public Object open() {
		createContents();
		shl${entityName}.open();
		shl${entityName}.layout();
		Display display = getParent().getDisplay();
		while (!shl${entityName}.isDisposed()) {
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
		shl${entityName} = new Shell(getParent(), SWT.SHELL_TRIM | SWT.BORDER);
		shl${entityName}.setSize(450, 300);
		shl${entityName}.setText("${tableName?replace("_"," ")?capitalize}");
		shl${entityName}.setLayout(new GridLayout(1, false));
		centerDialog();
		shl${entityName}.setMaximized(true);
		
		<#if (opt.filterColumns?? && opt.filterColumns?size == 0) >
		Composite filtersComposite = new Composite(shl${entityName}, SWT.NONE);
		filtersComposite.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, false, false, 1, 1));
		filtersComposite.setLayout(new GridLayout(2, false));
			<#list columns as column>
				<#if opt.sqlStringTypes?seq_contains(column.dataType)>
					<#assign camelCaseCol = opt.camelCase(column) />
					<#assign labelCol = column.columnName?replace("_"," ")?capitalize />
		Label lbl${camelCaseCol} = new Label(filtersComposite, SWT.NONE);
		lbl${camelCaseCol}.setText("${labelCol}");
		
		txt${camelCaseCol}Filter = new Text(filtersComposite, SWT.BORDER);
		txt${camelCaseCol}Filter.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, false, 1, 1));
				</#if>
			</#list>
		Button btnBuscar = new Button(filtersComposite, SWT.NONE);
		btnBuscar.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				refreshGrid();
			}
		});
		btnBuscar.setText("&Buscar");
		
		shl${entityName}.setDefaultButton(btnBuscar);
		new Label(filtersComposite, SWT.NONE);
		<#elseif (opt.filterColumns?? && opt.filterColumns?size > 0) >
		//Custom filters not implemented yet.. sorry :)
		</#if>
		
		table = new Table(shl${entityName}, SWT.BORDER | SWT.FULL_SELECTION);
		table.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent e) {
				if(e.character == SWT.CR)
					edit();
			}
		});
		table.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseDoubleClick(MouseEvent e) {
				edit();
			}
		});
		table.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true, 1, 1));
		table.setHeaderVisible(true);
		table.setLinesVisible(true);
		<#list columns as column>
		TableColumn tblclmn${opt.camelCase(column)} = new TableColumn(table, SWT.NONE);
		tblclmn${opt.camelCase(column)}.setWidth(100);
			<#assign label = column.columnName?replace("_"," ")?capitalize />
			<#if !column.primaryKey>
				<#assign fk = opt.getFk(column) />
				<#if (fk?size > 0)>
					<#list tables as t>
						<#if t.tableName == fk.pktableName>
							<#assign label = fk.pktableName?replace("_"," ")?capitalize />
							<#break />
						</#if>
					</#list>
				</#if>
			</#if>
		tblclmn${opt.camelCase(column)}.setText("${label}");		
		</#list>
		
		buttonsComposite = new Composite(shl${entityName}, SWT.NONE);
		buttonsComposite.setLayoutData(new GridData(SWT.CENTER, SWT.CENTER, false, false, 1, 1));
		buttonsComposite.setLayout(new GridLayout(4, false));
		
		btnNuevo = new Button(buttonsComposite, SWT.NONE);
		btnNuevo.setSize(43, 23);
		btnNuevo.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				${entityName}EditDialog ed = new ${entityName}EditDialog(shl${entityName});
				${entityName} o = ed.open();
				if(o != null)
					refreshGrid();
			}
		});
		btnNuevo.setText("&Nuevo");
		
		Button btnEditar = new Button(buttonsComposite, SWT.NONE);
		btnEditar.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				edit();
			}
		});
		btnEditar.setBounds(0, 0, 68, 23);
		btnEditar.setText("&Editar");
		
		Button btnBorrar = new Button(buttonsComposite, SWT.NONE);
		btnBorrar.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				if(table.getSelection().length > 0){
					try{
						EntityManager em = PersistenceHelper.getEmf().createEntityManager();
						em.getTransaction().begin();
						em.remove(em.find(${entityName}.class, new ${opt.insertJavaType(opt.keyColumn)}(table.getSelection()[0].getText(0))));
						em.getTransaction().commit();
						em.close();
						refreshGrid();
					}catch(Exception ex){
						MessageBox ms = new MessageBox(shl${entityName});
						ms.setMessage(ex.getMessage());
						ms.open();
					}
				}
			}
		});
		btnBorrar.setText("&Borrar");
		
		Composite paginationComposite = new Composite(buttonsComposite, SWT.NONE);
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
				firstResult = firstResult - Main.MAX_PAGE_RESUTLS < 0 ? 0 : firstResult - Main.MAX_PAGE_RESUTLS;
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
				firstResult = countResult.intValue() - Main.MAX_PAGE_RESUTLS < 0 ? 0 : countResult.intValue() - Main.MAX_PAGE_RESUTLS;
				refreshGrid();
			}
		});
		btnLastPage.setText(">>");
		
		lblPage = new Label(paginationComposite, SWT.NONE);
		GridData gd_lblPage = new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1);
		gd_lblPage.widthHint = 250;
		lblPage.setLayoutData(gd_lblPage);
		lblPage.setText("1 al 1 de 1");
		
		refreshGrid();
	}
	
	private void edit() {
		if(table.getSelection().length > 0){
			try{
				EntityManager em = PersistenceHelper.getEmf().createEntityManager();
				${entityName}EditDialog ed = new ${entityName}EditDialog(shl${entityName}, em.find(${entityName}.class, new ${opt.insertJavaType(opt.keyColumn)}(table.getSelection()[0].getText(0))));
				${entityName} o = ed.open();
				if(o != null)
					refreshGrid();
			}catch(Exception ex){
				MessageBox ms = new MessageBox(shl${entityName});
				ms.setMessage(ex.getMessage());
				ms.open();
			}
		}
	}
	
	private void centerDialog() {
		Monitor primary = shl${entityName}.getDisplay().getPrimaryMonitor();
		Rectangle bounds = primary.getBounds ();
		Rectangle rect = shl${entityName}.getBounds ();
		int x = bounds.x + (bounds.width - rect.width) / 2;
		int y = bounds.y + (bounds.height - rect.height) / 2;
		shl${entityName}.setLocation (x, y);
	}

	@SuppressWarnings("unchecked")
	private void refreshGrid() {
		try{
			EntityManager em = PersistenceHelper.getEmf().createEntityManager();
			SimpleDateFormat sdf = (SimpleDateFormat)SimpleDateFormat.getInstance();
			sdf.applyPattern("dd/MM/yyyy");
			for(TableItem ti : table.getItems())
				ti.dispose();
				
			countResult = countQuery(em);
			
			lblPage.setText((firstResult+1) + " al " + (firstResult + Main.MAX_PAGE_RESUTLS) + " de " + countResult);
			
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
			<#assign attrNames = "" />
			<#list columns as column>
				<#assign itemGenerated = false />
				<#assign javatype = opt.insertJavaType(column) />
				<#assign attrname = opt.mixedCase(column) />
				<#assign attrOfattr = "">
				<#if !column.primaryKey>
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
			</#list>
					});
			}
		}catch(Exception ex){
			if(ex.getMessage() != null){
				MessageBox ms = new MessageBox(shl${entityName});
				ms.setMessage(ex.getMessage());
				ms.open();
			}else {
				ex.printStackTrace();
			}
		}
	}
	
	private Long countQuery(EntityManager em){
		return (Long)em.createQuery(" select count(o) from ${entityName} o ").getSingleResult();
	}
}
</#if>