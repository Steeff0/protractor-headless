FROM node:14-slim
LABEL maintainer="Steven Gerritsen <steven.gerritsen@gmail.com>"

ENV CHROME_PACKAGE="google-chrome-stable_81.0.4044.92-1_amd64.deb"
ENV NODE_PATH=/usr/local/lib/node_modules:/protractor/node_modules
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null
ENV SCREEN_RES=1280x1024x24

COPY "./files/webdriver-versions.js" "./webdriver-versions.js"

RUN set -x \
    # Updating and installing packages
        && echo "deb http://ftp.us.debian.org/debian sid main" >> /etc/apt/sources.list \
        && mkdir -p "/usr/share/man/man1" \
        && apt-get update \
        && apt-get install -y xvfb wget sudo openjdk-8-jre \
    # Instal and configure Protractor
        && npm install -g protractor minimist@1.2.0 \
    # Install Chrome
        && wget "https://github.com/webnicer/chrome-downloads/raw/master/x64.deb/${CHROME_PACKAGE}" \
        && dpkg --unpack "${CHROME_PACKAGE}" \
        && apt-get install -f -y \
    # Clean up
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* \
        && rm ${CHROME_PACKAGE}

RUN set -x \
    # Configuring protractor
        && node ./webdriver-versions.js --chromedriver 2.32 \
        && webdriver-manager update \
    #prepaire user and directories
        && mkdir "/protractor" \
        && addgroup protractor \
        && adduser --home "/etc/protractor" --ingroup protractor --disabled-password protractor

COPY "./files/environment" "/etc/sudoers.d/"

USER protractor
COPY --chown=protractor:protractor "./files/entrypoint.sh" "/entrypoint.sh"

WORKDIR "/protractor"
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
