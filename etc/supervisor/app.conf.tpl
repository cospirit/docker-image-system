[include]
files = supervisord.conf watchdog.conf

[program:nginx]
command = nginx -c /etc/nginx/app.conf
stdout_logfile = /dev/stdout
stdout_logfile_maxbytes = 0
stderr_logfile = /dev/stderr
stderr_logfile_maxbytes = 0

{{/* Only for php related app */}}
{{- if has (slice "php" "silex" "symfony_2" "symfony") (getenv "APP") }}
[program:php]
{{- if has (slice "7.1" "7.2") (getenv "PHP_VERSION") }}
command = /root/php-fpm
{{- else }}
command = php-fpm{{ getenv "PHP_VERSION" }} --fpm-config /etc/php/{{ getenv "PHP_VERSION" }}/fpm/php-fpm.conf
{{- end }}
stdout_logfile = /dev/stdout
stdout_logfile_maxbytes = 0
stderr_logfile = /dev/stderr
stderr_logfile_maxbytes = 0
{{- end }}

{{- if (eq (getenv "APP") "nuxt")}}
[program:nuxt]
directory=/srv/app/
command= {{ getenv "NUXT_COMMAND" (getenv "NUXT_COMMAND" "npx nuxt-start") }}
autostart=true
autorestart=true
stderr_logfile = /dev/stderr
stdout_logfile = /dev/stdout
stdout_logfile_maxbytes = 0
stderr_logfile_maxbytes = 0
{{- end }}
