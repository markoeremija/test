FROM debian:stretch

# Docker image related information
LABEL "org.geant"="GÉANT Association"
LABEL maintainer.email="marko.eremija [at] amres.ac.rs"
LABEL maintainer.name="Marko Eremija"
LABEL version="0.0.1"
LABEL description="This is an phpLDAPadmin Dockerfile \
for the GN4 Campus IdP task (JRA3T1)."

# ENV variables
ENV DEBIAN_FRONTEND noninteractive

# Set options in advance for unattended Debian installation.

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
    apache2-utils \
    gettext \
    php7.0-ldap \
    python-passlib; \
    mod_ldap = $( apache2ctl -M | grep "ldap_module"; echo $? ) && \
    if [[ $mod_ldap -ne 0 ]]; then \
      printf "LDAP module is not installed.\n"
    fi;

# phpLDAPadmin related configuration files

COPY pla-files /opt/

# Change the working directory to /opt
WORKDIR /opt/

# Clean packages
RUN apt-get -y --purge autoremove && \
    rm -rf /var/lib/apt/lists/*

# Use entrypoint script to avoid too much copying in Dockerfile
# and to keep the image small

ENTRYPOINT [ "entrypoint.sh" ]

EXPOSE 8080 8443
