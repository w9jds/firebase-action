FROM node:16.16.0-buster

LABEL version="12.4.0"
LABEL repository="https://github.com/w9jds/firebase-action"
LABEL homepage="https://github.com/w9jds/firebase-action"
LABEL maintainer="Jeremy Shore <w9jds@github.com>"

LABEL com.github.actions.name="GitHub Action for Firebase"
LABEL com.github.actions.description="Wraps the firebase-tools CLI to enable common commands."
LABEL com.github.actions.icon="package"
LABEL com.github.actions.color="gray-dark"

RUN apt update && apt-get install --no-install-recommends -y jq openjdk-11-jre && rm -rf /var/lib/apt/lists/*;

RUN npm i -g npm@8.10.0 && npm cache clean --force;
RUN npm i -g pnpm@8.6.11 && npm cache clean --force;
RUN npm i -g firebase-tools@12.4.0 && npm cache clean --force;

COPY LICENSE README.md /
COPY "entrypoint.sh" "/entrypoint.sh"

ENTRYPOINT ["/entrypoint.sh"]
CMD ["--help"]
