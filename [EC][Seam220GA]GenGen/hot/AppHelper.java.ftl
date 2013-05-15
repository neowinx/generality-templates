<#import "*/gen-options.ftl" as opt>
package ${opt.hotPackage};

import org.jboss.seam.contexts.Context;

public class AppHelper {

	public static void removeFromContext(String contextVarName, Context context) {
		if(context.isSet(contextVarName))
			context.remove(contextVarName);
	}

	public static String removeFromContext(String value, String outcome, String contextVarName, Context context) {
		if(outcome.equals(value) && context.isSet(contextVarName))
			context.remove(contextVarName);
		return outcome;
	}
	
	public static String removeFromContext(String value, String outcome, String[] contextVarNames, Context context) {
		if(outcome.equals(value)){
			for(String contextVarName : contextVarNames){
				if(context.isSet(contextVarName))
					context.remove(contextVarName);
			}
		}
		return outcome;
	}
	
	public static String removeFromContext(String value, String outcome, String[] contextVarNames, Context[] contexts) {
		for(Context c : contexts)
			removeFromContext(value, outcome, contextVarNames, c);
		return outcome;
	}
}
