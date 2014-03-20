<#import "*/gen-options.ftl" as opt>
package ${opt.mainPackage};

import org.eclipse.swt.SWT;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Menu;
import org.eclipse.swt.widgets.MenuItem;
import org.eclipse.swt.widgets.Shell;

import ${opt.dialogsPackage}.AboutDialog;
<#list tables as t>
import ${opt.dialogsPackage}.${opt.camelCaseStr(t.tableName)}ListDialog;
</#list>

public class Main {

	public final static int MAX_PAGE_RESUTLS = 20;

	protected Shell shlMain;

	/**
	 * Launch the application.
	 * @param args
	 */
	public static void main(String[] args) {
		try {
			Main window = new Main();
			window.open();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * Open the window.
	 */
	public void open() {
		Display display = Display.getDefault();
		createContents();
		shlMain.open();
		shlMain.layout();
		while (!shlMain.isDisposed()) {
			if (!display.readAndDispatch()) {
				display.sleep();
			}
		}
	}

	/**
	 * Create contents of the window.
	 */
	protected void createContents() {
		shlMain = new Shell();
		shlMain.setSize(450, 300);
		shlMain.setText("${opt.applicationTitle}");
		shlMain.setLayout(new GridLayout(1, false));
		shlMain.setMaximized(true);
		
		Menu menu = new Menu(shlMain, SWT.BAR);
		shlMain.setMenuBar(menu);
		
		<#if opt.menuStructure??>
			<#assign index = 0 />
			<#list opt.menuStructure as menuItem>
				<#assign index = index + 1 />
				<#if menuItem?is_string>
					<#assign idx = opt.menuStructure?seq_index_of(menuItem) + 1 />
					
		MenuItem mntmSubmenu${index} = new MenuItem(menu, SWT.CASCADE);
		mntmSubmenu${index}.setText("&${menuItem}");
		
		Menu menu_${index} = new Menu(mntmSubmenu${index});
		mntmSubmenu${index}.setMenu(menu_${index});
		        
					<#list opt.menuStructure[idx] as sq>
						<#assign entityTitle = sq?replace("_", " ")?capitalize?replace(" ", "") />
						<#assign entityName = entityTitle?replace(" ", "") />
		MenuItem mntm${entityName} = new MenuItem(menu_${index}, SWT.NONE);
		mntm${entityName}.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
		        ${entityName}ListDialog d = new ${entityName}ListDialog(shlMain);
		        d.open();
			}
		});
		mntm${entityName}.setText("&${entityTitle}");
					</#list>
		    	</#if>
			</#list>
		<#else>
		MenuItem mntmNewSubmenu = new MenuItem(menu, SWT.CASCADE);
		mntmNewSubmenu.setText("&Menu");
		
		Menu menu_1 = new Menu(mntmNewSubmenu);
		mntmNewSubmenu.setMenu(menu_1);
		
			<#list tables as t>
				<#assign entityName = opt.camelCaseStr(t.tableName) />
				<#--Verificamos si la entidad posee detalles-->
				<#if opt.masterDetail??>
					<#assign index = 0/>
					<#assign valid = true/>
					<#list opt.masterDetail as entity>
						<#assign index = index + 1 />
						<#if entity?is_string>
							<#assign idx = opt.masterDetail?seq_index_of(entity) + 1 />
							<#list opt.masterDetail[idx] as detail>
								<#if detail?is_string>
									<#--entity es cada maestro-->
									<#if detail == entityName>
										<#assign valid = false/>
									</#if>
								</#if>
							</#list>		
						</#if>
					</#list>
					<#if valid>
		MenuItem mntm${entityName} = new MenuItem(menu_1, SWT.NONE);
		mntm${entityName}.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
		        ${entityName}ListDialog d = new ${entityName}ListDialog(shlMain);
		        d.open();
			}
		});
		mntm${entityName}.setText("&${t.tableName?replace("_"," ")?capitalize}");					
					</#if>
				<#else>
		MenuItem mntm${entityName} = new MenuItem(menu_1, SWT.NONE);
		mntm${entityName}.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
		        ${entityName}ListDialog d = new ${entityName}ListDialog(shlMain);
		        d.open();
			}
		});
		mntm${entityName}.setText("&${t.tableName?replace("_"," ")?capitalize}");
				</#if>	
			</#list>
		</#if>
		
		MenuItem mntmAbout = new MenuItem(menu, SWT.NONE);
		mntmAbout.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
		        AboutDialog d = new AboutDialog(shlMain);
		        d.open();
			}
		});
		mntmAbout.setText("Acerca de...");
	}
}
