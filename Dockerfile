FROM nvidia/cuda:10.0-devel-ubuntu16.04
ENTRYPOINT ["/home/miner/run-miner.sh"]

RUN groupadd -g 2000 miner && \
    useradd -u 2000 -g miner -m -s /bin/bash miner && \
    echo 'miner:miner' | chpasswd
RUN apt-get -y update
RUN apt-get -y install git automake libssl-dev libcurl4-openssl-dev wget

COPY run-miner.sh /home/miner/
RUN chmod +x /home/miner/run-miner.sh
RUN chown miner:miner /home/miner/run-miner.sh

USER miner

RUN mkdir /home/miner/cryptodredge \
    && wget "https://github.com/technobyl/CryptoDredge/releases/download/v0.9.2/CryptoDredge_0.9.2_cuda_10.0_linux.tar.gz" -O /home/miner/miner.tar.gz \
    && tar xvf /home/miner/miner.tar.gz -C /home/miner/cryptodredge \
    && chmod 0755 /home/miner && chmod 0755 /home/miner/cryptodredge \
    && rm /home/miner/miner.tar.gz
    
ENV ALGO lyra2v2
ENV MINING_POOL stratum+tcp://vps205351.vps.ovh.ca:4553
ENV USER ""
ENV PASSWORD ""
ADD run-miner.sh /
CMD [‘/home/miner/run-miner.sh’]
