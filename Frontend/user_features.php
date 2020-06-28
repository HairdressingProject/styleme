<?php
/*******************************************************
 * Project:     Admin-Portal-v2
 * File:        user_features.php
 * Author:      Your name
 * Date:        2020-06-28
 * Version:     1.0.0
 * Description:
 *******************************************************/

require_once $_SERVER['DOCUMENT_ROOT'] . '/helpers/utils.php';
require_once $_SERVER['DOCUMENT_ROOT']. '/helpers/actions/browse.php';
require_once $_SERVER['DOCUMENT_ROOT']. '/classes/UserFeature.php';

$token = Utils::addCSRFToken();
$alert = null;
$uf = new UserFeature();
$fs = new FaceShape();
$st = new SkinTone();
$hs = new HairStyle();


$userFeatures = [];
$faceShapes = [];
$skinTones = [];
$hairStyles = [];

if ($_POST && Utils::verifyCSRFToken()) {
    if (isset($_POST['_method'])) {
        $alert = $uf->handleSubmit($_POST['_method']);
    } else {
        $alert = $uf->handleSubmit();
    }
}

if (isset($_COOKIE["auth"])) {
    $browseResponse = $uf->browse();
    $userFeatures = $browseResponse['userFeatures'];

    $browseFaceShapesResponse = $fs->browse();
    $faceShapes = $browseFaceShapesResponse['faceShapes'];

    $browseSkinTonesResponse = $st->browse();
    $skinTones = $browseSkinTonesResponse['skinTones'];

    $hairStyles = $hs->browse()['hairStyles'];
}
?>

