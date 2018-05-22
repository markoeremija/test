#!/bin/bash

_target_dir=/root/ldap-configs
_cwd=`pwd`
_domain="amres.ac.rs"
_organization=AMRES
_hostname=`hostname`
_fqdn="`hostname`.${_domain}"


# Check if the current working directory matches the targeted directory
if [ "${_cwd}" != "${_target_dir}" ]; then
   cd /root/ldap-configs
fi

# Reconfigure defaults
printf "=============================\n"
printf "| Reconfiguring defaults... |\n"
printf "=============================\n"
printf "\n"

################################################################################
#
# This part of the script is used to extract the domain part for creating LDAP
# configuration. The institution has to provide a valid domain name. After that,
# using "sed" should enable to replace the default organization DN in all places.
#
################################################################################

dc_arr=($(echo ${_domain}| tr "." "\n"))

length=${#dc_arr[@]}

for ((i=0; i<$length; i++))
do
#  printf "dc="${dc_arr[i]}"\n"
  if (( $i < $length - 1 )); then
    dc=$dc"dc=${dc_arr[i]},"
  else
    dc=$dc"dc=${dc_arr[i]}"
  fi
done

_dn="dn: "$dc

printf "The complete dn is: ${_dn}\n"

# Replace all occurencies of dc=example,dc=org with the correct dn

find ./ -name "*.ldif" | xargs sed -i  's/dc\=example,dc\=org/'"${dc}"'/g'

################################################################################

deb_conf=$( debconf-get-selections | grep -q -s slapd; echo $? )

if [ $deb_conf ]; then
   echo "slapd slapd/password1 password" | debconf-set-selections && \
   echo "slapd slapd/password2 password" | debconf-set-selections && \
   echo "slapd slapd/move_old_database boolean true" | debconf-set-selections && \
   echo "slapd slapd/domain string "${_domain}"" | debconf-set-selections && \
   echo "slapd shared/organization string "${_organization}"" | debconf-set-selections && \
   echo "slapd slapd/no_configuration boolean false" | debconf-set-selections && \
   echo "slapd slapd/purge_database boolean false" | debconf-set-selections && \
   echo "slapd slapd/allow_ldap_v2 boolean false" | debconf-set-selections && \
   echo "slapd slapd/backend select MDB" | debconf-set-selections
   printf "Defaults were successfully reconfigured.\n"
else
   printf "An error occured.\n"
fi

# Create a server certificate before copying ldap.conf

printf "===================================================\n"
printf "Creating and copying certificate and private key...\n"
printf "===================================================\n"
printf "\n"

################################################################################
#
# This part of the script is used to create self-signed certificates for OpenLDAP.
# Previously provided domain name is used to create a certificate. After that,
# using "sed" should enable to replace the default organization domain in all places.
#
################################################################################

# Replace all occurencies of "example.org" with the correct domain and "test"
# with the correct hostname.

find ./ -name "*.cnf" | xargs sed -i  's/example\.org/'"${_domain}"'/g' &&
find ./ -name "*.cnf" | xargs sed -i 's/test/'"${_hostname}"'/g'

# Generate the server certificate

openssl req -newkey rsa:2048 -nodes -keyout "${_fqdn}".key -x509 -days 30 -config \
./server.cnf -out "${_fqdn}".pem; \
cp "${_fqdn}".key /etc/ssl/private/"${_fqdn}".key && \
cp "${_fqdn}".pem /etc/ssl/certs/"${_fqdn}".pem

# Replace ssl-cert with the name of certificate

find ./ -name "directory-settings.ldif" | xargs sed -i \
's/ssl-cert/'"${_fqdn}"'/g'

# Copy ldap.conf

cp ldap.conf /etc/ldap/

# Configure OpenLDAP
printf "=======================\n"
printf "Configuring OpenLDAP...\n"
printf "=======================\n"
printf "\n"

cp /etc/ldap/schema/ppolicy.ldif ppolicy.ldif
service slapd start && \
ldapadd -Y EXTERNAL -H ldapi:/// -f eduperson-201602.ldif && \
ldapadd -Y EXTERNAL -H ldapi:/// -f schac-20150413.ldif && \
ldapadd -Y EXTERNAL -H ldapi:/// -f ppolicy.ldif && \
ldapmodify -Y EXTERNAL -H ldapi:/// -f directory-settings.ldif && \
ldapadd -Y EXTERNAL -H ldapi:/// -f branches.ldif && \
ldapadd -Y EXTERNAL -H ldapi:/// -f users.ldif

cp 99-slapd.conf /etc/rsyslog.d/

############################################################
# Backup all the files needed to respawn a  container down #
############################################################

slapcat -n0 -l config.ldif && \
slapcat -n1 -l data.ldif

# Restart rsyslog
printf "=====================\n"
printf "Restarting rsyslog...\n"
printf "=====================\n"
printf "\n"

service rsyslog restart

# Restart slapd
printf "===================\n"
printf "Restarting slapd...\n"
printf "===================\n"
printf "\n"

service slapd stop && \
service slapd start

# Start slapd as a daemon

exec /usr/sbin/slapd -d 256 -h "ldap:// ldaps:// ldapi:///" -u openldap -g openldap \
-F /etc/ldap/slapd.d "$@"
