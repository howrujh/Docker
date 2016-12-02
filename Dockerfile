# Dev

from    ubuntu:latest

run		 sed -i 's/archive.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list
run		apt-get update

run		apt-get install -y git emacs cscope
run		apt-get install -y openssh-server aptitude net-tools curl

# SSH ���� ����
RUN mkdir /var/run/sshd

# Root ��й�ȣ ����
RUN echo 'root:123456789' |chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# SSH ��Ʈ ����
# HostOS�� ������Ʈ -> Container 22�� ��Ʈ�� �ٶ󺸰� �մϴ�.
# ��, �ܺο��� HostOS�� ���� ��Ʈ�� �����ϸ� �ش� Container�� ���� �Ҽ� �ֽ��ϴ�.
# �� �ڼ��Ѱ� http://docs.docker.io/reference/builder/#expose �� ���� �ϼ���.
EXPOSE 22

# SSH ����
CMD ["/usr/sbin/sshd", "-D"]