<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8"/>
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>User Features</title>
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
    <h3 class="_table-modal-title">Add a new user feature</h3>
    <button class="close-button _table-modal-close" data-close aria-label="Close modal" type="button">
        <span aria-hidden="true">&times;</span>
    </button>

    <form action="user_features.php" method="POST">
        <input type="hidden" name="token" value="<?=$token?>">
        <div class="grid-container">
            <div class="grid-x">
                <div class="cell account-field-cell" id="userFeatures-userId">
                    <label class="account-field">user_id<span class="account-required">*</span>
                        <input name="add_userId" type="text" placeholder="user_id" required class="account-input" id="selected-userId-add"
                               maxlength="32">
                    </label>
                </div>
                <div class="cell account-field-cell" id="userFeatures-faceShapeId">
                    <label class="account-field">face_shape_id<span class="account-required">*</span>
                        <input name="add_faceShapeId" type="text" placeholder="face_shape_id" required class="account-input" id="selected-faceShapeId-add"
                               maxlength="512">
                    </label>
                </div>
                <div class="cell account-field-cell" id="userFeatures-skinToneId">
                    <label class="account-field">skin_tone_id<span class="account-required">*</span>
                        <input name="add_skinToneId" type="text" placeholder="skin_tone_id" required class="account-input"
                               maxlength="128" id="selected-skinToneId-add">
                    </label>
                </div>
                <div class="cell account-field-cell" id="account-family-name">
                    <label class="account-field">last_name
                        <input name="add_last_name" type="text" placeholder="last_name" class="account-input" id="selected-last_name-add"
                               maxlength="128">
                    </label>
                </div>
                <div class="cell account-field-cell" id="account-given-name">
                    <label class="account-field">user_password<span class="account-required">*</span>
                        <input name="add_password" type="password" placeholder="******" required minlength="6" maxlength="512"
                               class="account-input" id="selected-password-add">
                        <button class="account-reveal-password">
                            <img src="img/icons/eye.svg" alt="Reveal password">
                        </button>
                    </label>
                </div>
                <div class="cell account-field-cell">
                    <label class="account-field">Confirm password<span class="account-required">*</span>
                        <input name="add_confirm_password" type="password" placeholder="******" required minlength="6" maxlength="512"
                               class="account-input" id="selected-confirm-password-add">
                        <button class="account-reveal-password account-reveal-password-active">
                            <img src="img/icons/eye.svg" alt="Reveal password">
                        </button>
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
    <h3 class="_table-modal-title">Edit a user feature</h3>
    <button class="close-button _table-modal-close" data-close aria-label="Close modal" type="button">
        <span aria-hidden="true">&times;</span>
    </button>
    <form action="user_features.php" method="POST" id="edit-form">
        <input type="hidden" name="token" value="<?=$token?>">
        <input type="hidden" name="_method" value="PUT" />
        <input id="selected-id-edit" type="hidden" name="put_id" value="0" />
        <div class="grid-container">
            <div class="grid-x">
                <div class="cell account-field-cell" id="account-username">
                    <label class="account-field">user_name<span class="account-required">*</span>
                        <input type="text" placeholder="user_name" name="put_username" required class="account-input" id="selected-username-edit"
                               maxlength="32">
                    </label>
                </div>



                <div class="cell account-field-cell">
                    <label class="account-field">face shape<span class="account-required">*</span>
                        <span class="grid-x account-user_role-container">
                            <select name="put_faceShapeId" class="account-user_role" id="selected-faceShape-edit" required>
                                <?php
                                // loop trough all face shapes
                                for ($i = 0; $i < count($faceShapes); $i++) {
                                    ?>
                                    <option value="<?= $faceShapes[$i]->id //id?>">
                                            <?= $faceShapes[$i]->shapeName //name?>
                                        </option>
                                <?php } ?>
                            </select>
                        </span>

                    </label>
                </div>

                <div class="cell account-field-cell">
                    <label class="account-field">skin tone<span class="account-required">*</span>
                        <span class="grid-x account-user_role-container">
                            <select name="put_skinToneId" class="account-user_role" id="selected-skinTone-edit" required>
                                <?php
                                // loop trough all skin tones
                                for ($i = 0; $i < count($skinTones); $i++) {
                                    ?>
                                    <option value="<?= $skinTones[$i]->id //id?>">
                                            <?= $skinTones[$i]->skinToneName //name?>
                                        </option>
                                <?php } ?>
                            </select>
                        </span>

                    </label>
                </div>

                <div class="cell account-field-cell">
                    <label class="account-field">hair style<span class="account-required">*</span>
                        <span class="grid-x account-user_role-container">
                            <select name="put_hairStyleId" class="account-user_role" id="selected-hairStyle-edit" required>
                                <?php
                                // loop trough all hair styles
                                for ($i = 0; $i < count($hairStyles); $i++) {
                                    ?>
                                    <option value="<?= $hairStyles[$i]->id //id?>">
                                            <?= $hairStyles[$i]->hairStyleName //name?>
                                        </option>
                                <?php } ?>
                            </select>
                        </span>

                    </label>
                </div>



                <div class="cell account-field-cell" id="account-given-name">
                    <label class="account-field">first_name<span class="account-required">*</span>
                        <input type="text" placeholder="first_name" name="put_first_name" required class="account-input"
                               maxlength="128" id="selected-first_name-edit">
                    </label>
                </div>
                <div class="cell account-field-cell" id="account-family-name">
                    <label class="account-field">last_name
                        <input type="text" placeholder="last_name" name="put_last_name" class="account-input" id="selected-last_name-edit"
                               maxlength="128">
                    </label>
                </div>
                <div class="cell account-field-cell">
                    <label class="account-field">user_role<span class="account-required">*</span>
                        <span class="grid-x account-user_role-container">
                            <select name="put_user_role" class="account-user_role" id="selected-user_role-edit" required>
                                <option value="user">User</option>
                                <option value="developer">Developer</option>
                                <option value="admin">Admin</option>
                            </select>
                        </span>

                    </label>
                </div>
                <div class="cell account-field-cell" id="account-given-name">
                    <label class="account-field">user_password<span class="account-required">*</span>
                        <input type="password" name="put_password" placeholder="******" required minlength="6" maxlength="512"
                               class="account-input" id="selected-password-edit">
                        <button class="account-reveal-password">
                            <img src="img/icons/eye.svg" alt="Reveal password">
                        </button>
                    </label>
                </div>
                <div class="cell account-field-cell">
                    <label class="account-field">Confirm password<span class="account-required">*</span>
                        <input type="password" placeholder="******" required minlength="6" maxlength="512"
                               class="account-input" name="put_confirm_password" id="selected-confirm-password-edit">
                        <button class="account-reveal-password account-reveal-password-active">
                            <img src="img/icons/eye.svg" alt="Reveal password">
                        </button>
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
    <h3 class="_table-modal-title" id="delete-user">Confirm delete user feature</h3>
    <form method="POST" action="user_features.php">
        <input type="hidden" name="token" value="<?=$token?>">
        <input type="hidden" name="_method" value="DELETE" />
        <input id="delete_id" type="hidden" name="delete_id" value="0" />
        <div class="grid-container">
            <div class="grid-x">
                <table class="_table-modal-delete">
                    <tbody>
                    <tr class="_table-modal-delete-row">
                        <td class="_table-modal-delete-prop">id:</td>
                        <td id="selected-id-delete" class="_table-modal-delete-val">user_feature_id</td>
                    </tr>
                    <tr class="_table-modal-delete-row">
                        <td class="_table-modal-delete-prop">user_name:</td>
                        <td id="selected-user_name-delete" class="_table-modal-delete-val">user_name</td>
                    </tr>
                    <tr class="_table-modal-delete-row">
                        <td class="_table-modal-delete-prop">face_shape_name:</td>
                        <td id="selected-face_shape_name-delete" class="_table-modal-delete-val">face_shape_name</td>
                    </tr>
                    <tr class="_table-modal-delete-row">
                        <td class="_table-modal-delete-prop">skin_tone_name:</td>
                        <td id="selected-skin_tone_name-delete" class="_table-modal-delete-val">skin_tone_name</td>
                    </tr>
                    <tr class="_table-modal-delete-row">
                        <td class="_table-modal-delete-prop">hair_style_name:</td>
                        <td id="selected-hair_style_name-delete" class="_table-modal-delete-val">hair_style_name</td>
                    </tr>
                    <tr class="_table-modal-delete-row">
                        <td class="_table-modal-delete-prop">hair_length_name:</td>
                        <td id="selected-hair_length_name-delete" class="_table-modal-delete-val">hair_length_name</td>
                    </tr>
                    <tr class="_table-modal-delete-row">
                        <td class="_table-modal-delete-prop">hair_colour_name:</td>
                        <td id="selected-hair_colour_name-delete" class="_table-modal-delete-val">hair_colour_name</td>
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
    <main class="main">
        <div class="grid-x _tables-grid">
            <div class="cell small-12 large-11 large-offset-4 _tables">
                <h2 class="_tables-title">User Featres</h2>
                <div class="_tables-search-input-container">
                    <input type="text" placeholder="Search for an entry..." id="entries-search-input"
                           class="_tables-search"/>
                    <img src="img/icons/search.svg" alt="Search" class="_tables-search-icon">
                </div>

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

                <table class="_resource-table _users-table">
                    <thead>
                    <tr>
                        <th>id</th>
                        <th>user_name</th>
                        <th>face_shape_name</th>
                        <th>skin_tone_name</th>
                        <th>hair_style_name</th>
                        <th>hair_length_name</th>
                        <th>hair_colour_name</th>
                        <th>date_created</th>
                        <th>date_modified</th>
                    </tr>
                    </thead>
                    <tbody>
                    <?php
                    for ($i = 0; $i < count($userFeatures); $i++) { $userFeatures = $userFeatures[$i]; ?>
                        <tr class="_tables-row">
                            <td class="_tables-cell id"><?= $userFeatures->id ?></td>
                            <td class="_tables-cell user_id" data-user-id="<?=$userFeatures->userId?>"><?= $userFeatures->user->userName ?></td>
                            <td class="_tables-cell face_shape_name" data-face-shape-id="<?=$userFeatures->faceShapeId?>"><?= $userFeatures->faceShape->shapeName ?></td>
                            <td class="_tables-cell skin_tone_name" data-skin-tone-id="<?=$userFeatures->skinToneId?>"><?= $userFeatures->skinTone->skinToneName ?></td>
                            <td class="_tables-cell hair_style_name" data-hair-style-id="<?=$userFeatures->hairStyleId?>"><?= $userFeatures->hairStyle->hairStyleName ?></td>
                            <td class="_tables-cell hair_length_name" data-hair-length-id="<?=$userFeatures->hairLengthId?>"><?= $userFeatures->hairLength->hairLengthName ?></td>
                            <td class="_tables-cell hair_colour_name" data-hair-colour-id="<?=$userFeatures->hairColourId?>"><?= $userFeatures->hairColour->colourName ?></td>
                            <td class="_tables-cell date_created"><?= Utils::prettyPrintDateTime($userFeatures->dateCreated) ?></td>
                            <td class="_tables-cell date_modified"><?= Utils::prettyPrintDateTime($userFeatures->dateModified) ?></td>
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
<script src="js/redirect.js"></script>
<script src="js/user_features.js"></script>
</body>

</html>