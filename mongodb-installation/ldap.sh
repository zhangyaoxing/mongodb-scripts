mongoldap --ldapServers ldap.jumpcloud.com \
    --ldapBindMethod sasl \
    --ldapBindSaslMechanisms DIGEST-MD5,CRAM-MD5 \
    --ldapTransportSecurity tls\
    --ldapQueryUser 'uid=query,ou=Users,o=5e4fd7f552dad134d3939f7b,dc=jumpcloud,dc=com' \
    --ldapQueryPassword LimaPeru587! \
    --ldapUserToDNMapping '[{"match": "(.+)","substitution": "uid={0},ou=Users,o=5e4fd7f552dad134d3939f7b,dc=jumpcloud,dc=com"}]' \
    --ldapAuthzQueryTemplate "{USER}?memberOf?base"\
    --user yxzhang \
    --password wrenpass1019

ldapsearch -H ldaps://ldap.jumpcloud.com \
    -b ou=Users,o=5e4fd7f552dad134d3939f7b,dc=jumpcloud,dc=com \
    -D uid=admin,ou=Users,o=5e4fd7f552dad134d3939f7b,dc=jumpcloud,dc=com \
    -W \
    mail=yaoxing.zhang@mongodb.com

mongo --host 127.0.0.1 --authenticationDatabase '$external' --authenticationMechanism PLAIN -u yxzhang -p


sudo yum install cyrus-sasl cyrus-sasl-gssapi cyrus-sasl-plain krb5-libs libcurl lm_sensors-libs net-snmp net-snmp-agent-libs openldap openssl tcp_wrappers-libs