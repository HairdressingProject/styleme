<?php
require_once $_SERVER['DOCUMENT_ROOT'] . '/helpers/utils.php';

/**
 * Gets all resources of type $resourceName. For example: 'users', 'user_features', 'colours', etc. Use snake_case here.
 * @param string $resourceName
 * @return array Response from the API as an associative array
 */
function browseResource(string $resourceName) {
    $opts = generateHeaders('GET');
    $resourceUrl = API_URL . '/api/' . $resourceName;
    return Utils::getResponse($resourceUrl, $opts);
}