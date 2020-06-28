<?php
require_once $_SERVER['DOCUMENT_ROOT'] . '/helpers/utils.php';
require_once $_SERVER['DOCUMENT_ROOT'] . '/helpers/authentication.php';
require_once $_SERVER['DOCUMENT_ROOT']. '/classes/User.php';

$token = Utils::addCSRFToken();
$alert = null;
$user = new User();

function readUser($user) {
    $id = isAuthenticated();

    if ($id) {
        // user is authenticated
        $user->id = intval($id);

        $response = $user->read();

        if (isset($response['user'])) {
            $u = $response['user'];

            // map fields
            $user->id = $u->id;
            $user->username = $u->userName;
            $user->email = $u->userEmail;
            $user->firstName = $u->firstName;
            $user->lastName = $u->lastName;
            $user->userRole = $u->userRole;
        }
    }

    return $user;
}

if (isset($_COOKIE['auth'])) {
    $user = readUser($user);
}
else {
    echo '<script>window.location.href = "/sign_in.php"</script>';
    exit();
}

if ($_POST && Utils::verifyCSRFToken()) {
    $results = $user->handleUpdateAccount();

    $alert = $results['alert'];

    if (isset($results['status']) && $results['status'] !== 200) {
        $user = readUser($user);
    }
}
?>

<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8" />
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Account</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/foundation/6.6.3/css/foundation.min.css"
        integrity="sha256-ogmFxjqiTMnZhxCqVmcqTvjfe1Y/ec4WaRj/aQPvn+I=" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/index.css" />
</head>

<body>
    <noscript>Please enable JavaScript for this page to work</noscript>
    <?php if (isset($alert)) echo $alert; ?>

    <!-- TOP BAR -->
    <div class="title-bar" data-responsive-toggle="responsive-menu" data-hide-for="medium">
        <button class="menu-icon" type="button" data-toggle="responsive-menu"></button>
        <div class="title-bar-title">Hairdressing Project</div>
    </div>

    <div class="top-bar" id="responsive-menu">
        <div class="top-bar-left">
            <img src="img/logo.svg" alt="Hairdressing Project" class="logo">
            <h1 class="text-center title">My account</h1>
        </div>
        <div class="top-bar-right">
            <ul class="dropdown menu _right-menu" data-dropdown-menu>
                <li>
                    <button>
                        <img src="img/icons/settings-dark.svg" alt="Settings" class="_menu-icon" />
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
                        <img src="img/icons/notifications-dark.svg" alt="Notifications" class="_menu-icon" />
                    </button>
                    <ul class="menu">
                        <li class="_menu-item"><a href="#" class="_dropdown-link">Example notification</a></li>
                    </ul>
                </li>
                <li>
                    <button>
                        <img src="img/icons/user.svg" alt="User" class="_menu-icon" />
                        <span id="user-name">User</span>
                        <img src="img/icons/caret-down.svg" alt="User menu" />
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
        <main class="account-main">
            <div class="account-basic-info grid-x">
                <div class="cell small-6 account-pic-container">
                    <button class="account-pic-attachment-btn">
                        <img src="img/icons/attachment.svg" alt="Attachment" class="account-pic-attachment">
                    </button>
                    <img src="img/icons/user.svg" alt="User" class="account-pic">
                </div>
                <div class="cell small-6 account-fullname-username">
                    <h1 id="account-fullname" class="account-fullname">
                        <?= $user->firstName . ' ' . $user->lastName ?>
                    </h1>
                    <p id="account-username" class="account-username"><?= ucfirst($user->userRole) ?></p>
                </div>
            </div>
            <form action="account.php" method="POST">
                <input type="hidden" name="_method" value="PUT">
                <input type="hidden" name="token" value="<?= $token ?>">
                <div class="grid-container">
                    <div class="grid-x">
                        <div class="cell account-field-cell" id="account-username">
                            <label class="account-field">user_name<span class="account-required">*</span>
                                <input
                                        type="text"
                                        placeholder="user_name"
                                        required
                                        name="username"
                                        class="account-input"
                                        id="username"
                                        maxlength="32"
                                        value="<?= $user->username ?>"
                                >
                            </label>
                        </div>
                        <div class="cell account-field-cell" id="account-email">
                            <label class="account-field">user_email<span class="account-required">*</span>
                                <input
                                        type="email"
                                        placeholder="user_email"
                                        required
                                        name="email"
                                        class="account-input"
                                        id="email"
                                        maxlength="512"
                                        value="<?= $user->email ?>"
                                >
                            </label>
                        </div>
                        <div class="cell account-field-cell" id="account-given-name">
                            <label class="account-field">first_name<span class="account-required">*</span>
                                <input
                                        type="text"
                                        placeholder="first_name"
                                        required
                                        name="first_name"
                                        class="account-input"
                                        maxlength="128"
                                        id="first_name"
                                        value="<?= $user->firstName ?>"
                                >
                            </label>
                        </div>
                        <div class="cell account-field-cell" id="account-family-name">
                            <label class="account-field">last_name
                                <input
                                        type="text"
                                        placeholder="last_name"
                                        class="account-input"
                                        name="last_name"
                                        id="last_name"
                                        maxlength="128"
                                        value="<?= $user->lastName ?>"
                                >
                            </label>
                        </div>
                        <div class="cell account-field-cell" id="account-given-name">
                            <label class="account-field">user_password<span class="account-required">*</span>
                                <input
                                        type="password"
                                        placeholder="******"
                                        required
                                        name="password"
                                        minlength="6"
                                        maxlength="512"
                                        class="account-input"
                                        id="password">
                                <button class="account-reveal-password">
                                    <img src="img/icons/eye.svg" alt="Reveal password">
                                </button>
                            </label>
                        </div>
                        <div class="cell account-field-cell">
                            <label class="account-field">Confirm password<span class="account-required">*</span>
                                <input
                                        type="password"
                                        placeholder="******"
                                        required
                                        name="confirm_password"
                                        minlength="6"
                                        maxlength="512"
                                    class="account-input" id="confirm-password">
                                <button class="account-reveal-password account-reveal-password-active">
                                    <img src="img/icons/eye.svg" alt="Reveal password">
                                </button>
                            </label>
                        </div>
                        <div class="account-btns grid-x">
                            <div class="cell small-12 medium-6">
                                <button class="account-restore-btn account-btn" id="btn-restore">Restore</button>
                            </div>
                            <div class="cell small-12 medium-6">
                                <button class="account-save-btn account-btn" type="submit">Save changes</button>
                            </div>
                        </div>
                    </div>
                </div>
            </form>

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
    <script src="js/account.js"></script>
</body>

</html>