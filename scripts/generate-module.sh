
printf "\e[36m What lab module would you like to generate?\n"
read -p "> " -e -r
printf "\n"
if [[ -d modules/$REPLY ]]
then
    MODULE_NAME=$REPLY
    
    rm_extensions=(.out .aux .log .pyg)

    if [[ ! -f modules/$MODULE_NAME/partial.tex ]]
    then
        printf "\e[31m[WARNING]\e[36m A malformed module directory was provided. Missing \e[31mpartial.tex\e[0m.\n"
        exit 0
    fi

    if [[ -f $MODULE_NAME.tex || -f $MODULE_NAME.pdf ]]
    then
        printf "\e[31m[WARNING]\e[36m By running this script you will override existing files. Are you sure you want to continue? \e[33m[y/n]\e[36m\n"
        read -p "> " -n 1 -r
        printf "\n\n"
        if [[ ! $REPLY =~ ^[Yy]$ ]]
        then
            echo "Aborting."
            printf "\e[0m"
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
    mv $MODULE_NAME.pdf dist/

    printf "\nAll finished! Check your \e[33mdist\e[36m folder for the output PDF. The output log and misc. files can be found in the \e[33mlogs\e[36m directory.\n"
else
    echo "This module does not exist! Check your modules folder."
fi
printf "\e[0m"

