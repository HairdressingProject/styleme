---
title: API End Points
keywords: Admin portal, Api, Endpoints
last_updated: July 23, 2020
tags: [api]
summary: "This document outlines all of the API endpoints."
sidebar: mydoc_sidebar
permalink: mydoc_api_endpoints.html
folder: mydoc
---

# Admin Portal - Backend


<!-- vscode-markdown-toc -->


<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

##  1. <a name='APIendpoints'></a>API endpoints

All endpoints are listed below. 

There are currently three user roles:

- Admin
- Developer
- User

The permissions work as follows:

- Admin: allowed to access the Admin Portal (shockingly enough) and all routes in the API
- Developer: allowed to sign in
- User: allowed to sign in

Sign up is currently restricted. New users will be able to sign up and access their own details in the future.

__NOTE:__ **ALL** routes require that you sign in first, except for `POST /users/sign_in` itself, `GET /users/authenticate` and `POST /users/forgot_password`.

Additional routes and other modifications may be made as we progress through the application. Stay tuned! 🧐

> Tip: The brackets `[]` represent optional queries and the less-than and greater-than operators `<>` represent data types.

###  1.1. <a name='Users'></a>Users

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

####  1.1.1. <a name='GETuserslimitlimitoffsetoffsetsearchsearch'></a>GET /users[?limit={limit}&offset={offset}&search={search}]
Retrieves all users. 

##### Optional queries
- `limit` (`int`): Limits the number of users retrieved
- `offset` (`int`): Offsets the position from which users will be retrieved (e.g. set `offset` to __5__ to ignore the first 5 users)
- `search` (`string`): Searches for users whose `UserName` or `UserEmail` match this query (case insensitive)

##### Remarks
`limit` and `offset` are useful for pagination. `search` is self-explanatory. 

####  1.1.2. <a name='GETusersid'></a>GET /users/{id}
Retrieves a user with the specified `id`.

####  1.1.3. <a name='GETuserstoken'></a>GET /users/{token}
Retrieves a user identified by their recover password token (if valid).

####  1.1.4. <a name='GETuserscountsearchsearch'></a>GET /users/count[?search={search}]
Retrieves the total number of users.

##### Optional queries
- `search` (`string`): Only counts the users whose `UserName` or `UserEmail` match this query (case insensitive)

##### Remarks
Combine this route with `GET /users[?limit={limit}&offset={offset}&search={search}]` to implement pagination more efficiently.

Optionally, add a `search` query to limit the count only to users whose `UserName` or `UserEmail` match it (case insensitive).

####  1.1.5. <a name='GETusersauthenticate'></a>GET /users/authenticate
Returns `UserId` and `UserRole` of the current user (if signed in). This information is retrieved from the current user's JWT token sent from cookies.

##### Remarks
If no JWT token is present in the cookies sent, it returns `401` (Unauthorized). 

If the JWT token has expired or no user associated with it is found, it returns `404` (Not found).

####  1.1.6. <a name='GETuserslogout'></a>GET /users/logout
Invalidates the current user's JWT token by setting its `Expires` property to a past date.

##### Remarks
It essentially signals browsers to delete the `auth` cookie.

####  1.1.7. <a name='POSTuserssign_in'></a>POST /users/sign_in
Authenticates a user with the details sent in the JSON request body.

##### Example request body

```json
{
  "UserNameOrEmail": "johnny",
  "UserPassword": "Secret1"
}
```

####  1.1.8. <a name='POSTuserssign_up'></a>POST /users/sign_up
Registers a new user with the details sent in the JSON request body.

##### Example request body

```json
{
  "UserName": "johnny",
  "UserEmail": "johnny@b.goode",
  "UserPassword": "Secret1",
  "FirstName": "John",
  "LastName": "Doe",
  "UserRole": "user"
}
```

##### Remarks
__NOTE__: `UserRole` will be set to `user` by default for security reasons.

####  1.1.9. <a name='POSTusers'></a>POST /users
An alternative to `POST /users/sign_up` that does not send back cookies.

##### Remarks
Only use it for development purposes.

####  1.1.10. <a name='POSTusersforgot_password'></a>POST /users/forgot_password
Sends an email to the user associated with the specified `UserNameOrEmail` sent in the request body to allow them to reset their password.

##### Example request body

