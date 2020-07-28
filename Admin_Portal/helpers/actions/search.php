<?php
/**********************************************************
 * Package: ${PACKAGE_NAME}
 * Project: Admin-Portal-v2
 * File: search.php
 * Author: Diego <20026893@tafe.wa.edu.au>
 * Date: 2020-06-30
 * Version: 1.0.0
 * Description: add short description of file's purpose
 **********************************************************/

require_once $_SERVER['DOCUMENT_ROOT'] . '/helpers/utils.php';

/**
 * Searches for a resource of type $resourceName based on a search query $query
 * @param  string  $resourceName  Plural snake_case representation of a resource, e.g. 'users', 'user_features', etc.
 * @param  string  $query  Search query
 * @param  int|null  $limit Optionally limit the number of results fetched
 * @param  int|null  $offset Optionally pass an offset from which results will be returned
 * @return array Response from the API as an associative array
 */
function searchResource(string $resourceName, string $query, int $limit = null, int $offset = null) {
    $opts = generateHeaders('GET');
    $resourceUrl = API_URL . '/' . $resourceName . '?search=' . Utils::sanitiseField($query, FILTER_SANITIZE_STRING);

    if (isset($limit) && isset($offset)) {
        $resourceUrl .= '&limit='. $limit . '&offset=' . $offset;
    }

    return Utils::getResponse($resourceUrl, $opts);
}