OPENDKIM-MANAGE 1 "JANUARY 2018" Linux "User Manuals"
=====================================================

NAME
----

`opendkim-manage` [`-h`] [`--list`] [`--create`] [`--delete`] [`--force-delete`]
                         [`--active`] [`--force-active`] [`--age` *AGE*]
                         [`--domain `*DOMAIN*] [`--selectorname` *SELECTORNAME*]
                         [`--size` *SIZE*] [`--testkey`] [`--config` *CONFIG*]
                         [`--add-missing`] [`--add-new`] [`--rotate`] `[--auto`]
                         [`--expire-after` *EXPIRE_AFTER*]
                         [`--delete-delay` *DELETE_DELAY*]
                         [`--interactive`] [`--debug`]
                         [`--verbose`] [`--color`] [`--version`]

DESCRIPTION
-----------

`opendkim-manage` is a tool that manages DKIM keys in OpenLDAP. OpenLDAP 
needs to use a modified version of the OpenDKIM LDAP schema, which is also 
distributed with this release. It can be run as a cron job on a daily basis. 
`opendkim-manage` can find new LDAP objcets in the tree that do not have DKIM
keys yet and add them. It auto rotates keys, if a period of days is over and
keys are outdated. It ensures that a DKIM key will only be acivated, if the
DNS does provide the matching public key. It also cleans the LDAP tree and 
purges old obsolete keys. Only keys that have been delayed for several days 
are removed. If a key rotation happened, `opendkim-manage` will not remove the
old key until the defined number of days was reached. The reason therefor is 
that remote MTAs might forward mails and temporarily bounce for some days. If
this tool would remove old keys too early, remote DKIM checks would fail due
to missing keys in the DNS (which are normally generated after an 
`opendkim-manage` `--auto` run). 

OPTIONS
-------

`--help`, `-h`
    Show a help message and exit

`--list`, `-l`
    List DKIM keys. It will print out a list for either all domains or a 
    subset of domains and there DKIM selectors.
    
`--create`, `-c`
    Create a new DKIM key in LDAP.
    
`--delete`, `-d`
    Delete one or many DKIM keys from LDAP.
    
`--force-delete`
    Force deletion of a DKIM key in LDAP. Normally a key can not be removed, 
    if it is either marked active or if its `--delete-delay` period has not 
    passed.
    
`--active`
    Set DKIMActive to TRUE for a selector. This will check the public DNS key
     and mark the key active on success.
    
`--force-active`
    Force activation of a DKIM key. If no DNS public key was found, a key 
    would not become active. Use this option to force it. Be careful not to 
    activate wrong keys or more than one key per domain.
    
`--age` *AGE*, `-A` *AGE*
    The key has to be older (postive value) or younger  (negative value) then
     *N* number of days. It will return 0, if the expected result happened, 
     else it returns 1.
    
`--domain` *DOMAIN*, `-D` *DOMAIN*
    There are some commands that support this parameter. With it, you can 
    reduce operations on a subset of one or more domains depending on the 
    command.
    
