---
title: Pictures API End Points
keywords: Pictures, Api, Endpoints
last_updated: September 27, 2020
tags: [api]
summary: "This document outlines all of the Pictures API endpoints."
sidebar: mydoc_sidebar
permalink: mydoc_pictures_api_endpoints.html
folder: mydoc
---

# Pictures API

##  1. <a name='APIendpoints'></a>API endpoints

All endpoints are listed below. 

###  1.1. <a name='Pictures'></a>Pictures

Properties:

```json
{
  "id": "<int>",
  "file_name": "<string> (Required, Unique, Maximum Length: 256)",
  "file_extension": "<string>",
  "file_path": "<string>",
  "file_size": "<string>",
  "height": "<int>",
  "width": "<int>",
  "date_created": "<DateTime?>",
  "date_updated": "<DateTime?>",
  "date_deleted": "<DateTime?>"
}
```
####  1.1.1. <a name='POSTpicture'></a>POST /pictures/upload
Saves a picture on local folder and on a S3 bucket.

##### Remarks
__NOTE__: if the uploaded picture is invalid, no picture is saved

####  1.1.2. <a name='GETpictureslimitlimitoffsetoffset'></a>GET /pictures[?skip={skip}&limit={limit}&search={search}]
Browses all pictures

##### Optional queries
- `limit` (`int`): Limits the number of pictures retrieved
- `skip` (`int`): Offsets the position from which pictures will be retrieved (e.g. set `skip` to __5__ to ignore the first 5 picture records)
- `search` (`string`): Searches for pictures whose `file_name` or `hash` match this query (case insensitive)

####  1.1.3. <a name='GETpicturesid'></a>GET /pictures/{id}
Retrieves a picture with the specified `id`.

####  1.1.4. <a name='DELETEpictureid'></a>DELETE /pictures/{id}
Deletes a picture identified by the specified `id`.


###  1.2. <a name='History'></a>History

Properties:

```json
{
  "id": "<int>",
  "file_name": "<string> (Required, Unique, Maximum Length: 256)",
  "file_extension": "<string>",
  "file_path": "<string>",
  "file_size": "<string>",
  "height": "<int>",
  "width": "",
  "date_created": "<DateTime?>",
  "date_updated": "<DateTime?>",
  "date_deleted": "<DateTime?>"
}
```
####  1.2.1. <a name='POSThistory'></a>POST /history
Creates a picture history so it is possible for users to keep track of changes applied to an original picture.

##### Example request body

```json
{
  "picture_id": 5,
  "original_picture_id": 3,
  "hair_colour_id": 2,
  "hair_style_id": 3,
  "face_shape_id": 5,
  "user_id": 1
}
```

####  1.2.2. <a name='GEThistorylimitlimitoffsetoffset'></a>GET /history[?skip={skip}&limit={limit}&search={search}]
Browses all history

##### Optional queries
- `limit` (`int`): Limits the number of history retrieved
- `skip` (`int`): Offsets the position from which history will be retrieved (e.g. set `skip` to __5__ to ignore the first 5 picture records)
- `search` (`string`): Searches for history whose `file_name` or `hash` match this query (case insensitive)

####  1.2.3. <a name='GEThistoryid'></a>GET /history/{id}
Retrieves a history by its `id`.

####  1.2.4. <a name='PUThistoryid'></a>PUT /history/{id}
Updates a history identified by the specified `id`.

##### Example request body

```json
{
  "id": 3,
  "hair_colour_id": 4
}
```

####  1.2.5. <a name='DELETEhistoryid'></a>DELETE /history/{id}
Deletes a history identified by the specified `id`.


###  1.3. <a name='ModelPictures'></a>ModelPicture

Properties:

```json
{
  "id": "<int>",
  "file_name": "<string> (Required, Unique, Maximum Length: 256)",
  "file_extension": "<string>",
  "file_path": "<string>",
  "file_size": "<string>",
  "height": "<int>",
  "width": "<int>",
  "hair_colour_id": 2,
  "hair_style_id": 3,
  "face_shape_id": 5,
  "hair_length_id": 1,
  "date_created": "<DateTime?>",
  "date_updated": "<DateTime?>",
  "date_deleted": "<DateTime?>"
}
```
##### Remarks
__NOTE__: ModelPicture inherits from Picture class.

####  1.3.2. <a name='GETmodelpictureslimitlimitoffsetoffset'></a>GET /model_pictures[?skip={skip}&limit={limit}&search={search}]
Browses all model pictures

##### Optional queries
- `limit` (`int`): Limits the number of pictures retrieved
- `skip` (`int`): Offsets the position from which pictures will be retrieved (e.g. set `skip` to __5__ to ignore the first 5 picture records)
- `search` (`string`): Searches for pictures whose `file_name` or `hash` match this query (case insensitive)

####  1.3.3. <a name='GETmodelpicturesid'></a>GET /model_pictures/{id}
Retrieves a model picture with the specified `id`.

####  1.3.4. <a name='DELETEpictureid'></a>DELETE /model_pictures/{id}
Deletes a model picture identified by the specified `id`.