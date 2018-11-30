
FROM node:10-slim

LABEL version="1.0.0"
LABEL repository="https://github.com/w9jds/firebase-action"
LABEL homepage="https://github.com/w9jds/firebase-action"
LABEL maintainer="Jeremy Shore <w9jds@github.com>"

LABEL com.github.actions.name="GitHub Action for Firebase"
LABEL com.github.actions.description="Wraps the firebase-tools CLI to enable common commands."
LABEL com.github.actions.icon="package"
LABEL com.github.actions.color="red"

RUN npm install -g firebase-tools

COPY LICENSE README.md THIRD_PARTY_NOTICE.md /
COPY "entrypoint.sh" "/entrypoint.sh"

ENTRYPOINT ["/entrypoint.sh"]
CMD ["--help"]