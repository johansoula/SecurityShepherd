 
# OWASP Security Shepherd [![OWASP Flagship](https://img.shields.io/badge/owasp-flagship%20project-48A646.svg)](https://www.owasp.org/index.php/OWASP_Project_Inventory#tab=Flagship_Projects) 
The [OWASP Security Shepherd Project](http://bit.ly/owaspSecurityShepherd) is a web application security training platform. Security Shepherd has been designed to foster and improve security awareness among a varied skill-set demographic. The aim of this project is to take AppSec novices or experienced engineers and sharpen their penetration testing skill set to security expert status.
  
# Why this repository ?

This fork was made to update the scripted setup to work automagically on Ubuntu 18.04 LTS .

Next steps:
- Fine tune CSS layout and logos
- OS hardening
- Ansible to have the same installation than the script shell installation but more "idem potent"

### Manual Setup

 ```sudo bash shepherdTotalInstall.sh ```

Modify letsencrypt.sh with your FQDN (or password if you have changed the default ones)

 ```bash letsencrypt.sh ```

### Azure Cloud Init Setup 
```
#cloud-config
package_upgrade: true
runcmd:
 - cd "/var/tmp"
 - wget https://raw.githubusercontent.com/johansoula/SecurityShepherd/master/shepherdTotalInstall.sh
 - bash shepherdTotalInstall.sh
 ``` 
### DB setup wizard
*   Hostname: ```localhost```
*   Port: ```3306```
*   DB user: ```root```
*   DB password: ```CowSaysMoo```
*   Override Database: ```Fresh Database```
*   Auth token: ```cat /var/lib/tomcat8//conf/SecurityShepherd.auth ; echo```

To login use the following credentials (you will be asked to update after login);

* username: ```admin```
* password: ```password```


# Check Official README
https://github.com/OWASP/SecurityShepherd

# Reskin Wiki
https://github.com/OWASP/SecurityShepherd/wiki/How-to-Reskin-Shepherd
