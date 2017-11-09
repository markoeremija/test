FROM debian:stretch

# Docker image related information
LABEL "org.geant"="GÉANT Association"
LABEL maintainer.email="marko.eremija [at] amres.ac.rs"
LABEL maintainer.name="Marko Eremija"
LABEL version="1.0"
LABEL description="This is an OpenLDAP Dockerfile \
for the GN4 Campus IdP task (JRA3T1)."

# ENV variables
ENV ldap['base_dn'] \
    ldap['domain'] \
    ldap['org'] \
    ldap['root_pw'] \
    ldap['root_dn']

# update APT cache and install required packages
RUN apt-get update && \
    apt-get -y --no-install-recommends install \
    debconf-utils \
    ldap-utils \
    python-ldap \
    slapd

# System related configuration

RUN mkdir /var/log/slapd

COPY 99-slapd.conf /etc/rsyslog.d/

COPY ldap.conf /etc/ldap/

# OpenLDAP related configuration

WORKDIR /root/ldap-configs

COPY ldif-files .

RUN wget -q -i openldap-schema-list.lst \ &&
    mv eduperson* eduperson-201602.ldif \ &&
    mv schac* schac-20150413.ldif \ &&
    cp /etc/ldap/schema/ppolicy.ldif ppolicy.ldif && \
    ldapadd -Y EXTERNAL -H ldapi:/// -f eduperson-201602.ldif && \
    ldapadd -Y EXTERNAL -H ldapi:/// -f ppolicy.ldif && \
    ldapadd -Y EXTERNAL -H ldapi:/// -f schac-20150413.ldif && \
    ldapmodify -Y EXTERNAL -H ldapi:/// -f directory-settings.ldif \ &&
    ldapadd -Y EXTERNAL -H ldapi:/// -f branches.ldif && \
    ldapadd -Y EXTERNAL -H ldapi:/// -f users.ldif

# Run restart rsyslog && slapd when everything is checked and copied
RUN service rsyslog restart && \
    service slapd restart

# Clean packages
RUN apt-get -y --purge autoremove && rm -rf /var/lib/apt/lists/*

EXPOSE 389 636

CMD ["bash"]
