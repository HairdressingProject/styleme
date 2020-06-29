<?php
/**********************************************************
 * Package: ${PACKAGE_NAME}
 * Project: Admin-Portal-v2
 * File: page_features.php
 * Author: Diego <20026893@tafe.wa.edu.au>
 * Date: 2020-06-30
 * Version: 1.0.0
 * Description: add short description of file's purpose
 **********************************************************/

/**
 * Initialises routine to handle default page features, such as pagination and search
 *
 * @param  string  $resourceName plural snake_case representation of the resources present in the current page, such as 'users' or 'user_features'
 * @param  object  $resource Instance of a resource that corresponds to the current page
 * @param  int  $itemsPerPage Maximum number of items to show in resource tables
 * @param  string  $currentBaseUrl The current URL without query strings
 * @return array State of the current page, including:
 *
 *      $state = [
 *          'alert' => Alert messages to display
 *          'resources' => Array of resources retrieved from the API
 *          'count' => Number of resources retrieved either in full or filtered by search or $itemsPerPage
 *          'page' => Current page number
 *          'totalNumberOfPages' => Number of pages available
 *          'search' => search query string appended to the current URL *
 *      ]
 */
function implementDefaultPageFeatures(
    string $resourceName,
    object $resource,
    int $itemsPerPage,
    string $currentBaseUrl
    ) {
    if (isset($_COOKIE['auth'])) {
        $alert = null;
        $count = 0;
        $page = 1;
        $totalNumberOfPages = 1;
        $resources = [];
        $search = null;
        if ($_POST && Utils::verifyCSRFToken()) {
            if (isset($_POST['search']) && !empty(trim($_POST['search']))) {
                $search = Utils::sanitiseField($_POST['search'], FILTER_SANITIZE_STRING);

                $redirectScript = '<script>window.location.href ="';
                $redirectScript .= $currentBaseUrl;
                $redirectScript .= '?page=1&search=';
                $redirectScript .= $search;
                $redirectScript .= '"</script>';
                echo $redirectScript;
                exit();
            }
            else {
                if (isset($_POST['_method'])) {
                    $alert = $resource->handleSubmit($_POST['_method']);
                } else {
                    $alert = $resource->handleSubmit();
                }

                $p = Utils::paginateResource($resource, $resourceName, $itemsPerPage, $currentBaseUrl);
                $resources = $p['resources'];
                $count = $p['count'];
                $page = $p['page'];
                $totalNumberOfPages = $p['totalNumberOfPages'];
            }
        }

        if (!$_POST) {
            if (isset($_GET['search'])) {
                $search = Utils::sanitiseField($_GET['search'], FILTER_SANITIZE_STRING);

                $p = Utils::paginateResource($resource, $resourceName, $itemsPerPage, $currentBaseUrl, $search);
                $resources = $p['resources'];
                $count = $p['count'];
                $page = $p['page'];
                $totalNumberOfPages = $p['totalNumberOfPages'];
            }
            else {
                $p = Utils::paginateResource($resource, $resourceName, $itemsPerPage, $currentBaseUrl);
                $resources = $p['resources'];
                $count = $p['count'];
                $page = $p['page'];
                $totalNumberOfPages = $p['totalNumberOfPages'];
            }
        }

        return array(
            'alert' => $alert,
            'resources' => $resources,
            'count' => $count,
            'page' => $page,
            'totalNumberOfPages' => $totalNumberOfPages,
            'search' => $search
        );
    }
    exit();
}