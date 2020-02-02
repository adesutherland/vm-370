# TODO

FROM	ubuntu:latest

RUN	apt-get update 
RUN apt-get install --no-install-recommends -y unzip wget ca-certificates
RUN apt-get install --no-install-recommends -y hercules 

WORKDIR     /opt/hercules/vm370

RUN wget https://github.com/adesutherland/HercControl/releases/download/v1.0.5/HercControl-Ubuntu.zip

RUN unzip HercControl-Ubuntu.zip && \
    chmod +x HercControl-Ubuntu/herccontrol && \
    cp HercControl-Ubuntu/herccontrol /usr/local/bin && \
	rm -r HercControl-Ubuntu && \
	rm HercControl-Ubuntu.zip
	
COPY build.sh hercules.conf start_vm370.sh ./

RUN chmod +x build.sh && \
    chmod +x start_vm370.sh && \
	chmod -x hercules.conf

RUN wget http://www.smrcc.org.uk/members/g4ugm/vm-370/vm370sixpack-1_3_Beta3.zip 

RUN /opt/hercules/vm370/build.sh && \
    rm /opt/hercules/vm370/build.sh


FROM ubuntu:latest  

RUN	apt-get update && \
    apt-get install --no-install-recommends -y hercules c3270 zip unzip netcat && \
    apt-get -y purge $(dpkg --get-selections | grep deinstall | sed s/deinstall//g) && \
    rm -rf /var/lib/apt/lists/*

WORKDIR     /opt/hercules/vm370

COPY --from=0 /opt/hercules/vm370/* ./

COPY --from=0 /usr/local/bin/herccontrol /usr/local/bin/herccontrol

EXPOSE      3270 8038 3505
ENTRYPOINT  ["/opt/hercules/vm370/start_vm370.sh"]