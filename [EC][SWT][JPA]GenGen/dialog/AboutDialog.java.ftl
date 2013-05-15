<#import "*/gen-options.ftl" as opt>
package ${opt.dialogsPackage};

import org.eclipse.swt.widgets.Dialog;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.custom.StyledText;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.layout.GridData;

public class AboutDialog extends Dialog {

	protected Object result;
	protected Shell shlAcercaDeSisre;

	/**
	 * Create the dialog.
	 * @param parent
	 * @param style
	 */
	public AboutDialog(Shell parent) {
		super(parent);
		setText("SWT Dialog");
	}

	/**
	 * Open the dialog.
	 * @return the result
	 */
	public Object open() {
		createContents();
		shlAcercaDeSisre.open();
		shlAcercaDeSisre.layout();
		Display display = getParent().getDisplay();
		while (!shlAcercaDeSisre.isDisposed()) {
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
		shlAcercaDeSisre = new Shell(getParent(), SWT.DIALOG_TRIM | SWT.PRIMARY_MODAL);
		shlAcercaDeSisre.setSize(450, 300);
		shlAcercaDeSisre.setText("Acerca de ${opt.projectName}");
		shlAcercaDeSisre.setLayout(new GridLayout(1, false));
		
		StyledText styledText = new StyledText(shlAcercaDeSisre, SWT.BORDER);
		styledText.setEditable(false);
		styledText.setText("${opt.aboutDialogText}");
		styledText.setDoubleClickEnabled(false);
		styledText.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true, 1, 1));
	}

}
