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
ENV CHROME_PACKAGE="google-chrome-stable_81.0.4044.92-1_amd64.deb"
ENV CHROMEDRIVER_VERSION=81.0.4044.138
ENV SELENIUM_BROWSER='chrome'

RUN set -x \
    # Install Chrome
        && wget "https://github.com/webnicer/chrome-downloads/raw/master/x64.deb/${CHROME_PACKAGE}" \
        && dpkg --unpack "${CHROME_PACKAGE}" \
        && apt-get update \
        && apt-get install -fy \
        && rm ${CHROME_PACKAGE} \
    # Configure webdriver
        && node ./webdriver-versions.js --chromedriver ${CHROMEDRIVER_VERSION} \
        && webdriver-manager update \
    # Clean up
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

USER protractor
WORKDIR "/protractor"
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
