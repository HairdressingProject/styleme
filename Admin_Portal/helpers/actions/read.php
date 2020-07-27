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

require_once $_SERVER['DOCUMENT_ROOT'] . '/helpers/utils.php';

/**
 * Read a resource of type $resourceName and $id
 * @param string $resourceName
 * @param int|string $id
 * @return array Response from the API as an associative array
 */
function readResource(string $resourceName, $id) {
    $opts = generateHeaders('GET');
    $resourceUrl = API_URL . '/' . $resourceName . '/' . $id;
    return Utils::getResponse($resourceUrl, $opts);
}