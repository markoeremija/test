# OpenLDAP Dockerfile

This is the OpenLDAP Dockerfile produced by JRA3T1 task within GÉANT4 project. It resembles the Ansible
recipe for OpenLDAP (https://github.com/GEANT/ansible-shibboleth/tree/master/roles/openldap),
also produced by JRA3T1 (contact: marco.malavolti [at] gmail.com).
This Dockerfile is based on using the well-known schemas for R&E community (eduPerson and schac).
It also contains password policy and memberOf overlay configuration.

# Volumes 

The MDB file with user data is mapped on a **local** volume, because primary idea of Docker is to be
used for **stateless** data. This way, when a container is stopped (or removed) the MDB file is
saved and can be migrated or used with another container.

The same applies for log files. They are mapped *locally*.

So, to better understand where mutable files are actually kept, take a look at this table.

| Local file system             | Container               |
| :---------------------------- | :---------------------- |
| /var/tmp/docker-logs-openldap | /var/log/slapd          |
| /usr/local/var/openldap-data  | /var/lib/ldap           |

This means that log files are created in the container but are changed only on the local file system.
MDB file can also be found on a local hard drive, but is presented to the container. Both of the files
can be accessed from the inside of the container, but physically exist only on the local file system.
