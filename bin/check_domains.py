#!/usr/bin/env python3
import os
import json
import string
import backoff
import itertools
from time import sleep
from boto3 import client
from botocore.exceptions import ClientError
from requests.exceptions import ConnectTimeout

class PendingRecord(Exception):
    pass

@backoff.on_exception(backoff.expo, (ClientError, ConnectTimeout, PendingRecord), max_tries=3)
def check_fqdn(c, fqdn):
    try:
        rval = c.check_domain_availability(DomainName=fqdn)
        if rval['Availability'] == 'PENDING':
            raise PendingRecord
        return rval
    except c.exceptions.UnsupportedTLD as ex:
        return None

combinations = list(itertools.product(list(string.ascii_lowercase), repeat=2))
names = [''.join(w) for w in combinations]
#names = [c*LENGTH for c in list(string.ascii_lowercase)]
#names = ['falcon', 'magi', 'nerv', 'sokolowski', 'gsokolowski', 'jgs']
domains = [
    #'name', 'info', 'blue', 'pink',
    'pro', 'org', 'net', 'biz', 'red',
    'eu', 'it', 'nl', 'de', 'ca', 'cc' 'be', 'ch',
]

OUTPUT_FILE='/tmp/domains.json'
if os.path.isfile(OUTPUT_FILE):
    with open(OUTPUT_FILE, 'r') as f:
        results = json.load(f)
else:
    results = {}

c = client('route53domains')

try:
    for name in names:
        for domain in domains:
            fqdn = '{}.{}'.format(name, domain)
            if fqdn not in results:
                rval = check_fqdn(c, fqdn)
                status = rval['Availability'] if rval is not None else 'ERROR'
                results[fqdn] = status
            print(' - {:>18} > {}'.format(fqdn, results[fqdn]))
finally:
    with open('/tmp/domains.json', 'w') as f:
        json.dump(results, f, indent=4)
