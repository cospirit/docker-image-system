# Docker Image - System
[![Image version](https://images.microbadger.com/badges/version/ardeveloppement/system.svg)][microbadger]
[![Image layers](https://images.microbadger.com/badges/image/ardeveloppement/system.svg)][microbadger]
[![CircleCI](https://circleci.com/gh/ArDeveloppement/docker-image-system.svg?style=shield&circle-token=aafc265e52c67ba156b7baa402d68ba91aebb93b)][circleci]

## Development workflow

1. Do your job :)
2. Update CHANGELOG.md
3. Update README.md if necessary
4. Increment `VERSION` file following semver paradigm
5. Build: `make build` (image will be locally tagged `latest`)
6. Add & run tests
7. Tag: `make tag`
8. Push: `make push`

## Versioning

This image follows a pseudo semver versioning, where 3 tags are published for each version, one `major`, one `major.minor` and one `major.minior.patch`.

For instance, pushing a `1.2.3` version, the following tags are available:
* `1`
* `1.2`
* `1.2.3`

This way, an application could reliabily be based on tag `1`, with the semver insurance that no breaking changes will be introduced during its all lifetime.

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

**APP**: define type of application. Can leverage parameters like launched services or web server public path.

Available values:
  - `angular`
  - `html`
  - `php`
  - `silex`
  - `symfony_2`
  - `symfony`
  - `vuejs`
  - `nuxt`

**NUXT_COMMAND** : define command to start nuxt server. The default value starts Nuxt in production mode.

Default value: `npx nuxt-start`

**NGINX_DIRECTIVES**: include pre-defined nginx inclusions directives. Must be in json array format.

Default value: `["gzip", "error", "assets"]`

Available values:
  - `gzip` *handle gzip compression*
  - `error` *handle errors*
  - `assets` *handle assets*

**PHP_VERSION**: define php version to use. Plumbering will internally take place to set alternatives, symlinks or paths accordingly:

Available values:
  - `7.2`
  - `7.3`
  - `7.4` *(default)*

**PHP_MODULES_EXTRA**: define extra php modules to load. Be careful of some subtleties, where some modules have hidden dependencies:
  - `mysqlnd` *mysqlnd pdo_mysql*
  - `redis` *redis igbinary*

**PHP_FPM_POOL_PM_MAX_CHILDREN**: define `pm.max_children` php fpm option. See: http://php.net/manual/en/install.fpm.configuration.php

Default value: `5`

**PHP_FPM_POOL_PM_START_SERVERS**: define `pm.start_servers` php fpm option. See: http://php.net/manual/en/install.fpm.configuration.php

Default value: `2`

**PHP_FPM_POOL_PM_MIN_SPARE_SERVERS**: define `pm.min_spare_servers` php fpm option. See: http://php.net/manual/en/install.fpm.configuration.php

Default value: `1`

**PHP_FPM_POOL_PM_MAX_SPARE_SERVERS**: define `pm.max_spare_servers` php fpm option. See: http://php.net/manual/en/install.fpm.configuration.php

Default value: `3`


[microbadger]: https://microbadger.com/images/ardeveloppement/system
[circleci]:    https://circleci.com/gh/ArDeveloppement/docker-image-system
