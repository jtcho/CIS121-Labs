
# -n flag accepts one character without the need
# to press `Enter`
printf "\e[36m This will remove all of the auxiliary files that LaTex generates when compiling pdfs. Are you sure you want to delete them?\e[0m\n"
read -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Cleaning up!"
    find . -name "*.aux" -type f -delete
    find . -name "*.log" -type f -delete
    find . -name "*.out" -type f -delete
    find . -name "*.pyg" -type f -delete
else
    echo "Aborting."
fi

