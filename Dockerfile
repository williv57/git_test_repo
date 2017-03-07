FROM docker.sas.com/centos/baseconsul:latest
MAINTAINER "William Ivey <william.ivey@sas.com>"

COPY startCas.sh /opt/cas/
COPY logcfg.xml /opt/cas/
COPY casconfig.lua /opt/sas/
COPY perms.xml /opt/cas/
COPY grid.hosts /opt/cas/
COPY cas.hosts /opt/cas/
#COPY setinit.sas /opt/sas/viya/config/etc/cas/default/setinit.sas

COPY libaio-0.3.107-10.el6.x86_64.rpm .
RUN yum -y install libaio-0.3.107-10.el6.x86_64.rpm
COPY oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm .
RUN yum -y install oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm
RUN echo "ln -s /usr/lib/oracle/12.1/client64/lib/libclntsh.so.12.1 /usr/lib/oracle/12.1/client64/lib/libclntsh.so.11.1" >> /etc/rc.local

COPY wrapper.sh .
COPY SAS_Visual_Investigator_playbook.tgz .
RUN tar -xf SAS_Visual_Investigator_playbook.tgz -C /opt
RUN ./wrapper.sh
RUN yum -y install "@SAS Data Connector to ODBC" "@SAS Data Connector to PostgreSQL" "@SAS Data Connector to Oracle" "@CAS for SAS Visual Investigator"
COPY perms.xml /opt/sas/viya/config/etc/cas/default/
RUN useradd -g sas videmo
COPY cas.settings /opt/sas/viya/home/SASFoundation/
RUN chown sas.sas /opt/sas/viya/home/SASFoundation/cas.settings
EXPOSE 5577
CMD [ "/opt/cas/startCas.sh" ]