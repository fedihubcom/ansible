import re

from ansible.errors import AnsibleFilterError

SHORT_KEY_RE = re.compile(r'^[0-9a-f]{64}$',  re.IGNORECASE)
LONG_KEY_RE  = re.compile(r'^[0-9a-f]{128}$', re.IGNORECASE)

def short_key(s):
    s = str(s)
    if not SHORT_KEY_RE.match(s):
        raise AnsibleFilterError('Invalid key: %s' % s)
    return '"%s"' % s.lower()

def long_key(s):
    s = str(s)
    if not LONG_KEY_RE.match(s):
        raise AnsibleFilterError('Invalid key: %s' % s)
    return '"%s"' % s.lower()

class FilterModule:
    '''Filters to validate and escape Yggdrasil configuration variables.'''

    def filters(self):
        return {
                'short_key': short_key,
                'long_key':  long_key,
        }
