# Admin Portal - Backend

## Testing routes
The [Postman_Collections](/Backend/Postman_Collections "Postman Collections") folder contains several `json` files, each including all routes to perform BREAD operations on the respective table in the database. You can use them to test any route in Postman.

Follow the instructions below to do so:

### 1- Importing collections
Click on the __Import__ button (top left):

![Importing collections](https://i.imgur.com/Y1Jcenw.png "Importing collections")

The __Import__ pop-up will open. Select all `json` files from the [Postman_Collections](/Admin/Backend/Postman_Collections "Postman Collections") folder and drag them where indicated:

![Dragging collection files](https://i.imgur.com/hnk7M39.png "Dragging collection files")

After all collections have been successfully imported, you can now explore all routes. Select the __Collections__ tab and expand any collection (Colours is shown as an example below). You should now see all routes associated with that table in the database. Click any of them to open the request settings.

![Browsing routes](https://i.imgur.com/XK7KDcj.png "Browsing routes")

### 2 - Setting up the database
From the [Database](/Database "Database") folder, run:
```
mysql -u root -p < database_v.2.1.sql
```

### 3 - Generating pepper
The back-end uses a [pepper](https://en.wikipedia.org/wiki/Pepper_(cryptography) "Pepper") that is added to hashed passwords. It is the same for all passwords, but stored outside of the application and the database. 

Navigate to the [AdminApi](/Backend/AdminApi/ "AdminApi") folder before running the commands below.

Now choose a Pepper secret (can be any string) and run the commands below to store the Pepper secret in your computer:

```
dotnet user-secrets init
dotnet user-secrets set "Application:Pepper" "<insert your secret here>"
```

To view your secret, run:

```
dotnet user-secrets list
```

To start both back-end and database servers, run:

```
dotnet watch run
```

### 4 - Sending requests
Before testing any route, you will first have to create a new sample admin account. That is because all passwords are now hashed by the server before being added to the database, so they should not be directly added with `INSERT` statements. 

Send a `POST /users/sign_up` request with a request body in the following format (you may change each property to suit your preferences):

```json
{
    "UserName": "admin",
    "UserPassword": "123456",
    "UserEmail": "admin@mail.com",
    "FirstName": "Admin",
    "UserRole": "admin"
}
```

> After you submit your request, notice that the user role was added as "user" instead of "admin". This is intentional, otherwise anyone would be able to register as admin. Similar measures may be implemented in other routes, if time permits.

If you have already registered an account, you can send a `POST /users/sign_in` request with the format below to authenticate:

```json
{
  "UserNameOrEmail": "admin",
  "UserPassword": "123456"
}
```

After you click "Send" (whether you signed in or signed up), you should get a cookie from the server:

![Cookie](https://i.imgur.com/OER135W.png "Cookie")

Now this cookie will be automatically sent back to the server (included in the headers by Postman) on every new request that you make, so you don't need to touch the Authorization tab.

> Note: if you get an error message saying "Invalid request origin", simply add this Origin header to your request:

![Origin](https://i.imgur.com/Q5nFuAp.png "Origin")

All `GET` and `DELETE` requests should work out of the box. You will have to provide a request `body` to `PUT` and `POST` requests (check the attributes in the corresponding [Model](AdminApi/Models_v2_1 "Models v2.1") file to understand how each property is validated).

> Remember: `PUT` requests require an `id` both in the endpoint and in the request `body`. You will also have to include __all__ `[Required]` properties in the request `body` (plus `DateCreated`), not just the ones that you wish to modify.

After you have set up your request, simply click __Send__. 

### Extra - Pagination & Searching
The "Colours" folder in the project's main Postman-collection outlines how pagination & searching work requests work in the project's API.
