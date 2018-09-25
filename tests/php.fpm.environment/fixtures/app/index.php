<?php

header("Content-Type: text/plain");

echo 'error_reporting: ' . ini_get('error_reporting') . "\n";
echo 'display_errors: ' . ini_get('display_errors') . "\n";
echo 'display_startup_errors: ' . ini_get('display_startup_errors') . "\n";
echo 'expose_php: ' . ini_get('expose_php') . "\n";
echo 'zend.assertions: ' . ini_get('zend.assertions') . "\n";
echo 'opcache.validate_timestamps: ' . ini_get('opcache.validate_timestamps') . "\n";
