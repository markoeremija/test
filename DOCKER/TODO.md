# TODO

1) Add a script to bootstrap certificates (use the script provided by FreeRADIUS project);
2) Add an LDAP container with all the schemas provided - this may require writing new Dockerfile as there are not any valid on Docker Hub;
3) Create a Docker Swarm environment - test with multiple VMs as well as with OpenStack(much later :));
4) Tweak Dockerfile to enable faster build times - it's more than one minute when cache is *not* used;
5) Test, test, test. :)
