FROM debian:stretch-slim

LABEL maintainer="AR Developpement <support-arconnect@cospirit.com>"

RUN \
    ##########
    # System #
    ##########
    \
    BUILD_PACKAGES=" \
        apt-utils \
        gnupg \
        curl \
    " \
    # Disable irrelevants apt-key warnings
    && export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE="1" \
    # Disable all debian user interaction
    && export DEBIAN_FRONTEND="noninteractive" \
    && apt-get update \
    && apt-get install -y --no-install-recommends ${BUILD_PACKAGES} \
        apt-transport-https \
        vim-tiny \
        mmv \
        ca-certificates \
        sudo \
        supervisor \
        make \
        git \
        unzip \
        gettext-base \
    && rm -rf /var/lib/apt/lists/* \
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
    && curl -sSL https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64 \
        -o /usr/local/bin/gosu \
    && chown root:root /usr/local/bin/gosu && chmod +x /usr/local/bin/gosu \
    # Gomplate
    && curl -sSL https://github.com/hairyhenderson/gomplate/releases/download/v3.0.0/gomplate_linux-amd64-slim \
        -o /usr/local/bin/gomplate \
    && chown root:root /usr/local/bin/gomplate && chmod +x /usr/local/bin/gomplate \
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
        nginx=1.14.* \
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
        php7.1-cli php7.2-cli \
        php7.1-fpm php7.2-fpm \
        php7.1-json php7.2-json \
        php7.1-opcache php7.2-opcache \
        php7.1-readline php7.2-readline \
        php7.1-curl php7.2-curl \
        php7.1-xml php7.2-xml \
        php7.1-mbstring php7.2-mbstring \
        php7.1-intl php7.2-intl \
        php-apcu-bc \
        php7.1-zip php7.2-zip \
        php7.1-mysql php7.2-mysql \
        php-xdebug \
    # Create run directory
    && mkdir -p /run/php \
    # Disable uncommon modules
    && phpdismod -v ALL -s ALL zip mysqli mysqlnd pdo_mysql xdebug \
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

COPY etc/supervisor/     /etc/supervisor/
COPY etc/nginx/          /etc/nginx/
COPY etc/php/            /etc/php/7.1/
COPY etc/php/            /etc/php/7.2/

#######
# Run #
#######

COPY root/ /root/

ENTRYPOINT ["/root/entrypoint"]

WORKDIR /srv/app

CMD ["bash"]
