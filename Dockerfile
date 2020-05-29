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
        && apt-get install -y xvfb wget openjdk-8-jre gnupg2 \
        && npm install -g protractor@${PROTRACTOR_VERSION} minimist@1.2.5 \
    # prepaire user and directories
        && mkdir "/protractor" \
        && useradd -Ums /bin/bash protractor \
    # Clean up
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

COPY --chown=protractor:protractor "./files/entrypoint.sh" "/entrypoint.sh"

## BROWSER SPECIFIC PART
ARG BROWSER_PACKAGE='google-chrome-stable'
ENV BROWSER_PACKAGE=${BROWSER_PACKAGE}
ARG BROWSER_VERSION='83'
ENV BROWSER_VERSION=${BROWSER_VERSION}
ARG WEBDRIVER_PACKAGE='chromedriver'
ENV WEBDRIVER_PACKAGE=${WEBDRIVER_PACKAGE}
ARG WEBDRIVER_VERSION='83.0.4103.39'
ENV WEBDRIVER_VERSION=${WEBDRIVER_VERSION}

RUN set -x \
    # Updating and installing packages
        && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list \
        && wget -q -O - 'https://dl-ssl.google.com/linux/linux_signing_key.pub' | apt-key add - \
        && apt-get update \
        && apt-get install --no-install-recommends -y ${BROWSER_PACKAGE}=${BROWSER_VERSION}\* \
    # Configure webdriver
        && node ./webdriver-versions.js --${WEBDRIVER_PACKAGE} ${WEBDRIVER_VERSION} \
        && webdriver-manager update \
    # Clean up
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

USER protractor
WORKDIR "/protractor"
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
