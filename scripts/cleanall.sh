
# -n flag accepts one character without the need
# to press `Enter`
printf "\e[31m[WARNING]\e[36m This will remove all files that LaTex generates when compiling pdfs. Are you sure you want to delete them? \e[33m[y/n]\e[36m\n"
read -p "> " -n 1 -r
printf "\n\n"
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Cleaning up!"
    find . -name "*.aux" -type f -delete
    find . -name "*.log" -type f -delete
    find . -name "*.out" -type f -delete
    find . -name "*.pyg" -type f -delete
    find . ! -path "./dist/*" -name "*.pdf" -type f -delete
else
    echo "Aborting."
fi
printf "\e[0m"

