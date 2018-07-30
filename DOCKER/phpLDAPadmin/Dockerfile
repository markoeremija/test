FROM debian:stretch

# Docker image related information
LABEL "org.geant"="GÉANT Association"
LABEL maintainer.email="marko.eremija [at] amres.ac.rs"
LABEL maintainer.name="Marko Eremija"
LABEL version="0.1.0"
LABEL description="This is a phpLDAPadmin Dockerfile \
for the GN4 Campus IdP task (JRA3T1)."

# ENV variables
ENV DEBIAN_FRONTEND noninteractive

# Set options in advance for unattended Debian installation.

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
	  apache2 \
	  apache2-utils \
	  ca-certificates \
	  cron \
    gettext \
	  php \
	  php-xml \
	  php7.0-ldap \
    python-passlib

# phpLDAPadmin related configuration files

COPY pla-files /opt/

# Change the working directory to /opt

WORKDIR /opt/

# Clean packages

RUN apt-get -y --purge autoremove && \
    rm -rf /var/lib/apt/lists/*

# Entrypoint script

COPY entrypoint.sh /usr/local/bin/

RUN ["chmod", "+x", "/usr/local/bin/entrypoint.sh"]

ENTRYPOINT [ "entrypoint.sh" ]

EXPOSE 80 443

CMD ["apachectl","-DFOREGROUND"]
