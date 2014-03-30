<#import "*/gen-options.ftl" as opt>
echo "===================================================="
echo "This will replace the files of your current project."
echo "Press CTRl+C to cancel."
echo "===================================================="
echo "Press [Enter] key to start backup..."
read A
echo "*********************************"
echo "INIT"
echo "*********************************"
echo " "
echo ====================
echo Copying main classes
echo ====================
#Verificamos si existe el directorio o paquete, de lo contrario lo creamos
MAIN_PATH=${opt.mainPath?replace("\\", "/")}
if [ -d $MAIN_PATH ];
then
	echo "Already exist main..."
else
	echo "Creanting main..."
	mkdir -p $MAIN_PATH
fi
#Verificamos si existe un .bk y en caso contrario copiamos o sobreescribimos los archivos
for x in $(ls main/*.java | cut -d "." -f1); do 
	FILE=`echo $x | cut -d \/ -f2`
	BACKUP="$MAIN_PATH/$FILE.java.bk"
	if [ -f $BACKUP ];then
		echo "* Already exist $FILE.java.bk, can not be replaced."
	else
		echo "* File $FILE.java.bk does not exist, was copied and/or replaced."
		cp $x.java $MAIN_PATH
	fi
done
echo "  "
echo ========================
echo Copying entities classes
echo ========================
ENTITY_PATH=${opt.entitiesPath?replace("\\", "/")}
if [ -d $ENTITY_PATH ];then
	echo "Already exist /entity..."
else
	echo "Creanting /entity..."
	mkdir -p $ENTITY_PATH
fi
for x in $(ls entity/*.java | cut -d "." -f1); do 
	BACKUP="$MAIN_PATH/$x.java.bk"
	if [ -f $BACKUP ];then
		echo "* Already exist $x.java.bk, can not be replaced."
	else
		echo "* File $x.java.bk does not exist, was copied and/or replaced."
		cp $x.java $ENTITY_PATH
	fi
done
echo "  "
echo ======================
echo Copying dialog classes
echo ======================
DIALOG_PATH=${opt.dialogsPath?replace("\\", "/")}
if [ -d $DIALOG_PATH ];then
	echo "Already exist /dialog..."
else
	echo "Creanting /dialog..."
	mkdir -p $DIALOG_PATH
fi
for x in $(ls dialog/*.java | cut -d "." -f1); do 
	BACKUP="$MAIN_PATH/swt/$x.java.bk"
	if [ -f $BACKUP ];then
		echo "* Already exist $x.java.bk, can not be replaced."
	else
		echo "* File $x.java.bk does not exist, was copied and/or replaced."
		cp $x.java $DIALOG_PATH
	fi
done
echo "  "
echo =================================
echo Adding classes to persistence.xml
echo =================================
PERSISTENCE_PATH=${opt.projectDir?replace("\\", "/")}
FILE="$PERSISTENCE_PATH/src/META-INF/persistence.xml"
FILE_BACKUP="$FILE.bk"
#Creamos el directorio si el mismo no existe
if [ -d $PERSISTENCE_PATH/src/META-INF ];then
	echo "Already exist /src/META-INF..."
else
	echo "Creanting /src/META-INF..."
	mkdir -p $PERSISTENCE_PATH/src/META-INF
fi
#Verificamos si existe un .bk del archivo
if [ -f $FILE_BACKUP ];then
	echo "$FILE_BACKUP already exist.. skipping"
else
	if [ -f  $FILE ]; then
		echo "* File $FILE_BACKUP does not exist, was copied and/or replaced"
		cp $FILE $FILE_BACKUP
	else
		echo "* File $FILE does not exist, can not be copied"
	fi

fi
echo " "
echo "*********************************"
echo "END"
echo "*********************************"
