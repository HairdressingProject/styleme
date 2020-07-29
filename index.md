---
title: "Documentation for the StyleMe.best App"
keywords: homepage
tags: [getting_started]
sidebar: mydoc_sidebar
permalink: index.html
---
Welcome to the documentation site for the Hairdressing Project available [here](https://github.com/HairdressingProject/styleme "styleme github repository")

# Documentation Layout
* Overview
    * Introduction
* Admin Portal
    * Setup
    * Guide (Admin Functions)
    * Design (Wireframes)
    * Deployment (Digital Ocean)
* Database
    * Design (MariaDB)
* API 
    * End Points
    * Build Instructions (Advanced)

# Project Overview
## Backend
### API
We used ASP.NET Core to build the main API of this project, which directly interfaces with our database. See the "End Points" section in the navbar for more details about its routes.

Additional APIs may be built to interpret and process images uploaded by users. This is related to the main feature of the Style Me app.

### Database
A MariaDB database is currently being used to store all the details needed for the Style Me app, including user information (best practices for security were adopted).

## Admin Portal v2
This is an overhaul of the initial version of the Admin Portal for this project.

The following languages and tools were used to build it:

- HTML
- SCSS
- JavaScript
- Zurb Foundation
- Webpack
- PHP

We are using Apache to serve the PHP pages. 
<sup> Private GitHub Source: https://github.com/HairdressingProject/styleme/blob/master/README.md </sup>
