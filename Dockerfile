# 이미지 빌드(ec2-deploy 폴더에서 실행)
#docker build -t ec2-deploy -f Dockerfile .
FROM        ubuntu:18.04
MAINTAINER hungyb0924@gmail.com

# 패캐지 업그레이드 , 파이썬3 설치
RUN     apt -y update
RUN     apt -y dist-upgrade
RUN     apt -y install python3-pip

# Nginx , uWSGI 설치 (webserver , wsgi)
RUN     apt -y install nginx
RUN     pip3 install uwsgi

# docker build 할때의 PATH에 해당하는 폴더의 전체 내용을
# Image의 /srv/project/폴더 내부에 복사
COPY        ./   /srv/project
WORKDIR     /srv/project

# settings 모듈에 대한 환경변수 설정
ENV         DJANGO_SETTINGS_MODULE  config.settings.production

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