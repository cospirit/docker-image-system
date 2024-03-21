FROM debian:buster-slim

LABEL maintainer="AR Developpement <support-arconnect@cospirit.com>"

RUN \
    ############
    # Versions #
    ############
    GOSU_VERSION="1.12" \
    GOMPLATE_VERSION="3.7.0" \
    SUPERVISOR_VERSION="4.2.2" \
    NGINX_VERSION="1.22.*" \
    NODE_VERSION="16" \
    ##########
    # System #
    ##########
    \
    BUILD_PACKAGES=" \
        python-setuptools \
        python-pip \
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
    && curl -sSL https://github.com/hairyhenderson/gomplate/releases/download/v${GOMPLATE_VERSION}/gomplate_linux-amd64-slim \
        -o /usr/local/bin/gomplate \
    && chown root:root /usr/local/bin/gomplate && chmod +x /usr/local/bin/gomplate \
    \
    ##############
    # Supervisor #
    ##############
    \
    && apt-get install -y --no-install-recommends \
        python-pkg-resources \
    && pip install supervisor==${SUPERVISOR_VERSION} \
    \
    #########
    # Nginx #
    #########
    \
    && echo "deb http://nginx.org/packages/debian/ buster nginx" > /etc/apt/sources.list.d/nginx.list \
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
    && echo "deb https://deb.nodesource.com/node_${NODE_VERSION}.x buster main" > /etc/apt/sources.list.d/node.list \
    && curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key \
        | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
    && curl -sSL https://dl.yarnpkg.com/debian/pubkey.gpg \
        | apt-key add - \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        nodejs \
        yarn
RUN yarn global add node-gyp;

    #######
    # Php #
    #######

RUN apt install wget lsb-release ca-certificates -y
RUN curl -sS https://packages.sury.org/php/apt.gpg | apt-key add -
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list
RUN apt update

RUN apt install -y --no-install-recommends \
        php7.2-cli php7.3-cli php7.4-cli php8.1-cli \
        php7.2-fpm php7.3-fpm php7.4-fpm php8.1-fpm \
        # Modules - Default
        php7.2-json php7.3-json php7.4-json \
        php7.2-opcache php7.3-opcache php7.4-opcache php8.1-opcache \
        php7.2-readline php7.3-readline php7.4-readline php8.1-readline \
        php7.2-curl php7.3-curl php7.4-curl php8.1-curl \
        php7.2-xml php7.3-xml php7.4-xml php8.1-xml \
        php7.2-mbstring php7.3-mbstring php7.4-mbstring php8.1-mbstring \
        php7.2-intl php7.3-intl php7.4-intl php8.1-intl \
        php7.2-apcu-bc php7.3-apcu-bc php7.4-apcu php8.1-apcu \
        # Modules - Extra
        php7.2-gd php7.3-gd php7.4-gd php8.1-gd \
        php7.2-ldap php7.3-ldap php7.4-ldap php8.1-ldap \
        php7.2-zip php7.3-zip php7.4-zip php8.1-zip \
        php7.2-mysql php7.3-mysql php7.4-mysql php8.1-mysql \
        php7.2-pgsql php7.3-pgsql php7.4-pgsql php8.1-pgsql \
        php7.2-amqp php7.3-amqp php7.4-amqp php8.1-amqp \
        php7.2-redis php7.3-redis php7.4-redis php8.1-redis \
        php7.2-xdebug php7.3-xdebug php7.4-xdebug php8.1-xdebug\
    # Composer
    && curl -sSL https://getcomposer.org/installer \
        | php -- --install-dir /usr/local/bin --filename composer;

RUN su app -l -c "composer global config --no-plugins allow-plugins.pyrech/composer-changelogs true"

RUN su app -l -c "composer global config --no-plugins allow-plugins.sllh/composer-versions-check true"

RUN su app -l -c "composer global require pyrech/composer-changelogs sllh/composer-versions-check && rm -rf ~/.composer/cache"

    #########
    # Clean #
    #########
RUN apt-get purge -y --auto-remove ${BUILD_PACKAGES} \
    && rm -rf \
        /var/lib/apt/lists/* \
        /var/cache/debconf/*-old \
        /var/lib/dpkg/*-old \
    && truncate -s 0 /var/log/*.log \
    && truncate -s 0 /var/log/**/*.log

##########
# Config #
##########

COPY etc/supervisor/ /etc/supervisor/
COPY etc/nginx/      /etc/nginx/
COPY etc/php/        /etc/php/7.2/
COPY etc/php/        /etc/php/7.3/
COPY etc/php/        /etc/php/7.4/
COPY etc/php/        /etc/php/8.1/

COPY root/ /root/

ENV APP="" \
    PHP_VERSION="7.4" \
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
