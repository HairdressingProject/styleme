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

require_once $_SERVER['DOCUMENT_ROOT'] . '/helpers/utils.php';

/**
 * Edit a resource of type $resourceName
 * @param string $resourceName
 * @param array $data
 * @return array Response from the API as an associative array
 */
function editResource(string $resourceName, array $data) {
    $opts = generateHeaders('PUT', $data);
    $resourceUrl = API_URL . '/api/' . $resourceName . '/' . $data['Id'];
    return Utils::getResponse($resourceUrl, $opts);
}