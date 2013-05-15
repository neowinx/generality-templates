<#import "*/gen-options.ftl" as opt>
package ${opt.mainPackage};
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

public class PersistenceHelper {
	
	private static EntityManagerFactory emf;

	public static EntityManagerFactory getEmf() {
		if(emf == null)
			emf = generateEntityManagerFactory();
		return emf;
	}

	private static EntityManagerFactory generateEntityManagerFactory() {
		return Persistence.createEntityManagerFactory("${opt.projectName}");
	}

	public static void setEmf(EntityManagerFactory emf) {
		PersistenceHelper.emf = emf;
	}

}
