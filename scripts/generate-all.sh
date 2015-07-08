
printf "\e[31m[WARNING]\e[36m This script generates all modules located inside the \e[32mmodule\e[36m folder as individual PDF files. It will override any files in this directory that have the same name, as well as override files in the \e[32mdist\e[36m directory. Do you want to continue? \e[33m[y/n]\e[36m\n"
read -p "> " -n 1 -r
printf "\n\n"
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    printf "Aborting...\n\e[0m"
    exit 0
fi

printf "Generating \e[32mcompendium\e[36m PDF.\n"
xelatex --shell-escape compendium.tex > /dev/null

if [[ ! -f compendium.pdf ]]
then
    printf "\e[31m[ERROR]\e[36m Encountered error generating \e[32mcompendium\e[36m PDF. See log for details.\n"
else
    echo "Cleaning..."
    mv compendium.pdf dist/
    rm_extensions=(.out .aux .log .pyg)
    for ext in "${rm_extensions[@]}"; do
        if [[ -f compendium$ext ]]
        then
            rm compendium$ext
        fi
    done
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
        printf "Generating \e[32m$module_name\e[36m as a standalone PDF.\n"
        sed -e "s;%MODULE%;$module_name;g" module_template > $module_name.tex
        xelatex --shell-escape $module_name.tex >/dev/null
        if [[ ! -f $module_name.pdf ]]
        then
            printf "\e[31m[ERROR]\e[36m Encountered error generating PDF for \e[32m$module_name\e[36m. See log for details.\n"
        else
            mv $module_name.pdf dist/
            echo "Cleaning..."
            rm $module_name.tex
            for ext in "${rm_extensions[@]}"; do
                if [[ -f $module_name$ext ]]
                then
                rm $module_name$ext
                fi
            done
        fi
    fi
done

printf "Done! Check your \e[33mdist\e[36m folder for the outputted PDFs. If there were any errors, try generating the file individually.\n"

printf "\e[0m"
