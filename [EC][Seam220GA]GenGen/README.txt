========================================
Seam 2.2.0 GA Generic Entities Generator
========================================

Generates entities for a jboss-seam 2.2.0 GA with all the necessary assets
to start programming teh application.

Requeriments
============
- ALL tables needs to have single column PKs. (NO EXCEPTIONS)
- A generated jboss-seam 2.2.0 GA project using the JBoss Tools plug-in for eclipse. 

Optional Requeriments
=====================
- In case of the automatic generation of sequence, the sequences NEED to have this pattern:
  [TABLENAME]_[PKCOLUMNNAME]_seq
  Where [TABLENAME] is the name of the table and [PKCOLUMNNAME] is the name of the primary column.

Instructions
============
Modify the values of gen-options.opt according to your settings.
Right click in the project [EC][Seam220GA]GenGen and select "Run Template".
After the generation of the files, execute 'deploy.bat' to copy all files to their corresponding
directories and modify the neccesary files in the Seam 2.2.0 GA project.

Enjoy :D

Pedro Flores