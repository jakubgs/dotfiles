#!/usr/bin/env python3
import re
import json
import argparse
from boto3 import client

HELP_MESSAGE = '''
Add new FQDNs!

Gotta have the env variables:
AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
'''

DEFAULT_TTL = 300

def is_ip_addr(val):
    return re.match(r'([0-9]\.?){4}', val) is not None

def get_domain(fqdn):
    return '.'.join(fqdn.split('.')[-3:])

def add_fqdn(rec_type, fqdn, values, ttl=DEFAULT_TTL, comment=None):
    c = client('route53')
    zones = {z['Name']: z for z
             in c.list_hosted_zones()['HostedZones']}

    if not fqdn.endswith('.'):
        fqdn = fqdn + '.'

    domain = get_domain(fqdn)

    return c.change_resource_record_sets(
        HostedZoneId=zones[domain]['Id'],
        ChangeBatch={
            'Comment': comment,
            'Changes': [
                {
                    'Action': 'UPSERT',
                    'ResourceRecordSet': {
                        'Name': fqdn,
                        'Type': rec_type,
                        'TTL': ttl,
                        'ResourceRecords': [
                            { 'Value': v } for v in values
                        ],
                    }
                },
            ]
        }
    )

def create_arguments():
    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawDescriptionHelpFormatter,
                                     description=HELP_MESSAGE)
    parser.add_argument("fqdn", type=str,
                        help="FQDN to change.")
    parser.add_argument("values", nargs='+', type=str,
                        help="Values for DNS record.")
    parser.add_argument("--ttl", type=int, default=DEFAULT_TTL,
                        help="TTL for DNS record.")
    parser.add_argument("--comment", type=str,
                        default='Done by Boto script.',
                        help="Comment for the change.")
    return parser.parse_args()


def main():
    opts = create_arguments()

    if all(is_ip_addr(v) for v in opts.values):
        rec_type = 'A'
    elif all(not is_ip_addr(v) for v in opts.values):
        rec_type = 'CNAME'
    else:
        raise Exception('Invalid values!')

    rval = add_fqdn(
        rec_type, opts.fqdn, opts.values,
        ttl=opts.ttl, comment=opts.comment
    )
    print(rval)

if __name__ == "__main__":
    main()
