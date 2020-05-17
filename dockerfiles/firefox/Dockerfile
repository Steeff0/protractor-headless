FROM node:14-slim
LABEL maintainer="Steven Gerritsen <steven.gerritsen@gmail.com>"

ENV NODE_PATH=/usr/local/lib/node_modules:/protractor/node_modules
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null
ENV SCREEN_RES=1280x1024x24
ENV PROTRACTOR_VERSION=5.4.4

COPY "./files/webdriver-versions.js" "./webdriver-versions.js"

RUN set -x \
    # Updating and installing packages
        && echo "deb http://ftp.us.debian.org/debian sid main" >> /etc/apt/sources.list \
        && mkdir -p "/usr/share/man/man1" \
        && apt-get update \
        && apt-get install -y xvfb wget sudo openjdk-8-jre \
        && npm install -g protractor@${PROTRACTOR_VERSION} minimist@1.2.5 \
    # prepaire user and directories
        && mkdir "/protractor" \
        && useradd -Ums /bin/bash protractor \
    # Clean up
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

COPY --chown=protractor:protractor "./files/entrypoint.sh" "/entrypoint.sh"

## BROWSER SPECIFIC PART
ENV FIREFOX_VERSION=76
ENV GECKODRIVER_VERSION=v0.26.0
ENV SELENIUM_BROWSER='firefox'

RUN set -x \
    # Install Firefox
        && apt-get update \
        && apt-get install firefox=${FIREFOX_VERSION}\* -y \
    # Configure webdriver
        && node ./webdriver-versions.js --geckodriver ${GECKODRIVER_VERSION} \
        && webdriver-manager update \
    # Clean up
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

USER protractor
WORKDIR "/protractor"
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
