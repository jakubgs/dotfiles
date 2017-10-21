#!/usr/bin/env python3
import os
import json
import string
import backoff
import itertools
from time import sleep
from boto3 import client
from boto.route53.domains.exceptions import UnsupportedTLD
from botocore.exceptions import ClientError
from requests.exceptions import ConnectTimeout

LENGTH=3
RETRIES=8
OUTPUT_FILE='/tmp/domains.json'

@backoff.on_exception(backoff.expo, (ClientError, ConnectTimeout), max_tries=RETRIES)
def check_fqdn(fqdn):
    c = client('route53domains')
    try:
        return c.check_domain_availability(DomainName=fqdn)
    except UnsupportedTLD as ex:
        return None

#combinations = list(itertools.product(list(string.ascii_lowercase), repeat=LENGTH))
#names = [''.join(w) for w in combinations]
#names = [c*LENGTH for c in list(string.ascii_lowercase)]
names = ['falcon', 'magi', 'nerv', 'sokolowski', 'gsokolowski', 'jgs']
domains = [
    #'name', 'info', 'blue', 'pink',
    'pro', 'org', 'net', 'biz', 'red',
    'eu', 'it', 'nl', 'de', 'ca', 'cc' 'be', 'ch',
]

if os.path.isfile(OUTPUT_FILE):
    with open(OUTPUT_FILE, 'r') as f:
        results = json.load(f)
else:
    results = {}

try:
    for domain in domains:
        for name in names:
            fqdn = '{}.{}'.format(name, domain)
            if fqdn not in results:
                rval = check_fqdn(fqdn)
                status = rval['Availability'] if rval is not None else 'ERROR'
                results[fqdn] = status
            print(' - {:>18} > {}'.format(fqdn, results[fqdn]))
finally:
    with open('/tmp/domains.json', 'w') as f:
        json.dump(results, f, indent=4)
