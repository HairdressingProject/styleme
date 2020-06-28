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

function countResource(string $resourceName) {
    $opts = generateHeaders('GET');

    $resourceUrl = API_URL . '/api/' . $resourceName . '/count';

    return Utils::getResponse($resourceUrl, $opts);
}