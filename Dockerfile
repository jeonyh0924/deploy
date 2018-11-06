
# 이미지 빌드(ec2-deploy폴더에서 실행)
#  docker build -t ec2-deploy -f Dockerfile .
FROM        python:3.6.7-slim
MAINTAINER  dev@lhy.kr
ENV         LANG                    C.UTF-8

RUN         apt -y update
RUN         apt -y dist-upgrade
RUN         apt -y install gcc nginx supervisor
RUN         pip3 install uwsgi


# requirements.txt파일만 복사 후, 패키지 설치
# requirements.txt파일의 내용이 바뀌지 않으면 pip3 install ...부분이 재실행되지 않음
COPY        requirements-production.txt /tmp/requirements.txt
RUN         pip3 install -r /tmp/requirements.txt

ENV         DJANGO_SETTINGS_MODULE config.settings.production

# 전체 소스코드 복사
COPY        ./   /srv/project
WORKDIR     /srv/project

# 프로세스를 실행할 명령
WORKDIR     /srv/project/app
RUN         python3 manage.py collectstatic --noinput

# Nginx
#  기존에 존재하던 Nginx설정파일들 삭제
RUN         rm -rf  /etc/nginx/sites-available/*
RUN         rm -rf  /etc/nginx/sites-enabled/*

# 프로젝트 Nginx설정파일 복사 및 enabled로 링크 설정
RUN         cp -f   /srv/project/.config/app.nginx \
                    /etc/nginx/sites-available/
RUN         ln -sf  /etc/nginx/sites-available/app.nginx \
                    /etc/nginx/sites-enabled/app.nginx

# supervisor설정파일 복사
RUN         cp -f   /srv/project/.config/supervisord.conf \
                    /etc/supervisor/conf.d/
# 80번 포트 개방
EXPOSE      80
# Command로 supervisor실행
CMD         supervisord -n