# Docker image of Protractor with headless Chrome

![GitHub Build Status](https://img.shields.io/github/workflow/status/Steeff0/protractor-headless/docker-image-test?style=flat-square)
![GitHub](https://img.shields.io/github/license/Steeff0/protractor-headless?style=flat-square)
![Docker Image Version (latest semver)](https://img.shields.io/docker/v/stevengerritsen/protractor-headless?style=flat-square)

![Docker Pulls](https://img.shields.io/docker/pulls/stevengerritsen/protractor-headless?style=flat-square)
![Docker Stars](https://img.shields.io/docker/stars/stevengerritsen/protractor-headless?style=flat-square)
![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/stevengerritsen/protractor-headless?style=flat-square)

Based on [webnicer/protractor-headles](https://www.github.com/jciolek/docker-protractor-headless)

Protractor end to end testing - dockerised with headless real Chrome. This image is meant as a drop-in replacement for Protractor, so you can use it virtually in the same way you would use Protractor installed directly on your machine.

## Why headless Chrome?

PhantomJS is [discouraged by Protractor creators](https://angular.github.io/protractor/#/browser-setup#setting-up-phantomjs) and for a good reason. It's basically a bag of problems.

## What is headless Chrome anyway?

To be perfectly honest - it is a [real chrome running on xvfb](http://tobyho.com/2015/01/09/headless-browser-testing-xvfb/). Therefore you have every confidence that the tests are run on the real thing.

## What is included in the latest?

The image in the latest version contains the following packages in their respective versions:

* Chrome - 81.0.4044
* Protractor - 5.4.4
* Node.js - 14
* Chromedriver - 81.0.4044

The packages are pinned to those versions so that they should work together without issues.

# Usage

The command below, will run protractor in your current directory.

```
docker run -it --privileged --rm --shm-size 2g -v $(pwd):/protractor protractor-headless protractor [protractor options]
```

The image adds `/protractor/node_modules` directory to its `NODE_PATH` environmental variable, so that it can use Jasmine, Mocha or whatever else the project uses from the project's own node modules. Therefore, Mocha and Jasmine aren't included in the image.

## Why `--privileged`?

Chrome uses sandboxing, therefore if you try and run Chrome within a non-privileged container you will receive the following message:

"Failed to move to new namespace: PID namespaces supported, Network namespace supported, but failed: errno = Operation not permitted".

The [`--privileged`](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities) flag gives the container almost the same privileges to the host machine resources as other processes running outside the container, which is required for the sandboxing to run smoothly.

## Setting up custom screen resolution

The default screen resolution is **1280x1024** with **24-bit color**. You can set a custom screen resolution and color depth via the **SCREEN_RES** env variable, like this:
```
docker run -it --privileged --rm --shm-size 2g -e SCREEN_RES=1920x1080x24 -v $(pwd):/protractor protractor-headless protractor [protractor options]
```

## Test localhost

In order to test on sites running on localhost you have to add the option `--net=host`. This options is required **only** if the dockerised Protractor is run against localhost on the host. Imagine this sscenario: you run an http test server on your local machine, let's say on port 8000. You type in your browser `http://localhost:8000` and everything goes smoothly. Then you want to run the dockerised Protractor against the same localhost:8000. If you don't use `--net=host` the container will receive the bridged interface and its own loopback and so the `localhost` within the container will refer to the container itself. Using `--net=host` you allow the container to share host's network stack and properly refer to the host when Protractor is run against `localhost`.

## Container Commands

If you want to run protractor inside the container before closing it again, you give the commands `protractor [protractor options]`, but run other commands in this container by just change the commands to the thing you want to run. If you want for example run bash inside the container you can use the following command:

```docker run -it --privileged --rm --shm-size 2g -v $(pwd):/protractor protractor-headless bash
```

# Tests
The tests are run with GitHub workflow and include the following:

* image build
* run of the default protractor tutorial tests (included in this project)

It is run with:
```bash
docker image build . --file Dockerfile --tag protractor-headless
docker container run -it --privileged --rm --shm-size 2g -v /$(pwd):/protractor protractor-headless protractor ./tests/conf.js
```

If you want to test it yourself, you can check out this project, build the image and run it with the above mentioned commands.
