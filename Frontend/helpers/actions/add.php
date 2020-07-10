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

require_once $_SERVER['DOCUMENT_ROOT'] . '/helpers/utils.php';

/**
 * Add a new resource of type $resourceName
 * @param string $resourceName
 * @param array $data
 * @return array Response from the API as an associative array
 */
function addResource($resourceName, $data) {
    $opts = generateHeaders('POST', $data);
    $resourceUrl = API_URL . '/' . $resourceName;
    return Utils::getResponse($resourceUrl, $opts);
}