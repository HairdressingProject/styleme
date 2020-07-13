<?php
/**********************************************************
 * Package: ${PACKAGE_NAME}
 * Project: Admin-Portal-v2
 * File: hair_style_links.php
 * Author: Diego <20026893@tafe.wa.edu.au>
 * Date: 2020-06-28
 * Version: 1.0.0
 * Description: add short description of file's purpose
 **********************************************************/
require_once $_SERVER['DOCUMENT_ROOT'] . '/helpers/redirect-https.php';
require_once $_SERVER['DOCUMENT_ROOT'] . '/helpers/utils.php';
require_once $_SERVER['DOCUMENT_ROOT']. '/helpers/actions/browse.php';
require_once $_SERVER['DOCUMENT_ROOT']. '/classes/HairStyleLink.php';
require_once $_SERVER['DOCUMENT_ROOT']. '/classes/HairStyle.php';
require_once $_SERVER['DOCUMENT_ROOT'] . '/helpers/page_features.php';

$token = Utils::addCSRFToken();
$alert = null;
$search = null;
$hairStyleLink = new hairStyleLink();
$hairStyle = new hairStyle();
$hairStyleLinks = [];
$hairStyles = [];
// for pagination
define('ITEMS_PER_PAGE', 5);
$count = 0;
$page = 1;
$totalNumberOfPages = 1;

$parsedUrl = parse_url($_SERVER['REQUEST_URI']);
$currentBaseUrl = Utils::getUrlProtocol().$_SERVER['SERVER_NAME'].':'.$_SERVER['SERVER_PORT'].$parsedUrl['path'];

$f = implementDefaultPageFeatures(
    'hairStyleLinks',
    $hairStyleLink,
    ITEMS_PER_PAGE,
    $currentBaseUrl
);

$alert = $f['alert'];
$hairStyleLinks = $f['resources'];
$count = $f['count'];
$page = $f['page'];
$totalNumberOfPages = $f['totalNumberOfPages'];
$search = $f['search'];


if (isset($_COOKIE["auth"])) {
    $browseHairStyles = $hairStyle->browse();
    $hairStyles = $browseHairStyles['hairStyles'];
}
?>


<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8"/>
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta name="description" content="Admin Portal website for the Hairdressing Project" />
    <title>Hair Style Links</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/foundation/6.6.3/css/foundation.min.css"
          integrity="sha256-ogmFxjqiTMnZhxCqVmcqTvjfe1Y/ec4WaRj/aQPvn+I=" crossorigin="anonymous"/>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/index.css"/>
</head>

<body>
<noscript>Please enable JavaScript for this page to work</noscript>

<?php if(isset($alert)) echo $alert; ?>
<!-- ADD MODAL -->
<div class="reveal large _table-modal" id="add-modal" data-reveal>
    <h3 class="_table-modal-title">Add a new hair style link</h3>
    <button class="close-button _table-modal-close" data-close aria-label="Close modal" type="button">
        <span aria-hidden="true">&times;</span>
    </button>

    <form action="<?= 'hair_style_links.php?page=' . $page ?>" method="POST">
        <input type="hidden" name="token" value="<?=$token?>">
        <div class="grid-container">
            <div class="grid-x">

                <div class="cell account-field-cell">
                    <label class="account-field">hair_style<span class="account-required">*</span>
                        <span class="grid-x account-user_role-container">
                            <select name="add_hairStyleId" class="account-user_role" id="selected-hairStyle-add" required>
                                <?php
                                for ($i = 0; $i < count($hairStyles); $i++) {
                                    ?>
                                    <option value="<?= $hairStyles[$i]->id ?>">
                                            <?= $hairStyles[$i]->hairStyleName ?>
                                        </option>
                                <?php } ?>
                            </select>
                        </span>

                    </label>
                </div>

                <div class="cell account-field-cell">
                    <label class="account-field">Link name<span class="account-required">*</span>
                        <input name="add_linkName" type="text" placeholder="link name" required class="account-input" id="selected-linkName-add"
                               maxlength="128">
                    </label>
                </div>

                <div class="cell account-field-cell">
                    <label class="account-field">Link URL<span class="account-required">*</span>
                        <input name="add_linkUrl" type="text" placeholder="link url" required class="account-input" id="selected-linkUrl-add"
                               maxlength="512">
                    </label>
                </div>

                <div class="account-btns grid-x">
                    <div class="cell small-12 medium-6">
                        <button id="btn-clear" class="account-restore-btn account-btn">Clear</button>
                    </div>
                    <div class="cell small-12 medium-6">
                        <button class="account-save-btn account-btn" type="submit">Save changes</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>
