FROM mcr.microsoft.com/powershell:lts-debian-bullseye-slim

MAINTAINER github.com/johanngoltz

RUN apt-get update && apt-get upgrade -y \
      && apt-get install -y inotify-tools wget \
      && wget -O pdftk https://gitlab.com/pdftk-java/pdftk/-/jobs/586506030/artifacts/raw/build/native-image/pdftk?inline=false \
      && install pdftk /usr/bin/ \
      && rm ./pdftk \
      && apt-get remove -y wget \
      && apt-get autoremove -y

COPY watch.ps1 /watch.ps1

VOLUME ["/files-in", "/files-out"]

ENTRYPOINT ["pwsh", "watch.ps1"]
