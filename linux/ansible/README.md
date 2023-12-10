Here is where I'm going to make ansible playbooks to run, to configure things like pamd.



I currently have some stuff done. To run it (I only tested it in an ubuntu docker container): 

with the ansible directory of this repo as your working directory:

`ansible-playbook --inventory inventory/ playbook.yaml`






The ansible modules I am looking at are:


Sudoers:

<https://docs.ansible.com/ansible/latest/collections/community/general/sudoers_module.html>

However, I don't like the declarative nature of this, becuase it might not catch that a user has permissions in sudoers that they shouldn't. It may be better to just look at the sudoers file(s), and edit them.


Pamd:

<https://docs.ansible.com/ansible/latest/collections/community/general/pamd_module.html>

This one looks to be pretty good, especially if we can find a playbook online already.


Sshd:

<https://github.com/willshersystems/ansible-sshd>

Third party, but seems to be pretty good. 


Login_defs:

There exist a ton of third party/community roles to configure login_defs, but no official one, so I need to do some research:


<https://github.com/neoloc/ansible-role-logindefs> 

<https://github.com/amtega/ansible_role_login_defs>

<https://github.com/jtyr/ansible-login_defs>: last commit 4 years ago.... ?