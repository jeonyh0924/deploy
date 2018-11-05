from .base import *

DEBUG = False

WSGI_APPLICATION = 'config.wsgi.application'

DATABASES = secrets['DATABASES']