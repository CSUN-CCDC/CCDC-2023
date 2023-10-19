echo -e "apache\n"
python3 ../apache/src/init.py
echo -e '\n'
echo -e "logindefs\n"
python3 ../logindefs/src/init.py
echo -e '\n'
echo -e "sshd\n"
python3 ../sshd/src/init.py
echo -e '\n'
echo -e "pam\n"
python3 ../pam/src/init.py
echo -e '\n'
echo -e "php\n"
python3 ../php/src/init.py
echo -e '\n'
