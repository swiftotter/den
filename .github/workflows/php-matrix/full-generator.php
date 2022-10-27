<?php

require_once(__DIR__ . DIRECTORY_SEPARATOR . 'constants.php');

$matrix = [];

foreach (PHP_VERSIONS as $phpVersion) {
    $xdebugType = !in_array($phpVersion, NOT_STABLE_XDEBUG_PHP_VERSIONS) ? 'xdebug-stable' : 'xdebug';
    $experimental = in_array($phpVersion, EXPERIMENTAL_PHP_VERSIONS);
    $matrix[] = [
        'php_version' => $phpVersion,
        'node_version' => 'x',
        'xdebug_type' => $xdebugType,
        'experimental' => $experimental
    ];
    foreach (NODE_VERSIONS as $nodeVersion) {
        $matrix[] = [
            'php_version' => $phpVersion,
            'node_version' => $nodeVersion,
            'xdebug_type' => $xdebugType,
            'experimental' => $experimental
        ];
    }
}

echo 'matrix=' . json_encode(['include' => $matrix]);