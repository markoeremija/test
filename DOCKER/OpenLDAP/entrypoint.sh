#!/usr/bin/env bash
set -e

_target_dir=/root/ldap-configs
_cwd=`pwd`
_domain="amres.ac.rs"
_organization=AMRES
_hostname=`hostname`
_fqdn="`hostname`.${_domain}"

##################################################################################
#                                                                                #
# This part of the script is used to extract the domain part for creating LDAP   #
# configuration. The institution has to provide a valid domain name. After that, #
# using "sed" should enable replacing the default organization DN in all places. #
#                                                                                #
##################################################################################

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

# Replace all occurencies of dc=example,dc=org with the correct dn

find ./ -name "*.ldif" | xargs sed -i  's/dc\=example,dc\=org/'"${dc}"'/g'

cat /root/ldap-configs/branches.ldif

printf "\n"

#########################################################################
# Check if the current working directory matches the targeted directory #
#########################################################################

if [ "${_cwd}" != "${_target_dir}" ]; then
   cd /root/ldap-configs
fi

chown openldap:openldap /etc/ssl/private/"${_fqdn}".key && \
chown openldap:openldap /etc/ssl/certs/"${_fqdn}".pem && \
cp /etc/ssl/certs/cacert.pem /root/ldap-configs/cacert.pem

printf "\n"

# Copy ldap.conf

cp ldap.conf /etc/ldap/ && cp 99-slapd.conf /etc/rsyslog.d/

# Configure OpenLDAP
printf "=======================\n"
printf "Configuring OpenLDAP...\n"
printf "=======================\n"
printf "\n"

cp /etc/ldap/schema/ppolicy.ldif ppolicy.ldif

service slapd start

ldapadd -Y EXTERNAL -H ldapi:/// -f eduperson-201602.ldif && \
ldapadd -Y EXTERNAL -H ldapi:/// -f schac-20150413.ldif && \
ldapadd -Y EXTERNAL -H ldapi:/// -f ppolicy.ldif && \
ldapmodify -Y EXTERNAL -H ldapi:/// -f directory-settings.ldif

sleep 1

SLAPD_PID=$(cat /run/slapd/slapd.pid)
kill -15 $SLAPD_PID

service slapd start
printf "\n"
ldapadd -Y EXTERNAL -H ldapi:/// -f branches.ldif && \
ldapadd -Y EXTERNAL -H ldapi:/// -f users.ldif

######################################################
# Backup all the files needed to respawn a container #
######################################################

slapcat -n0 -l config.ldif && \
slapcat -n1 -l data.ldif

# Restart rsyslog
printf "=====================\n"
printf "Restarting rsyslog...\n"
printf "=====================\n"
printf "\n"

service rsyslog start

sleep 1

# Restart slapd
printf "===================\n"
printf "Restarting slapd...\n"
printf "===================\n"
printf "\n"

# Start slapd - the CMD can be omitted and put here

SLAPD_PID=$(cat /run/slapd/slapd.pid)
kill -15 $SLAPD_PID

printf "=========================\n"
printf "OpenLDAP container is up.\n"
printf "=========================\n"

exec "$@"
