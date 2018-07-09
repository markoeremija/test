# phpLDAPadmin Dockerfile

This is the phpLDAPadmin Dockerfile produced by JRA3T1 task within GÉANT4 project. It resembles the Ansible
recipe for phpLDAPadmin (https://github.com/GEANT/ansible-shibboleth/tree/master/roles/phpldapadmin),
also produced by JRA3T1 (contact: marco.malavolti [at] gmail.com).
This Dockerfile is based on using the well-known .

# Prerequisites

In order to be able to fully utilize the phpLDAPadmin Dockerfile, there has to exist an OpenLDAP container. The
reason for this is because entrypoint script is using some of the configuration files that belongs to the (local) volume
that is shared between OpenLDAP and phpLDAPadmin containers. This is especially important in case you are using a
CA certificate authority that you created. If it's not among the well-known ones, it must be added to the CA certificate
chain on Linux. That is done by using "update-ca-certificates" script that comes with the package of the same name.

**Note: When importing the custom CA certificate, it has to have .crt extension, otherwise it will not be added to the chain and
you will not be able to establish a TLS connection between OpenLDAP and phpLDAPadmin containers.**

Using **VOLUME** keyword in Dockerfile means that if the files you are trying are already present, then the copying inside Dockerfile
is omitted for the files that have the same name, e.g.:

`VOLUME [/root/ldap-configs/]`

will provide all the configuration files from that particular directory inside the container to be accessible even after the container has
been brought down, if it is paired with `--mount source=backup,destination=/root/ldap-configs`.
Likewise, when starting the container again, it will first look for the files inside the backup
directory and copy them only if they are not present. This enables faster container deployment.

If you are not using a custom Root CA certificate, then you need to modify the entrypoint script to best represent what you are using. All of the
major Root CA certificates should be present on the operating system (e.g. DigiCertAssuredRootID CA). If that is the case, then you should remove
the following lines from the entrypoint.sh script:

```
cp /opt/phpldapadmin/config/cacert.pem /usr/local/share/ca-certificates/cacert.crt && \
cd /usr/local/share/ca-certificates/ && \
/usr/sbin/update-ca-certificates
```

As phpLDAPadmin is acting as an LDAP client in this case, it is relying on the configuration from ldap.conf. Since the default ldap.conf file has only one line commented out (TLS_CACERT), and it references the file `ca-certificates`, which, as it was already mentioned, uses the complete chain of all well-known Root CA certificates, nothing has to be changed and the default LDAP client configuration file can be used:

```
TLS_CACERT      /etc/ssl/certs/ca-certificates.crt
```

# Todo

As the idea is to enable as much configuration to be dynamically created as possible, the future work is going to focus on creating a custom Root CA file. This should be done because it provides more security and, at the same time, protects communication between OpenLDAP and phpLDAPadmin containers. In order to make building of the custom Docker images even faster and more transparent, a Docker Compose file will be created. 

## Volumes

| Local file system              | phpLDAPadmin Container     | OpenLDAP Container   |
| :----------------------------- | :------------------------- | :------------------- |
| /var/lib/docker/volumes/backup | /opt/phpldapadmin/config   | /root/ldap-configs/  |
| /var/lib/docker/volumes/logs   | N/A                        | /var/log/slapd/      |
