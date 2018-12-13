[www]

; Unix user/group of processes
user = app
group = app

; The address on which to accept FastCGI requests
listen = 9000

; Choose how the process manager will control the number of child processes
pm = dynamic

; The number of child processes to be created when pm is set to 'static' and the
; maximum number of child processes when pm is set to 'dynamic' or 'ondemand'
pm.max_children = {{ getenv "PHP_FPM_POOL_PM_MAX_CHILDREN" "5" }}

; The number of child processes created on startup.
pm.start_servers = {{ getenv "PHP_FPM_POOL_PM_START_SERVERS" "2" }}

; The desired minimum number of idle server processes
pm.min_spare_servers = {{ getenv "PHP_FPM_POOL_PM_MIN_SPARE_SERVERS" "1" }}

; The desired maximum number of idle server processes
pm.max_spare_servers = {{ getenv "PHP_FPM_POOL_PM_MAX_SPARE_SERVERS" "3" }}

; The URI to view the FPM status page
pm.status_path = /status

; The ping URI to call the monitoring page of FPM
ping.path = /ping

; The access log file
; If we send this to /proc/self/fd/1, it never appears
; See https://bugs.php.net/bug.php?id=73886
; See https://github.com/php/php-src/pull/2310
;access.log = /proc/self/fd/2

; Redirect worker stdout and stderr into main error log
catch_workers_output = yes

{{- if not (has (slice "7.1" "7.2") (getenv "PHP_VERSION")) }}

; Decorate worker output with prefix and suffix
decorate_workers_output = no
{{- end }}

; Clear environment in FPM workers
clear_env = no
