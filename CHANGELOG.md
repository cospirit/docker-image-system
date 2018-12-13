# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Changed
- Update Gosu 1.11
- Update Gotemplate 3.1.0
- Update Nginx 1.14.2
- Update Node 8.14.0
- Update Yarn 1.12.3
- Update Php 7.1.25
- Update Php 7.2.13
- Default Php version to 7.3
- Composer 1.8.0
- Introduce pseudo semver versionning

### Added
- Php 7.3.0
- Php Extension - Redis
- Environment variable "PHP_FPM_POOL_PM_MAX_CHILDREN"
- Environment variable "PHP_FPM_POOL_PM_START_SERVERS"
- Environment variable "PHP_FPM_POOL_PM_MIN_SPARE_SERVERS"

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
