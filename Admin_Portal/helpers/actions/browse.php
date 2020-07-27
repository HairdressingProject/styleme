<?php
require_once $_SERVER['DOCUMENT_ROOT'] . '/helpers/utils.php';

/**
 * Gets all resources of type $resourceName. For example: 'users', 'user_features', 'colours', etc. Use snake_case here.
 * This methods also supports optional pagination
 * @param string $resourceName
 * @param int $limit Number of results to be retrieved from the API
 * @param int $offset Offset from which the results should be retrieved
 * @return array Response from the API as an associative array
 */
function browseResource(string $resourceName, int $limit = null, int $offset = null) {
    $opts = generateHeaders('GET');

    $resourceUrl = API_URL . '/' . $resourceName;

    if (isset($limit) && isset($offset)) {
        $resourceUrl = API_URL . '/' . $resourceName . '?limit=' . $limit . '&offset=' . $offset;
    }
    
    return Utils::getResponse($resourceUrl, $opts);
}