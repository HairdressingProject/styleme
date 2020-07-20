# Admin Portal - Backend

## Table of Contents

- [Admin Portal - Backend](#admin-portal---backend)
  * [API endpoints](#api-endpoints)
    + [Users](#users)
      - [GET /users[?limit={limit}&offset={offset}&search={search}]](#get--users--limit--limit--offset--offset--search--search--)
        * [Optional queries](#optional-queries)
        * [Remarks](#remarks)
      - [GET /users/{id}](#get--users--id-)
      - [GET /users/{token}](#get--users--token-)
      - [GET /users/count[?search={search}]](#get--users-count--search--search--)
        * [Optional queries](#optional-queries-1)
        * [Remarks](#remarks-1)
      - [GET /users/authenticate](#get--users-authenticate)
        * [Remarks](#remarks-2)
      - [GET /users/logout](#get--users-logout)
        * [Remarks](#remarks-3)
      - [POST /users/sign_in](#post--users-sign-in)
        * [Example request body](#example-request-body)
      - [POST /users/sign_up](#post--users-sign-up)
        * [Example request body](#example-request-body-1)
        * [Remarks](#remarks-4)
      - [POST /users](#post--users)
        * [Remarks](#remarks-5)
      - [POST /users/forgot_password](#post--users-forgot-password)
        * [Example request body](#example-request-body-2)
        * [Remarks](#remarks-6)
      - [PUT /users/{id}](#put--users--id-)
        * [Example request body](#example-request-body-3)
        * [Remarks](#remarks-7)
      - [PUT /users/{id}/change_password](#put--users--id--change-password)
        * [Example request body](#example-request-body-4)
        * [Remarks](#remarks-8)
      - [PUT /users/{token}/change_password](#put--users--token--change-password)
        * [Example request body](#example-request-body-5)
      - [PUT /users/{id}/change_role](#put--users--id--change-role)
        * [Example request body](#example-request-body-6)
        * [Remarks](#remarks-9)
      - [DELETE /users/{id}](#delete--users--id-)
    + [User features](#user-features)
      - [GET /user_features[?limit={limit}&offset={offset}&search={search}]](#get--user-features--limit--limit--offset--offset--search--search--)
        * [Optional queries](#optional-queries-2)
        * [Remarks](#remarks-10)
      - [GET /user_features/{id}](#get--user-features--id-)
      - [GET /user_features/count[?search={search}]](#get--user-features-count--search--search--)
        * [Optional queries](#optional-queries-3)
      - [POST /user_features](#post--user-features)
        * [Example request body](#example-request-body-7)
        * [Remarks](#remarks-11)
      - [PUT /user_features/{id}](#put--user-features--id-)
        * [Example request body](#example-request-body-8)
        * [Remarks](#remarks-12)
      - [DELETE /user_features/{id}](#delete--user-features--id-)
    + [Colours](#colours)
      - [GET /colours[?limit={limit}&offset={offset}&search={search}]](#get--colours--limit--limit--offset--offset--search--search--)
        * [Optional queries](#optional-queries-4)
        * [Remarks](#remarks-13)
      - [GET /colours/{id}](#get--colours--id-)
      - [GET /colours/count[?search={search}]](#get--colours-count--search--search--)
        * [Optional queries](#optional-queries-5)
      - [POST /colours](#post--colours)
        * [Example request body](#example-request-body-9)
      - [PUT /colours/{id}](#put--colours--id-)
        * [Example request body](#example-request-body-10)
        * [Remarks](#remarks-14)
      - [DELETE /colours/{id}](#delete--colours--id-)
    + [Face shapes](#face-shapes)
      - [GET /face_shapes[?limit={limit}&offset={offset}&search={search}]](#get--face-shapes--limit--limit--offset--offset--search--search--)
        * [Optional queries](#optional-queries-6)
        * [Remarks](#remarks-15)
      - [GET /face_shapes/{id}](#get--face-shapes--id-)
      - [GET /face_shapes/count[?search={search}]](#get--face-shapes-count--search--search--)
        * [Optional queries](#optional-queries-7)
      - [POST /face_shapes](#post--face-shapes)
        * [Example request body](#example-request-body-11)
      - [PUT /face_shapes/{id}](#put--face-shapes--id-)
        * [Example request body](#example-request-body-12)
        * [Remarks](#remarks-16)
      - [DELETE /face_shapes/{id}](#delete--face-shapes--id-)
    + [Face shape links](#face-shape-links)
      - [GET /face_shape_links[?limit={limit}&offset={offset}&search={search}]](#get--face-shape-links--limit--limit--offset--offset--search--search--)
        * [Optional queries](#optional-queries-8)
        * [Remarks](#remarks-17)
      - [GET /face_shape_links/{id}](#get--face-shape-links--id-)
      - [GET /face_shape_links/count[?search={search}]](#get--face-shape-links-count--search--search--)
        * [Optional queries](#optional-queries-9)
      - [POST /face_shape_links](#post--face-shape-links)
        * [Example request body](#example-request-body-13)
      - [PUT /face_shape_links/{id}](#put--face-shape-links--id-)
        * [Example request body](#example-request-body-14)
        * [Remarks](#remarks-18)
      - [DELETE /face_shape_links/{id}](#delete--face-shape-links--id-)
    + [Skin tones](#skin-tones)
      - [GET /skin_tones[?limit={limit}&offset={offset}&search={search}]](#get--skin-tones--limit--limit--offset--offset--search--search--)
        * [Optional queries](#optional-queries-10)
        * [Remarks](#remarks-19)
      - [GET /skin_tones/{id}](#get--skin-tones--id-)
      - [GET /skin_tones/count[?search={search}]](#get--skin-tones-count--search--search--)
        * [Optional queries](#optional-queries-11)
      - [POST /skin_tones](#post--skin-tones)
        * [Example request body](#example-request-body-15)
      - [PUT /skin_tones/{id}](#put--skin-tones--id-)
        * [Example request body](#example-request-body-16)
        * [Remarks](#remarks-20)
      - [DELETE /skin_tones/{id}](#delete--skin-tones--id-)
    + [Skin tone links](#skin-tone-links)
      - [GET /skin_tone_links[?limit={limit}&offset={offset}&search={search}]](#get--skin-tone-links--limit--limit--offset--offset--search--search--)
        * [Optional queries](#optional-queries-12)
        * [Remarks](#remarks-21)
      - [GET /skin_tone_links/{id}](#get--skin-tone-links--id-)
      - [GET /skin_tone_links/count[?search={search}]](#get--skin-tone-links-count--search--search--)
        * [Optional queries](#optional-queries-13)
      - [POST /skin_tone_links](#post--skin-tone-links)
        * [Example request body](#example-request-body-17)
      - [PUT /skin_tone_links/{id}](#put--skin-tone-links--id-)
        * [Example request body](#example-request-body-18)
        * [Remarks](#remarks-22)
      - [DELETE /skin_tone_links/{id}](#delete--skin-tone-links--id-)
    + [Hair styles](#hair-styles)
      - [GET /hair_styles[?limit={limit}&offset={offset}&search={search}]](#get--hair-styles--limit--limit--offset--offset--search--search--)
        * [Optional queries](#optional-queries-14)
        * [Remarks](#remarks-23)
      - [GET /hair_styles/{id}](#get--hair-styles--id-)
      - [GET /hair_styles/count[?search={search}]](#get--hair-styles-count--search--search--)
        * [Optional queries](#optional-queries-15)
      - [POST /hair_styles](#post--hair-styles)
        * [Example request body](#example-request-body-19)
      - [PUT /hair_styles/{id}](#put--hair-styles--id-)
        * [Example request body](#example-request-body-20)
        * [Remarks](#remarks-24)
      - [DELETE /hair_styles/{id}](#delete--hair-styles--id-)
    + [Hair style links](#hair-style-links)
      - [GET /hair_style_links[?limit={limit}&offset={offset}&search={search}]](#get--hair-style-links--limit--limit--offset--offset--search--search--)
        * [Optional queries](#optional-queries-16)
        * [Remarks](#remarks-25)
      - [GET /hair_style_links/{id}](#get--hair-style-links--id-)
      - [GET /hair_style_links/count[?search={search}]](#get--hair-style-links-count--search--search--)
        * [Optional queries](#optional-queries-17)
      - [POST /hair_style_links](#post--hair-style-links)
        * [Example request body](#example-request-body-21)
      - [PUT /hair_style_links/{id}](#put--hair-style-links--id-)
        * [Example request body](#example-request-body-22)
        * [Remarks](#remarks-26)
      - [DELETE /hair_style_links/{id}](#delete--hair-style-links--id-)
    + [Hair length](#hair-length)
      - [GET /hair_lengths[?limit={limit}&offset={offset}&search={search}]](#get--hair-lengths--limit--limit--offset--offset--search--search--)
        * [Optional queries](#optional-queries-18)
        * [Remarks](#remarks-27)
      - [GET /hair_lengths/{id}](#get--hair-lengths--id-)
      - [GET /hair_lengths/count[?search={search}]](#get--hair-lengths-count--search--search--)
        * [Optional queries](#optional-queries-19)
      - [POST /hair_lengths](#post--hair-lengths)
        * [Example request body](#example-request-body-23)
      - [PUT /hair_lengths/{id}](#put--hair-lengths--id-)
        * [Example request body](#example-request-body-24)
        * [Remarks](#remarks-28)
      - [DELETE /hair_lengths/{id}](#delete--hair-lengths--id-)
    + [Hair length links](#hair-length-links)
      - [GET /hair_length_links[?limit={limit}&offset={offset}&search={search}]](#get--hair-length-links--limit--limit--offset--offset--search--search--)
        * [Optional queries](#optional-queries-20)
        * [Remarks](#remarks-29)
      - [GET /hair_length_links/{id}](#get--hair-length-links--id-)
      - [GET /hair_length_links/count[?search={search}]](#get--hair-length-links-count--search--search--)
        * [Optional queries](#optional-queries-21)
      - [POST /hair_length_links](#post--hair-length-links)
        * [Example request body](#example-request-body-25)
      - [PUT /hair_length_links/{id}](#put--hair-length-links--id-)
        * [Example request body](#example-request-body-26)
        * [Remarks](#remarks-30)
      - [DELETE /hair_length_links/{id}](#delete--hair-length-links--id-)
  * [Testing routes](#testing-routes)
    + [1- Importing collections](#1--importing-collections)
    + [2 - Setting up the database](#2---setting-up-the-database)
    + [3 - Generating pepper](#3---generating-pepper)
    + [4 - Sending requests](#4---sending-requests)
    + [Extra - Pagination & Searching](#extra---pagination---searching)

## API endpoints

All endpoints are listed below. 

There are currently three user roles:

- Admin
- Developer
- User

The permissions work as follows:

- Admin: allowed to access to the Admin Portal (shockingly enough) and all routes in the API
- Developer: allowed to sign in
- User: allowed to sign in

Sign up is currently restricted. New users will be able to sign up and access their own details in the future.

__NOTE:__ **ALL** routes require that you sign in first, except for `POST /users/sign_in` itself and `GET /users/authenticate`.

Additional routes and other modifications may be made as we progress through the application. Stay tuned! 🧐

> Tip: The brackets `[]` represent optional queries and the less-than and greater-than operators `<>` represent data types.

### Users

Properties (see the [Models_v2_1/Validation](/Backend/AdminApi/Models_v2_1/Validation "Validation") folder for additional models and properties used in specific routes - e.g. `POST /users/sign_in` and `POST /users/sign_up`):

```json
{
  "Id": "<ulong?>",
  "UserName": "<string> (Required, Unique, Maximum Length: 32)",
  "UserEmail": "<string> (Required, Unique, Maximum Length: 512)",
  "UserPasswordHash": "<string>",
  "UserPasswordSalt": "<string>",
  "FirstName": "<string> (Required, Maximum Length: 128)",
  "LastName": "<string> (Maximum Length: 128)",
  "UserRole": "<string> (Required, One of: admin, developer or user)",
  "DateCreated": "<DateTime?>",
  "DateModified": "<DateTime?>"
}
```

#### GET /users[?limit={limit}&offset={offset}&search={search}]
Retrieves all users. 

##### Optional queries
- `limit` (`int`): Limits the number of users retrieved
- `offset` (`int`): Offsets the position from which users will be retrieved (e.g. set `offset` to __5__ to ignore the first 5 users)
- `search` (`string`): Searches for users whose `UserName` or `UserEmail` match this query (case insensitive)

##### Remarks
`limit` and `offset` are useful for pagination. `search` is self-explanatory. 

#### GET /users/{id}
Retrieves a user with the specified `id`.

#### GET /users/{token}
Retrieves a user identified by the specified JWT `token` (if signed in).

#### GET /users/count[?search={search}]
Retrieves the total number of users.

##### Optional queries
- `search` (`string`): Only counts the users whose `UserName` or `UserPassword` match this query

##### Remarks
Combine this route with `GET /users[?limit={limit}&offset={offset}&search={search}]` to implement pagination more efficiently.

Optionally, add a `search` query to limit the count only to users whose `UserName` or `UserEmail` match it (case insensitive).

#### GET /users/authenticate
Returns `UserId` and `UserRole` of the current user (if signed in). This information is retrieved from the current user's JWT token sent from cookies.

##### Remarks
If no JWT token is present in the cookies sent, it returns `401` (Unauthorized). 

If the JWT token has expired or no user associated with it is found, it returns `404` (Not found).

#### GET /users/logout
Invalidates the current user's JWT token by setting its `Expires` property to a past date.

##### Remarks
It essentially signals browsers to delete the `auth` cookie.

#### POST /users/sign_in
Authenticates a user with the details sent in the JSON request body.

##### Example request body

```json
{
  "UserNameOrEmail": "johnny",
  "UserPassword": "Secret1"
}
```

#### POST /users/sign_up
Registers a new user with the details sent in the JSON request body.

##### Example request body

```json
{
  "UserName": "johnny",
  "UserEmail": "johnny@b.good",
  "UserPassword": "Secret1",
  "FirstName": "John",
  "LastName": "Doe",
  "UserRole": "user"
}
```

##### Remarks
__NOTE__: `UserRole` will be set to `user` by default for security reasons.

#### POST /users
An alternative to `POST /users/sign_up` that does not send back cookies.

##### Remarks
Only use it for development purposes.

#### POST /users/forgot_password
Sends an email to the user associated with the specified `UserNameOrEmail` sent in the request body to allow them to reset their password.

##### Example request body

```json
{
  "UserNameOrEmail": "johnny@b.good"
}
```

##### Remarks
This route is not currently implemented in the Admin Portal, so the link sent to your email will not work.

#### PUT /users/{id}
Updates a user's details, identified by the specified `id`.

##### Example request body

```json
{
  "Id": 5,
  "UserName": "johnny",
  "UserEmail": "johnny@b.good",
  "UserPassword": "Secret1",
  "FirstName": "John",
  "LastName": "Doe",
  "UserRole": "user"
}
```

##### Remarks
__NOTE__: the `Id` property __must__ be added to the request body as well (and it __must__ match the `id` from the endpoint).

#### PUT /users/{id}/change_password
Updates a user's password, identified by the specified `id`.

##### Example request body

```json
{
  "Id": 5,
  "UserNameOrEmail": "johnny",
  "UserPassword": "NewSecret1"
}
```

##### Remarks
__NOTE__: the `Id` property __must__ be added to the request body as well (and it __must__ match the `id` from the endpoint).

#### PUT /users/{token}/change_password
Alternative to `PUT /users/{id}/change_password` that uses the current user's JWT token instead, sent by the `auth` cookie.

##### Example request body

```json
{
  "Id": 5,
  "UserNameOrEmail": "johnny",
  "UserPassword": "NewSecret1"
}
```

#### PUT /users/{id}/change_role
Updates a user's role. 

##### Example request body

```json
{
  "Id": 5,
  "UserName": "johnny",
  "UserEmail": "johnny@b.good",
  "UserRole": "developer"
}
```

##### Remarks
__NOTE__: the `Id` property __must__ be added to the request body as well (and it __must__ match the `id` from the endpoint).

#### DELETE /users/{id}
Deletes a user identified by the specified `id`.

### User features

Properties:

```json
{
  "Id": "<ulong?>",
  "UserId": "<ulong?> (Required, Foreign key: Users.Id)",
  "FaceShapeId": "<ulong?> (Required, Foreign key: FaceShapes.Id)",
  "SkinToneId": "<ulong?> (Required, Foreign key: SkinTones.Id)",
  "HairStyleId": "<ulong?> (Required, Foreign key: HairStyles.Id)",
  "HairLengthId": "<ulong?> (Required, Foreign key: HairLengths.Id)",
  "HairColourId": "<ulong?> (Required, Foreign key: Colours.Id)",
  "DateCreated": "<DateTime?>",
  "DateModified": "<DateTime?>"
}
```

#### GET /user_features[?limit={limit}&offset={offset}&search={search}]
Retrieves all users features.

##### Optional queries
- `limit` (`int`): Limits the number of user features retrieved
- `offset` (`int`): Offsets the position from which user features will be retrieved (e.g. set `offset` to __5__ to ignore the first 5 user feature records)
- `search` (`string`): Searches for user features associated with users whose `UserName` or `UserEmail` match this query (case insensitive)

##### Remarks
`limit` and `offset` are useful for pagination. `search` is self-explanatory. 

#### GET /user_features/{id}
Retrieves a user feature by its `id`.

#### GET /user_features/count[?search={search}]
Retrieves the total number of user features.

##### Optional queries
- `search` (`string`): Only counts the user features associated with users whose `UserName` or `UserPassword` match this query (case insensitive)

#### POST /user_features
Adds a new user feature associated with a user identified by `UserId` specified in the request body.

##### Example request body

```json
{
  "UserId": 5,
  "FaceShapeId": 2,
  "SkinToneId": 3,
  "HairStyleId": 1,
  "HairLengthId": 8,
  "HairColourId": 4
}
```

##### Remarks
Make sure that each ID property already exists in the database, though this route also handles this case (it returns `404` Not Found if any of them does not exist).

#### PUT /user_features/{id}
Updates a user feature identified by the specified `id`.

##### Example request body

```json
{
  "Id": 2,
  "UserId": 5,
  "FaceShapeId": 2,
  "SkinToneId": 3,
  "HairStyleId": 1,
  "HairLengthId": 8,
  "HairColourId": 4
}
```

##### Remarks
__NOTE__: the `Id` property __must__ be added to the request body as well (and it __must__ match the `id` from the endpoint).

#### DELETE /user_features/{id}
Deletes a user feature identified by the specified `id`.

### Colours

Properties:

```json
{
  "Id": "<ulong?>",
  "ColourName": "<string> (Required, Maximum Length: 64)",
  "ColourHash": "<string> (Required, Patterns: #ABC or #ABCABC)",
  "DateCreated": "<DateTime?>",
  "DateModified": "<DateTime?>"
}
```

#### GET /colours[?limit={limit}&offset={offset}&search={search}]
Retrieves all colours.

##### Optional queries
- `limit` (`int`): Limits the number of colours retrieved
- `offset` (`int`): Offsets the position from which colours will be retrieved (e.g. set `offset` to __5__ to ignore the first 5 colour records)
- `search` (`string`): Searches for colours whose `ColourName` or `ColourHash` match this query (case insensitive)

##### Remarks
`limit` and `offset` are useful for pagination. `search` is self-explanatory. 

#### GET /colours/{id}
Retrieves a colour by its `id`.

#### GET /colours/count[?search={search}]
Retrieves the total number of colours.

##### Optional queries
- `search` (`string`): Only counts the colours whose `ColourName` or `ColourHash` match this query (case insensitive)

#### POST /colours
Adds a new colour.

##### Example request body

```json
{
  "ColourName": "Grey",
  "ColourHash": "#333"
}
```

#### PUT /colours/{id}
Updates a colour identified by the specified `id`.

##### Example request body

```json
{
  "Id": 2,
  "ColourName": "Grey",
  "ColourHash": "#444"
}
```

##### Remarks
__NOTE__: the `Id` property __must__ be added to the request body as well (and it __must__ match the `id` from the endpoint).

#### DELETE /colours/{id}
Deletes a colour identified by the specified `id`.

### Face shapes

Properties:

```json
{
  "Id": "<ulong?>",
  "ShapeName": "<string> (Required, Maximum Length: 128)",
  "DateCreated": "<DateTime?>",
  "DateModified": "<DateTime?>"
}
```

#### GET /face_shapes[?limit={limit}&offset={offset}&search={search}]
Retrieves all face shapes.

##### Optional queries
- `limit` (`int`): Limits the number of face shapes retrieved
- `offset` (`int`): Offsets the position from which face shapes will be retrieved (e.g. set `offset` to __5__ to ignore the first 5 face shape records)
- `search` (`string`): Searches for face shapes which `ShapeName` match this query (case insensitive)

##### Remarks
`limit` and `offset` are useful for pagination. `search` is self-explanatory. 

#### GET /face_shapes/{id}
Retrieves a face shape by its `id`.

#### GET /face_shapes/count[?search={search}]
Retrieves the total number of face shapes.

##### Optional queries
- `search` (`string`): Only counts the face shapes whose `ShapeName` match this query (case insensitive)

#### POST /face_shapes
Adds a new face shape.

##### Example request body

```json
{
  "ShapeName": "oval",
}
```

#### PUT /face_shapes/{id}
Updates a face shape identified by the specified `id`.

##### Example request body

```json
{
  "Id": 2,
  "ShapeName": "square"
}
```

##### Remarks
__NOTE__: the `Id` property __must__ be added to the request body as well (and it __must__ match the `id` from the endpoint).

#### DELETE /face_shapes/{id}
Deletes a face shape identified by the specified `id`.

### Face shape links

Properties:

```json
{
  "Id": "<ulong?>",
  "FaceShapeId": "<ulong?> (Required, Foreign key: FaceShapes.Id)",
  "LinkName": "<string> (Required, Maximum Length: 128)",
  "LinkUrl": "<string> (Required, Maximum Length: 512)",
  "DateCreated": "<DateTime?>",
  "DateModified": "<DateTime?>"
}
```

#### GET /face_shape_links[?limit={limit}&offset={offset}&search={search}]
Retrieves all face shape links.

##### Optional queries
- `limit` (`int`): Limits the number of face shape links retrieved
- `offset` (`int`): Offsets the position from which face shape links will be retrieved (e.g. set `offset` to __5__ to ignore the first 5 face shape links)
- `search` (`string`): Searches for face shape links which `LinkName` match this query (case insensitive)

##### Remarks
`limit` and `offset` are useful for pagination. `search` is self-explanatory. 

#### GET /face_shape_links/{id}
Retrieves a face shape link by its `id`.

#### GET /face_shape_links/count[?search={search}]
Retrieves the total number of face shape links.

##### Optional queries
- `search` (`string`): Only counts the face shape links whose `LinkName` match this query (case insensitive)

#### POST /face_shape_links
Adds a new face shape link.

##### Example request body

```json
{
  "FaceShapeId": 2,
  "LinkName": "links",
  "LinkUrl": "https://cdn.shoplightspeed.com/shops/606094/files/3159302/face-shapes-alter-dates.jpg"
}
```

#### PUT /face_shape_links/{id}
Updates a face shape link identified by the specified `id`.

##### Example request body

```json
{
  "Id": 2,
  "FaceShapeId": 3,
  "LinkName": "updated links",
  "LinkUrl": "https://i.dailymail.co.uk/i/pix/scaled/2014/10/16/1413436649391_wps_18_face_shapes_jpg.jpg"
}
```

##### Remarks
__NOTE__: the `Id` property __must__ be added to the request body as well (and it __must__ match the `id` from the endpoint).

#### DELETE /face_shape_links/{id}
Deletes a face shape link identified by the specified `id`.

### Skin tones

Properties:

```json
{
  "Id": "<ulong?>",
  "SkinToneName": "<string> (Required, Maximum Length: 128)",
  "DateCreated": "<DateTime?>",
  "DateModified": "<DateTime?>"
}
```

#### GET /skin_tones[?limit={limit}&offset={offset}&search={search}]
Retrieves all skin tones.

##### Optional queries
- `limit` (`int`): Limits the number of skin tones retrieved
- `offset` (`int`): Offsets the position from which skin tones will be retrieved (e.g. set `offset` to __5__ to ignore the first 5 skin tone records)
- `search` (`string`): Searches for skin tones which `SkinToneName` match this query (case insensitive)

##### Remarks
`limit` and `offset` are useful for pagination. `search` is self-explanatory. 

#### GET /skin_tones/{id}
Retrieves a skin tone by its `id`.

#### GET /skin_tones/count[?search={search}]
Retrieves the total number of skin tones.

##### Optional queries
- `search` (`string`): Only counts the skin tones whose `SkinToneName` match this query (case insensitive)

#### POST /skin_tones
Adds a new skin tone.

##### Example request body

```json
{
  "SkinToneName": "light brown",
}
```

#### PUT /skin_tones/{id}
Updates a skin tone identified by the specified `id`.

##### Example request body

```json
{
  "Id": 2,
  "SkinToneName": "dark brown"
}
```

##### Remarks
__NOTE__: the `Id` property __must__ be added to the request body as well (and it __must__ match the `id` from the endpoint).

#### DELETE /skin_tones/{id}
Deletes a skin tone identified by the specified `id`.

### Skin tone links

Properties:

```json
{
  "Id": "<ulong?>",
  "SkinToneId": "<ulong?> (Required, Foreign key: SkinTones.Id)",
  "LinkName": "<string> (Required, Maximum Length: 128)",
  "LinkUrl": "<string> (Required, Maximum Length: 512)",
  "DateCreated": "<DateTime?>",
  "DateModified": "<DateTime?>"
}
```

#### GET /skin_tone_links[?limit={limit}&offset={offset}&search={search}]
Retrieves all skin tone links.

##### Optional queries
- `limit` (`int`): Limits the number of skin tone links retrieved
- `offset` (`int`): Offsets the position from which skin tone links will be retrieved (e.g. set `offset` to __5__ to ignore the first 5 skin tone links)
- `search` (`string`): Searches for skin tone links which `LinkName` match this query (case insensitive)

##### Remarks
`limit` and `offset` are useful for pagination. `search` is self-explanatory. 

#### GET /skin_tone_links/{id}
Retrieves a skin tone link by its `id`.

#### GET /skin_tone_links/count[?search={search}]
Retrieves the total number of skin tone links.

##### Optional queries
- `search` (`string`): Only counts the skin tone links whose `LinkName` match this query (case insensitive)

#### POST /skin_tone_links
Adds a new skin tone link.

##### Example request body

```json
{
  "SkinToneId": 2,
  "LinkName": "links",
  "LinkUrl": "https://i.pinimg.com/originals/45/cc/0e/45cc0eb65b2a2d7711d27384fbd0ab8b.jpg"
}
```

#### PUT /skin_tone_links/{id}
Updates a skin tone link identified by the specified `id`.

##### Example request body

```json
{
  "Id": 2,
  "SkinToneId": 3,
  "LinkName": "updated links",
  "LinkUrl": "https://shopify-blog.s3.us-east-2.amazonaws.com/1521225785_1.jpg"
}
```

##### Remarks
__NOTE__: the `Id` property __must__ be added to the request body as well (and it __must__ match the `id` from the endpoint).

#### DELETE /skin_tone_links/{id}
Deletes a skin tone link identified by the specified `id`.

### Hair styles

Properties:

```json
{
  "Id": "<ulong?>",
  "HairStyleName": "<string> (Required, Maximum Length: 128)",
  "DateCreated": "<DateTime?>",
  "DateModified": "<DateTime?>"
}
```

#### GET /hair_styles[?limit={limit}&offset={offset}&search={search}]
Retrieves all hair styles.

##### Optional queries
- `limit` (`int`): Limits the number of hair styles retrieved
- `offset` (`int`): Offsets the position from which hair styles will be retrieved (e.g. set `offset` to __5__ to ignore the first 5 hair style records)
- `search` (`string`): Searches for hair styles which `HairStyleName` match this query (case insensitive)

##### Remarks
`limit` and `offset` are useful for pagination. `search` is self-explanatory. 

#### GET /hair_styles/{id}
Retrieves a hair style by its `id`.

#### GET /hair_styles/count[?search={search}]
Retrieves the total number of hair styles.

##### Optional queries
- `search` (`string`): Only counts the hair styles whose `HairStyleName` match this query (case insensitive)

#### POST /hair_styles
Adds a new hair style.

##### Example request body

```json
{
  "HairStyleName": "bob"
}
```

#### PUT /hair_styles/{id}
Updates a hair style identified by the specified `id`.

##### Example request body

```json
{
  "Id": 2,
  "HairStyleName": "medium bob"
}
```

##### Remarks
__NOTE__: the `Id` property __must__ be added to the request body as well (and it __must__ match the `id` from the endpoint).

#### DELETE /hair_styles/{id}
Deletes a hair style identified by the specified `id`.

### Hair style links

Properties:

```json
{
  "Id": "<ulong?>",
  "HairStyleId": "<ulong?> (Required, Foreign key: HairStyles.Id)",
  "LinkName": "<string> (Required, Maximum Length: 128)",
  "LinkUrl": "<string> (Required, Maximum Length: 512)",
  "DateCreated": "<DateTime?>",
  "DateModified": "<DateTime?>"
}
```

#### GET /hair_style_links[?limit={limit}&offset={offset}&search={search}]
Retrieves all hair style links.

##### Optional queries
- `limit` (`int`): Limits the number of hair style links retrieved
- `offset` (`int`): Offsets the position from which hair style links will be retrieved (e.g. set `offset` to __5__ to ignore the first 5 hair style links)
- `search` (`string`): Searches for hair style links which `LinkName` match this query (case insensitive)

##### Remarks
`limit` and `offset` are useful for pagination. `search` is self-explanatory. 

#### GET /hair_style_links/{id}
Retrieves a hair style link by its `id`.

#### GET /hair_style_links/count[?search={search}]
Retrieves the total number of hair style links.

##### Optional queries
- `search` (`string`): Only counts the hair style links whose `LinkName` match this query (case insensitive)

#### POST /hair_style_links
Adds a new hair style link.

##### Example request body

```json
{
  "HairStyleId": 2,
  "LinkName": "bob link",
  "LinkUrl": "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/gettyimages-1187900303.jpg?crop=0.446xw:0.837xh;0.238xw,0.0102xh&resize=480:*"
}
```

#### PUT /hair_style_links/{id}
Updates a hair style link identified by the specified `id`.

##### Example request body

```json
{
  "Id": 2,
  "HairStyleId": 2,
  "LinkName": "updated bob link",
  "LinkUrl": "https://short-haircut.com/wp-content/uploads/2019/02/Thick-Bob-Hairstyle.jpg"
}
```

##### Remarks
__NOTE__: the `Id` property __must__ be added to the request body as well (and it __must__ match the `id` from the endpoint).

#### DELETE /hair_style_links/{id}
Deletes a hair style link identified by the specified `id`.

### Hair length

Properties:

```json
{
  "Id": "<ulong?>",
  "HairLengthName": "<string> (Required, Maximum Length: 128)",
  "DateCreated": "<DateTime?>",
  "DateModified": "<DateTime?>"
}
```

#### GET /hair_lengths[?limit={limit}&offset={offset}&search={search}]
Retrieves all hair lengths.

##### Optional queries
- `limit` (`int`): Limits the number of hair lengths retrieved
- `offset` (`int`): Offsets the position from which hair lengths will be retrieved (e.g. set `offset` to __5__ to ignore the first 5 hair length records)
- `search` (`string`): Searches for hair lengths which `HairLengthName` match this query (case insensitive)

##### Remarks
`limit` and `offset` are useful for pagination. `search` is self-explanatory. 

#### GET /hair_lengths/{id}
Retrieves a hair length by its `id`.

#### GET /hair_lengths/count[?search={search}]
Retrieves the total number of hair lengths.

##### Optional queries
- `search` (`string`): Only counts the hair lengths whose `HairLengthName` match this query (case insensitive)

#### POST /hair_lengths
Adds a new hair length.

##### Example request body

```json
{
  "HairLengthName": "short",
}
```

#### PUT /hair_lengths/{id}
Updates a hair length identified by the specified `id`.

##### Example request body

```json
{
  "Id": 2,
  "HairLengthName": "medium"
}
```

##### Remarks
__NOTE__: the `Id` property __must__ be added to the request body as well (and it __must__ match the `id` from the endpoint).

#### DELETE /hair_lengths/{id}
Deletes a hair length identified by the specified `id`.

### Hair length links

Properties:

```json
{
  "Id": "<ulong?>",
  "HairLengthId": "<ulong?> (Required, Foreign key: HairLengths.Id)",
  "LinkName": "<string> (Required, Maximum Length: 128)",
  "LinkUrl": "<string> (Required, Maximum Length: 512)",
  "DateCreated": "<DateTime?>",
  "DateModified": "<DateTime?>"
}
```

#### GET /hair_length_links[?limit={limit}&offset={offset}&search={search}]
Retrieves all hair length links.

##### Optional queries
- `limit` (`int`): Limits the number of hair length links retrieved
- `offset` (`int`): Offsets the position from which hair length links will be retrieved (e.g. set `offset` to __5__ to ignore the first 5 hair length links)
- `search` (`string`): Searches for hair length links which `LinkName` match this query (case insensitive)

##### Remarks
`limit` and `offset` are useful for pagination. `search` is self-explanatory. 

#### GET /hair_length_links/{id}
Retrieves a hair length link by its `id`.

#### GET /hair_length_links/count[?search={search}]
Retrieves the total number of hair length links.

##### Optional queries
- `search` (`string`): Only counts the hair length links whose `LinkName` match this query (case insensitive)

#### POST /hair_length_links
Adds a new hair length link.

##### Example request body

```json
{
  "HairLengthId": 2,
  "LinkName": "short link",
  "LinkUrl": "https://i1.wp.com/therighthairstyles.com/wp-content/uploads/2014/05/3-short-layered-haircut-for-thick-hair.jpg?resize=240%2C340&ssl=1"
}
```

#### PUT /hair_length_links/{id}
Updates a hair length link identified by the specified `id`.

##### Example request body

```json
{
  "Id": 2,
  "HairLengthId": 2,
  "LinkName": "updated short link",
  "LinkUrl": "https://i.ytimg.com/vi/3o70sG3YE2A/maxresdefault.jpg"
}
```

##### Remarks
__NOTE__: the `Id` property __must__ be added to the request body as well (and it __must__ match the `id` from the endpoint).

#### DELETE /hair_length_links/{id}
Deletes a hair length link identified by the specified `id`.

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
