<?php
define("API_URL", "https://localhost:5000");

$protocol = 'http://';

// haxx to check whether the application is running under HTTPS or HTTP
if (isset($_SERVER['HTTPS']) &&
    ($_SERVER['HTTPS'] == 'on' || $_SERVER['HTTPS'] == 1) ||
    isset($_SERVER['HTTP_X_FORWARDED_PROTO']) &&
    $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https') {
    $protocol = 'https://';
}

$opts = array(
    'http' => array(
        'method' => "GET",
        'origin' => $protocol.$_SERVER["HTTP_HOST"],
        'header' => "Accept-language: en\r\n".
            "Cookie: auth=".$_COOKIE['auth']."\r\n"
    )
);

function fetchResource($resourceName) {
    global $opts;
    $context = stream_context_create($opts);
    $data = [];

    if (isAuthenticated()) {
        $resourceUrl = API_URL . '/api/' . $resourceName;
        $resourceData = @file_get_contents($resourceUrl, false, $context);

        if ($resourceData) {
            $parsedResource = json_decode($resourceData);
            $data = is_object($parsedResource) ? $parsedResource->$resourceName : $parsedResource;
        }
        return $data;
    }

    // user is not authenticated
    return null;
}

function isAuthenticated() {
    global $opts;

    $context = stream_context_create($opts);
    $authUrl = API_URL . '/api/users/authenticate';

    $userData = @file_get_contents($authUrl, false, $context);

    return isset($userData);
}