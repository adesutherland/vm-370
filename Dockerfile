# Dockerfile for the VM/370 Container
FROM	ubuntu:latest

RUN	apt-get update
RUN apt-get install --no-install-recommends -y unzip wget ca-certificates
RUN apt-get install --no-install-recommends -y hercules

WORKDIR     /opt/hercules/vm370

# HercControl
RUN wget -nv https://github.com/adesutherland/HercControl/releases/download/v1.1.0/HercControl-Ubuntu.zip
RUN unzip HercControl-Ubuntu.zip && \
    chmod +x HercControl-Ubuntu/herccontrol && \
    cp HercControl-Ubuntu/herccontrol /usr/local/bin && \
	rm -r HercControl-Ubuntu && \
	rm HercControl-Ubuntu.zip

# Local Config files
COPY build.sh hercules.conf start_vm370.sh ./
RUN chmod +x build.sh && \
    chmod +x start_vm370.sh && \
	  chmod -x hercules.conf

# Build & Sanity Test VM/370 Host
RUN /opt/hercules/vm370/build.sh && \
    rm /opt/hercules/vm370/build.sh

# Create the final Docker Image
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
