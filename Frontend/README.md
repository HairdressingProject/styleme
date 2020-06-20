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

### 2 - Install the Live Server extension
If you're using VSCode and have not installed it yet, search for "live server" under the extensions tab as illustrated in the picture below and it should be the first result.

![Live Server](https://i.imgur.com/6nOHYJE.png "Live Server")

Now you should be all set. Start Live Server (available in the bottom right) and navigate to any of the HTML pages to start developing.