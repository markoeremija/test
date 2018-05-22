#!/usr/bin/python

import ldap
import ldap.modlist as modlist
from datetime import datetime

try:
        l = ldap.open("{{ fqdn }}", 389)
        l.protocol_version = ldap.VERSION3
        l.simple_bind('{{ pla['ldap']['root_dn'] }}','{{ pla['ldap']['root_pw'] }}')

        search_base = "ou=people,{{ pla['ldap']['basedn'] }}"
        search_scope = ldap.SCOPE_SUBTREE
        retrieve_attributes = [ 'uid', 'cn', 'pwdAccountLockedTime', 'schacExpiryDate' ]
        search_filter = "uid=*"

        ldap_result_id = l.search(search_base, search_scope, search_filter, retrieve_attributes)
        while 1:
                result_type, result_data = l.result(ldap_result_id, 0)
                if (result_data == []): break

                if result_type == ldap.RES_SEARCH_ENTRY:
                        cur_cn = result_data[0][0]
                        cur_attrs = result_data[0][1]

                        if 'schacExpiryDate' in cur_attrs and len(cur_attrs['schacExpiryDate']) > 0:
                                expiry_date = datetime.strptime(cur_attrs['schacExpiryDate'][0], '%Y%m%d%H%M%SZ')
                                if datetime.now() >= expiry_date:
                                        if not 'pwdAccountLockedTime' in cur_attrs:
                                                old = { }
                                                new = { 'pwdAccountLockedTime': ['000001010000Z'] }
                                                ldif = modlist.modifyModlist(old, new)
                                                l.modify_s(cur_cn, ldif)
                                                print "Locked user %s" % cur_cn

        l.unbind_s()

except ldap.LDAPError, e:
        print e
