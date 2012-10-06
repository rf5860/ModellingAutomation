#!/bin/sh
# Parse the arguments
if [[ $# -lt 3 || $# -gt 5 ]]; then
    # Usage Instructions
    echo "Usage: createMessage <name> <id> <type> <message> <package>";
    echo "E.g. createMessage MSTiNotClosed I0009 Information \"MSTi <{}> was not closed.\" M8MWP";
    exit 1;
else
    if [ $# -eq 4 ]; then
	# Provide a default package
	package="M8MWP";
    else
	package=$5;
    fi
    name=$1;
    id=$2;
    type=$3;
    # Escape '<' entities
    message=$(echo -e ${4//</\\&lt;});
fi
# Model fragment used for errors - WARNING: Not vigorously tested when errors /aren't/ in their own fragment.
errorClass=el_model/UMLModel/Module-8MWP/003.Design/002.Service/001.Errors.efx
# Path to this script - should contain the following files:
#                   o org.eclipse.emf.ecore.jar
#                   o org.eclipse.emf.common.jar
#                     Both of the above can be found in your IBM/SDPShared/Plugins directory (Used by RSA).
#                   o GenerateUUID.java
scriptDir="c:/Useful Stuff/code/java"
uuid=$(java -cp "$scriptDir;$scriptDir/org.eclipse.emf.ecore.jar;$scriptDir/org.eclipse.emf.common.jar" GenerateUUID);
stereotypeUuid=$(java -cp "$scriptDir;$scriptDir/org.eclipse.emf.ecore.jar;$scriptDir/org.eclipse.emf.common.jar" GenerateUUID);
xmiEnd="</xmi:XMI>";
packageEnd="  </uml:Package>";
# The new elements to insert.
newPackagedElement="    <packagedElement xmi:type=\"uml:Class\" xmi:id=\"${uuid}\" name=\"${package}_${id}_${name}\"/>";
newStereotypeElement="  <Ellipse:${type} xmi:id=\"${stereotypeUuid}\" message=\"${message}\" id=\"${package}.${id}\" base_Class=\"${uuid}\"/>";
# Insert the new elements by replacing the previous magic string
# WARNING: Stuff can go horribly wrong if any of the supplied parameters contains '@', as it will interefere with the sed separators.
# TODO: Escape '@' - similar to how '<' is escaped.
sed -i "s@${packageEnd}@${newPackagedElement}$(echo -e '\\n')${packageEnd}@g" $errorClass;
sed -i "s@${xmiEnd}@${newStereotypeElement}$(echo -e '\\n')${xmiEnd}@g" $errorClass;
