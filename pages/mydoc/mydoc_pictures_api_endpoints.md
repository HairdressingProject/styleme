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
####  1.1.1. <a name='POSTupload'></a>POST /pictures/upload
Uploads a picture.

####  1.1.2. <a name='GETface_shape'></a>GET /pictures/{id}/face_shape

