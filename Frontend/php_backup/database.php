<?php
require_once $_SERVER['DOCUMENT_ROOT'] . '/helpers/redirect-https.php';
require_once $_SERVER['DOCUMENT_ROOT'] . '/helpers/authentication.php';
require_once $_SERVER['DOCUMENT_ROOT'] . '/helpers/utils.php';
// require_once $_SERVER['DOCUMENT_ROOT'] . '/helpers/policies.php';

$parsedUrl = parse_url($_SERVER['REQUEST_URI']);
$currentBaseUrl = Utils::getUrlProtocol().$_SERVER['SERVER_NAME'].':'.$_SERVER['SERVER_PORT'].$parsedUrl['path'];

handleAuthorisation();

$token = Utils::addCSRFToken();
$alert = null;
$search = null;

$tables = [
        'users' => 'Users',
        'colours' => 'Colours',
        'face_shapes' => 'Face shapes',
        'face_shape_links' => 'Face shape links',
        'hair_lengths' => 'Hair lengths',
        'hair_length_links' => 'Hair length links',
        'hair_styles' => 'Hair styles',
        'hair_style_links' => 'Hair style links',
        'skin_tones' => 'Skin tones',
        'skin_tone_links' => 'Skin tone links',
        'user_features' => 'User features'
];

$filteredTables = [];

function filter(string $str, array $arr) {
    $filtered = [];
    foreach ($arr as $k => $v) {
        if (stripos($k, $str) !== false) $filtered[$k] = $v;
    }
    return $filtered;
}

if ($_POST && $_POST['search_table'] && Utils::verifyCSRFToken()) {
    $search = Utils::sanitiseField($_POST['search_table'], FILTER_SANITIZE_STRING);

    if (!empty(filter($search, $tables))) {
        $redirect = '<script>';
        $redirect .= 'window.location.href="';
        $redirect .= $currentBaseUrl.'?search='.$search;
        $redirect .= '";</script>';

        echo $redirect;
        exit();
    }
    else {
        $alert = Utils::createAlert('No results found', 'error');
    }
}

if ($_GET && $_GET['search']) {
    $search = Utils::sanitiseField($_GET['search'], FILTER_SANITIZE_STRING);
    $filteredTables = filter($search, $tables);
}
?>

<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8"/>
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta name="description" content="Admin Portal website for the Hairdressing Project" />
    <title>Database</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/foundation/6.6.3/css/foundation.min.css"
          integrity="sha256-ogmFxjqiTMnZhxCqVmcqTvjfe1Y/ec4WaRj/aQPvn+I=" crossorigin="anonymous" media="screen" />
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;700&display=swap" rel="stylesheet" media="screen">
    <link rel="stylesheet" href="css/index.css" media="screen" />
</head>

<body>
<noscript>Please enable JavaScript for this page to work</noscript>

