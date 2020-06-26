<?php
/**********************************************************
 * Package: ${PACKAGE_NAME}
 * Project: Admin-Portal-v2
 * File: add.php
 * Author: Diego <20026893@tafe.wa.edu.au>
 * Date: 2020-06-26
 * Version: 1.0.0
 * Description: add short description of file's purpose
 **********************************************************/

require_once $_SERVER['DOCUMENT_ROOT']. '/helpers/headers.php';
require_once $_SERVER['DOCUMENT_ROOT']. '/helpers/authentication.php';

/**
 * Add a new resource of type $resourceName
 * @param string $resourceName
 * @param array $data
 * @return bool Result of the operation
 */
function addResource($resourceName, $data) {
    $opts = generateHeaders('POST', $data);
    $context = stream_context_create($opts);
    $resourceAdded = false;

    if (isAuthenticated()) {
        $resourceUrl = API_URL . '/api/' . $resourceName;
        $resourceData = @file_get_contents($resourceUrl, false, $context);

        if ($resourceData) {
            // the newly created resource was successfully added
            $resourceAdded = true;
        }
    }

    return $resourceAdded;
}