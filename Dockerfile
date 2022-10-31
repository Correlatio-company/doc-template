FROM pandoc/latex:latest-ubuntu
COPY entry.sh package.json package-lock.json puppeteer-config.json /src/
VOLUME /data
WORKDIR /src
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
RUN apt-get update -yq \
    && apt-get install curl wget gnupg -yq \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install nodejs inotify-tools google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 -yq \
    && npm install \
    && rm -rf /var/lib/apt/lists/* 
ENTRYPOINT ["./entry.sh", "../data"]