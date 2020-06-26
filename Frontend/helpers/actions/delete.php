<?php
/**********************************************************
 * Package: ${PACKAGE_NAME}
 * Project: Admin-Portal-v2
 * File: delete.php
 * Author: Diego <20026893@tafe.wa.edu.au>
 * Date: 2020-06-26
 * Version: 1.0.0
 * Description: add short description of file's purpose
 **********************************************************/

require_once $_SERVER['DOCUMENT_ROOT']. '/helpers/headers.php';
require_once $_SERVER['DOCUMENT_ROOT']. '/helpers/authentication.php';

/**
 * Delete a resource of type $resourceName with $id
 * @param string $resourceName
 * @param int|string $id
 * @return bool Result of the operation
 */
function deleteResource(string $resourceName, $id) {
    $opts = generateHeaders('DELETE');
    $context = stream_context_create($opts);
    $resourceDeleted = false;

    if (isAuthenticated()) {
        $resourceUrl = API_URL . '/api/' . $resourceName . '/' . $id;
        $resourceData = @file_get_contents($resourceUrl, false, $context);

        if ($resourceData) {
            // the resource was successfully deleted
            $resourceDeleted = true;
        }
    }

    return $resourceDeleted;
}