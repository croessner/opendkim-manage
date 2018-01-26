#!/bin/bash

TSIGKEY=/etc/opendkim-manage.d/Kexample.private
WORKDIR=/var/nsupdatedkim
NS="your.master.dns.goes.here"

if [[ ! -f ${TSIGKEY} ]]; then
	echo "This script requires a TSIG key"
	exit 1
fi
if [[ ! -d "${WORKDIR}" ]]; then
	mkdir -p ${WORKDIR}
fi

for domain in $(opendkim-manage -l | grep "DNS" | cut -d "'" -f2 | cut -d "'" -f1); do
	# Generate nsupdate files
	echo -n "Generate ${WORKDIR}/${domain}.nsupdate file... "
	opendkim-genzone -F -t 3600 -u -x /etc/opendkim/opendkim.sign.conf -d ${domain} 2>/dev/null | \
		sed -e 's/server mx/server ${NS}/' | \
		sed -e 's/TXT "/TXT "v=DKIM1\\; k=rsa\\; s=email\\; p=" "/' | \
		sed -e '/answer/d' > "${WORKDIR}/${domain}.nsupdate"
	echo "done"
	
	# Remove old keys from DNS
	for dkimkey in $(dig +noall +answer @${NS} AXFR -k ${TSIGKEY} ${domain} | \
		grep _domainkey | grep "IN TXT" | cut -d " " -f1); do
		opendkim-manage -l -D ${domain} | grep "DKIMSelector" | awk '{ print $3; }' | \
		while read selector; do
			ldapkey="${selector,,}._domainkey.${domain}."
			if [[ "${dkimkey}" != "${ldapkey}" ]]; then
				echo -n "Removing old DKIM DNS record ${ldapkey}... "
				(
				cat - <<EOF
server ${NS}
update delete ${dkimkey}
send
EOF
				) | nsupdate -v -k "${TSIGKEY}"
				echo "done"
			fi
		done
	done

	# Add new keys to DNS
	opendkim-manage -l -D ${domain} | grep "DKIMSelector" | grep "active" | awk '{ print $3; }' | \
	while read selector; do
		ldapkey="${selector,,}._domainkey.${domain}."
		dnsresult=$(dig +short @${NS} -t TXT ${ldapkey})
		if [[ "${dnsresult}" == "" ]]; then
			echo -n "Adding new DKIM key ${ldapkey} to DNS... "
			nsupdate -v -k "${TSIGKEY}" "${WORKDIR}/${domain}.nsupdate"
			echo "done"
		fi
	done
done

echo -n "Cleanup... "
rm "${WORKDIR}"/*.nsupdate
echo "done"

exit 0

# vim: ts=4 sw=4
