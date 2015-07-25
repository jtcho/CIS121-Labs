#!/bin/bash

ERR_COL="\e[31m"
MSG_COL="\e[36m"
MIS_COL="\e[32m"
CON_COL="\e[33m"
RES_COL="\e[0m"

# Needs testing on a Linux machine. OSX appears
# to run fine even if the script is invoked
# via `sh`.
if [ ! "$BASH_VERSION" ] ; then
    printf "${ERR_COL}[Error] ${MSG_COL}Please do not use sh or some other shell to run this script ($0), execute it directly!\n${RES_COL}" 1>&2
    exit 1
fi

if ! hash xelatex 2>/dev/null; then
    printf "${ERR_COL}[Error] ${MSG_COL}You do not appear to have XeLaTeX installed and in your path. Have you installed TeX Live?\n${RES_COL}"
    exit 1
fi

# Nifty way of getting directory of script.
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Jump to `modules` directory for tab 
# autocompletion.
pushd $DIR/../modules

printf "${MSG_COL}What lab module would you like to generate?\n"
read -p "> " -e -r
printf "\n"

# Return to original directory.
popd

# Because we allow autocomplete of directories,
# we need to trim off any '/' characters.
REPLY="${REPLY//\/}"

if [[ -d modules/$REPLY ]]
then
    MODULE_NAME=$REPLY
    
    rm_extensions=(.out .aux .log .pyg)

    if [[ ! -f modules/$MODULE_NAME/partial.tex ]]
    then
        printf "${ERR_COL}[WARNING]${MSG_COL} A malformed module directory was provided. Missing ${MIS_COL}mpartial.tex${RES_COL}.\n"
        exit 0
    fi

    if [[ -f $MODULE_NAME.tex || -f $MODULE_NAME.pdf ]]
    then
        printf "${ERR_COL}[WARNING]${MSG_COL} By running this script you will override existing files. Are you sure you want to continue? ${CON_COL}[y/n]${MSG_COL}\n"
        read -p "> " -n 1 -r
        printf "\n\n"
        if [[ ! $REPLY =~ ^[Yy]$ ]]
        then
            echo "Aborting."
            printf "${RES_COL}"
            exit 0
        fi
    fi
    echo "Generating \`$MODULE_NAME\` as a standalone PDF."
    sed -e "s;%MODULE%;$MODULE_NAME;g" module_template > $MODULE_NAME.tex
    xelatex --shell-escape $MODULE_NAME.tex

    for ext in "${rm_extensions[@]}"; do
        if [[ -f $MODULE_NAME$ext ]]
        then
            mv $MODULE_NAME$ext logs/
        fi
    done

    rm $MODULE_NAME.tex
    rm -f $MODULE_NAME.listing
    rm -f modules/$MODULE_NAME/*.aux
    mv $MODULE_NAME.pdf dist/

    printf "\nAll finished! Check your ${MIS_COL}mdist${MSG_COL} folder for the output PDF. The output log and misc. files can be found in the ${MIS_COL}logs${MSG_COL} directory.\n"
else
    echo "This module does not exist! Check your modules folder."
fi
printf "${RES_COL}"

