#!/bin/bash
#
source 00_env.sh
#
# Generate the kerberos configuration file
#
cat <<! >krb5.conf
# https://web.mit.edu/kerberos/krb5-1.12/doc/admin/conf_files/krb5_conf.htm
[logging]
default = FILE:/var/log/krb5libs.log
kdc = FILE:/var/log/krb5kdc.log
admin_server = FILE:/var/log/kadmind.log

[libdefaults]
default_realm = ${AD_DOMAIN}
dns_lookup_realm = false
dns_lookup_kdc = false
ticket_lifetime = 24h
renew_lifetime = 7d
forwardable = true 

[realms]
${AD_DOMAIN^^} = {
   kdc = ${AD_NODE}.${AD_DOMAIN,,}:88
   admin_server = ${AD_NODE,,}.${AD_DOMAIN,,}:749
   default_domain = ${AD_DOMAIN,,}
  }

[domain_realm]
!
for DOM in ${DB_DOMAIN_REALMS[@]}; do
  echo ${DOM} '=' ${AD_DOMAIN^^} >>krb5.conf
done
echo copy krb5.conf to /etc
