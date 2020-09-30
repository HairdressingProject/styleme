<?php
    // require_once $_SERVER['DOCUMENT_ROOT'] . '/helpers/redirect-https.php';
    require_once $_SERVER['DOCUMENT_ROOT'] . '/helpers/utils.php';
    
    $alert = null;
    $parsedUrl = parse_url($_SERVER['REQUEST_URI']);
    $currentBaseUrl = Utils::getUrlProtocol().$_SERVER['SERVER_NAME'];

    if ($_POST) {
        $alert = Utils::createAlert(
            'Sorry, registrations are currently closed. Contact your admin for more details.',
            'error');
    }

?>

<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8" />
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="Admin Portal website for the Hairdressing Project" />
    <title>Sign up</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/foundation/6.6.3/css/foundation.min.css"
        integrity="sha256-ogmFxjqiTMnZhxCqVmcqTvjfe1Y/ec4WaRj/aQPvn+I=" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/index.css" />
<script defer src="dist/js/alert.5fbb88c61d48f3e1ef1b.js"></script><script defer src="dist/js/index.a4419fb66731ce4f5d91.js"></script><script defer src="dist/js/sign_up.89ebd79dd47a483c30b7.js"></script></head>

<body class="landing-background">
    <noscript>Please enable JavaScript for this page to work</noscript>
    <?php if(isset($alert)) echo $alert; ?>
    <div class="sign-up grid-x">
        <div class="cell small-12 medium-6 large-4 medium-offset-3 large-offset-4 sign-up-container">
            <h1 class="sign-up-title">Hairdressing Application - Admin Portal</h1>
            <p class="sign-up-subtitle">Hey there! Let's get started</p>

            <form action="<?= $currentBaseUrl . '/sign_up.php' ?>" method="POST" id="sign-up-form">
                <div class="sign-up-given-name" id="sign-up-given-name">
                    <div class="input-group sign-up-input-group" id="sign-up-given-name-group">
                        <label for="given-name" class="input-group-label sign-up-input-label">
                            <img src="./img/icons/user.svg" alt="Given name" class="sign-up-input-icon" />
                        </label>
                        <input type="text" class="input-group-field sign-up-input" placeholder="Given name"
                            id="given-name" name="given-name" required maxlength="128" />
                    </div>
                </div>

                <div class="sign-up-family-name" id="sign-up-family-name">
                    <div class="input-group sign-up-input-group" id="sign-up-family-name-group">
                        <label for="family-name" class="input-group-label sign-up-input-label">
                            <img src="./img/icons/user.svg" alt="Family name" class="sign-up-input-icon" />
                        </label>
                        <input type="text" class="input-group-field sign-up-input" placeholder="Family name"
                            id="family-name" name="family-name" maxlength="128" />
                    </div>
                </div>

                <div class="sign-up-username" id="sign-up-username">
                    <div class="input-group sign-up-input-group" id="sign-up-username-group">
                        <label for="username" class="input-group-label sign-up-input-label">
                            <img src="./img/icons/user.svg" alt="Username or email" class="sign-up-input-icon" />
                        </label>
                        <input type="text" class="input-group-field sign-up-input" placeholder="Username" id="username"
                            required maxlength="32" name="username" />
                    </div>
                </div>

                <div class="sign-up-email" id="sign-up-email">
                    <div class="input-group sign-up-input-group" id="sign-up-email-group">
                        <label for="email" class="input-group-label sign-up-input-label">
                            <img src="./img/icons/mail.svg" alt="Email" class="sign-up-input-icon" />
                        </label>
                        <input type="email" class="input-group-field sign-up-input" placeholder="Email" id="email"
                            required maxlength="512" name="email" />
                    </div>
                </div>

                <div class="sign-up-password" id="sign-up-password">
                    <div class="input-group sign-up-input-group sign-up-input-group-last" id="sign-up-password-group">
                        <label for="password" class="input-group-label sign-up-input-label">
                            <img src="./img/icons/password.svg" alt="Password" class="sign-up-input-icon" />
                        </label>
                        <input type="password" class="input-group-field sign-up-input" placeholder="Password"
                            id="password" required minlength="6" maxlength="512" name="password" />
                    </div>
                </div>

                <div class="sign-up-confirm-password" id="sign-up-confirm-password">
                    <div class="input-group sign-up-input-group sign-up-input-group-last"
                        id="sign-up-confirm-password-group">
                        <label for="confirm-password" class="input-group-label sign-up-input-label">
                            <img src="./img/icons/password.svg" alt="Confirm Password" class="sign-up-input-icon" />
                        </label>
                        <input type="password" class="input-group-field sign-up-input" placeholder="Confirm Password"
                            id="confirm-password" required minlength="6" name="confirm-password" maxlength="512" />
                    </div>
                </div>

                <div class="sign-up-submit">
                    <button class="sign-up-submit-btn" id="sign-up-btn" type="submit">Sign up</button>
                </div>
        </div>
        </form>
    </div>


    <div class="grid-x returning-user">
        <p class="cell text-center returning-user-text">Returning user? <a href="sign_in.php">Sign in</a></p>
    </div>


    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"
        integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/what-input/5.2.10/what-input.min.js"
        integrity="sha256-ZLjSztVkz5q3lKFjN9AgL6qR7TGLE+qnTXnNNTWtMF4=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/foundation/6.6.3/js/foundation.min.js"
        integrity="sha256-pRF3zifJRA9jXGv++b06qwtSqX1byFQOLjqa2PTEb2o=" crossorigin="anonymous"></script>

    <!-- <script src="js/index.js"></script>
    <script src="js/alert.js"></script>
    <script src="js/sign-up.js"></script> -->
</body>

</html>