```json
{
  "UserNameOrEmail": "johnny@b.goode"
}
```

##### Remarks
This route is not currently implemented in the Admin Portal, so the link sent to your email will not work.

####  1.1.11. <a name='PUTusersid'></a>PUT /users/{id}
Updates a user's details, identified by the specified `id`.

##### Example request body

```json
{
  "Id": 5,
  "UserName": "johnny",
  "UserEmail": "johnny@b.goode",
  "UserPassword": "Secret1",
  "FirstName": "John",
  "LastName": "Doe",
  "UserRole": "user"
}
```

##### Remarks
__NOTE__: the `Id` property __must__ be added to the request body as well (and it __must__ match the `id` from the endpoint).

####  1.1.12. <a name='PUTusersidchange_password'></a>PUT /users/{id}/change_password
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

####  1.1.13. <a name='PUTuserstokenchange_password'></a>PUT /users/{token}/change_password
Alternative to `PUT /users/{id}/change_password` that uses the current user's recover password token instead.

##### Example request body

```json
{
  "Id": 5,
  "UserNameOrEmail": "johnny",
  "UserPassword": "NewSecret1"
}
```

####  1.1.14. <a name='PUTusersidchange_role'></a>PUT /users/{id}/change_role
Updates a user's role. 

##### Example request body

```json
{
  "Id": 5,
  "UserName": "johnny",
  "UserEmail": "johnny@b.goode",
  "UserRole": "developer"
}
```

##### Remarks
__NOTE__: the `Id` property __must__ be added to the request body as well (and it __must__ match the `id` from the endpoint).

####  1.1.15. <a name='DELETEusersid'></a>DELETE /users/{id}
Deletes a user identified by the specified `id`.

###  1.2. <a name='Userfeatures'></a>User features

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

####  1.2.1. <a name='GETuser_featureslimitlimitoffsetoffsetsearchsearch'></a>GET /user_features[?limit={limit}&offset={offset}&search={search}]
Retrieves all users features.

##### Optional queries
- `limit` (`int`): Limits the number of user features retrieved
- `offset` (`int`): Offsets the position from which user features will be retrieved (e.g. set `offset` to __5__ to ignore the first 5 user feature records)
- `search` (`string`): Searches for user features associated with users whose `UserName` or `UserEmail` match this query (case insensitive)

##### Remarks
`limit` and `offset` are useful for pagination. `search` is self-explanatory. 

####  1.2.2. <a name='GETuser_featuresid'></a>GET /user_features/{id}
Retrieves a user feature by its `id`.

####  1.2.3. <a name='GETuser_featurescountsearchsearch'></a>GET /user_features/count[?search={search}]
Retrieves the total number of user features.

##### Optional queries
- `search` (`string`): Only counts the user features associated with users whose `UserName` or `UserPassword` match this query (case insensitive)

####  1.2.4. <a name='POSTuser_features'></a>POST /user_features
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

####  1.2.5. <a name='PUTuser_featuresid'></a>PUT /user_features/{id}
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

####  1.2.6. <a name='DELETEuser_featuresid'></a>DELETE /user_features/{id}
Deletes a user feature identified by the specified `id`.

###  1.3. <a name='Colours'></a>Colours

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

####  1.3.1. <a name='GETcolourslimitlimitoffsetoffsetsearchsearch'></a>GET /colours[?limit={limit}&offset={offset}&search={search}]
Retrieves all colours.

##### Optional queries
- `limit` (`int`): Limits the number of colours retrieved
- `offset` (`int`): Offsets the position from which colours will be retrieved (e.g. set `offset` to __5__ to ignore the first 5 colour records)
- `search` (`string`): Searches for colours whose `ColourName` or `ColourHash` match this query (case insensitive)

##### Remarks
`limit` and `offset` are useful for pagination. `search` is self-explanatory. 

####  1.3.2. <a name='GETcoloursid'></a>GET /colours/{id}
Retrieves a colour by its `id`.

####  1.3.3. <a name='GETcolourscountsearchsearch'></a>GET /colours/count[?search={search}]
Retrieves the total number of colours.

##### Optional queries
- `search` (`string`): Only counts the colours whose `ColourName` or `ColourHash` match this query (case insensitive)

####  1.3.4. <a name='POSTcolours'></a>POST /colours
Adds a new colour.

##### Example request body

