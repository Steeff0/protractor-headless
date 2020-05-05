#!/bin/bash

echo ""
echo "Starting container with the following commands: $*"

if [ "$1" == "protractor" ];
then
  shift

  echo ""
  echo "Starting protractor with the following arguments: $*"
  echo "Using a screen resolution of ${SCREEN_RES}"

  echo "Executing command: xvfb-run --server-args=\"-screen 0 ${SCREEN_RES}\" -a protractor $*"
  xvfb-run --server-args="-screen 0 ${SCREEN_RES}" -a protractor "$@"
else
  echo "executing $*"
  exec "$@"
fi