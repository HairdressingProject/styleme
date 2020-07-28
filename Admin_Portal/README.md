# Admin Portal - Frontend

## Setting up
### 1 - Install SASS
I recommend using the [Dart SASS CLI](https://sass-lang.com/documentation/cli/dart-sass "Dart SASS") (latest version of SASS' CLI) instead of the [Live SASS Compiler](https://github.com/ritwickdey/vscode-live-sass-compiler "Live SASS Compiler") extension for VSCode, because the latter hasn't been updated in nearly 2 years. It doesn't seem to support `@use`, for example.

Instructions are available at https://sass-lang.com/install

After you install it, run the command below from the Frontend folder:

```bash
sass scss/index.scss css/index.css --watch --color
```

Now when you edit any of the files in the `scss` folder, they will be automatically compiled to `css/index.css` (all the style rules will be bundled together, which can then be minified for production).

### 2 - Set up Laragon to serve the pages
Stop Laragon (if you're currently running it) and follow the steps below to serve the application with Apache instead of Live Server from VSCode.

1. Move the entire project (from the root folder) to your `www` directory 
2. Go to __Preferences (cog button) > Services & Ports > change Apache port to 5500__
![Laragon - changing Apache port](https://i.imgur.com/WQuyIs4.png "Changing Apache port")

3. Go to __Menu > `www` (second submenu from the top) > Switch Document Root > Select another__ and then choose your Frontend folder
![Laragon - changing root directory](https://i.imgur.com/NlbJoO1.png "Changing root directory")

Notice that I have already changed it, that's why it's showing `C:\laragon\www\Admin-Portal-v2\Frontend`

4. Start Laragon. You might be prompted to allow admin access several times (mildly annoying).

5. Navigate to [http://localhost:5500/sign_in.php](http://localhost:5500/sign_in.php "Sign In") and the application should work.

Now you may open the project (from the root folder or from Frontend) in PHPStorm and start working on it. Check the console for errors and confirm that you're still successfully fetching data from the API (when you get to the Database page). 

> Make sure that you have already set up the backend (including the database) and started it as well, by running `dotnet watch run` from the AdminApi folder.

## Naming Convention
- Classes : PascalCase, singular
- Tables in database: snake_case, plural
- Properties: camelCase
- Constants: UPPERCASE_SEPARATED_BY_UNDERSCORES
