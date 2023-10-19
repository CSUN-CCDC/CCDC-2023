# permissions.sh
## Various Permissions checkers for *NIX like file systems

### Behavior
Currently searches all files recursively in /home/, checks if the executable bit is set for user group and others, and appends the list of files that meet this description into a file called "report"

### Usage
`$ ./src/permissions.sh`

