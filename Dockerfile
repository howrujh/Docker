# Dev

FROM ubuntu:latest

RUN sed -i 's/archive.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list
RUN apt-get update

# PACKAGE INSTALL
RUN apt-get install -y git emacs cscope
RUN apt-get install -y git tmux ack-grep
RUN apt-get install -y openssh-server aptitude net-tools curl

# github
RUN mkdir ~/github
RUN git clone http://github.com/howrujh/MyConf ~/github/myconf
RUN git clone http://github.com/howrujh/MyScript ~/github/myscript

RUN ln -s ~/github/myconf/.tmux.conf ~/.tmux.conf
RUN ln -s ~/github/myconf/.emacs ~/.emacs
RUN touch ~/.emacs_disable.el
RUN echo "(setq disable_php-mode t) (setq disable_python-mode t) (setq disable_go-mode t) (setq disable_evil t) (setq disable_nxml-mode t)" >> ~/.emacs_disable.el

RUN echo "if [ -f ~/github/myconf/.my_bash_profile ]; then . ~/github/myconf/.my_bash_profile fi" >> ~/.profile

RUN echo "if [ -f ~/github/myconf/.my_bashrc ]; then . ~/github/myconf/.my_bashrc fi" >> ~/.bashrc

# PROJECT DIRECTORY MOUNT
RUN mkdir ~/project/

# SSH 관련 설정
RUN mkdir /var/run/sshd

# Root 비밀번호 설정
RUN echo 'root:123456789' |chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# SSH 포트 설정
# HostOS의 랜덤포트 -> Container 22번 포트를 바라보게 합니다.
# 즉, 외부에서 HostOS의 랜덤 포트로 접속하면 해당 Container에 접속 할수 있습니다.
# 더 자세한건 http://docs.docker.io/reference/builder/#expose 를 참고 하세요.
EXPOSE 22

# SSH 실행
CMD ["/usr/sbin/sshd", "-D"]
