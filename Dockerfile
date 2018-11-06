
# docker build -t ec2-deploy -f Dockerfile .
# . 까지 써줘야함

FROM        ubuntu:18.04
MAINTAINER  hungyb0924@gmail.com

ENV         LANG                    C.UTF-8

RUN         apt -y update
RUN         apt -y dist-upgrade
RUN         apt -y install gcc nginx supervisor
RUN         pip3 install uwsgi


# docker build할때의 PATH에 해당하는 폴더의 전체 내용을
# Image의 /srv/project/폴더 내부에 복사
# requirements.txt의 내용이 변경이 없으면 RUN을 건너뛰고
# 변경사항이 있으면 RUN을 실행한다
COPY        requirements.txt /tmp/requirements.txt
RUN         pip3 install -r /tmp/requirements.txt

# 전체 소스코드 복
COPY        ./     /srv/project
WORKDIR     /srv/project

# 프로세스를 실행할 명령
WORKDIR     /srv/project/app
RUN         python3 manage.py collectstatic --noinput

# Nginx
# 기존에 존재하던 Nginx설정 파일들 삭제
RUN         rm -rf /etc/nginx/sites-available/*
RUN         rm -rf /etc/nginx/sites-enabled/*

# 프로젝트 Nginx설정파일 복사 및 enabled로 링크 설정
# cp 명령어의 -f 옵션은 강제 옵션이다. 그 파일이 있더라도 덮어 씌운다.
RUN         cp -f  /srv/project/.config/app.nginx \
                   /etc/nginx/sites-available
RUN         ln -sf /etc/nginx/sites-available/app.nginx \
                   /etc/nginx/sites-enabled/app.nginx
# supervisor 설정파일 복사
RUN         cp -f  /srv/project/.config/supervisord.conf \
                   /etc/supervisor/conf.d/

# Command 로 supervisor 실행
CMD         supervisord -n