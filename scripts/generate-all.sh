#!/bin/bash
# trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

ERR_COL="\e[31m"
MSG_COL="\e[36m"
MIS_COL="\e[33m"
CON_COL="\e[32m"
RES_COL="\e[0m"

printf "${ERR_COL}[WARNING]${MSG_COL} This script generates all modules located inside the ${MIS_COL}module${MSG_COL} folder as individual PDF files. It will override any files in this directory that have the same name, as well as override files in the ${MIS_COL}dist${MSG_COL} directory. Do you want to continue? ${CON_COL}[y/n]${MSG_COL}\n"
read -p "> "
printf "\n\n"
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    printf "Aborting...\n${RES_COL}"
    exit 0
fi

#
if [[ ! -d dist ]]
then
    mkdir dist
fi
if [[ ! -d logs ]]
then
    mkdir logs
fi

rm_extensions=(.out .aux .log .pyg)

printf "Generating ${MIS_COL}compendium${MSG_COL} PDF."
pdflatex --shell-escape compendium.tex
printf "."

if [[ ! -f compendium.pdf ]]
then
    printf "...${ERR_COL}[ERROR]${MSG_COL} \n"
else
    mv compendium.pdf dist/
    for ext in "${rm_extensions[@]}"; do
        printf "."
        if [[ -f compendium$ext ]]
        then
            mv compendium$ext logs/
        fi
    done
    printf "Done!\n"
fi


# Allow handling of empty modules directory.
shopt -s extglob nullglob

modules=("modules"/*)
for module in "${modules[@]}"; do
    module_name=${module:8:${#module}-8}
    if [[ ! -f modules/$module_name/partial.tex ]]
    then
        printf "${ERR_COL}[WARNING]${MSG_COL} Module ${MIS_COL}$module_name${MSG_COL} is missing a partial.tex file. Skipping...\n"
    else
        printf "Generating ${MIS_COL}$module_name${MSG_COL} as a standalone PDF."
        sed -e "s;%MODULE%;$module_name;g" module_template > $module_name.tex
        printf "."
        pdflatex --shell-escape $module_name.tex
        printf "."
        if [[ ! -f $module_name.pdf ]]
        then
            printf "${ERR_COL}[ERROR]${MSG_COL}\n"
        else
            mv $module_name.pdf dist/
            rm $module_name.tex
            rm -f $module_name.listing
            rm -f modules/$module_name/*.aux
            for ext in "${rm_extensions[@]}"; do
                printf "."
                if [[ -f $module_name$ext ]]
                then
                    mv $module_name$ext logs/
                fi
                if [[ -f modules/$module_name/$module_name$ext ]]
                then
                    mv modules/$module_name/$module_name$ext logs/
                fi
            done
            printf "Done!\n"
        fi
    fi
done

printf "\nAll finished! Check your ${MIS_COL}dist${MSG_COL} folder for the outputted PDFs. All output logs and miscellaneous files can be found in the ${MIS_COL}logs${MSG_COL} directory.\n"

printf "${RES_COL}"
