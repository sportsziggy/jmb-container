FROM alpine:3

LABEL maintainer="craumix <soeren@guertler.net>"

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="craumix/jmusicbot"
LABEL org.label-schema.description="Java based Discord music bot"
LABEL org.label-schema.url="https://github.com/jagrosh/MusicBot"
LABEL org.label-schema.vcs-url="https://github.com/craumix/jmb-container"
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.version=$VERSION
LABEL org.label-schema.docker.cmd="docker run -v ./config:/jmb/config -d craumix/jmusicbot"

RUN apk add --update --no-cache \
    openjdk11-jre-headless tini

#No downloadable example config since 0.2.10
RUN mkdir -p /jmb/config
ADD --chmod=644 https://cdn.discordapp.com/attachments/185037029384388608/1291372385361989673/JMusicBot-0.4.3-yt-oauth2-348fc3c.jar?ex=67217a01&is=67202881&hm=b9e41ca74fbabe15d28e3b4d7bca4eb090fd2f6c3107062e2d9840dcfa3b7555& /jmb/JMusicBot.jar
ADD --chmod=644 https://github.com/jagrosh/MusicBot/releases/download/0.2.9/config.txt /jmb/config/config.txt

COPY --chmod=755 ./docker-entrypoint.sh /jmb

VOLUME /jmb/config

RUN addgroup -S appgroup -g 10001 && \
    adduser -S appuser -G appgroup -u 10000

USER appuser

WORKDIR /jmb/config

ENTRYPOINT ["/sbin/tini", "--", "/jmb/docker-entrypoint.sh"]
