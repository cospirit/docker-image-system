<?php

header("Content-Type: text/plain");

echo 'app: symfony' . "\n";
echo 'php: ' . PHP_MAJOR_VERSION . '.' . PHP_MINOR_VERSION . "\n";
echo 'date.timezone: ' . ini_get('date.timezone') . "\n";
