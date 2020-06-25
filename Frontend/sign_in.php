<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8" />
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sign in</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/foundation/6.6.3/css/foundation.min.css"
        integrity="sha256-ogmFxjqiTMnZhxCqVmcqTvjfe1Y/ec4WaRj/aQPvn+I=" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/index.css" />
</head>

<body class="landing-background">
    <noscript>Please enable JavaScript for this page to work</noscript>

    <div class="sign-in grid-x">
        <div class="cell small-12 medium-6 large-4 medium-offset-3 large-offset-4 sign-in-container">
            <h1 class="sign-in-title">Hairdressing Application - Admin Portal</h1>
            <p class="sign-in-subtitle">Welcome back! Please login to continue.</p>

            <form action="https://localhost:5000/api/users/sign_in" method="POST" id="sign-in-form">
                <div class="sign-in-username" id="sign-in-username">
                    <div class="input-group sign-in-input-group" id="sign-in-username-group">
                        <span class="input-group-label sign-in-input-label">
                            <img src="./img/icons/mail.svg" alt="Username or email" class="sign-in-input-icon" />
                        </span>
                        <input type="text" class="input-group-field sign-in-input" placeholder="Username or email"
                            id="username" required maxlength="512" />
                    </div>
                </div>

                <div class="sign-in-password" id="sign-in-password">
                    <div class="input-group sign-in-input-group sign-in-input-group-last" id="sign-in-password-group">
                        <span class="input-group-label sign-in-input-label">
                            <img src="./img/icons/password.svg" alt="Password" class="sign-in-input-icon" />
                        </span>
                        <input type="password" class="input-group-field sign-in-input" placeholder="Password"
                            id="password" required minlength="6" maxlength="512" />
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

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"
        integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/what-input/5.2.10/what-input.min.js"
        integrity="sha256-ZLjSztVkz5q3lKFjN9AgL6qR7TGLE+qnTXnNNTWtMF4=" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/foundation/6.6.3/js/foundation.min.js"
        integrity="sha256-pRF3zifJRA9jXGv++b06qwtSqX1byFQOLjqa2PTEb2o=" crossorigin="anonymous"></script>

    <script src="js/index.js"></script>
    <script src="js/alert.js"></script>
    <script src="js/sign-in.js"></script>
</body>

</html>