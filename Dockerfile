FROM node:10-slim

LABEL version="1.1.0"
LABEL repository="https://github.com/fulfillmenttools/firebase-action"
LABEL homepage="https://github.com/fulfillmenttools/firebase-action"
LABEL maintainer="OC Fulfillment Team"

LABEL com.github.actions.name="GitHub Action for Firebase with JDK"
LABEL com.github.actions.description="Wraps the firebase-tools CLI to enable common commands."
LABEL com.github.actions.icon="package"
LABEL com.github.actions.color="gray-dark"

ENV JAVA_HOME="~/jdk"
ENV PATH="${PATH}:${JAVA_HOME}/bin"

RUN apt-get update && apt-get install -y wget
RUN npm install -g firebase-tools
RUN mkdir -p ~/jdk/ && wget -qO- https://github.com/AdoptOpenJDK/openjdk13-binaries/releases/download/jdk-13.0.2%2B8/OpenJDK13U-jre_x64_linux_hotspot_13.0.2_8.tar.gz | tar xvz -C ~/jdk --strip-components=1


COPY LICENSE README.md /
COPY "entrypoint.sh" "/entrypoint.sh"

ENTRYPOINT ["/entrypoint.sh"]
CMD ["--help"]
