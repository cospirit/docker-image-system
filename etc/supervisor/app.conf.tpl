[include]
files = supervisord.conf watchdog.conf

[program:nginx]
command = nginx -c /etc/nginx/app.conf
stdout_logfile = /dev/stdout
stdout_logfile_maxbytes = 0
stderr_logfile = /dev/stderr
stderr_logfile_maxbytes = 0

{{/* Only for php related app */}}
{{- if has (slice "php" "silex" "symfony_2" "symfony_4") (getenv "APP") }}
[program:php]
command = /root/php-fpm
stdout_logfile = /dev/stdout
stdout_logfile_maxbytes = 0
stderr_logfile = /dev/stderr
stderr_logfile_maxbytes = 0
{{- end }}
