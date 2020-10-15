# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.1] - 2020-10-15
### Added
- Environment variable `PHP_MAX_INPUT_VARS`
- Environment variable `PHP_FPM_MAX_INPUT_VARS`
- Environment variable `PHP_CLI_MAX_INPUT_VARS`

## [2.0] - 2020-06-20
### Added
- Php 7.4.7 (cli/fpm)
- Php Extension - AMQP

### Changed
- Update Supervisor 4.2.0
- Update Gosu 1.12
- Update Gomplate 3.7.0
- Change `symfony_4` application with `symfony`
- Update Php 7.2.31 (cli/fpm)
- Update Php 7.3.19 (cli/fpm)
- Update Composer 1.10.7
- Update Composer plugin hirak/prestissimo 0.3.10
- Update Composer plugin sllh/composer-versions-check v2.0.4
- Update Composer plugin pyrech/composer-changelogs v1.7.1
- Update NodeJS 12.18.1
- Update Goss v0.3.12
- Update dgoss

### Removed
- PHP 7.1

## [1.5.0] - 2020-04-19
### Added
- Environment variable `NUXT_COMMAND`

## [1.4.1] - 2020-04-19
### Changed
- Update Node 12.16.1
- Update Php 7.2.28 (cli/fpm)
- Update Php 7.3.15 (cli/fpm)
- Update nginx 1.16.1
- Update yarn 1.22.4

## [1.4.0] - 2019-11-08
### Added
- Php 7.1.33 (cli/fpm)

### Changed
- Update Php 7.2.24
- Update Php 7.3.11
- Update Composer 1.9.1
- Update Composer plugin pyrech/composer-changelogs v1.7.0

## [1.3.0] - 2019-10-15
### Added
- Handle Nuxt application
    - Add nginx configuration
    - Add `nuxt-start` in supervisor
    
### Changed
- Update Php 7.2.23
- Update Php 7.3.10
- Update Yarn 1.19.1
- Update NodeJS 8.16.2

## [1.2.2] - 2019-07-01
### Fixed
- Handle correctly existing group when `GROUP_ID` is specified (especially when
  using this image on mac osx, where default user id is `502` and default group
  id is `20`, which is an already existing debian system group)

## [1.2.1] - 2019-06-11
### Added
- Introduce circleci tests

### Changed
- Update Gomplate 3.5.0
- Update Supervisor 4.0.3
- Update Php 7.1.30
- Update Php 7.2.19
- Update Php 7.3.6
- Update Composer 1.8.6

## [1.2.0] - 2019-03-26
### Fixed
- Nginx config for Static service dev environment

### Changed
- Update Php 7.1.29
- Update Php 7.2.18
- Update Php 7.3.5
- Update Composer 1.8.5
- Update Composer plugin hirak/prestissimo 0.3.9
- Update Node 8.16.0
- Update Yarn 1.16.0

### Added
- Php Extension - PostgreSQL

## [1.1.0] - 2019-02-19
### Changed
- System applications versions as building docker environment variables
- Update Gomplate 3.2.0
- Update Php 7.2.15
- Update Php 7.3.2
- Update Composer 1.8.4

### Added
- Environment variable `NGINX_DIRECTIVES`

## [1.0.1] - 2019-01-30
### Changed
- Update Supervisor 3.3.5
- Update nginx 1.14.2
- Update Node 8.15.0
- Update Yarn 1.13.0
- Update Php 7.1.26
- Update Php 7.2.14
- Update Php 7.3.1
- Update Composer 1.8.3
- Keep apt packaging packages so that installing packages after build does not raises warnings anymore

## [1.0.0] - 2018-12-13
### Changed
- Update Gosu 1.11
- Update Gomplate 3.1.0
- Update Nginx 1.14.2
- Update Node 8.14.0
- Update Yarn 1.12.3
- Update Php 7.1.25
- Update Php 7.2.13
- Default Php version to 7.3
- Update Composer 1.8.0
- Introduce pseudo semver versionning

### Added
- Php 7.3.0
- Php Extension - Redis
- Environment variable `PHP_FPM_POOL_PM_MAX_CHILDREN`
- Environment variable `PHP_FPM_POOL_PM_START_SERVERS`
- Environment variable `PHP_FPM_POOL_PM_MIN_SPARE_SERVERS`
- Environment variable `PHP_FPM_POOL_PM_MAX_SPARE_SERVERS`

## [0.2.0] - 2018-10-30
### Added
- From debian stretch (slim)
- Disable irrelevants apt-key warnings
- Disable all debian user interaction
- Vim (Debian package)
- Less (Debian package)
- Procps (Debian package)
- Sudo (Debian package)
- Make (Debian package)
- Git (Debian package)
- Unzip (Debian package)
- User "app" (Uid 1000) / Group "app" (Gid 1000)
- User "app" passwordless sudoer
- Disable sudo env resetting
- Gosu 1.10
- Gomplate 3.0.0
- Supervisor 3.3.4
- Nginx 1.14.0
- Node 8.12.0
- Yarn 1.9.4
- Php 7.1.23 (cli/fpm)
- Php 7.2.11 (cli/fpm)
- Php Extension - Json
- Php Extension - OPcache
- Php Extension - Readline
- Php Extension - Curl
- Php Extension - Xml
- Php Extension - Mbstring
- Php Extension - Intl
- Php Extension - APCu
- Php Extension - MySQL
- Composer 1.7.2
- Composer plugin hirak/prestissimo 0.3.8
- Composer plugin sllh/composer-versions-check 2.0.3
- Composer plugin pyrech/composer-changelogs 1.6.0
