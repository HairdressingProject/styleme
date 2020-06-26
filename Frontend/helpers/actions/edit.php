<?php
/**********************************************************
 * Package: ${PACKAGE_NAME}
 * Project: Admin-Portal-v2
 * File: edit.php
 * Author: Diego <20026893@tafe.wa.edu.au>
 * Date: 2020-06-26
 * Version: 1.0.0
 * Description: add short description of file's purpose
 **********************************************************/

require_once $_SERVER['DOCUMENT_ROOT']. '/helpers/headers.php';
require_once $_SERVER['DOCUMENT_ROOT']. '/helpers/authentication.php';

/**
 * Edit a resource of type $resourceName
 * @param string $resourceName
 * @param array $data
 * @return bool Result of the operation
 */
function editResource(string $resourceName, array $data) {
    $opts = generateHeaders('PUT', $data);
    $context = stream_context_create($opts);
    $resourceUpdated = false;

    if (isAuthenticated()) {
        $resourceUrl = API_URL . '/api/' . $resourceName . '/' . $data['Id'];
        $r = @file_get_contents($resourceUrl, false, $context);

        if (is_array($http_response_header)) {
            $parts = explode(' ', $http_response_header[0]);
            if (count($parts) > 1) {
                if (intval($parts[1]) === 204 || intval($parts[1]) === 200) {
                    $resourceUpdated = true;
                }
            }
        }
    }

    return $resourceUpdated;
}