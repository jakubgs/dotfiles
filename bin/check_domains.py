#!/usr/bin/env python3
import json
import string
import backoff
import itertools
from time import sleep
from boto3 import client
from botocore.exceptions import ClientError

RETRIES=8
LENGTH=3

@backoff.on_exception(backoff.expo, ClientError, max_tries=RETRIES)
def check_availability(c, fqdn):
    return c.check_domain_availability(DomainName=fqdn)

def check_fqdns(names, domain):
    c = client('route53domains')
    results = {}
    for name in names:
        fqdn = '{}.{}'.format(name, domain)
        rval = check_availability(c, fqdn)

        if rval is None:
            continue
        print(' - {:>18} > {}'.format(fqdn, rval['Availability']))
        # save result
        results.setdefault(rval['Availability'], []).append(fqdn)
    return results


#combinations = list(itertools.product(list(string.ascii_lowercase), repeat=LENGTH))
#names = [''.join(w) for w in combinations]
#names = [c*LENGTH for c in list(string.ascii_lowercase)]
names = ['falcon', 'magi', 'nerv', 'sokolowski', 'gsokolowski', 'jgs']
domains = ['name', 'info', 'pro', 'org', 'net', 'biz', 'red', 'eu', 'it', 'nl', 'de', 'ca', 'cc' 'be']

results = {}
for domain in domains:
    results.update(check_fqdns(names, domain))

with open('/tmp/domains.json', 'w') as f:
    json.dump(results, f)
