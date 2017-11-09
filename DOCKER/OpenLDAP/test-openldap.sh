#!/bin/sh

# Test and display what would be done if everything works fine

output=$( ldapmodify -n -v -Y EXTERNAL -H ldapi:/// -f users.ldif )

if [ $output -eq 0 ]; then
  printf "There was an error when trying to import LDIF file!\n"
  printf "Please verify the LDIF file and possible errors before importing it\n"
  printf "through Dockerfile.\n"
