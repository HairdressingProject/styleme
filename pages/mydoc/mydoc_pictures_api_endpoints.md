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
  "width": "",
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

####  1.1.3. <a name='DELETEpictureid'></a>DELETE /pictures/{id}
Deletes a picture identified by the specified `id`.

