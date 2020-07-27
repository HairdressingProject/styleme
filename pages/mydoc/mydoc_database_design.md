---
title: Database Design
keywords: Admin portal, Database
last_updated: April 7, 2020
tags: [database]
summary: "This document outlines the database's design & how it is initally constructed using MariaDB."
sidebar: mydoc_sidebar
permalink: mydoc_database_design.html
folder: mydoc
---

## 1. Design

[Database design diagram](https://dbdiagram.io/d/5e82af534495b02c3b890292)


## 2. Database and user creation

```mysql
CREATE DATABASE IF NOT EXISTS hair_project_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

```

## 3. Tables

### 3.1 Users table

<!-- {% include image.html file="/DB_design/users_table.png" alt="Users table" caption="Users table" %} -->

| users |
|-------|---------|
| id | bigint|
| user_name | varchar(32) |
| user_password_hash | varchar(512) |
| user_password_salt | varchar(512) |
| user_email | varchar(512) |
| first_name | varchar(128) | 
| last_name | varchar(128) |
| user_role | ENUM('admin', 'developer', 'user') |
| date_created | datetime |
| date_updated | datetime |



```mysql
CREATE TABLE IF NOT EXISTS hair_project_db.users
(
    `id`            		BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    `user_name`     		VARCHAR(32) NOT NULL,
    `user_password_hash` 	VARCHAR(512) NOT NULL,
	`user_password_salt` 	VARCHAR(512) NOT NULL,
    `user_email`    		VARCHAR(512) NOT NULL,
    `first_name`    		VARCHAR(128) NOT NULL DEFAULT 'user',
    `last_name`     		VARCHAR(128),
    `user_role`     		ENUM('admin', 'developer', 'user') NOT NULL DEFAULT 'user',
    `date_created`  		DATETIME DEFAULT NOW(),
    `date_modified` 		DATETIME DEFAULT NULL ON UPDATE NOW(),
    UNIQUE (`user_name`),
    UNIQUE (`user_email`),
    INDEX (`id`)
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;
```

### 3.2 Accounts table

<!-- {% include image.html file="/DB_design/accounts.png" alt="Accounts table" caption="Accounts table" %} -->

| users |
|-------|---------|
| user_id | bigint|
| recover_password_token | binary(16) |
| account_confirmed | bool |
| unusual_activity | bool |
| date_created | datetime |
| date_updated | datetime |

```mysql
CREATE TABLE IF NOT EXISTS hair_project_db.accounts (
    `user_id` 				BIGINT UNSIGNED NOT NULL PRIMARY KEY,
    `recover_password_token` 		BINARY(16) UNIQUE DEFAULT NULL,
    `account_confirmed` 		BOOL DEFAULT FALSE,
    `unusual_activity` 			BOOL DEFAULT FALSE,
    `date_created` 			DATETIME DEFAULT NOW(),
    `date_modified` 			DATETIME DEFAULT NULL ON UPDATE NOW(),
    CONSTRAINT fk_user_id 		FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;
```

### 3.3 User Features table

<!-- {% include image.html file="/DB_design/user_features_table.png" alt="User features table" caption="User features table" %} -->

| user_features |
|-------|---------|
| id | bigint |
| user_id | bigint |
| face_shape_id | bigint |
| skin_tone_id | bigint |
| hair_style_id | bigint | 
| hair_length_id | bigint |
| hair_colour_id | bigint |
| date_created | datetime |
| date_updated | datetime |

```mysql
CREATE TABLE IF NOT EXISTS hair_project_db.user_features
(
    `id`             	BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    `user_id`        	BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `face_shape_id`  	BIGINT NOT NULL,
    `skin_tone_id`   	BIGINT NOT NULL,
    `hair_style_id`  	BIGINT NOT NULL,
    `hair_length_id` 	BIGINT NOT NULL,
    `hair_colour_id` 	BIGINT NOT NULL,
    `date_created`  	DATETIME NOT NULL DEFAULT NOW(),
    `date_modified`  	DATETIME DEFAULT NULL ON UPDATE NOW(),
    INDEX (`id`),
    FOREIGN KEY (`user_id`)
        REFERENCES hair_project_db.users (`id`)
        ON DELETE CASCADE
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;
```

### 3.4 Face shapes table

<!-- {% include image.html file="/DB_design/face_shapes_table.png" alt="Face shapes table" caption="Face shapes table" %} -->

| face_shapes |
|-------|---------|
| id | bigint |
| shape_name | varchar(128) |
| date_created | datetime |
| date_updated | datetime |


```mysql
CREATE TABLE IF NOT EXISTS hair_project_db.face_shapes
(
    `id`            	BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    `shape_name`    	VARCHAR(128) NOT NULL DEFAULT '** ERROR: missing category **',
    `date_created` 	DATETIME NOT NULL DEFAULT NOW(),
    `date_modified` 	DATETIME DEFAULT NULL ON UPDATE NOW(),
    INDEX (`id`)
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;
```

### 3.5 Face shape links table

<!-- {% include image.html file="/DB_design/face_shape_links_table.png" alt="Face shape links table" caption="Face shape links table" %} -->

| face_shape_links |
|-------|---------|
| id | bigint |
| face_shape_id | bigint |
| link_name | varchar(128) |
| link_url | varchar(512) |
| date_created | datetime |
| date_updated | datetime |

```mysql
CREATE TABLE IF NOT EXISTS hair_project_db.face_shape_links
(
    `id`            	BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    `face_shape_id` 	BIGINT UNSIGNED NOT NULL,
    `link_name`     	VARCHAR(128) NOT NULL DEFAULT '** ERROR: missing category **',
    `link_url`      	VARCHAR(512) NOT NULL DEFAULT '** ERROR: missing category **',
    `date_created` 	DATETIME NOT NULL DEFAULT NOW(),
    `date_modified` 	DATETIME DEFAULT NULL ON UPDATE NOW(),
    INDEX(`id`),
    FOREIGN KEY (`face_shape_id`)
        REFERENCES hair_project_db.face_shapes (`id`)
        ON DELETE CASCADE
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;
```

### 3.6 Hair styles table

<!-- {% include image.html file="/DB_design/hair_styles_table.png" alt="Hair styles table" caption="Hair styles table" %} -->

| hair_styles |
|-------|---------|
| id | bigint |
| hair_style_name | varchar(128) |
| date_created | datetime |
| date_updated | datetime |

```mysql
CREATE TABLE IF NOT EXISTS hair_project_db.hair_styles
(
    `id`              	BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    `hair_style_name` 	VARCHAR(128) NOT NULL DEFAULT '** ERROR: missing category **',
    `date_created`   	DATETIME NOT NULL DEFAULT NOW(),
    `date_modified`   	DATETIME DEFAULT NULL ON UPDATE NOW(),
    INDEX (`id`)
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;
```

### 3.7 Hair style links table

<!-- {% include image.html file="/DB_design/hair_style_links_table.png" alt="Hair style links table" caption="Hair style links table" %} -->

| hair_style_links |
|-------|---------|
| id | bigint |
| hair_style_id | bigint |
| link_name | varchar(128) |
| link_url | varchar(512) |
| date_created | datetime |
| date_updated | datetime |

```mysql
CREATE TABLE IF NOT EXISTS hair_project_db.hair_style_links
(
    `id`            	BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    `hair_style_id` 	BIGINT UNSIGNED NOT NULL,
    `link_name`     	VARCHAR(128) NOT NULL DEFAULT '** ERROR: missing category **',
    `link_url`      	VARCHAR(512) NOT NULL DEFAULT '** ERROR: missing category **',
    `date_created` 	DATETIME NOT NULL DEFAULT NOW(),
    `date_modified` 	DATETIME DEFAULT NULL ON UPDATE NOW(),
    INDEX(`id`),
    FOREIGN KEY (`hair_style_id`)
        REFERENCES hair_project_db.hair_styles (`id`)
        ON DELETE CASCADE
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;
```

### 3.8 Hair lengths table

<!-- {% include image.html file="/DB_design/hair_lengths_table.png" alt="Hair lengths table" caption="Hair lengths table" %} -->

| hair_lengths |
|-------|---------|
| id | bigint |
| hair_length_name | varchar(128) |
| date_created | datetime |
| date_updated | datetime |

```mysql
CREATE TABLE IF NOT EXISTS hair_project_db.hair_lengths
(
    `id`               		BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    `hair_length_name` 		VARCHAR(128) NOT NULL DEFAULT '** ERROR: missing category **',
    `date_created`    		DATETIME NOT NULL DEFAULT NOW(),
    `date_modified`    		DATETIME DEFAULT NULL ON UPDATE NOW(),
    INDEX (`id`)
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;
```

### 3.9 Hair length links table

<!-- {% include image.html file="/DB_design/hair_length_links_table.png" alt="Hair length links table" caption="Hair length links table" %} -->

| hair_length_links |
|-------|---------|
| id | bigint |
| hair_length_id | bigint |
| link_name | varchar(128) |
| link_url | varchar(512) |
| date_created | datetime |
| date_updated | datetime |

```mysql
CREATE TABLE IF NOT EXISTS hair_project_db.hair_length_links
(
    `id`             	BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    `hair_length_id` 	BIGINT UNSIGNED NOT NULL,
    `link_name`      	VARCHAR(128) NOT NULL DEFAULT '** ERROR: missing category **',
    `link_url`       	VARCHAR(512) NOT NULL DEFAULT '** ERROR: missing category **',
    `date_created` 	DATETIME NOT NULL DEFAULT NOW(),
    `date_modified`  	DATETIME DEFAULT NULL ON UPDATE NOW(),
    INDEX(`id`),
    FOREIGN KEY (`hair_length_id`)
        REFERENCES hair_project_db.hair_lengths (`id`)
        ON DELETE CASCADE
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;
```

### 3.10 Skin tones table

<!-- {% include image.html file="/DB_design/skin_tones_table.png" alt="Skin tones table" caption="Skin tones table" %} -->

| skin_tones |
|-------|---------|
| id | bigint |
| skin_tone_name | varchar(128) |
| skin_tone_colour_id | bigint |
| date_created | datetime |
| date_updated | datetime |

```mysql
CREATE TABLE IF NOT EXISTS hair_project_db.skin_tones
(
    `id`             	BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    `skin_tone_name` 	VARCHAR(128) NOT NULL DEFAULT '** ERROR: missing category **',
    `date_created`  	DATETIME NOT NULL DEFAULT NOW(),
    `date_modified`  	DATETIME DEFAULT NULL ON UPDATE NOW(),
    INDEX (`id`)
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;
```

### 3.11 Skin tone links table

<!-- {% include image.html file="/DB_design/skin_tone_links_table.png" alt="Skin tone links table" caption="Skin tone links table" %} -->

| skin_tone_links |
|-------|---------|
| id | bigint |
| skin_tone_id | bigint |
| link_name | varchar(128) |
| link_url | varchar(512) |
| date_created | datetime |
| date_updated | datetime |

```mysql
CREATE TABLE IF NOT EXISTS hair_project_db.skin_tone_links
(
    `id`            	BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    `skin_tone_id`  	BIGINT UNSIGNED NOT NULL,
    `link_name`     	VARCHAR(128) NOT NULL DEFAULT '** ERROR: missing category **',
    `link_url`      	VARCHAR(512) NOT NULL DEFAULT '** ERROR: missing category **',
    `date_created` 	DATETIME NOT NULL DEFAULT NOW(),
    `date_modified` 	DATETIME DEFAULT NULL ON UPDATE NOW(),
    INDEX(`id`),
    FOREIGN KEY (`skin_tone_id`)
        REFERENCES hair_project_db.skin_tones (`id`)
        ON DELETE CASCADE
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;
```

### 3.12 Colours table

<!-- {% include image.html file="/DB_design/colours_table.png" alt="Colours table" caption="Colours table" %} -->

| colours |
|-------|---------|
| id | bigint |
| colour_name | varchar(64) |
| colour_haSH | varchar(64) |
| date_created | datetime |
| date_updated | datetime |

```mysql
CREATE TABLE IF NOT EXISTS hair_project_db.colours
(
    `id` 		BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    `colour_name`   	VARCHAR(64) NOT NULL DEFAULT '** ERROR: missing category **',
    `colour_hash`   	VARCHAR(64) NOT NULL DEFAULT '** ERROR: missing category **',
    `date_created` 	DATETIME NOT NULL DEFAULT NOW(),
    `date_modified` 	DATETIME DEFAULT NULL ON UPDATE NOW(),
    INDEX(`id`)
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;
```
