# Docker Image - System

## Testing

Note: tests run locally, using [Goss](https://goss.rocks), and `latest`docker image tag

Run test suite:
```
make test
```

Run one specific test:
```
cd tests/[test]
./run
```

One can also works interactively on a specific test using (See [DGoss documentation](https://github.com/aelsabbahy/goss/tree/master/extras/dgoss)):
```
./edit
```

## Environment variables

* **APP**: define type of application. Can leverage parameters like launched services or web server public path.
Available values:
    * angular
    * html
    * php
    * silex
    * symfony_2
    * symfony_4
    * vuejs

* **PHP_VERSION**: define php version to use. Plumbering will internally take place to set alternatives, symlinks or paths accordingly:
Available values:
    * 7.1
    * 7.2
    * 7.3 *(default)*

* **PHP_MODULES_EXTRA**: define extra php modules to load. Be careful of some subtleties, where some modules have hidden dependencies:
    * mysqlnd: *mysqlnd pdo_mysql*
    * redis: *redis igbinary*
