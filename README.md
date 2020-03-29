# ansible-docker
## Ansible Docker container with Molecule

Based on Python 3.8 on Alpine, Ansible and Molecule installed with passlib for password generation.


Current versions

* Python 3.8.2
* Alpine 3.11
* Ansible 2.9.6
* Molecule 3.0.2
* Passlib (latest)


Volume

* /data/ansible (base directory)


Ansible directory structure (prefined with ENV variables)
Based on the Ansible recommended directory layout.
https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html#alternative-directory-layout


```
inventories/
   production/
      hosts               # inventory file for production servers
      group_vars/
         group1.yml       # here we assign variables to particular groups
         group2.yml
      host_vars/
         hostname1.yml    # here we assign variables to particular systems
         hostname2.yml

   staging/
      hosts               # inventory file for staging environment
      group_vars/
         group1.yml       # here we assign variables to particular groups
         group2.yml
      host_vars/
         stagehost1.yml   # here we assign variables to particular systems
         stagehost2.yml

library/
module_utils/
filter_plugins/

site.yml
webservers.yml
dbservers.yml

roles/
    common/
    webtier/
    monitoring/
    fooapp/
```
