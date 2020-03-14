FROM amd64/debian:stretch-slim

ENV PATH="/usr/local/texlive/2020/bin/x86_64-linux:${PATH}"

RUN echo -e "Dir::Cache "";\nDir::Cache::archives "";" > /etc/apt/apt.conf.d/02nocache && \
        apt update && apt install -y make perl wget xz-utils tar && mkdir /tmp/install-tl-unx

COPY texlive.profile /tmp/install-tl-unx/
COPY packages.txt /tmp/packages.txt

RUN wget -qO - ftp://tug.org/historic/systems/texlive/2019/tlnet-final/install-tl-unx.tar.gz | \
    tar -xz -C /tmp/install-tl-unx --strip-components=1
RUN /tmp/install-tl-unx/install-tl \
      --profile=/tmp/install-tl-unx/texlive.profile
RUN rm -rf /tmp/install-tl-unx

RUN tlmgr install $(cat /tmp/packages.txt) && rm /tmp/packages.txt

WORKDIR /workdir
VOLUME ["/workdir"]

CMD ["bash"]
