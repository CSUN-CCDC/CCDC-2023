This is the "nonotools" list.

Created by looking at the Kali Linux metapackages, using this command:

`apt-cache depends METAPACKAGE | grep Depends | awk '{print $2}' | tee output-file`


To uninstall any installed "nonotools" on Debian based distros:

`apt-get purge $(cat nonotools)`

This will remove any of these tools, if they are installed. Beware, this is not trustworthy though, it's possible for a "hacker" tool to not be in the Kali linux repo's. This just catches the low hanging fruit all in one go. 