<!-- END OF ADD MODAL -->

<!-- EDIT MODAL -->
<div class="reveal large _table-modal" id="edit-modal" data-reveal>
    <h3 class="_table-modal-title">Edit a hair style link</h3>
    <button class="close-button _table-modal-close" data-close aria-label="Close modal" type="button">
        <span aria-hidden="true">&times;</span>
    </button>
    <form action="<?= 'hair_style_links.php?page=' . $page ?>" method="POST" id="edit-form">
        <input type="hidden" name="token" value="<?=$token?>">
        <input type="hidden" name="_method" value="PUT" />
        <input id="selected-id-edit" type="hidden" name="put_id" value="0" />
        <div class="grid-container">
            <div class="grid-x">

                <div class="cell account-field-cell">
                    <label class="account-field">hair style<span class="account-required">*</span>
                        <span class="grid-x account-user_role-container">
                            <select name="put_hairStyleId" class="account-user_role" id="selected-hairStyle-edit" required>
                                <?php
                                for ($i = 0; $i < count($hairStyles); $i++) {
                                    ?>
                                    <option value="<?= $hairStyles[$i]->id ?>">
                                            <?= $hairStyles[$i]->hairStyleName ?>
                                        </option>
                                <?php } ?>
                            </select>
                        </span>

                    </label>
                </div>

                <div class="cell account-field-cell">
                    <label class="account-field">Link name<span class="account-required">*</span>
                        <input name="put_linkName" type="text" placeholder="link name" required class="account-input" id="selected-linkName-edit"
                               maxlength="128">
                    </label>
                </div>

                <div class="cell account-field-cell">
                    <label class="account-field">Link URL<span class="account-required">*</span>
                        <input name="put_linkUrl" type="text" placeholder="link url" required class="account-input" id="selected-linkUrl-edit"
                               maxlength="512">
                    </label>
                </div>

                <div class="account-btns grid-x">
                    <div class="cell small-12 medium-6">
                        <button id="btn-restore" class="account-restore-btn account-btn">Restore</button>
                    </div>
                    <div class="cell small-12 medium-6">
                        <button class="account-save-btn account-btn" type="submit">Save changes</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>
<!-- END OF EDIT MODAL -->

<!-- DELETE MODAL -->
<div class="reveal large _table-modal" id="delete-modal" data-reveal>
    <h3 class="_table-modal-title" id="delete-hair_style_link">Confirm delete hair style link</h3>
    <form method="POST" action="<?= 'hair_style_links.php?page=' . $page ?>">
        <input type="hidden" name="token" value="<?=$token?>">
        <input type="hidden" name="_method" value="DELETE" />
        <input id="delete_id" type="hidden" name="delete_id" value="0" />
        <div class="grid-container">
            <div class="grid-x">
                <table class="_table-modal-delete">
                    <tbody>
                    <tr class="_table-modal-delete-row">
                        <td class="_table-modal-delete-prop">id:</td>
                        <td id="selected-id-delete" class="_table-modal-delete-val">id</td>
                    </tr>
                    <tr class="_table-modal-delete-row">
                        <td class="_table-modal-delete-prop">face_shape:</td>
                        <td id="selected-hairStyle-delete" class="_table-modal-delete-val">hair_style</td>
                    </tr>
                    <tr class="_table-modal-delete-row">
                        <td class="_table-modal-delete-prop">link_name:</td>
                        <td id="selected-linkName-delete" class="_table-modal-delete-val">link_name</td>
                    </tr>
                    <tr class="_table-modal-delete-row">
                        <td class="_table-modal-delete-prop">link_url:</td>
                        <td id="selected-linkUrl-delete" class="_table-modal-delete-val">link_url</td>
                    </tr>

                    <tr class="_table-modal-delete-row">
                        <td class="_table-modal-delete-prop">date_created:</td>
                        <td id="selected-date_created-delete" class="_table-modal-delete-val">date_created</td>
                    </tr>
                    <tr class="_table-modal-delete-row">
                        <td class="_table-modal-delete-prop">date_modified:</td>
                        <td id="selected-date_modified-delete" class="_table-modal-delete-val">date_modified</td>
                    </tr>
                    </tbody>
                </table>
                <div class="account-btns grid-x">
                    <div class="cell small-12 medium-6">
                        <button id="btn-cancel" class="account-restore-btn account-btn">Cancel</button>
                    </div>
                    <div class="cell small-12 medium-6">
                        <form>
                            <button class="account-delete-btn account-btn" type="submit">Confirm</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <button class="close-button _table-modal-close" data-close aria-label="Close modal" type="button" id="close-delete-modal">
        <span aria-hidden="true">&times;</span>
    </button>
