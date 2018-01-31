Prerequirements
---------------

This packages is (will be) well tested on Debian 9 (Stretch) and SuSE Linux 
Enterprise Server 11 (SLES_11). The following packages have to be pre-installed:

```
apt-get install --no-install-recommends python-setuptools
apt-get install --no-install-recommends python-dnspython
apt-get install --no-install-recommends python-ldap
apt-get install --no-install-recommends python-m2crypto
```

If you want to use the `--color` option, you also need to install:

```
apt-get install --no-install-recommends python-colorama
```

*opendkim-manage* is a tool to mange DKIM keys stored in OpenLDAP. It uses a 
modified version of the OpenDKIM LDAP schema, which is also shipped with this
release. You can find the schema in the contrib folder as well as a sample 
configuration file. Please see also the README.md file there for a structural
overview.

There is nothing much to install. Simply place the `opendkim-manage` script 
somewhere into your bin-path, for example /usr/local/sbin. Edit your 
configuration and you are fine.

If you have tested the functionaility, you may add a cron job at the end that
runs once a day:
 
```cron
@daily /usr/local/sbin/opendkim-manage --auto
```

If you find issues, you are welcome to use the issue tracker here at Github 
or send a pull request. Have fun...