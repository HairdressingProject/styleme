<?php
/**********************************************************
 * Package: ${PACKAGE_NAME}
 * Project: Admin-Portal-v2
 * File: count.php
 * Author: Diego <20026893@tafe.wa.edu.au>
 * Date: 2020-06-28
 * Version: 1.0.0
 * Description: add short description of file's purpose
 **********************************************************/

require_once $_SERVER['DOCUMENT_ROOT'] . '/helpers/utils.php';

/**
 * Requests the total count of $resourceName
 * @param  string  $resourceName  plural snake_case representation of a resource, e.g. 'user_features' or 'hair_style_links'
 * @param  string|null  $search Optional query string to count results obtained
 * @return array HTTP response with status included
 */
function countResource(string $resourceName, string $search = null) {
    $opts = generateHeaders('GET');

    $resourceUrl = API_URL . '/' . $resourceName . '/count';

    if (isset($search)) {
        $resourceUrl .= '?search=' . Utils::sanitiseField($search, FILTER_SANITIZE_STRING);
    }

    return Utils::getResponse($resourceUrl, $opts);
}