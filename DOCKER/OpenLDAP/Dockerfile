FROM debian:stretch

# Docker image related information
LABEL "org.geant"="GÉANT Association"
LABEL maintainer.email="marko.eremija [at] amres.ac.rs"
LABEL maintainer.name="Marko Eremija"
LABEL version="0.0.1"
LABEL description="This is an OpenLDAP Dockerfile \
for the GN4 Campus IdP task (JRA3T1)."

# ENV variables
# Using ENV variables can help with setting defaults for
# unattended installation of OpenLDAP. Add it later.
ENV DEBIAN_FRONTEND noninteractive

# Set options in advance for unattended Debian installation.

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
    debconf-utils \
    python-ldap; \
    debconf=$( debconf-get-selections | grep -q -s slapd ); \
    if [ $debconf ]; then \
      echo "slapd shared/organization string EXAMPLE Institution" | debian-set-selections && \
      echo "slapd slapd/allow_ldap_v2 boolean false" | debian-set-selections && \
      echo "slapd slapd/backend select MDB" | debian-set-selections && \
      echo "slapd slapd/domain string example.org" | debian-set-selections && \
      echo "slapd slapd/move_old_database boolean true" | debian-set-selections && \
      echo "slapd slapd/no_configuration boolean false" | debian-set-selections && \
      echo "slapd slapd/password1 password" | debian-set-selections && \
      echo "slapd slapd/password2 password" | debian-set-selections && \
      echo "slapd slapd/purge_database boolean false" | debian-set-selections \
    fi

RUN apt-get -y --no-install-recommends install \
    ldap-utils \
    slapd && \
    mkdir /var/log/slapd

# System related configuration

COPY 99-slapd.conf /etc/rsyslog.d/

COPY ldap.conf /etc/ldap/

# OpenLDAP related configuration

WORKDIR /root/ldap-configs

COPY ldif-files .

RUN wget -q -i openldap-schema-list.lst && \
    mv eduperson* eduperson-201602.ldif && \
    mv schac* schac-20150413.ldif && \
    cp /etc/ldap/schema/ppolicy.ldif ppolicy.ldif && \
    ldapadd -Y EXTERNAL -H ldapi:/// -f eduperson-201602.ldif && \
    ldapadd -Y EXTERNAL -H ldapi:/// -f ppolicy.ldif && \
    ldapadd -Y EXTERNAL -H ldapi:/// -f schac-20150413.ldif && \
    ldapmodify -Y EXTERNAL -H ldapi:/// -f directory-settings.ldif && \ 
    ldapadd -Y EXTERNAL -H ldapi:/// -f branches.ldif && \
    ldapadd -Y EXTERNAL -H ldapi:/// -f users.ldif

# Run restart rsyslog && slapd when everything is checked and copied
RUN service rsyslog restart && \
    service slapd restart

# Clean packages
RUN apt-get -y --purge autoremove && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 389 636

CMD ["bash"]
