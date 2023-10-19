## This is a list of anything tagged "games" in dpkg-control

Created with

`$ grep-aptavail -n -F Section -s Package games > listofgames`

to uninstall all things games

`apt-get purge $(cat listofgames)`

This will remove anything tagged 'games'! 
