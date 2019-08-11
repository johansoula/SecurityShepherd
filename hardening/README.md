## How to use

# Install roles

```
pip install ansible
chmod 711 $PWD
#ansible-galaxy install -r requirements.yml -p .
```
# Execute playbook

```
$ ansible-playbook playbook.yml -i inventory --ask-pass --ask-become-pass

$  ansible-playbook playbook.yml -i inventory --ask-pass --ask-become-pass  --vault-password-file group_vars/vault.txt 
```
