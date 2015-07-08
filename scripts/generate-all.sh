
printf "\e[31m[WARNING]\e[36m This script generates all modules located inside the \e[32mmodule\e[36m folder as individual PDF files. It will override any files in this directory that have the same name, as well as override files in the \e[32mdist\e[36m directory. Do you want to continue? \e[33m[y/n]\e[36m\n"
read -p "> " -n 1 -r
printf "\n\n"
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    printf "Aborting...\n\e[0m"
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

printf "Generating \e[32mcompendium\e[36m PDF."
xelatex --shell-escape compendium.tex > /dev/null
printf "."

if [[ ! -f compendium.pdf ]]
then
    printf "...\e[31m[ERROR]\e[36m \n"
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
        printf "\e[31m[WARNING]\e[36m Module \e[32m$module_name\e[36m is missing a partial.tex file. Skipping...\n"
    else
        printf "Generating \e[32m$module_name\e[36m as a standalone PDF."
        sed -e "s;%MODULE%;$module_name;g" module_template > $module_name.tex
        printf "."
        xelatex --shell-escape $module_name.tex >/dev/null
        printf "."
        if [[ ! -f $module_name.pdf ]]
        then
            printf "\e[31m[ERROR]\e[36m\n"
        else
            mv $module_name.pdf dist/
            rm $module_name.tex
            for ext in "${rm_extensions[@]}"; do
                printf "."
                if [[ -f $module_name$ext ]]
                then
                    mv $module_name$ext logs/
                fi
            done
            printf "Done!\n"
        fi
    fi
done

printf "\nAll finished! Check your \e[33mdist\e[36m folder for the outputted PDFs. All output logs and miscellaneous files can be found in the \e[33mlogs\e[36m directory.\n"

printf "\e[0m"
