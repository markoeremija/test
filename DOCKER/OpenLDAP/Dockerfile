FROM debian:stretch

# Docker image related information
LABEL "org.geant"="GÉNT Association"
LABEL maintainer.email="marko.eremija [at] amres.ac.rs"
LABEL maintainer.name="Marko Eremija"
LABEL version="0.1.0"
LABEL description="This is an OpenLDAP Dockerfile \
for the GN4 Campus IdP task (JRA3T1)."

# ENV variables

ENV DEBIAN_FRONTEND noninteractive

# Set options in advance for unattended Debian installation.

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
    apt-utils \
    debconf-utils \
    python-ldap && \
    deb_conf=$( debconf-get-selections | grep -q -s slapd; echo $? ) && \
    if [ $deb_conf ]; then \
       echo "slapd slapd/password1 password" | debconf-set-selections && \
       echo "slapd slapd/password2 password" | debconf-set-selections && \
       echo "slapd slapd/move_old_database boolean true" | debconf-set-selections && \
       echo "slapd slapd/domain string amres.ac.rs" | debconf-set-selections && \
       echo "slapd shared/organization string AMRES" | debconf-set-selections && \
       echo "slapd slapd/no_configuration boolean false" | debconf-set-selections && \
       echo "slapd slapd/purge_database boolean false" | debconf-set-selections && \
       echo "slapd slapd/allow_ldap_v2 boolean false" | debconf-set-selections && \
       echo "slapd slapd/backend select MDB" | debconf-set-selections; \
    fi;

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
    ldap-utils \
    slapd \
    rsyslog

# Change the working directory

WORKDIR /root/ldap-configs

# System related configuration

COPY ldif-files /root/ldap-configs/

# Copy certificates

COPY docker-test.amres.ac.rs.key /etc/ssl/private/docker-test.amres.ac.rs.key

COPY docker-test.amres.ac.rs.pem /etc/ssl/certs/docker-test.amres.ac.rs.pem

# Map the volumes

VOLUME ["/root/ldap-configs/","/var/log/slapd/","/etc/ssl/"]

# Clean packages

RUN apt-get -y --purge autoremove && \
rm -rf /var/lib/apt/lists/*

# Entrypoint script

COPY entrypoint.sh /usr/local/bin/

RUN ["chmod", "+x", "/usr/local/bin/entrypoint.sh"]

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 389 636

CMD ["slapd", \
     "-d", "-1", \
     "-h ldap:// ldaps:// ldapi:///", \
     "-u", "openldap", \
     "-g", "openldap", \
     "-F", "/etc/ldap/slapd.d"]