```json
{
  "ColourName": "Grey",
  "ColourHash": "#333"
}
```

####  1.3.5. <a name='PUTcoloursid'></a>PUT /colours/{id}
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

####  1.3.6. <a name='DELETEcoloursid'></a>DELETE /colours/{id}
Deletes a colour identified by the specified `id`.

###  1.4. <a name='Faceshapes'></a>Face shapes

Properties:

```json
{
  "Id": "<ulong?>",
  "ShapeName": "<string> (Required, Maximum Length: 128)",
  "DateCreated": "<DateTime?>",
  "DateModified": "<DateTime?>"
}
```

####  1.4.1. <a name='GETface_shapeslimitlimitoffsetoffsetsearchsearch'></a>GET /face_shapes[?limit={limit}&offset={offset}&search={search}]
Retrieves all face shapes.

##### Optional queries
- `limit` (`int`): Limits the number of face shapes retrieved
- `offset` (`int`): Offsets the position from which face shapes will be retrieved (e.g. set `offset` to __5__ to ignore the first 5 face shape records)
- `search` (`string`): Searches for face shapes which `ShapeName` match this query (case insensitive)

##### Remarks
`limit` and `offset` are useful for pagination. `search` is self-explanatory. 

####  1.4.2. <a name='GETface_shapesid'></a>GET /face_shapes/{id}
Retrieves a face shape by its `id`.

####  1.4.3. <a name='GETface_shapescountsearchsearch'></a>GET /face_shapes/count[?search={search}]
Retrieves the total number of face shapes.

##### Optional queries
- `search` (`string`): Only counts the face shapes whose `ShapeName` match this query (case insensitive)

####  1.4.4. <a name='POSTface_shapes'></a>POST /face_shapes
Adds a new face shape.

##### Example request body

```json
{
  "ShapeName": "oval",
}
```

####  1.4.5. <a name='PUTface_shapesid'></a>PUT /face_shapes/{id}
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

####  1.4.6. <a name='DELETEface_shapesid'></a>DELETE /face_shapes/{id}
Deletes a face shape identified by the specified `id`.

###  1.5. <a name='Faceshapelinks'></a>Face shape links

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

####  1.5.1. <a name='GETface_shape_linkslimitlimitoffsetoffsetsearchsearch'></a>GET /face_shape_links[?limit={limit}&offset={offset}&search={search}]
Retrieves all face shape links.

##### Optional queries
- `limit` (`int`): Limits the number of face shape links retrieved
- `offset` (`int`): Offsets the position from which face shape links will be retrieved (e.g. set `offset` to __5__ to ignore the first 5 face shape links)
- `search` (`string`): Searches for face shape links which `LinkName` match this query (case insensitive)

##### Remarks
`limit` and `offset` are useful for pagination. `search` is self-explanatory. 

####  1.5.2. <a name='GETface_shape_linksid'></a>GET /face_shape_links/{id}
Retrieves a face shape link by its `id`.

####  1.5.3. <a name='GETface_shape_linkscountsearchsearch'></a>GET /face_shape_links/count[?search={search}]
Retrieves the total number of face shape links.

##### Optional queries
- `search` (`string`): Only counts the face shape links whose `LinkName` match this query (case insensitive)

####  1.5.4. <a name='POSTface_shape_links'></a>POST /face_shape_links
Adds a new face shape link.

##### Example request body

```json
{
  "FaceShapeId": 2,
  "LinkName": "links",
  "LinkUrl": "https://cdn.shoplightspeed.com/shops/606094/files/3159302/face-shapes-alter-dates.jpg"
}
```

####  1.5.5. <a name='PUTface_shape_linksid'></a>PUT /face_shape_links/{id}
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

####  1.5.6. <a name='DELETEface_shape_linksid'></a>DELETE /face_shape_links/{id}
Deletes a face shape link identified by the specified `id`.

###  1.6. <a name='Skintones'></a>Skin tones

Properties:

```json
{
  "Id": "<ulong?>",
  "SkinToneName": "<string> (Required, Maximum Length: 128)",
  "DateCreated": "<DateTime?>",
  "DateModified": "<DateTime?>"
}
```

####  1.6.1. <a name='GETskin_toneslimitlimitoffsetoffsetsearchsearch'></a>GET /skin_tones[?limit={limit}&offset={offset}&search={search}]
Retrieves all skin tones.

