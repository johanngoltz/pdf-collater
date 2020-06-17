FROM mcr.microsoft.com/powershell:lts-alpine-3.8

MAINTAINER github.com/johanngoltz

RUN apk update && apk upgrade \
      && apk add pdftk inotify-tools

COPY watch.ps1 /watch.ps1

VOLUME ["/files-in", "/files-out"]

ENTRYPOINT ["pwsh", "watch.ps1"]
