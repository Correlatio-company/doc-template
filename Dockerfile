FROM pandoc/latex:latest-ubuntu
ADD . /src/
RUN apt-get update -yq \
    && apt-get install npm nodejs -yq \
    && npm install --global mermaid-filter
VOLUME /artifacts
ENTRYPOINT ["/src/entry.sh"]