user nginx;
worker_processes 1;

error_log stderr warn;
pid /var/run/nginx.pid;

events {
    worker_connections 1024;
    multi_accept on;
    use epoll;
}

daemon off;

http {
{{- if eq (getenv "ENVIRONMENT") "development" }}
    server_tokens on;
{{- else }}
    server_tokens off;
{{- end }}

    default_type application/octet-stream;

    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"'
    ;

    access_log /dev/stdout main;

{{- if getenv "NGINX_REAL_IP_HEADER" }}
    real_ip_header {{ getenv "NGINX_REAL_IP_HEADER" }};
{{- end }}
{{- if getenv "NGINX_SET_REAL_IP_FROM" }}
    {{- range (getenv "NGINX_SET_REAL_IP_FROM" | jsonArray) }}
    set_real_ip_from {{ . }};
    {{- end }}
{{- end }}

{{- if getenv "NGINX_FASTCGI_BUFFERS" }}
    fastcgi_buffers {{ getenv "NGINX_FASTCGI_BUFFERS" }};
{{- end }}
{{- if getenv "NGINX_FASTCGI_MAX_TEMP_FILE_SIZE" }}
    fastcgi_max_temp_file_size {{ getenv "NGINX_FASTCGI_MAX_TEMP_FILE_SIZE" }};
{{- end }}
{{- if getenv "NGINX_FASTCGI_READ_TIMEOUT" }}
    fastcgi_read_timeout {{ getenv "NGINX_FASTCGI_READ_TIMEOUT" }};
{{- end }}

{{- if getenv "NGINX_CLIENT_MAX_BODY_SIZE" }}
    client_max_body_size {{ getenv "NGINX_CLIENT_MAX_BODY_SIZE" }};
{{- end }}

    include mime.types;

    server {
        listen 80;

{{- if eq (getenv "APP") "angular" }}

        root /srv/app/dist;

        location / {
            try_files $uri $uri/ /index.html =404;
        }

{{- else if eq (getenv "APP") "html" }}

        root /srv/app;

{{- else if eq (getenv "APP") "php" }}

        root /srv/app;

        location / {
            try_files $uri /index.php$is_args$args;
        }

        location ~ ^/index\.php(/|$) {
            include app_php;
            internal;
        }

{{- else if eq (getenv "APP") "silex" }}

        root /srv/app/web;

        location / {
            try_files $uri /index.php$is_args$args;
        }

        location ~ ^/index\.php(/|$) {
            include app_php;
            internal;
        }

{{- else if eq (getenv "APP") "symfony_2" }}

        root /srv/app/web;

        location / {
            try_files $uri /app.php$is_args$args;
        }

    {{ if eq (getenv "ENVIRONMENT") "development" }}
        location ~ ^/(app(_[-\w]+)?)\.php(/|$) {
            include app_php;
        }

        location ~ ^/app\.php(/|$) {
            include app_php;
        }
    {{- else }}
        location ~ ^/app\.php(/|$) {
            include app_php;
            internal;
        }
    {{- end }}

{{- else if eq (getenv "APP") "symfony_4" }}

        root /srv/app/public;

        location / {
            try_files $uri /index.php$is_args$args;
        }

        location ~ ^/index\.php(/|$) {
            include app_php;
            internal;
        }

{{- else if eq (getenv "APP") "vuejs" }}

        root /srv/app/dist;

        location / {
            try_files $uri $uri/ /index.html =404;
        }

{{- end }}

    {{- range (getenv "NGINX_DIRECTIVES" | jsonArray) }}
        include directives/{{ . }};
    {{- end }}
    }

    server {
        listen 10000;

        access_log off;

        location / {
            return 404;
        }

        location = /ping {
{{- if has (slice "php" "silex" "symfony_2" "symfony_4") (getenv "APP") }}
            include app_php;
            fastcgi_param SCRIPT_NAME /ping;
            fastcgi_param SCRIPT_FILENAME /ping;
{{- else }}
            add_header Content-Type text/plain;
            return 200 'pong';
{{- end }}
        }

        location = /nginx/status {
            stub_status on;
        }

{{- if has (slice "php" "silex" "symfony_2" "symfony_4") (getenv "APP") }}
        location = /php/status {
            include app_php;
            fastcgi_param SCRIPT_NAME /status;
            fastcgi_param SCRIPT_FILENAME /status;
        }
{{- end }}

        error_page 404 @error;

        location @error {
            try_files /error/$status.html /error/error.html =520;
        }
    }
}
