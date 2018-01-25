Slightly improved version of the well known OpenDKIM LDAP schema from Patrick
Ben Koetter.

Changes:
--------

- DKIMDomain is a MUST attribute
- DKIM is a structural class
- Added DKIMActive attribute for key management


Example objects in LDAP:
------------------------

```
dn: dc=example,dc=test,ou=dkim,o=company
objectClass: top
objectClass: domain
objectClass: domainRelatedObject
dc: example
associatedDomain: example.test

dn: DKIMSelector=sC9C7B71D.2018-01,dc=example,dc=test,ou=dkim,o=company
objectClass: top
objectClass: DKIM
DKIMKey: Some RSA key
DKIMIdentity: @example.test
DKIMActive: FALSE
DKIMDomain: christianroessner.de
DKIMSelector: sC9C7B71D.2018-01
```

Example opendkim.conf KeyTable and SigningTable:
------------------------------------------------

```
SigningTable            ldap://localhost/ou=dkim,o=company?DKIMSelector,DKIMIdentity?sub?(&(|(DKIMDomain=$d)(DKIMIdentity=$d))(DKIMActive=TRUE))
KeyTable                ldap://localhost/ou=dkim,o=company?DKIMDomain,DKIMSelector,DKIMKey?sub?(DKIMSelector=$d)
```

