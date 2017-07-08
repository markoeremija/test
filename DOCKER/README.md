# How to use this?

In case, you have:

todo: Create separate sections for Docker and Shibboleth

1. Working Docker environment. This can be achieved using the *install.sh* script.
2. A certificate with the full chain in `cert.pem` file.
3. A private key in `key.pem` file.

You just need to follow these steps:

1. Clone the repository.
2. Tweak at least `PASSWORD_CERT_KEY` (private key for the certificate) variable in `Dockerfile`.
3. Execute `build.sh`.
4. Execute `run.sh`.
5. In case you would like to go into the container, execute `attach.sh`.
6. To stop the container, execute `stop.sh`.

To get Shibboleth IdP up and running. However, no configuration (LDAP etc.) is available at this moment.


# Logging #

It's not a good idea to keep logs inside the container. Best practice says it's better to send to std_err and std_out:

> RUN ln -sf /dev/stdout  /opt/jetty/logs \
        && ln -sf /dev/stdout /opt/shibboleth-idp/logs

Mounting volumes with log files that constantly change is also a bad idea.

Dockerfile should also have as small changes as possible. So, the RUN command with metadata should come right before
the CMD, to enable cache usage as much as possible.

When using more than one container, Docker Compose can be used only for *testing* purposes. To install a different
version of Docker Compose, use this command:

> curl -L https://github.com/docker/compose/releases/download/1.14.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
