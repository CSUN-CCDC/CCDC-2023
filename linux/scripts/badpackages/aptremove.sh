while read package; do
    sudo apt-get remove -y "$package"
done < packages-to-remove.txt