<?php
/**********************************************************
 * Package: ${PACKAGE_NAME}
 * Project: Admin-Portal-v2
 * File: read.php
 * Author: Diego <20026893@tafe.wa.edu.au>
 * Date: 2020-06-26
 * Version: 1.0.0
 * Description: add short description of file's purpose
 **********************************************************/

/**
 * Read a resource of type $resourceName and $id
 * @param string $resourceName
 * @param int|string $id
 * @return object $resource
 */
function readResource(string $resourceName, $id) {
    $opts = generateHeaders('GET');
    $context = stream_context_create($opts);
    $resource = null;

    if (isAuthenticated()) {
        $resourceUrl = API_URL . '/api/' . $resourceName . '/' . $id;
        $resourceData = @file_get_contents($resourceUrl, false, $context);

        if ($resourceData) {
            $parsedResource = json_decode($resourceData);
            $resource = $parsedResource;
        }
    }

    return $resource;
}