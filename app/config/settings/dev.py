from .base import *
secrets = json.load(open(os.path.join(SECRETS_DIR, 'dev.json')))

DEBUG = True

WSGI_APPLICATION = 'config.wsgi.dev.application'

#  .secrets/dev.json 의 내용을 사용해서
#   아래 DATABASE 설정 채우기
DATABASES = secrets['DATABASES']

# django-storages
DEFAULT_FILE_STORAGE = 'config.storages.MediaStorage'
#  collectstatic 을 실행했을 떄
#  버킷의 'static' 폴더 아래에 정적 파일들이 저장되도록 설정해보기
#  config.starages.StaticStorage 클래스를 만들어서 적용

# STATICFILES_STORAGE = 'config.storages.StaticStorage'
# 위 설정시 S3 프리티어의 기본 PUT 한계를 금방 초과하게 되므로
# STATIC_ROOT에 collectstatic 후 Nginx에서 제공하는 형태로 사용

AWS_ACCESS_KEY_ID = secrets['AWS_ACCESS_KEY_ID']
AWS_SECRET_ACCESS_KEY = secrets['AWS_SECRET_ACCESS_KEY']
AWS_STORAGE_BUCKET_NAME = secrets['AWS_STORAGE_BUCKET_NAME']