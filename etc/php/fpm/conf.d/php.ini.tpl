;;;;;;;;;;;;;;;
; Environment ;
;;;;;;;;;;;;;;;

{{- if eq (getenv "ENVIRONMENT") "development" }}

error_reporting = E_ALL
display_errors = On
display_startup_errors = On
zend.assertions = 1
expose_php = On

;;;;;;;;;;;
; OPcache ;
;;;;;;;;;;;

; When disabled, you must reset the OPcache manually or restart the
; webserver for changes to the filesystem to take effect.
opcache.validate_timestamps = On

;;;;;;;;;;
; XDebug ;
;;;;;;;;;;

xdebug.remote_enable = On
xdebug.remote_autostart = On

{{- else }}

error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT
display_errors = Off
display_startup_errors = Off
zend.assertions = -1
expose_php = Off

;;;;;;;;;;;
; OPcache ;
;;;;;;;;;;;

; When disabled, you must reset the OPcache manually or restart the
; webserver for changes to the filesystem to take effect.
opcache.validate_timestamps = Off

{{- end }}

;;;;;;;;;;;;;;;;;;;;
; Language Options ;
;;;;;;;;;;;;;;;;;;;;

; Determines the size of the realpath cache to be used by PHP.
realpath_cache_size = 4096K

; Duration of time, in seconds for which to cache realpath information for a given file or directory.
realpath_cache_ttl = 600

;;;;;;;;;;;;;;;;;;;
; Resource Limits ;
;;;;;;;;;;;;;;;;;;;

; Maximum execution time of each script, in seconds
; Note: This directive is hardcoded to 0 for the CLI SAPI
max_execution_time = {{ getenv "PHP_FPM_MAX_EXECUTION_TIME" "30" }}

; Maximum amount of memory a script may consume.
memory_limit = {{ getenv "PHP_FPM_MEMORY_LIMIT" (getenv "PHP_MEMORY_LIMIT" "128M") }}

; How many GET/POST/COOKIE input variables may be accepted
max_input_vars = {{ getenv "PHP_FPM_MAX_INPUT_VARS" (getenv "PHP_MAX_INPUT_VARS" "1000") }}

;;;;;;;;;;;;;;;;;
; Data Handling ;
;;;;;;;;;;;;;;;;;

; Maximum size of POST data that PHP will accept.
post_max_size = {{ getenv "PHP_FPM_POST_MAX_SIZE" (getenv "PHP_POST_MAX_SIZE" "8M") }}

;;;;;;;;;;;;;;;;
; File Uploads ;
;;;;;;;;;;;;;;;;

; Maximum allowed size for uploaded files.
upload_max_filesize = {{ getenv "PHP_FPM_UPLOAD_MAX_FILESIZE" (getenv "PHP_UPLOAD_MAX_FILESIZE" "2M") }}

;;;;;;;;;;;;;;;;;;;
; Module Settings ;
;;;;;;;;;;;;;;;;;;;

[Date]

; Defines the default timezone used by the date functions.
date.timezone = {{ getenv "PHP_DATE_TIMEZONE" }}

[opcache]

; The OPcache shared memory storage size.
opcache.memory_consumption = 256

; The maximum number of keys (scripts) in the OPcache hash table.
; Only numbers between 200 and 1000000 are allowed.
opcache.max_accelerated_files = 20000

[apc]

apc.enabled = On
apc.enable_cli = On
apc.ttl = 3600

[xdebug]

xdebug.remote_port = {{ getenv "PHP_FPM_XDEBUG_REMOTE_PORT" (getenv "PHP_XDEBUG_REMOTE_PORT" "9000") }}