`--selectorname` *SELECTORNAME*, `-s` *SELECTORNAME`
    This is an optional parameter. You can specify one or more selectors for 
    several commands that do support it.
    
`--size` *SIZE*, `-S` *SIZE* 
    Size of DKIM keys (default: 2048). If a new DKIM key is generated, the 
    resulting RSA key will have these number of bits.
    
`--testkey`, `-t`
    Check that the listed DKIM keys are published in DNS. It will print out 
    the TXT record for a key.
    
`--config` *CONFIG*, `-f` *CONFIG*
    Path to the `opendkim-manage` config file. (default:
    `/etc/opendkim-manage.cfg`)
    
`--add-missing`, `-m`
    Add missing DKIM keys to LDAP objects. DKIM keys are stored in LDAP under
    a defined baseDN. There should exist objects for each domain that carry 
    a domain attribute. These objects are like containers for the DKIM keys.
    If such a container is empty, `opendkim-manage` will create a new DKIM 
    key. This newly created key is not automatically activated, as there does
    not yet exist a public DNS key. 

`--max-initial`
    If you maintain lots of domains and start using `opendkim-manage`, it 
    might be better to initialize DKIM object in chunks. This parameter will not 
    create more than N missing DKIM keys per run. It is only used together 
    with the `--add-missing` parameter.

`--add-new`, `-n`
    Check the age for DKIM keys and create new keys on demand. If the 
    `--expire-after` time period is over for a key, `opendkim-manage` creates
    a new DKIM key. This newly created key is not automatically activated, as 
    there does not yet exist a public DNS key.
    
`--rotate`, `-r`
    Rotate one or all DKIM keys. It checks all newer keys against DNS and if 
    possible will mark a newer key active and deactivate (all) former active 
    keys.

`--auto`, `-a`
    Short for `--add-missing`, `--add-new`, `--rotate`, `--active` and 
    `--delete`. Normally, you will use only this parameter in production 
    environments as a cron job.
    
`--expire-after` *EXPIRE_AFTER*, `-e` *EXPIRE_AFTER*
    Number of days after which new DKIM keys will be created with `--add-new` 
    (default: 365 days)
    
`--delete-delay` *DELETE_DELAY*, `-y` *DELETE_DELAY*
    Delay deletion of old DKIM keys (default: 10 days)
    
`--interactive`, `-i`
    Turn on interactive mode. This is a safety feature to test the system 
    before creating automatic cron jobs. Each LDAP operation is asked to the 
    admin and only operated on confirmation.
    
`--debug`
    Turn on debugging. This will print out a lot of debug information. If 
    something unexpected happens, please try this option and report it back 
    in the issue tracker.

`--verbose`, `-v`
    Verbose output. This will print out some helpful messages. Not too much 
    at the moment.
    
`--color`
    Turn on colors for output. This is a nice helper on the command line. If 
    you have dozens of domains and also combine parameters mit debugging, 
    overview will become quickly harder. Just give it a try.
    
`--version`, `-V` 
    Print the version of `opendkim-manage` and exit

EXAMPLES
--------

Print a list of DKIM selectors for the domain 'exampleserver.de':

    opendkim-manage --list -D exampleserver.de
    
    DNS domain 'exampleserver.de':
    DN: dc=exampleserver,dc=de,ou=dkim,ou=it,dc=roessner-net,dc=de
    2018-01-30 09:28:43 DKIMSelector: s9C50794A.2018-01 (active)

Create missing DKIM keys:

    opendkim-manage --add-missing
    
Check, if the DKIM selector 's9C50794A.2018-01' is already in the DNS:

    opendkim-manage --testkey -s s9C50794A.2018-01
    
    Query s9C50794A.2018-01._domainkey.exampleserver.de
    TXT: v=DKIM1; k=rsa; s=email; p=MIIBIj........DAQAB

Check, if all DKIM selectors for some domains are already in the DNS:

    opendkim-manage --testkey -D roessner.blog -D exampleserver.de
    
    Query s97BEBEE5.2018-01._domainkey.roessner.blog
    TXT: v=DKIM1; k=rsa; s=email; p=MIIBIj........DAQAB
    Query s9C50794A.2018-01._domainkey.exampleserver.de
    TXT: v=DKIM1; k=rsa; s=email; p=MIIBIj........DAQAB
    
Check, if the given key is older than a year:

    opendkim-manage --age 365 -s s9C50794A.2018-01
    echo $?
    1

Check, if the given key is younger than 30 days:

    opendkim-manage --age -30 -s s9C50794A.2018-01
    echo $?
    0

Run opendkim-manage as a daily cron job:

    opendkim-manage --auto
    

FILES
-----

*/etc/opendkim-manage.cfg*
      The system wide configuration file. See opendkim-manage.cfg(5) for 
      further details.

AUTHOR
------

Christian Rößner <c@roessner.co>

SEE ALSO
--------

opendkim-manage.cfg(5), opendkim(1), [Project home for opendkim-manage](https://github.com/croessner/opendkim-manage/)