---
title: Pictures API End Points
keywords: Pictures, Api, Endpoints
last_updated: November 23, 2020
tags: [api]
summary: "This document describes all endpoints of the Pictures API."
sidebar: mydoc_sidebar
permalink: mydoc_pictures_api_endpoints.html
folder: mydoc
---

# Pictures API

This is a [FastAPI](https://fastapi.tiangolo.com/ "FastAPI") application that handles all operations related to pictures, such as changing hair styles, hair colours and keeping the history of such changes.

## Uploading model pictures

After the Pictures API is up and running, you will need to seed model pictures into the database.

The [`init_models.py`](https://github.com/HairdressingProject/styleme/blob/master/Backend/PicturesAPI/init_models.py "Seed models script") script has been provided for your convenience.

All you need to do is activate your `Conda` environment (refer to this [link](https://github.com/HairdressingProject/styleme/tree/master/Backend/PicturesAPI#create-virtual-environment "Creating environment") for more information) and run the script from the [`PicturesAPI`](https://github.com/HairdressingProject/styleme/tree/master/Backend/PicturesAPI "PicturesAPI folder") folder:

```bash
python init_models.py
```

It will take a while because the API will need to process each picture individually (detecting face landmarks, face shapes, adding records to the database, saving files, etc.).

## 1. <a name='APIendpoints'></a>API endpoints

All endpoints are listed below.

### 1.1. <a name='Pictures'></a>Pictures

Properties:

```json
{
  "id": "<int>",
  "file_name": "<string> (Required, Unique, Maximum Length: 256)",
  "file_path": "<string>",
  "file_size": "<string>",
  "height": "<int>",
  "width": "<int>",
  "date_created": "<DateTime?>",
  "date_updated": "<DateTime?>"
}
```

#### 1.1.1. <a name='POSTpicture'></a>POST /pictures

Uploads a picture associated with an authenticated user.

The user must be signed in to be identified by a JWT token sent either via cookies or `Authorization` (Bearer token) HTTP header.

This route also handles detecting face landmarks and face shapes. Those parameters are then added as a new entry in the history table associated with the current user.

The picture is sent in the request body as `multipart/form-data`, with "file" as key.

Returns:

```json
{
  "picture": "<Picture>",
  "face_shape": "<FaceShape>",
  "history_entry": "<HistoryEntry>"
}
```

##### Remarks

**NOTE**: if the uploaded picture is invalid (e.g. a GIF), no face is detected or its landmarks cannot be detected, it is not saved and a `422` status code is returned.

#### 1.1.2. <a name='GETpictureslimitlimitoffsetoffset'></a>GET /pictures[?skip={skip}&limit={limit}&search={search}]

Retrieves all picture objects available in the database. Skip, limit and search are optional parameters that may be specified to filter results.

##### Optional queries

- `limit` (`int`): Limits the number of pictures retrieved
- `skip` (`int`): Offsets the position from which pictures will be retrieved (e.g. set `skip` to **5** to ignore the first 5 picture records)
- `search` (`string`): Searches for pictures whose `file_name` match this query (case insensitive)

#### 1.1.3. <a name='GETpicturesid'></a>GET /pictures/id/{picture_id}

Retrieves a picture with the specified `picture_id`.

#### 1.1.4. <a name='GETpicturesfile'></a>GET /pictures/file/{picture_id}

Retrieves a picture file with the specified `picture_id`.

Returns: Raw bytes of the picture file.

#### 1.1.5. <a name='GETpicturesfaceshape'></a>GET /pictures/face_shape/{picture_id}

Retrieves the face shape of a picture that has already been uploaded, identified by picture_id.

Returns:

```json
{
  "face_shape": "<FaceShape>"
}
```

#### 1.1.6. <a name='GETpictureschangehaircolour'></a>GET /pictures/change_hair_colour/{picture_id}?colour={colour}&r={r}&g={g}&b={b}

Changes the hair colour of a picture identified by `picture_id`.

The `colour` parameter must be one of the options available in the colours table, identified by the colour name (e.g. _sunny_yellow_). The `r`, `g` and `b` parameters must be integers between 0 and 255.

Returns:

```json
{
  "history_entry": "<History>",
  "picture": "<Picture>",
  "hair_colour": "<HairColour>"
}
```

#### 1.1.7. <a name='GETpictureschangehairstyle'></a>GET /pictures/change_hair_style?user_picture_id={user_picture_id}&model_picture_id={model_picture_id}[&user_picture_file_name={user_picture_file_name}&model_picture_file_name={model_picture_file_name}

Changes the hair style of a picture identified either by `user_picture_id` or `user_picture_file_name`.

The model picture based on which the new hair style will be applied is identified either by `model_picture_id` or `model_picture_file_name`.

The combinations to be provided must be:

`user_picture_id` AND `model_picture_id`

OR

`user_picture_file_name` AND `model_picture_file_name`

Returns:

```json
{
  "history_entry": "<History>",
  "hair_style": "<HairStyle>",
  "current_picture": "<Picture>",
  "original_picture": "<Picture>"
}
```

#### 1.1.8. <a name='GETpicturesusers'></a>GET /pictures/users/{user_id}/latest

Retrieves the latest picture uploaded by a user identified by `user_id`.

Returns: Raw bytes of the picture file.

#### 1.1.9. <a name='DELETEpicturesid'></a>DELETE /pictures/{picture_id}

Deletes a picture identified by the specified `picture_id`.

Returns: `Picture` deleted

#### 1.1.10. <a name='DELETEpicturesdiscardchanges'></a>/pictures/discard_changes/{original_picture_id}

Deletes all entries in the `history` table identified by `original_picture_id` (along with the respective picture files and entries in the `pictures` table).

Only the very first entry containing `original_picture_id` is kept.

Returns:

```json
{
  "history": "<History>",
  "current_picture": "<Picture>"
}
```

### 1.2. <a name='History'>History</a>

Properties:

```json
{
  "id": "<int>",
  "picture_id": "<int>",
  "original_picture_id": "<int>",
  "previous_picture_id": "<int>",
  "hair_colour_id": "<int>",
  "hair_style_id": "<int>",
  "face_shape_id": "<int>",
  "user_id": "<int>",
  "date_created": "<DateTime?>",
  "date_updated": "<DateTime?>"
}
```

#### 1.2.1. <a name='POSThistory'></a>POST /history

Creates a picture history so it is possible for users to keep track of changes applied to an original picture.

##### Example request body

```json
{
  "picture_id": 5,
  "original_picture_id": 3,
  "previous_picture_id": 4,
  "hair_colour_id": 2,
  "hair_style_id": 3,
  "face_shape_id": 5,
  "user_id": 1
}
```

Returns: `History` entry added.

#### 1.2.2. <a name='GEThistorylimitlimitoffsetoffset'></a>GET /history[?skip={skip}&limit={limit}&search={search}]

Retrieves all `History` records.

`Limit`, `skip` and `search` parameters may be specified to filter results. Search is performed by username, which is then associated with the `user_id` of each history entry.

##### Optional queries

- `limit` (`int`): Limits the number of history retrieved
- `skip` (`int`): Offsets the position from which history will be retrieved (e.g. set `skip` to **5** to ignore the first 5 picture records)
- `search` (`string`): Searches for history entries which `user_id` corresponds to a user whose `user_name` matches this query (case insensitive)

Returns: List of `History` objects.

#### 1.2.3. <a name='GEThistoryid'></a>GET /history/{history_id}

Retrieves a history entry by its `history_id`.

Returns: `History` entry.

#### 1.2.4. <a name='PUThistoryid'></a>PUT /history/{history_id}

Updates a history record identified by the specified `history_id`.

##### Example request body

```json
{
  "id": 3,
  "hair_colour_id": 4
}
```

Returns: Updated `History` entry.

#### 1.2.5. <a name='DELETEhistoryid'></a>DELETE /history/{history_id}

Deletes a history identified by the specified `history_id`.

Returns: `History` record deleted.

#### 1.2.6. <a name='GEThistoryusers'></a>GET /history/users/{user_id}

Retrieves the entire history of pictures uploaded and changes made by a user identified by `user_id`.

Returns: List of `History` entries.

#### 1.2.7. <a name='GEThistoryuserslatest'></a>GET /history/users/{user_id}/latest

Retrieves the latest history entry associated with a user identified by `user_id`.

Returns:

```json
{
  "history_entry": "History",
  "current_picture": "Picture",
  "original_picture": "Picture"
}
```

#### 1.2.8. <a name='GEThistorypicturesfilename'></a>GET /history/pictures/{filename}

Retrieves all history entries associated with a picture identified by its `filename`.

The picture may be linked to either `picture_id` , `previous_picture_id` or `original_picture_id`.

Returns: List of `History` entries.

#### 1.2.9. <a name='GEThistorypicturesoriginalpictureid'></a>GET /history/pictures/id/{original_picture_id}

Retrieves all `History` entries associated with an original picture identified by `original_picture_id`.

Returns: List of `History` entries.

#### 1.2.10. <a name='POSThistoryfaceshape'></a>POST /history/face_shape

Adds a new `History` record (sent in the request body) based on the previous one with an updated `face_shape_id`.

Returns: `History` entry added.

### 1.3. <a name='ModelPictures'></a>ModelPicture

Properties:

```json
{
  "id": "<int>",
  "file_name": "<string> (Required, Unique, Maximum Length: 255)",
  "file_path": "<string>",
  "file_size": "<string>",
  "height": "<int>",
  "width": "<int>",
  "hair_colour_id": "<int>",
  "hair_style_id": "<int>",
  "face_shape_id": "<int>",
  "hair_length_id": "<int>",
  "date_created": "<DateTime?>",
  "date_updated": "<DateTime?>"
}
```

#### 1.3.1. <a name='GETmodelpictureslimitlimitoffsetoffset'></a>GET /model_pictures[?skip={skip}&limit={limit}&search={filename}]

Retrieves all model pictures.

`Skip`, `limit` and `search` are optional parameters that may be specified to filter results.

##### Optional queries

- `limit` (`int`): Limits the number of pictures retrieved
- `skip` (`int`): Offsets the position from which pictures will be retrieved (e.g. set `skip` to **5** to ignore the first 5 picture records)
- `search` (`string`): Searches for pictures which `file_name` match this query (case insensitive)

Returns: List of `ModelPicture`.

#### 1.3.2. <a name='GETmodelpicturesid'></a>GET /model_pictures/id/{model_picture_id}

Retrieves a model picture object identified by `model_picture_id`.

Returns: `ModelPicture`.

#### 1.3.3. <a name='GETmodelpicturesfile'></a>GET /model_pictures/file/{model_picture_id}

Retrieves a model picture file identified by model_picture_id.

Returns: Raw bytes of the model picture file.

#### 1.3.4. <a name='DELETEmodelpictureid'></a>DELETE /model_pictures/{model_picture_id}

Deletes a model picture identified by the specified `model_picture_id`.

Returns: `ModelPicture` deleted.

#### 1.3.5. <a name='POSTmodels'></a>POST /models[?hair_length_id={hair_length_id}&hair_style_id={hair_style_id}&hair_length={hair_length}&hair_style={hair_style}]

Uploads a model picture, sent as `multipart/form-data` in the request body (with `file` as key) and with the specified parameters from the database.

The possible combinations are:

- hair_length_id AND hair_style_id

OR

- hair_length and hair_style (as strings, each one corresponding to the `name` column of the `hair_lengths` and `hair_styles` tables, respectively). For instance: hair_length = "long" and hair_style = "wavy".

Returns:

```json
{
  "model_picture": "<ModelPicture>",
  "face_shape": "<FaceShape>",
  "hair_length": "<HairLength>",
  "hair_style": "<HairStyle>"
}
```

#### 1.3.6. <a name='PUTmodelpictureid'></a>PUT /models/{model_picture_id}

Updates a model picture object sent in the request body, identified by `model_picture_id`.

Returns: Updated `ModelPicture`.
