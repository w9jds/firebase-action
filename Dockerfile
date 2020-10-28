FROM node:12.13.0

LABEL version="1.3.1"
LABEL repository="https://github.com/urbanisierung/firebase-action"
LABEL homepage="https://github.com/urbanisierung/firebase-action"
LABEL maintainer="Adam Urban <urbanisierung@github.com>"

LABEL com.github.actions.name="GitHub Action for Firebase"
LABEL com.github.actions.description="Wraps the firebase-tools CLI to enable common commands."
LABEL com.github.actions.icon="package"
LABEL com.github.actions.color="gray-dark"

# git is now required when install firebase-tools
# RUN apk update && apk upgrade && apk add --no-cache git

RUN npm install -g firebase-tools

COPY LICENSE README.md /
COPY "entrypoint.sh" "/entrypoint.sh"

ENTRYPOINT ["/entrypoint.sh"]
CMD ["--help"]
