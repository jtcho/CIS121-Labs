
if hash convert 2>/dev/null; then
    for f in $(find ./ -type f -name "*.png")
    do
        echo "Processing image $f..."
        convert $f -strip $f
    done
else
    echo "Error: You do not have ImageMagick's command line tools installed. Please see http://www.imagemagick.org/script/command-line-tools.php for installation instructions."
fi
