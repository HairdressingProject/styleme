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

### 2 - Sending requests
As explained in the [Instructions](/README.md#11---testing-backend-connection "Instructions"), you should now sign in to get a token from the backend. You can reuse the same token for any new request by simply copying and pasting it into the __Token__ field in the `Authorization` tab (do not forget to select the `Bearer Token` type in the dropdown). 

All `GET` and `DELETE` requests should work out of the box. You will have to provide a request `body` to `PUT` and `POST` requests (check the attributes in the corresponding [Model](/Admin/Backend/AdminApi/Models "Models") file to understand how each property is validated).

> Remember: `PUT` requests require an `id` both in the endpoint and in the request `body`. You will also have to include __all__ `[Required]` properties in the request `body` (plus `DateCreated`), not just the ones that you wish to modify.

After you have set up your request, simply click __Send__. 
