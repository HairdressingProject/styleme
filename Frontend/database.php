<?php

define("API_URL", "https://localhost:5000");

if (isset($_COOKIE["auth"])) {
    $protocol = 'http://';

    // haxx to check whether the application is running under HTTPS or HTTP
    if (isset($_SERVER['HTTPS']) &&
        ($_SERVER['HTTPS'] == 'on' || $_SERVER['HTTPS'] == 1) ||
        isset($_SERVER['HTTP_X_FORWARDED_PROTO']) &&
        $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https') {
        $protocol = 'https://';
    }

    $opts = array(
        'http' => array(
            'method' => "GET",
            'origin' => $protocol.$_SERVER["HTTP_HOST"],
            'header' => "Accept-language: en\r\n".
                "Cookie: auth=".$_COOKIE['auth']."\r\n"
        )
    );

    $context = stream_context_create($opts);

// Open the file using the HTTP headers set above
    $authUrl = API_URL . '/api/users/authenticate';

    $userData = @file_get_contents($authUrl, false, $context);

    if ($userData) {
        // user is authenticated
        // fetch data

        $resources = [
            'colours',
            'face_shape_links',
            'face_shapes',
            'hair_length_links',
            'hair_lengths',
            'hair_style_links',
            'hair_styles',
            'skin_tone_links',
            'skin_tones',
            'user_features',
            'users'
        ];

        $fetched = [];

        foreach ($resources as $key => $r) {
            $resourceUrl = API_URL . '/api/' . $r;
            $resourceData = @file_get_contents($resourceUrl, false, $context);

            if ($resourceData) {
                $parsedResource = json_decode($resourceData);

                $fetched[$r] = is_object($parsedResource) ? $parsedResource->$r : $parsedResource;
            }
            else {
                echo 'could not fetch ' . $key;
            }
        }

    } else {
        // user is NOT authenticated
        // in this case, the auth cookie is either expired or invalid
        // the case when the auth cookie does not exist is already being handled by javascript (by redirecting to /sign_in.php)
        // NOTE: the code below is not quite working at the moment, probably because some redirects are already being made by javascript
        // Needs further investigation
        // header('Location: '. $protocol . $_SERVER["HTTP_HOST"] . '/sign_in.php');
        // exit();
    }
}
?>

<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8"/>
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Database</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/foundation/6.6.3/css/foundation.min.css"
          integrity="sha256-ogmFxjqiTMnZhxCqVmcqTvjfe1Y/ec4WaRj/aQPvn+I=" crossorigin="anonymous"/>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/index.css"/>
</head>

<body>
<noscript>Please enable JavaScript for this page to work</noscript>

<!-- TOP BAR -->
<div class="title-bar" data-responsive-toggle="responsive-menu" data-hide-for="medium">
    <button class="menu-icon" type="button" data-toggle="responsive-menu"></button>
    <div class="title-bar-title">Hairdressing Project</div>
</div>

<div class="top-bar" id="responsive-menu">
    <div class="top-bar-left">
        <img src="img/logo.svg" alt="Hairdressing Project" class="logo">
        <h1 class="text-center title">Database</h1>
    </div>
    <div class="top-bar-right">
        <ul class="dropdown menu _right-menu" data-dropdown-menu>
            <li>
                <button>
                    <img src="img/icons/settings-dark.svg" alt="Settings" class="_menu-icon"/>
                </button>
                <ul class="menu _settings-dropdown">
                    <li class="_menu-item">
                        <a href="#" class="_dropdown-link">Privacy Policy</a>
                    </li>
                    <li class="_menu-item">
                        <a href="#" class="_dropdown-link">Pictures storage</a>
                    </li>
                    <li class="_menu-item">
                            <span class="_dropdown-link">
                                <span class="_dark-mode-title">Show notifications</span>
                                <span class="switch _dark-mode-toggle">
                                    <input class="switch-input" id="notifications" type="checkbox" name="exampleSwitch">
                                    <label class="switch-paddle" for="notifications">
                                        <span class="show-for-sr">Show notifications?</span>
                                        <span class="switch-active" aria-hidden="true">Yes</span>
                                        <span class="switch-inactive" aria-hidden="true">No</span>
                                    </label>
                                </span>
                            </span>
                    </li>
                    <li class="_menu-item">
                            <span class="_dropdown-link">
                                <span class="_dark-mode-title">Dark mode</span>
                                <span class="switch _dark-mode-toggle">
                                    <input class="switch-input" id="dark-mode" type="checkbox" name="exampleSwitch">
                                    <label class="switch-paddle" for="dark-mode">
                                        <span class="show-for-sr">Dark mode?</span>
                                        <span class="switch-active" aria-hidden="true">Yes</span>
                                        <span class="switch-inactive" aria-hidden="true">No</span>
                                    </label>
                                </span>
                            </span>
                    </li>
                </ul>
            </li>
            <li>
                <button>
                    <img src="img/icons/notifications-dark.svg" alt="Notifications" class="_menu-icon"/>
                </button>
                <ul class="menu">
                    <li class="_menu-item"><a href="#" class="_dropdown-link">Example notification</a></li>
                </ul>
            </li>
            <li>
                <button>
                    <img src="img/icons/user.svg" alt="User" class="_menu-icon"/>
                    <span id="user-name">User</span>
                    <img src="img/icons/caret-down.svg" alt="User menu"/>
                </button>
                <ul class="menu">
                    <li class="_menu-item"><a href="account.php" class="_dropdown-link">My account</a></li>
                    <li class="_menu-item">
                        <a href="sign_in.php" class="_dropdown-link" id="logout">Logout</a>
                    </li>
                </ul>
            </li>
        </ul>
    </div>
