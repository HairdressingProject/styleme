<?php
    // require_once $_SERVER['DOCUMENT_ROOT'] . '/helpers/redirect-https.php';
    require_once $_SERVER['DOCUMENT_ROOT'] . '/helpers/utils.php';
    require_once $_SERVER['DOCUMENT_ROOT'] . '/helpers/authentication.php';

    if (isAuthenticated()) {
        $parsedUrl = parse_url($_SERVER['REQUEST_URI']);
        $currentBaseUrl = Utils::getUrlProtocol().$_SERVER['SERVER_NAME'];
        header('Location: ' . $currentBaseUrl . '/database.php', true, 302);
        exit();
    }
?>

<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8" />
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="Admin Portal website for the Hairdressing Project" />
    <title>Sign in</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/foundation/6.6.3/css/foundation.min.css"
        integrity="sha256-ogmFxjqiTMnZhxCqVmcqTvjfe1Y/ec4WaRj/aQPvn+I=" crossorigin="anonymous" media="screen" />
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/index.css" media="screen" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"
        integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous" defer></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/what-input/5.2.10/what-input.min.js"
        integrity="sha256-ZLjSztVkz5q3lKFjN9AgL6qR7TGLE+qnTXnNNTWtMF4=" crossorigin="anonymous" defer></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/foundation/6.6.3/js/foundation.min.js"
        integrity="sha256-pRF3zifJRA9jXGv++b06qwtSqX1byFQOLjqa2PTEb2o=" crossorigin="anonymous" defer></script>
</head>

<body class="landing-background">
    <noscript>Please enable JavaScript for this page to work</noscript>

    <div class="sign-in grid-x">
        <div class="cell small-12 medium-6 large-4 medium-offset-3 large-offset-4 sign-in-container">
            <h1 class="sign-in-title">Hairdressing Application - Admin Portal</h1>
            <p class="sign-in-subtitle">Welcome back! Please login to continue.</p>

            <form action="http://localhost:5050/users/sign_in" method="POST" id="sign-in-form">
                <div class="sign-in-username" id="sign-in-username">
                    <div class="input-group sign-in-input-group" id="sign-in-username-group">
                        <label for="username" class="input-group-label sign-in-input-label">
                            <img src="./img/icons/mail.svg" alt="Username or email" class="sign-in-input-icon" />
                        </label>
                        <input type="text" name="username" class="input-group-field sign-in-input" placeholder="Username or email"
                            id="username" required maxlength="512" />
                    </div>
                </div>

                <div class="sign-in-password" id="sign-in-password">
                    <div class="input-group sign-in-input-group sign-in-input-group-last" id="sign-in-password-group">
                        <label for="password" class="input-group-label sign-in-input-label">
                            <img src="./img/icons/password.svg" alt="Password" class="sign-in-input-icon" />
                        </label>
                        <input type="password" class="input-group-field sign-in-input" placeholder="Password"
                            id="password" name="password" required minlength="6" maxlength="512" />
                    </div>
                </div>

                <div class="sign-in-submit">
                    <button class="sign-in-submit-btn" id="sign-in-btn" type="submit">Sign in</button>
                </div>
        </div>
        </form>
    </div>


    <div class="grid-x new-user">
        <p class="cell text-center new-user-text">New user? <a href="sign_up.php">Sign up</a></p>
    </div>
</body>

</html>