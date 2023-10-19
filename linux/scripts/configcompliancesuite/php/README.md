# php.ini file validity tester
## Python script for checking compliance of config files

### Sample Usage
`$ python3 src/init.py`

On failure, returns the number of checks failed.

`$ echo $?`

## Errata

Location of Config file is dependent on php version
i.e
`/etc/php/8.2/apache2/php.ini`

This script is modified from the main one to handle phps use of "="