</div>

<!-- END OF TOP BAR -->

<div class="grid-x">
    <!-- SIDE BAR -->
    <ul class="vertical menu _sidebar" id="sidebar">
        <li class="_sidebar-item">
            <a href="#" class="grid-x _sidebar-item-link">
                <img src="img/icons/home-dark.svg" alt="Dashboard" class="_sidebar-item-icon">
                <span class="_sidebar-item-text">Dashboard</span>
            </a>
        </li>
        <li class="_sidebar-item _sidebar-item-selected">
            <a href="#" class="grid-x _sidebar-item-link">
                <img src="img/icons/databases-dark.svg" alt="Database" class="_sidebar-item-icon">
                <span class="_sidebar-item-text">Database</span>
            </a>
        </li>
        <li class="_sidebar-item">
            <a href="#" class="grid-x _sidebar-item-link">
                <img src="img/icons/traffic-dark.svg" alt="Traffic" class="_sidebar-item-icon">
                <span class="_sidebar-item-text">Traffic</span>
            </a>
        </li>
        <li class="_sidebar-item">
            <a href="#" class="grid-x _sidebar-item-link">
                <img src="img/icons/permissions-dark.svg" alt="Permissions" class="_sidebar-item-icon">
                <span class="_sidebar-item-text">Permissions</span>
            </a>
        </li>
        <li class="_sidebar-item">
            <a href="#" class="grid-x _sidebar-item-link">
                <img src="img/icons/pictures-dark.svg" alt="Pictures" class="_sidebar-item-icon">
                <span class="_sidebar-item-text">Pictures</span>
            </a>
        </li>
        <li class="_sidebar-controls">
            <button id="sidebar-close">
                <img src="img/icons/caret-left.svg" alt="Close">
            </button>

            <button class="hide" id="sidebar-open">
                <img src="img/icons/caret-right-dark.svg" alt="Open">
            </button>
        </li>
    </ul>

    <!-- END OF SIDE BAR -->

    <!-- MAIN CONTENT -->
    <main class="main">
        <div class="grid-x _tables-grid">
            <div class="cell small-12 large-8 large-offset-4 _tables">
                <h2 class="_tables-title">hair_project_db tables</h2>
                <div class="_tables-search-input-container">
                    <input type="text" placeholder="Search for a table..." id="tables-search-input"
                           class="_tables-search"/>
                    <img src="img/icons/search.svg" alt="Search" class="_tables-search-icon">
                </div>

                <!-- YOU MIGHT WANT TO RE-USE THIS TABLE -->
                <table>
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>table name</th>
                        <th>created</th>
                        <th>last updated</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr class="_tables-row _row-selected">
                        <td>1</td>
                        <td>Users</td>
                        <td>Content Goes Here</td>
                        <td>Content Goes Here</td>
                    </tr>
                    <tr class="_tables-row">
                        <td>2</td>
                        <td>Colours</td>
                        <td>Content Goes Here</td>
                        <td>Content Goes Here</td>
                    </tr>
                    <tr class="_tables-row">
                        <td>3</td>
                        <td>Face shapes</td>
                        <td>Content Goes Here</td>
                        <td>Content Goes Here</td>
                    </tr>
                    <tr class="_tables-row">
                        <td>4</td>
                        <td>Face shape links</td>
                        <td>Content Goes Here</td>
                        <td>Content Goes Here</td>
                    </tr>
                    <tr class="_tables-row">
                        <td>5</td>
                        <td>Hair lengths</td>
                        <td>Content Goes Here</td>
                        <td>Content Goes Here</td>
                    </tr>
                    <tr class="_tables-row">
                        <td>6</td>
                        <td>Hair length links</td>
                        <td>Content Goes Here</td>
                        <td>Content Goes Here</td>
                    </tr>
                    <tr class="_tables-row">
                        <td>7</td>
                        <td>Hair styles</td>
                        <td>Content Goes Here</td>
                        <td>Content Goes Here</td>
                    </tr>
                    <tr class="_tables-row">
                        <td>8</td>
                        <td>Hair style links</td>
                        <td>Content Goes Here</td>
                        <td>Content Goes Here</td>
                    </tr>
                    <tr class="_tables-row">
                        <td>9</td>
                        <td>Skin tones</td>
                        <td>Content Goes Here</td>
                        <td>Content Goes Here</td>
                    </tr>
                    <tr class="_tables-row">
                        <td>10</td>
                        <td>Skin tone links</td>
                        <td>Content Goes Here</td>
                        <td>Content Goes Here</td>
                    </tr>
                    <tr class="_tables-row">
                        <td>11</td>
                        <td>User features</td>
                        <td>Content Goes Here</td>
                        <td>Content Goes Here</td>
                    </tr>
                    </tbody>
                </table>
            </div>

            <div class="cell small-12 large-11 large-offset-4 _tables">
                <h2 class="_tables-title">Users</h2>
                <div class="_tables-search-input-container">
                    <input type="text" placeholder="Search for an entry..." id="entries-search-input"
                           class="_tables-search"/>
                    <img src="img/icons/search.svg" alt="Search" class="_tables-search-icon">
                </div>

                <table>
                    <thead>
                    <tr>
                        <th>id</th>
                        <th>user_name</th>
                        <th>user_email</th>
                        <th>first_name</th>
                        <th>last_name</th>
                        <th>user_role</th>
                        <th>date_created</th>
                        <th>date_modified</th>
                    </tr>
                    </thead>
                    <tbody>
                    <?php
                    $allUsers = $fetched['users'];

                    for ($i = 0; $i < count($allUsers); $i++) { $user = $allUsers[$i]; ?>
                        <tr class="_tables-row">
                            <td><?= $user->id ?></td>
                            <td><?= $user->userName ?></td>
                            <td><?= $user->userEmail ?></td>
                            <td><?= $user->firstName ?></td>
                            <td><?= $user->lastName ?></td>
                            <td><?= $user->userRole ?></td>
                            <td><?= $user->dateCreated ?></td>
                            <td><?= $user->dateModified ?></td>
                        </tr>
                    <?php } ?>
                    </tbody>
                </table>
                <nav aria-label="Pagination" class="_pagination">
                    <ul class="pagination text-center">
                        <li class="pagination-previous disabled">Previous</li>
                        <li class="current"><span class="show-for-sr">You're on page</span> 1</li>
                        <li><a href="#" aria-label="Page 2">2</a></li>
                        <li><a href="#" aria-label="Page 3">3</a></li>
                        <li><a href="#" aria-label="Page 4">4</a></li>
                        <li class="ellipsis"></li>
                        <li><a href="#" aria-label="Page 12">12</a></li>
                        <li><a href="#" aria-label="Page 13">13</a></li>
                        <li class="pagination-next"><a href="#" aria-label="Next page">Next</a></li>
                    </ul>
                </nav>
            </div>
    </main>
    <!-- END OF MAIN CONTENT -->
</div>


<!-- FOOTER -->
<footer class="footer">
    <p>Copyright &copy; 2020 Hairdressing Project</p>
</footer>
<!-- END OF FOOTER -->

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"
        integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/what-input/5.2.10/what-input.min.js"
        integrity="sha256-ZLjSztVkz5q3lKFjN9AgL6qR7TGLE+qnTXnNNTWtMF4=" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/foundation/6.6.3/js/foundation.min.js"
        integrity="sha256-pRF3zifJRA9jXGv++b06qwtSqX1byFQOLjqa2PTEb2o=" crossorigin="anonymous"></script>

<script src="js/index.js"></script>
<script src="js/alert.js"></script>
<script src="js/authenticate.js"></script>
<script src="js/sidebar.js"></script>
<script src="js/database.js"></script>
</body>

</html>