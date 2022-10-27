<?php

require_once(__DIR__ . DIRECTORY_SEPARATOR . 'constants.php');

$matrix = [];

foreach (PHP_VERSIONS as $phpVersion) {
    $experimental = in_array($phpVersion, EXPERIMENTAL_PHP_VERSIONS);
    $matrix[] = [
        'php_version' => $phpVersion,
        'experimental' => $experimental
    ];
}

echo 'matrix=' . json_encode($matrix);