##### Optional queries
- `limit` (`int`): Limits the number of skin tones retrieved
- `offset` (`int`): Offsets the position from which skin tones will be retrieved (e.g. set `offset` to __5__ to ignore the first 5 skin tone records)
- `search` (`string`): Searches for skin tones which `SkinToneName` match this query (case insensitive)

##### Remarks
`limit` and `offset` are useful for pagination. `search` is self-explanatory. 

####  1.6.2. <a name='GETskin_tonesid'></a>GET /skin_tones/{id}
Retrieves a skin tone by its `id`.

####  1.6.3. <a name='GETskin_tonescountsearchsearch'></a>GET /skin_tones/count[?search={search}]
Retrieves the total number of skin tones.

##### Optional queries
- `search` (`string`): Only counts the skin tones whose `SkinToneName` match this query (case insensitive)

####  1.6.4. <a name='POSTskin_tones'></a>POST /skin_tones
Adds a new skin tone.

##### Example request body

```json
{
  "SkinToneName": "light brown"
}
```

####  1.6.5. <a name='PUTskin_tonesid'></a>PUT /skin_tones/{id}
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

####  1.6.6. <a name='DELETEskin_tonesid'></a>DELETE /skin_tones/{id}
Deletes a skin tone identified by the specified `id`.

###  1.7. <a name='Skintonelinks'></a>Skin tone links

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

####  1.7.1. <a name='GETskin_tone_linkslimitlimitoffsetoffsetsearchsearch'></a>GET /skin_tone_links[?limit={limit}&offset={offset}&search={search}]
Retrieves all skin tone links.

##### Optional queries
- `limit` (`int`): Limits the number of skin tone links retrieved
- `offset` (`int`): Offsets the position from which skin tone links will be retrieved (e.g. set `offset` to __5__ to ignore the first 5 skin tone links)
- `search` (`string`): Searches for skin tone links which `LinkName` match this query (case insensitive)

##### Remarks
`limit` and `offset` are useful for pagination. `search` is self-explanatory. 

####  1.7.2. <a name='GETskin_tone_linksid'></a>GET /skin_tone_links/{id}
Retrieves a skin tone link by its `id`.

####  1.7.3. <a name='GETskin_tone_linkscountsearchsearch'></a>GET /skin_tone_links/count[?search={search}]
Retrieves the total number of skin tone links.

##### Optional queries
- `search` (`string`): Only counts the skin tone links whose `LinkName` match this query (case insensitive)

####  1.7.4. <a name='POSTskin_tone_links'></a>POST /skin_tone_links
Adds a new skin tone link.

##### Example request body

```json
{
  "SkinToneId": 2,
  "LinkName": "links",
  "LinkUrl": "https://i.pinimg.com/originals/45/cc/0e/45cc0eb65b2a2d7711d27384fbd0ab8b.jpg"
}
```

####  1.7.5. <a name='PUTskin_tone_linksid'></a>PUT /skin_tone_links/{id}
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

####  1.7.6. <a name='DELETEskin_tone_linksid'></a>DELETE /skin_tone_links/{id}
Deletes a skin tone link identified by the specified `id`.

###  1.8. <a name='Hairstyles'></a>Hair styles

Properties:

```json
{
  "Id": "<ulong?>",
  "HairStyleName": "<string> (Required, Maximum Length: 128)",
  "DateCreated": "<DateTime?>",
  "DateModified": "<DateTime?>"
}
```

####  1.8.1. <a name='GEThair_styleslimitlimitoffsetoffsetsearchsearch'></a>GET /hair_styles[?limit={limit}&offset={offset}&search={search}]
Retrieves all hair styles.

##### Optional queries
- `limit` (`int`): Limits the number of hair styles retrieved
- `offset` (`int`): Offsets the position from which hair styles will be retrieved (e.g. set `offset` to __5__ to ignore the first 5 hair style records)
- `search` (`string`): Searches for hair styles which `HairStyleName` match this query (case insensitive)

##### Remarks
`limit` and `offset` are useful for pagination. `search` is self-explanatory. 

####  1.8.2. <a name='GEThair_stylesid'></a>GET /hair_styles/{id}
Retrieves a hair style by its `id`.

####  1.8.3. <a name='GEThair_stylescountsearchsearch'></a>GET /hair_styles/count[?search={search}]
Retrieves the total number of hair styles.

