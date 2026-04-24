from .base import djsettings
from .logging import LOGGING

djsettings.debug = True

# SECURITY WARNING: keep the secret key used in production secret!
djsettings.secret_key = 'django-insecure-8d-%uqj1b$_pb53d*sadbk^x1^o2qg$pzw$mt^szqh8j$#3+m5'

# SECURITY WARNING: define the correct hosts in production!
djsettings.allowed_hosts = ["*"]

djsettings.logging = LOGGING

try:
    from .local import *
except ImportError:
    pass

djsettings.register()