FROM node:10-slim

LABEL version="1.1.0"
LABEL repository="https://github.com/w9jds/firebase-action"
LABEL homepage="https://github.com/w9jds/firebase-action"
LABEL maintainer="Jeremy Shore <w9jds@github.com>"

LABEL com.github.actions.name="GitHub Action for Firebase with JDK"
LABEL com.github.actions.description="Wraps the firebase-tools CLI to enable common commands."
LABEL com.github.actions.icon="package"
LABEL com.github.actions.color="gray-dark"

ENV JAVA_HOME="/opt/jdk"
ENV PATH="${PATH}:${JAVA_HOME}/bin"

RUN apt-get update && apt-get install -y wget
RUN npm install -g firebase-tools
RUN mkdir -p ${JAVA_HOME} && wget -qO- https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.6%2B10/OpenJDK11U-jdk_x64_linux_hotspot_11.0.6_10.tar.gz | tar xvz -C ${JAVA_HOME} --strip-components=1


COPY LICENSE README.md /
COPY "entrypoint.sh" "/entrypoint.sh"

ENTRYPOINT ["/entrypoint.sh"]
CMD ["--help"]