##### Optional queries
- `search` (`string`): Only counts the hair styles whose `HairStyleName` match this query (case insensitive)

####  1.8.4. <a name='POSThair_styles'></a>POST /hair_styles
Adds a new hair style.

##### Example request body

```json
{
  "HairStyleName": "bob"
}
```

####  1.8.5. <a name='PUThair_stylesid'></a>PUT /hair_styles/{id}
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

####  1.8.6. <a name='DELETEhair_stylesid'></a>DELETE /hair_styles/{id}
Deletes a hair style identified by the specified `id`.

###  1.9. <a name='Hairstylelinks'></a>Hair style links

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

####  1.9.1. <a name='GEThair_style_linkslimitlimitoffsetoffsetsearchsearch'></a>GET /hair_style_links[?limit={limit}&offset={offset}&search={search}]
Retrieves all hair style links.

##### Optional queries
- `limit` (`int`): Limits the number of hair style links retrieved
- `offset` (`int`): Offsets the position from which hair style links will be retrieved (e.g. set `offset` to __5__ to ignore the first 5 hair style links)
- `search` (`string`): Searches for hair style links which `LinkName` match this query (case insensitive)

##### Remarks
`limit` and `offset` are useful for pagination. `search` is self-explanatory. 

####  1.9.2. <a name='GEThair_style_linksid'></a>GET /hair_style_links/{id}
Retrieves a hair style link by its `id`.

####  1.9.3. <a name='GEThair_style_linkscountsearchsearch'></a>GET /hair_style_links/count[?search={search}]
Retrieves the total number of hair style links.

##### Optional queries
- `search` (`string`): Only counts the hair style links whose `LinkName` match this query (case insensitive)

####  1.9.4. <a name='POSThair_style_links'></a>POST /hair_style_links
Adds a new hair style link.

##### Example request body

```json
{
  "HairStyleId": 2,
  "LinkName": "bob link",
  "LinkUrl": "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/gettyimages-1187900303.jpg?crop=0.446xw:0.837xh;0.238xw,0.0102xh&resize=480:*"
}
```

####  1.9.5. <a name='PUThair_style_linksid'></a>PUT /hair_style_links/{id}
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

####  1.9.6. <a name='DELETEhair_style_linksid'></a>DELETE /hair_style_links/{id}
Deletes a hair style link identified by the specified `id`.

###  1.10. <a name='Hairlengths'></a>Hair lengths

Properties:

```json
{
  "Id": "<ulong?>",
  "HairLengthName": "<string> (Required, Maximum Length: 128)",
  "DateCreated": "<DateTime?>",
  "DateModified": "<DateTime?>"
}
```

####  1.10.1. <a name='GEThair_lengthslimitlimitoffsetoffsetsearchsearch'></a>GET /hair_lengths[?limit={limit}&offset={offset}&search={search}]
Retrieves all hair lengths.

##### Optional queries
- `limit` (`int`): Limits the number of hair lengths retrieved
- `offset` (`int`): Offsets the position from which hair lengths will be retrieved (e.g. set `offset` to __5__ to ignore the first 5 hair length records)
- `search` (`string`): Searches for hair lengths which `HairLengthName` match this query (case insensitive)

##### Remarks
`limit` and `offset` are useful for pagination. `search` is self-explanatory. 

####  1.10.2. <a name='GEThair_lengthsid'></a>GET /hair_lengths/{id}
Retrieves a hair length by its `id`.

####  1.10.3. <a name='GEThair_lengthscountsearchsearch'></a>GET /hair_lengths/count[?search={search}]
Retrieves the total number of hair lengths.

##### Optional queries
- `search` (`string`): Only counts the hair lengths whose `HairLengthName` match this query (case insensitive)

####  1.10.4. <a name='POSThair_lengths'></a>POST /hair_lengths
Adds a new hair length.

##### Example request body

```json
{
  "HairLengthName": "short"
}
```

####  1.10.5. <a name='PUThair_lengthsid'></a>PUT /hair_lengths/{id}
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

####  1.10.6. <a name='DELETEhair_lengthsid'></a>DELETE /hair_lengths/{id}
Deletes a hair length identified by the specified `id`.

###  1.11. <a name='Hairlengthlinks'></a>Hair length links

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