<?php if(isset($alert)) echo $alert; ?>
<!-- TOP BAR -->
<div class="title-bar" data-responsive-toggle="responsive-menu" data-hide-for="medium">
    <button class="menu-icon" type="button" data-toggle="responsive-menu" aria-label="menu"></button>
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
    <ul class="vertical menu _sidebar _sidebar-closed" id="sidebar">
        <li class="_sidebar-item">
            <a href="#" class="grid-x _sidebar-item-link">
                <img src="img/icons/home-dark.svg" alt="Dashboard" class="_sidebar-item-icon slide-left">
                <span class="_sidebar-item-text hide">Dashboard</span>
            </a>
        </li>
        <li class="_sidebar-item _sidebar-item-selected">
            <a href="/database.php" class="grid-x _sidebar-item-link">
                <img src="img/icons/databases-dark.svg" alt="Database" class="_sidebar-item-icon slide-left">
                <span class="_sidebar-item-text hide">Database</span>
            </a>
        </li>
        <li class="_sidebar-item">
            <a href="#" class="grid-x _sidebar-item-link">
                <img src="img/icons/traffic-dark.svg" alt="Traffic" class="_sidebar-item-icon slide-left">
                <span class="_sidebar-item-text hide">Traffic</span>
            </a>
        </li>
        <li class="_sidebar-item">
            <a href="#" class="grid-x _sidebar-item-link">
                <img src="img/icons/permissions-dark.svg" alt="Permissions" class="_sidebar-item-icon slide-left">
                <span class="_sidebar-item-text hide">Permissions</span>
            </a>
        </li>
        <li class="_sidebar-item">
            <a href="#" class="grid-x _sidebar-item-link">
                <img src="img/icons/pictures-dark.svg" alt="Pictures" class="_sidebar-item-icon slide-left">
                <span class="_sidebar-item-text hide">Pictures</span>
            </a>
        </li>
        <li class="_sidebar-controls">
            <button id="sidebar-close" class="hide">
                <img src="img/icons/caret-left.svg" alt="Close">
            </button>

            <button id="sidebar-open" style="transform: translateX(250%)">
                <img src="img/icons/caret-right-dark.svg" alt="Open">
            </button>
        </li>
    </ul>

    <!-- END OF SIDE BAR -->

    <!-- MAIN CONTENT -->
    <main class="main main-sidebar-closed">
        <div class="grid-x _tables-grid">
            <div class="cell small-12 large-8 large-offset-4 _tables">
                <h2 class="_tables-title">hair_project_db tables</h2>
                <form
                        action="database.php"
                        method="POST"
                        class="_tables-search-input-container">
                    <input type="hidden" name="token" value="<?= $token ?>">
                    <label for="tables-search-input" aria-label="search for a table"></label>
                    <input type="text" name="search_table" placeholder="Search for a table..." id="tables-search-input"
                           class="_tables-search"/>
                   
                    <button type="submit" style="cursor: pointer">
                        <img src="img/icons/search.svg" alt="Search for a table" class="_tables-search-icon">
                    </button>
                </form>

                <?php
                if (isset($search)) {
                    ?>
                    <div class="text-center" style="margin-bottom: 5rem">
                        <h2 style="margin-bottom: 2.5rem; font-size: 2rem">
                            Search results for: <?= Utils::sanitiseField($search, FILTER_SANITIZE_STRING) ?>
                        </h2>
                        <a      style="font-size: 1.5rem"
                                href="database.php"
                        >
                            Show all results
                        </a>
                    </div>
                <?php } ?>

                <!-- YOU MIGHT WANT TO RE-USE THIS TABLE -->
                <table>
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>table name</th>
                    </tr>
                    </thead>
                    <tbody>

                    <?php if (!empty($filteredTables)) {
                        $count = 0;
                        foreach ($filteredTables as $k => $v) { $count++ ?>
                            <tr class="_tables-row" data-href="/<?= Utils::sanitiseField($k, FILTER_SANITIZE_STRING) . '.php' ?>">
                                <td><?= Utils::sanitiseField($count, FILTER_SANITIZE_NUMBER_INT) ?></td>
                                <td><?= Utils::sanitiseField($v, FILTER_SANITIZE_STRING) ?></td>
                            </tr>
                    <?php } ?>

                   <?php } else { $count = 0;
                   foreach ($tables as $k => $v) { $count++?>
                       <tr class="_tables-row" data-href="/<?= Utils::sanitiseField($k, FILTER_SANITIZE_STRING) . '.php' ?>">
                           <td><?= Utils::sanitiseField($count, FILTER_SANITIZE_NUMBER_INT) ?></td>
                           <td><?= Utils::sanitiseField($v, FILTER_SANITIZE_STRING) ?></td>
                       </tr>
                    <?php }} ?>
                    </tbody>
                </table>
            </div>
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

<!-- <script src="dist/js/index.15929ebd2c9329d115b2.js"></script>   
<script src="dist/js/alert.63343dc1ee857e6a231d.js"></script>
<script src="dist/js/authenticate.03a439d03468df849e11.js"></script>
<script src="dist/js/sidebar.50133d7752b0bb6b835d.js"></script>
<script src="dist/js/database.92eff97ca026a2176aa8.js"></script>
<script src="dist/js/redirect.4f2eb9a33949dcb44653.js"></script> -->
</body>

</html>