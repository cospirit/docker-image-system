FROM debian:stretch-slim

LABEL maintainer="AR Developpement <support-arconnect@cospirit.com>"

RUN \
    ############
    # Versions #
    ############
    GOSU_VERSION="1.11" \
    GOMPLATE_VERSION="3.5.0" \
    SUPERVISOR_VERSION="4.0.3" \
    NGINX_VERSION="1.14.*" \
    ##########
    # System #
    ##########
    \
    BUILD_PACKAGES=" \
        python-setuptools \
    " \
    # Disable irrelevants apt-key warnings
    && export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE="1" \
    # Disable all debian user interaction
    && export DEBIAN_FRONTEND="noninteractive" \
    && apt-get update \
    && apt-get install -y --no-install-recommends ${BUILD_PACKAGES} \
        apt-utils \
        gnupg \
        dirmngr \
        apt-transport-https \
        vim-tiny \
        less \
        procps \
        curl \
        ca-certificates \
        sudo \
        make \
        git \
        unzip \
    # User
    && adduser --disabled-password --gecos "" app \
    # Sudo
    && echo "app ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/app \
    && echo "Defaults !env_reset" > /etc/sudoers.d/env \
    # Workdir
    && mkdir -p /srv/app && chown app:app /srv/app \
    # Entrypoint directory
    && mkdir -p /home/app/entrypoint.d && chown app:app /home/app/entrypoint.d \
    # Gosu
    && curl -sSL https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64 \
        -o /usr/local/bin/gosu \
    && chown root:root /usr/local/bin/gosu && chmod +x /usr/local/bin/gosu \
    # Gomplate
    && curl -sSL https://github.com/hairyhenderson/gomplate/releases/download/v${GOMPLATE_VERSION}/gomplate_linux-amd64 \
        -o /usr/local/bin/gomplate \
    && chown root:root /usr/local/bin/gomplate && chmod +x /usr/local/bin/gomplate \
    \
    ##############
    # Supervisor #
    ##############
    \
    && apt-get install -y --no-install-recommends \
        python-pkg-resources \
    && easy_install supervisor==${SUPERVISOR_VERSION} \
    \
    #########
    # Nginx #
    #########
    \
    && echo "deb http://nginx.org/packages/debian/ stretch nginx" > /etc/apt/sources.list.d/nginx.list \
    && curl -sSL http://nginx.org/keys/nginx_signing.key \
        | apt-key add - \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        nginx=${NGINX_VERSION} \
    \
    ########
    # Node #
    ########
    \
    && echo "deb https://deb.nodesource.com/node_8.x stretch main" > /etc/apt/sources.list.d/node.list \
    && curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key \
        | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
    && curl -sSL https://dl.yarnpkg.com/debian/pubkey.gpg \
        | apt-key add - \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        nodejs \
        yarn \
    \
    #######
    # Php #
    #######
    \
    && echo "deb https://packages.sury.org/php/ stretch main" > /etc/apt/sources.list.d/php.list \
    && curl -sSL https://packages.sury.org/php/apt.gpg --output /etc/apt/trusted.gpg.d/php.gpg \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        php7.2-cli php7.3-cli \
        php7.2-fpm php7.3-fpm \
        # Modules - Default
        php7.2-json php7.3-json \
        php7.2-opcache php7.3-opcache \
        php7.2-readline php7.3-readline \
        php7.2-curl php7.3-curl \
        php7.2-xml php7.3-xml \
        php7.2-mbstring php7.3-mbstring \
        php7.2-intl php7.3-intl \
        php-apcu-bc \
        # Modules - Extra
        php7.2-zip php7.3-zip \
        php7.2-mysql php7.3-mysql \
        php7.2-pgsql php7.3-pgsql \
        php-redis \
        php-xdebug \
    # Composer
    && curl -sSL https://getcomposer.org/installer \
        | php -- --install-dir /usr/local/bin --filename composer \
    && su app -l -c "\
        composer global require \
            hirak/prestissimo \
            sllh/composer-versions-check \
            pyrech/composer-changelogs \
        && rm -rf ~/.composer/cache \
    " \
    \
    #########
    # Clean #
    #########
    \
    && apt-get purge -y --auto-remove ${BUILD_PACKAGES} \
    && rm -rf /var/lib/apt/lists/*

##########
# Config #
##########

COPY etc/supervisor/ /etc/supervisor/
COPY etc/nginx/      /etc/nginx/
COPY etc/php/        /etc/php/7.2/
COPY etc/php/        /etc/php/7.3/

COPY root/ /root/

ENV APP="" \
    PHP_VERSION="7.3" \
    PHP_MODULES_EXTRA="" \
    PHP_DATE_TIMEZONE="UTC" \
    NGINX_DIRECTIVES="[\"gzip\", \"error\", \"assets\"]" \
    SYSTEM_TIMEZONE="Etc/UTC" \
    ENVIRONMENT="production"

RUN /root/configure

ONBUILD ARG DEFAULT_APP
ONBUILD ARG DEFAULT_PHP_VERSION
ONBUILD ARG DEFAULT_PHP_MODULES_EXTRA
ONBUILD ARG DEFAULT_PHP_DATE_TIMEZONE
ONBUILD ARG DEFAULT_NGINX_DIRECTIVES
ONBUILD ARG DEFAULT_SYSTEM_TIMEZONE
ONBUILD ARG DEFAULT_ENVIRONMENT

ONBUILD ENV APP=${DEFAULT_APP:-${APP}} \
            PHP_VERSION=${DEFAULT_PHP_VERSION:-${PHP_VERSION}} \
            PHP_MODULES_EXTRA=${DEFAULT_PHP_MODULES_EXTRA:-${PHP_MODULES_EXTRA}} \
            PHP_VERSION=${DEFAULT_PHP_VERSION:-${PHP_VERSION}} \
            PHP_DATE_TIMEZONE=${DEFAULT_PHP_DATE_TIMEZONE:-${PHP_DATE_TIMEZONE}} \
            NGINX_DIRECTIVES=${DEFAULT_NGINX_DIRECTIVES:-${NGINX_DIRECTIVES}} \
            SYSTEM_TIMEZONE=${DEFAULT_SYSTEM_TIMEZONE:-${SYSTEM_TIMEZONE}} \
            ENVIRONMENT=${DEFAULT_ENVIRONMENT:-${ENVIRONMENT}}

ONBUILD RUN /root/configure

#######
# Run #
#######

ENTRYPOINT ["/root/entrypoint"]

WORKDIR /srv/app

CMD ["supervisord", "--configuration", "/etc/supervisor/app.conf"]