####  1.11.1. <a name='GEThair_length_linkslimitlimitoffsetoffsetsearchsearch'></a>GET /hair_length_links[?limit={limit}&offset={offset}&search={search}]
Retrieves all hair length links.

##### Optional queries
- `limit` (`int`): Limits the number of hair length links retrieved
- `offset` (`int`): Offsets the position from which hair length links will be retrieved (e.g. set `offset` to __5__ to ignore the first 5 hair length links)
- `search` (`string`): Searches for hair length links which `LinkName` match this query (case insensitive)

##### Remarks
`limit` and `offset` are useful for pagination. `search` is self-explanatory. 

####  1.11.2. <a name='GEThair_length_linksid'></a>GET /hair_length_links/{id}
Retrieves a hair length link by its `id`.

####  1.11.3. <a name='GEThair_length_linkscountsearchsearch'></a>GET /hair_length_links/count[?search={search}]
Retrieves the total number of hair length links.

##### Optional queries
- `search` (`string`): Only counts the hair length links whose `LinkName` match this query (case insensitive)

####  1.11.4. <a name='POSThair_length_links'></a>POST /hair_length_links
Adds a new hair length link.

##### Example request body

```json
{
  "HairLengthId": 2,
  "LinkName": "short link",
  "LinkUrl": "https://i1.wp.com/therighthairstyles.com/wp-content/uploads/2014/05/3-short-layered-haircut-for-thick-hair.jpg?resize=240%2C340&ssl=1"
}
```

####  1.11.5. <a name='PUThair_length_linksid'></a>PUT /hair_length_links/{id}
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

####  1.11.6. <a name='DELETEhair_length_linksid'></a>DELETE /hair_length_links/{id}
Deletes a hair length link identified by the specified `id`.

##  2. <a name='Testingroutes'></a>Testing routes
The [Postman_Collections](/Backend/Postman_Collections "Postman Collections") folder contains several `json` files, each including all routes to perform BREAD operations on the respective table in the database. You can use them to test any route in Postman.

Follow the instructions below to do so:

###  2.1 <a name='Importingcollections'></a>- Importing collections
Click on the __Import__ button (top left):

![Importing collections](https://i.imgur.com/Y1Jcenw.png "Importing collections")

The __Import__ pop-up will open. Select all `json` files from the [Postman_Collections](/Admin/Backend/Postman_Collections "Postman Collections") folder and drag them where indicated:

![Dragging collection files](https://i.imgur.com/hnk7M39.png "Dragging collection files")

After all collections have been successfully imported, you can now explore all routes. Select the __Collections__ tab and expand any collection (Colours is shown as an example below). You should now see all routes associated with that table in the database. Click any of them to open the request settings.

![Browsing routes](https://i.imgur.com/XK7KDcj.png "Browsing routes")

###  2.2 <a name='Settingupthedatabase'></a> - Setting up the database
From the [Database](/Database "Database") folder, run:
```
mysql -u root -p < database_v.2.1.sql
```

###  2.3 <a name='Generatingpepper'></a>- Generating pepper
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

###  2.4 <a name='Sendingrequests'></a>- Sending requests
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

![Cookie](https://i.imgur.com/RgNLVqd.png "Cookie")

Now this cookie will be automatically sent back to the server (included in the headers by Postman) on every new request that you make, so you don't need to touch the Authorization tab.

> Note: if you get an error message saying "Invalid request origin", simply add this Origin header to your request:

![Origin](https://i.imgur.com/Dzx9OQD.png "Origin")

All `GET` and `DELETE` requests should work out of the box. You will have to provide a request `body` to `PUT` and `POST` requests (check the attributes in the corresponding [Model](AdminApi/Models_v2_1 "Models v2.1") file to understand how each property is validated).

> Remember: `PUT` requests require an `id` both in the endpoint and in the request `body`. You will also have to include __all__ `[Required]` properties in the request `body` (plus `DateCreated`), not just the ones that you wish to modify.

After you have set up your request, simply click __Send__. 

###  2.5. <a name='Extra-PaginationSearching'></a>Extra - Pagination & Searching
The "Colours" folder in the project's main Postman-collection outlines how pagination & searching work requests work in the project's API.

<sup> *Private GitHub Source: https://github.com/HairdressingProject/Production/blob/master/Backend/README.md (editted to remove the 'Table of Contents') </sup>
