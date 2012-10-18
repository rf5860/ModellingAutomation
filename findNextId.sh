#!/bin/sh
# Parse the arguments
if [[ $# -gt 2 || $# -lt 1 ]]; then
    # Usage Instructions
    echo "Usage: findNextId <type> [<package>]";
    echo "E.g.  findNextId Information";
    exit 1;
else
    if [ $# -eq 1 ]; then
	# Provide a default package
	package="M8MWP";
    else
	package=$2;
    fi
    type=$1;
fi
errorClass=el_model/UMLModel/Module-8MWP/003.Design/002.Service/001.Errors.efx
scriptDir="c:/Useful Stuff/code/java"
IFS=$'\n';
# Look for error classes, and extract their ids.
ids=( $(grep -i Ellipse:$type $errorClass|grep id) );
# Hide my shame - don't look at this.
# Iterate through the found id's
lastId=$(for id in "${ids[@]}"
do
    # Only match if item is in the desired package.
    if [[ $id == *${package}.${type:0:1}* ]]; then
	# Extract the id from the current line.
	idStartPosition=$(expr $(awk -v a=$id -v b=" id=" 'BEGIN{print index(a,b)}') + 10);
	echo ${id:idStartPosition:5};
    fi
done|sort|tail -1);
nextIdNumber=$(printf %04d $(expr ${lastId:1} + 1));
echo ${type:0:1}$nextIdNumber;
