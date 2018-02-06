OPENDKIM-MANAGE.CFG 5 "JANUARY 2018" Linux "File Formats Manual"
================================================================

NAME
----

`/etc/opendkim-manage.cfg`

DESCRIPTION
-----------

This is the configuration file for `opendkim-manage(1)`. The file is an ini 
formatted file which defines three sections `[global]`, `[ldap]` and `dns`. The 
first section defines some runtime parameters, while the second section defines
all LDAP related parameters. The third section is only required, if you want 
to do dynamic DNS zone updates using the `--update-dns` parameter in 
*opendkim-manage*

OPTIONS
-------

The following parameters are defined for the *global* section:

`expire_after`
    *days* If a DKIM key in LDAP is older than these number of days, a new 
    key will be created with the `--add-new` parameter. The creation date and
    time is taken from the *createTimestamp* attribute in LDAP.
     
`delete_delay`
    If a DKIM key was rotated, the former DKIM key shall persist for some 
    time to prevent e-mail verification issues with remote MTAs that currently 
    try to forward a e-mail and temp fail for some days. This is a safety 
    feature. Usually a value between 6 to 10 days should be fair enough. The 
    value is an integer representing days.
    
`selectorformat`
    As `opendkim-manage` can create new DKIM objects automatically, it 
    requires a format string. New objects are created with a RDN attribute 
    DKIMSelector. This attribute represents the selector field. Such a 
    selector must be unique across the whole LDAP subtree. Therefor the 
    format string may (or even MUST) include some random symbols. You can use
    defined variables in the format string: ${randomhex:length}, ${year}, 
    ${month} and ${day}.
    
    Example:
    
    s${randomhex:8}.${year}-${month}
    
    This would create a selector such as: sA7DCF9B4.2018-01
    
`use_dkim_identity`
    `opendkim` can create signatures including the *i=* field. If you set 
    this option to yes, `opendkim-manage` will add an attribute DKIMIdentity 
    with an *@* prefixed domain, for example @example.test. You must therefor
    adopt your opendkim.conf settings to honor this.
    
`terminal_background`
    If you want to make use of the `--color` option, you can define, if you 
    run on a light or a dark terminal background. Colors will be improved for
    this.

The following parameters are defined for the *ldap* section:

`uri`
    This defines a LDAP URI. It has the following used form:
    schema://host:port/basDN??scope
    
    Example:
    
    uri = ldaps://example.test/ou=dkim,dc=example,dc=test,o=company??sub
    
`bindmethod`
    *simple* or *sasl* - This is the bind method
    
`saslmech`
    *DIGEST-MD5*
    *CRAM-MD5*
    *GSSAPI*
    *EXTERNAL*
    
`filter`
    The LDAP filter defines a basic filter for the root of DKIM key 
    containers. It must also define a macro '%s', which is internally 
    replaced with a string representing a domain in FQDN format, for example 
    *exampleserver.de*
    
    Example:
    
    filter = (&(objectClass=domain)(associatedDomain=%s))
    
`domain`
    Because `opendkim-manage` does not have a LDAP filter parser, you must 
    repeat the attribute that represents a domain name in the container objects.
    
    Example:
    
    domain = associatedDomain
    
`usetls`
    *yes* or *no* This enables TLS for LDAP connections.
    
`reqcert`
    *never*
    *allow*
    *try*
    *demand*
    This option deals with the LDAP server certificate.
    
`ciphers`
    You can define a custom cipher suite. The default is system dependend.
    
`cert`
    Absolute path to a client TLS certificate. If your LDAP server requires 
    such a certificate, you can define it here.
    
`key`
    Absolute path to a client TLS key.
    
`ca`
    This is a custom CA bundled file.
    
    Example:
    
    ca = /etc/ssl/certs/your_own_cacert.pem
    
`authz_id`
    Optional authorization id for SASL/GSSAPI and SASL/EXTERNAL
    
`binddn`
    Either the simple bind or SASL username
    
`bindpw`
    Either the simple bind or SASL password

The following parameters are defined for the *dns* section:

`primary_nameserver`
    IP or hostname for the first nameserver that receives DNS updates

`tsig_key_file`
    Full path to a TSIG key file (generate it with i.e. `dnssec-keygen`)
    
`tsig_key_name`
    The TSIG key name that was used while creating the TSIG key
    
`algorithm`
    *hmac_sha256*
    *hmac_sha384*
    *hmac_sha512*
    The algorithm that was used for the TSIG key. Currently, only three 
    algorithms are supported

`ttl`
    Time to live in seconds. There is no default. If unsure, use 86400 for one
     day

AUTHOR
------

Christian Rößner <c@roessner.co>

SEE ALSO
--------

opendkim-manage(1), opendkim(1), [Project home for opendkim-manage](https://github.com/croessner/opendkim-manage/)
