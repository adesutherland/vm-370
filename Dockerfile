# Dockerfile for the VM/370 Container
FROM	ubuntu:latest

RUN	apt-get update
RUN apt-get install --no-install-recommends -y unzip wget netcat ca-certificates
RUN apt-get install --no-install-recommends -y hercules dos2unix regina-rexx

WORKDIR     /opt/hercules/vm370

# Local Config files
COPY *.sh hercules.conf cleandisks.conf ./
RUN dos2unix *.sh hercules.conf cleandisks.conf
RUN chmod +x *.sh && \
	  chmod -x hercules.conf cleandisks.conf

# DASD
COPY disks/ ./disks/

# Build & Sanity Test VM/370 Host
RUN /opt/hercules/vm370/build.sh && \
    rm /opt/hercules/vm370/build.sh

# Cleanup
RUN rm -r ./disks
RUN rm cleandisks.conf


# Create the final Docker Image
FROM ubuntu:latest

RUN	apt-get update && \
    apt-get install --no-install-recommends -y hercules c3270 zip unzip netcat \
    dos2unix regina-rexx wget ca-certificates && \
    apt-get -y purge $(dpkg --get-selections | grep deinstall | sed s/deinstall//g) && \
    rm -rf /var/lib/apt/lists/*

WORKDIR     /opt/hercules/vm370

COPY --from=0 /opt/hercules/vm370/* ./

COPY --from=0 /usr/local/bin/herccontrol /usr/local/bin/herccontrol
COPY --from=0 /usr/local/bin/yata /usr/local/bin/yata

EXPOSE      3270 8038 3505
ENTRYPOINT  ["/opt/hercules/vm370/start_vm370.sh"]
