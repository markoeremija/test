#!/bin/bash

target_dir=/opt
cwd=`pwd`

# Password for LDAP admin
ldap_root_pw="test123";

if [ "$cwd" != "$target_dir" ]; then
   cd /opt
fi

# Untar phpLDAPadmin tar file
tar xf phpldapadmin.tar.gz

# Copy config.php file
cp config.php ./phpldapadmin/config/config.php

# Create a user named "admin" and use LDAP root password parameter
htpasswd -b -c /etc/apache2/htpasswd admin "$ldap_root_pw"

# Copy custom phpLDAPadmin configuration file to Apache conf-enabled dir
cp phpldapadmin.conf /etc/apache2/conf-enabled/phpldapadmin.conf

# Copy IdM related configuration file
cp idm.conf /etc/apache2/conf-enabled/idm.conf

chmod 644 /etc/apache2/conf-enabled/idm.conf && \
chown root:root /etc/apache2/conf-enabled/idm.conf

# Copy institution logo and change permissions
cp logo.png ./phpldapadmin/htdocs/images/default/logo-small.png

chmod 644 ./phpldapadmin/htdocs/images/default/logo-small.png && \
chown root:root ./phpldapadmin/htdocs/images/default/logo-small.png

# Copy all templates, change ownership and permissions

cp homeJavascript.js ./phpldapadmin/htdocs/js/homeJavascript.js && \
chmod 644 ./phpldapadmin/htdocs/js/homeJavascript.js && \
chown root:root ./phpldapadmin/htdocs/js/homeJavascript.js

cp formJavascript.js ./phpldapadmin/htdocs/js/formJavascript.js && \
chmod 644 ./phpldapadmin/htdocs/js/formJavascript.js && \
chown root:root ./phpldapadmin/htdocs/js/formJavascript.js

cp checkValue.php ./phpldapadmin/htdocs/checkValue.php && \
chmod 644 ./phpldapadmin/htdocs/checkValue.php && \
chown root:root ./phpldapadmin/htdocs/checkValue.php

cp lockuser.php ./phpldapadmin/htdocs/lockuser.php && \
chmod 644 ./phpldapadmin/htdocs/lockuser.php && \
chown root:root ./phpldapadmin/htdocs/lockuser.php

cp lockusers.py /etc/cron.hourly/lockusers.py && \
chmod 755 /etc/cron.hourly/lockusers.py && \
chown root:root /etc/cron.hourly/lockusers.py

cp action_lock.php ./phpldapadmin/htdocs/action_lock.php && \
chmod 644 ./phpldapadmin/htdocs/action_lock.php && \
chown root:root ./phpldapadmin/htdocs/action_lock.php

# Copy easy identity templates

cp create_idpAccount_easy.xml ./phpldapadmin/templates/creation/custom_idpAccount.xml && \
chmod 640 ./opt/phpldapadmin/templates/creation/custom_idpAccount.xml && \
chown root:www-data ./opt/phpldapadmin/templates/creation/custom_idpAccount.xml

cp modify_idpAccount_easy.xml ./phpldapadmin/templates/modification/custom_idpAccount.xml && \
chmod 640 ./opt/phpldapadmin/templates/modification/custom_idpAccount.xml && \
chown root:www-data ./phpldapadmin/templates/modification/custom_idpAccount.xml

# Copy full identity templates if easy identity templates are not present

if  ! { [ -f /opt/phpldapadmin/templates/creation/custom_idpAccount.xml ] && \
      [ -f /opt/phpldapadmin/templates/modification/custom_idpAccount.xml ]; }; then

  cp create_idpAccount.xml ./phpldapadmin/templates/creation/custom_idpAccount.xml && \
  chmod 640 ./phpldapadmin/templates/creation/custom_idpAccount.xml && \
  chown root:www-data ./phpldapadmin/templates/creation/custom_idpAccount.xml

  cp modify_idpAccount.xml ./phpldapadmin/templates/modification/custom_idpAccount.xml && \
  chmod 640 ./phpldapadmin/templates/modification/custom_idpAccount.xml && \
  chown root:www-data ./phpldapadmin/templates/modification/custom_idpAccount.xml

else
  printf "Easy IdM templates have been copied.\n"

fi

# Create "idm-tools" directory

mkdir -p -m 755 ./phpldapadmin/htdocs/idm-tools && \
cp index.php ./phpldapadmin/htdocs/idm-tools/index.php

chown root:root ./phpldapadmin/htdocs/idm-tools/index.php && \
chmod 644 ./phpldapadmin/htdocs/idm-tools/index.php

# Run apache2
