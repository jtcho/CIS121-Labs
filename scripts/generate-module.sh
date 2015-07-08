
printf "\e[36m What lab module would you like to generate?\n"
read -p "> " -e -r
printf "\n"
if [[ -f modules/$REPLY/full.tex ]]
then
    MODULE_NAME=$REPLY
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
    sed -e "s;%MODULE%;$MODULE_NAME;g" full_template > $MODULE_NAME.tex
    xelatex --shell-escape $MODULE_NAME.tex
    echo "Cleaning up..."
    rm $MODULE_NAME.tex
else
    echo "This module does not exist! Check your modules folder."
fi
printf "\e[0m"