</div>
<!-- END OF DELETE MODAL -->


<!-- TOP BAR -->
<div class="title-bar" data-responsive-toggle="responsive-menu" data-hide-for="medium">
    <button class="menu-icon" type="button" data-toggle="responsive-menu" aria-label="Menu"></button>
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
                <button aria-label="Settings">
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
                <button aria-label="Notifications">
                    <img src="img/icons/notifications-dark.svg" alt="Notifications" class="_menu-icon"/>
                </button>
                <ul class="menu">
                    <li class="_menu-item"><a href="#" class="_dropdown-link">Example notification</a></li>
                </ul>
            </li>
            <li>
                <button aria-label="User">
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
            <button id="sidebar-close" class="hide" aria-label="Close">
                <img src="img/icons/caret-left.svg" alt="Close">
            </button>

            <button id="sidebar-open" style="transform: translateX(250%)" aria-label="Open">
                <img src="img/icons/caret-right-dark.svg" alt="Open">
            </button>
        </li>
    </ul>

    <!-- END OF SIDE BAR -->

    <!-- MAIN CONTENT -->
    <main class="main">
        <div class="grid-x _tables-grid">
            <div class="cell small-12 large-11 large-offset-4 _tables">
                <h2 class="_tables-title">Hair style links</h2>
                <form
                        action="<?= 'hair_style_links.php?page='. $page ?>"
                        method="POST"
                        class="_tables-search-input-container">
                    <input type="hidden" name="token" value="<?= $token ?>">
                    <label for="search" aria-label="Search for an entry"></label>
                    <input type="text" placeholder="Search for an entry..."
                           name="search"
                           id="search"
                           class="_tables-search _search-field"/>

                    <button class="_search-btn" data-search="users" type="submit" aria-label="Search">
                        <img src="img/icons/search.svg" alt="Search" class="_tables-search-icon">
                    </button>
                </form>

                <div class="grid-x _table-btn-container">
                    <div class="cell small-12 medium-2 text-center">
                        <button class="_table-btn _table-btn-add" data-open="add-modal">Add</button>
                    </div>
                    <div class="cell small-12 medium-2 text-center">
                        <button class="_table-btn _table-btn-edit _table-btn-disabled" data-open="edit-modal" disabled>Edit</button>
                    </div>
                    <div class="cell small-12 medium-2 text-center">
                        <button class="_table-btn _table-btn-delete _table-btn-disabled" data-open="delete-modal" disabled>Delete</button>
                    </div>
                </div>

                <?php
                if (isset($search)) {
                    ?>
                    <div class="text-center" style="margin-bottom: 5rem">
                        <h2 style="margin-bottom: 2.5rem; font-size: 2rem">
                            Search results for: <?= Utils::sanitiseField($search, FILTER_SANITIZE_STRING) ?>
                        </h2>
                        <a      style="font-size: 1.5rem"
                                href="hair_style_links.php"
                        >
                            Show all results
                        </a>
                    </div>
                <?php } ?>

                <table class="_resource-table _hairStyles-table">
                    <thead>
                    <tr>
                        <th>id</th>
                        <th>hair_style</th>
                        <th>link_name</th>
                        <th>link_url</th>
                        <th>date_created</th>
                        <th>date_modified</th>
                    </tr>
                    </thead>
                    <tbody>
                    <?php
                    for ($i = 0; $i < count($hairStyleLinks); $i++) { $hairStyleLink = $hairStyleLinks[$i]; ?>
                        <tr class="_tables-row">
                            <td class="_tables-cell id"><?= $hairStyleLink->id ?></td>
                            <td class="_tables-cell linkName" data-hair-style-id="<?=$hairStyleLink->hairStyleId?>"><?= $hairStyleLink->hairStyle->hairStyleName ?></td>
                            <td class="_tables-cell linkName"><?= $hairStyleLink->linkName ?></td>
                            <td class="_tables-cell linkUrl"><?= $hairStyleLink->linkUrl ?></td>
                            <td class="_tables-cell date_created"><?= Utils::prettyPrintDateTime($hairStyleLink->dateCreated) ?></td>
                            <td class="_tables-cell date_modified"><?= Utils::prettyPrintDateTime($hairStyleLink->dateModified) ?></td>
                        </tr>
                    <?php } ?>
                    </tbody>
                </table>
                <!-- PAGINATION -->
                <nav aria-label="Pagination" class="_pagination">
                    <ul class="pagination text-center">
                        <?php if ($page <= 1) {?>
                            <li class="pagination-previous disabled">Previous</li>
                        <?php } else { ?>
                            <li
                                    class="pagination-previous">
                                <?php
                                if (isset($search)) {
                                    ?>
                                    <a href="<?= $currentBaseUrl . '?page='. ($page - 1) . '&search=' . $search ?>">
                                        Previous
                                    </a>
                                <?php } else { ?>
                                    <a href="<?= $currentBaseUrl . '?page='. ($page - 1) ?>">
                                        Previous
                                    </a>
                                <?php } ?>
                            </li>
                        <?php } ?>

                        <?php
                        for ($i = 1; $i <= $totalNumberOfPages; $i++) {
                            ?>
                            <li>
                                <?php if ($i === $page) { ?>
                                    <?php if (isset($search)) { ?>
                                        <a
                                                class="current"
                                                href="<?= $currentBaseUrl . '?page=' . $i . '&search=' . $search?>" aria-label="<?= 'Page ' . $page ?>">
                                            <?= $i ?>
                                        </a>
                                    <?php } else {?>

                                        <a
                                                class="current"
                                                href="<?= $currentBaseUrl . '?page=' . $i ?>" aria-label="<?= 'Page ' . $page ?>">
                                            <?= $i ?>
                                        </a>
                                    <?php } ?>
                                <?php } else { ?>

                                    <?php if (isset($search)) { ?>
                                        <a
                                                href="<?= $currentBaseUrl . '?page=' . $i . '&search=' . $search ?>" aria-label="<?= 'Page ' . $page ?>">
                                            <?= $i ?>
                                        </a>
                                    <?php } else { ?>
                                        <a
                                                href="<?= $currentBaseUrl . '?page=' . $i ?>" aria-label="<?= 'Page ' . $page ?>">
                                            <?= $i ?>
                                        </a>
                                    <?php } ?>
                                <?php } ?>
                            </li>
                        <?php } ?>

                        <?php if ($page >= $totalNumberOfPages) {?>
                            <li class="pagination-next disabled">
                                Next
                            </li>
                        <?php } else {?>
                            <li class="pagination-next">
                                <?php if (isset($search)) { ?>
                                    <a href="<?= $currentBaseUrl . '?page=' . ($page + 1) . '&search=' . $search ?>">
                                        Next
                                    </a>
                                <?php } else { ?>
                                    <a href="<?= $currentBaseUrl . '?page=' . ($page + 1) ?>">
                                        Next
                                    </a>
                                <?php } ?>
                            </li>
                        <?php } ?>
                    </ul>
                </nav>

                <!-- END OF PAGINATION -->
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

<!-- <script src="js/index.js"></script>
<script src="js/alert.js"></script>
<script src="js/authenticate.js"></script>
<script src="js/sidebar.js"></script>
<script src="js/redirect.js"></script>
<script src="js/hair_style_links.js"></script> -->
</body>

</html>