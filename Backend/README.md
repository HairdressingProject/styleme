# Admin Portal - Backend

## Testing routes
The [Postman_Collections](/Admin/Backend/Postman_Collections "Postman Collections") folder contains several `json` files, each including all routes to perform BREAD operations on the respective table in the database. You can use them to test any route in Postman.

Follow the instructions below to do so:

### 1- Importing collections
Click on the __Import__ button (top left):

![Importing collections](https://i.imgur.com/Y1Jcenw.png "Importing collections")

The __Import__ pop-up will open. Select all `json` files from the [Postman_Collections](/Admin/Backend/Postman_Collections "Postman Collections") folder and drag them where indicated:

![Dragging collection files](https://i.imgur.com/hnk7M39.png "Dragging collection files")

After all collections have been successfully imported, you can now explore all routes. Select the __Collections__ tab and expand any collection (Colours is shown as an example below). You should now see all routes associated with that table in the database. Click any of them to open the request settings.

![Browsing routes](https://i.imgur.com/XK7KDcj.png "Browsing routes")

### 2 - Generating pepper
The back-end uses a [pepper](https://en.wikipedia.org/wiki/Pepper_(cryptography) "Pepper") that is added to hashed passwords. It is the same for all passwords, but stored outside of the application and the database. 

Choose a secret (can be any string) and run the commands below (from the __AdminApi__ folder) to store it in your computer:

```
dotnet user-secrets init
dotnet user-secrets set "Application:Pepper" "<insert your secret here>"
```

To view your secret, run:

```
dotnet user-secrets list
```

Don't forget to start both back-end and database servers before proceeding to the next step.

### 3 - Sending requests
Before testing any route, you will first have to sign in (use the `POST /api/users/sign_in` route for this). Sample admin details are still the same as the old repo:
```
{
  "UserNameOrEmail": "admin",
  "UserPassword": "123456"
}
```

After you click "Send", you should get a cookie from the server:

![Cookie](https://i.imgur.com/OER135W.png "Cookie")

Now this cookie will be automatically sent back to the server (included in the headers by Postman) on every new request that you make, so you don't need to touch the Authorization tab.

> Note: if you get an error message saying "Invalid request origin", simply add this Origin header to your request:

![Origin](https://i.imgur.com/Q5nFuAp.png "Origin")

All `GET` and `DELETE` requests should work out of the box. You will have to provide a request `body` to `PUT` and `POST` requests (~~check the attributes in the corresponding [Model](/Admin/Backend/AdminApi/Models "Models") file to understand how each property is validated).~~

> Remember: `PUT` requests require an `id` both in the endpoint and in the request `body`. You will also have to include __all__ `[Required]` properties in the request `body` (plus `DateCreated`), not just the ones that you wish to modify.

After you have set up your request, simply click __Send__. 
