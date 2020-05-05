# Protractor-Headless
run with:
```bash
winpty docker container run -it --privileged --rm --shm-size 2g -v /$(pwd):/protractor protractor-headless protractor ./tests/conf.js
```
