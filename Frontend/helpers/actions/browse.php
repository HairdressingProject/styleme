<?php
require_once $_SERVER['DOCUMENT_ROOT']. '/helpers/headers.php';
require_once $_SERVER['DOCUMENT_ROOT']. '/helpers/authentication.php';

/**
 * Gets all resources of type $resourceName. For example: 'users', 'user_features', 'colours', etc. Use snake_case here.
 * @param $resourceName
 * @return array|null
 */
function browseResource($resourceName) {
    $opts = generateHeaders('GET');
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