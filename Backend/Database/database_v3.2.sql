-- Log in to MySQL as root
-- mysql -u root

-- Clean things up just in case
DROP USER IF EXISTS 'dev_admin'@'localhost';
DROP DATABASE IF EXISTS hairdressing_project_db;

-- Create database
CREATE DATABASE IF NOT EXISTS hairdressing_project_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- Create user
CREATE USER IF NOT EXISTS 'dev_admin'@'localhost' IDENTIFIED BY 'administrator';

-- Provide all permissions on the database for the user
GRANT ALL PRIVILEGES ON hairdressing_project_db.* TO 'dev_admin'@'localhost';
FLUSH PRIVILEGES;

-- Log out as root then login as the admin user:
-- exit
-- mysql -u dev_admin -p

-- Select database
USE hairdressing_project_db;

-- Create USERS table
-- InnoDB is the default MySQL storage engine
CREATE TABLE IF NOT EXISTS hairdressing_project_db.users
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
    `date_updated` 		    DATETIME DEFAULT NULL ON UPDATE NOW(),
    UNIQUE (`user_name`),
    UNIQUE (`user_email`),
    INDEX (`id`)
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;

-- ACCOUNTS table: utilities and security-related data
CREATE TABLE IF NOT EXISTS hairdressing_project_db.accounts (
    `user_id` 					BIGINT UNSIGNED NOT NULL PRIMARY KEY,
    `recover_password_token` 	BINARY(16) UNIQUE DEFAULT NULL,
    `account_confirmed` 		BOOL DEFAULT FALSE,
    `unusual_activity` 			BOOL DEFAULT FALSE,
    `date_created` 				DATETIME DEFAULT NOW(),
    `date_updated` 			    DATETIME DEFAULT NULL ON UPDATE NOW(),
    CONSTRAINT fk_user_id 		FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX(user_id)
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;

-- FACE_SHAPES table
CREATE TABLE IF NOT EXISTS hairdressing_project_db.face_shapes
(
    `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    `shape_name`    VARCHAR(128) NOT NULL DEFAULT '** ERROR: missing category **',
    `date_created`  DATETIME DEFAULT NOW(),
    `date_updated`  DATETIME DEFAULT NULL ON UPDATE NOW(),
    INDEX (`id`)
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;

-- FACE_SHAPE_LINKS table
CREATE TABLE IF NOT EXISTS hairdressing_project_db.face_shape_links
(
    `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    `face_shape_id` BIGINT UNSIGNED NOT NULL,
    `link_name`     VARCHAR(128) NOT NULL DEFAULT '** ERROR: missing category **',
    `link_url`      VARCHAR(512) NOT NULL DEFAULT '** ERROR: missing category **',
    `date_created`  DATETIME DEFAULT NOW(),
    `date_updated`  DATETIME DEFAULT NULL ON UPDATE NOW(),
    INDEX(`id`),
    FOREIGN KEY (`face_shape_id`)
        REFERENCES hairdressing_project_db.face_shapes (`id`)
        ON DELETE CASCADE
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;

-- HAIR_STYLES table
CREATE TABLE IF NOT EXISTS hairdressing_project_db.hair_styles
(
    `id`              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    `hair_style_name` VARCHAR(128) NOT NULL DEFAULT '** ERROR: missing category **',
    `date_created`    DATETIME NOT NULL DEFAULT NOW(),
    `date_updated`    DATETIME DEFAULT NULL ON UPDATE NOW(),
    INDEX (`id`)
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;

-- HAIR_STYLE_LINKS table
CREATE TABLE IF NOT EXISTS hairdressing_project_db.hair_style_links
(
    `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    `hair_style_id` BIGINT UNSIGNED NOT NULL,
    `link_name`     VARCHAR(128) NOT NULL DEFAULT '** ERROR: missing category **',
    `link_url`      VARCHAR(512) NOT NULL DEFAULT '** ERROR: missing category **',
    `date_created`  DATETIME DEFAULT NOW(),
    `date_updated`  DATETIME DEFAULT NULL ON UPDATE NOW(),
    INDEX(`id`),
    FOREIGN KEY (`hair_style_id`)
        REFERENCES hairdressing_project_db.hair_styles (`id`)
        ON DELETE CASCADE
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;

-- HAIR_LENGTHS table
CREATE TABLE IF NOT EXISTS hairdressing_project_db.hair_lengths
(
    `id`               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    `hair_length_name` VARCHAR(128) NOT NULL DEFAULT '** ERROR: missing category **',
    `date_created`     DATETIME NOT NULL DEFAULT NOW(),
    `date_updated`     DATETIME DEFAULT NULL ON UPDATE NOW(),
    INDEX (`id`)
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;

-- HAIR_LENGTH_LINKS table
CREATE TABLE IF NOT EXISTS hairdressing_project_db.hair_length_links
(
    `id`             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    `hair_length_id` BIGINT UNSIGNED NOT NULL,
    `link_name`      VARCHAR(128) NOT NULL DEFAULT '** ERROR: missing category **',
    `link_url`       VARCHAR(512) NOT NULL DEFAULT '** ERROR: missing category **',
    `date_created`   DATETIME NOT NULL DEFAULT NOW(),
    `date_updated`   DATETIME DEFAULT NULL ON UPDATE NOW(),
    INDEX(`id`),
    FOREIGN KEY (`hair_length_id`)
        REFERENCES hairdressing_project_db.hair_lengths (`id`)
        ON DELETE CASCADE
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;

-- COLOURS table
CREATE TABLE IF NOT EXISTS hairdressing_project_db.colours
(
    `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    `colour_name`   VARCHAR(64) NOT NULL DEFAULT '** ERROR: missing category **',
    `colour_hash`   VARCHAR(64) NOT NULL DEFAULT '** ERROR: missing category **',
    `date_created`  DATETIME DEFAULT NOW(),
    `date_updated`  DATETIME DEFAULT NULL ON UPDATE NOW(),
    INDEX(`id`)
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;

-- Pictures table: contains basic information about picture files uploaded--
CREATE TABLE IF NOT EXISTS hairdressing_project_db.pictures (
    `id`                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `file_name`         VARCHAR(255) NOT NULL UNIQUE,
    `file_path`         VARCHAR(255),
    `file_size`         INT,
    `height`            INT,
    `width`             INT,
    `date_created`      DATETIME DEFAULT NOW(),
    `date_updated`      DATETIME DEFAULT NULL ON UPDATE NOW(),
    INDEX(id, file_name, file_path)
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;

-- Model pictures table: related to pre-loaded model pictures to be displayed in the app --
CREATE TABLE IF NOT EXISTS hairdressing_project_db.model_pictures (
    `id`                                BIGINT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    `file_name`                         VARCHAR(255) NOT NULL UNIQUE,
    `file_path`                         VARCHAR(255),
    `file_size`                         INT,
    `height`                            INT,
    `width`                             INT,
    `hair_style_id`                     BIGINT UNSIGNED,
    `hair_length_id`                    BIGINT UNSIGNED,
    `face_shape_id`                     BIGINT UNSIGNED,
    `hair_colour_id`                    BIGINT UNSIGNED,
    `date_created`                      DATETIME DEFAULT NOW(),
    `date_updated`                      DATETIME DEFAULT NULL ON UPDATE NOW(),
    CONSTRAINT fk_hair_style_id         FOREIGN KEY (hair_style_id) REFERENCES hair_styles(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_hair_length_id        FOREIGN KEY (hair_length_id) REFERENCES hair_lengths(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_face_shape_id         FOREIGN KEY (face_shape_id) REFERENCES face_shapes(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_hair_colour_id        FOREIGN KEY (hair_colour_id) REFERENCES colours(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX(id, file_name, file_path, hair_style_id, hair_length_id, face_shape_id, hair_colour_id)
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;

-- History table: keeps track of changes made to pictures uploaded by users --
CREATE TABLE IF NOT EXISTS hairdressing_project_db.history (
    `id`                                    BIGINT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    `picture_id`                            BIGINT UNSIGNED NOT NULL,
    `original_picture_id`                   BIGINT UNSIGNED,
    `previous_picture_id`                   BIGINT UNSIGNED,
    `hair_colour_id`                        BIGINT UNSIGNED,
    `hair_style_id`                         BIGINT UNSIGNED,
    `face_shape_id`                         BIGINT UNSIGNED,
    `user_id`                               BIGINT UNSIGNED NOT NULL,
    `date_created`                          DATETIME DEFAULT NOW(),
    `date_updated`                          DATETIME DEFAULT NULL ON UPDATE NOW(),

    CONSTRAINT fk_history_picture_id
        FOREIGN KEY(picture_id)
        REFERENCES pictures(id) ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_history_original_picture_id
        FOREIGN KEY(original_picture_id)
        REFERENCES pictures(id) ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_history_previous_picture_id
        FOREIGN KEY(previous_picture_id)
        REFERENCES pictures(id) ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_history_hair_colour_id
        FOREIGN KEY(hair_colour_id)
        REFERENCES colours(id) ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_history_hair_style_id
        FOREIGN KEY(hair_style_id)
        REFERENCES hair_styles(id) ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_history_face_shape_id
        FOREIGN KEY (face_shape_id)
        REFERENCES face_shapes(id) ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_history_user_id
        FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE CASCADE,

    INDEX(id, picture_id, original_picture_id, previous_picture_id, hair_colour_id, hair_style_id, face_shape_id, user_id)
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;

-- DATABASE SEED --

INSERT INTO hairdressing_project_db.users(`user_name`, `user_password_hash`, `user_password_salt`, `user_email`, `first_name`, `user_role`)
VALUES
('admin', '123456', 'whatever', 'admin@mail.com', 'Admin', 'admin');

INSERT INTO hairdressing_project_db.accounts(`user_id`) VALUES (1);

INSERT INTO hairdressing_project_db.colours(`colour_name`, `colour_hash`)
VALUES 
('sunny_yellow', '#F9E726'),
('juicy_orange', '#EC6126'),
('fiery_red', '#B80C44'),
('hot_pink', '#CF34B1'),
('mysterious_violet', '#402D87'),
('ocean_blue', '#013C7A'),
('tropical_green', '#255638'),
('jet_black', '#27221C');

INSERT INTO hairdressing_project_db.face_shapes(`shape_name`)
VALUES
('heart'),
('square'),
('round'),
('oval'),
('long');
 
INSERT INTO  hairdressing_project_db.hair_styles(`hair_style_name`)
VALUES 
('curly'),
('wavy'),
('side_swept'),
('pixie_cut'),
('side_swept_bangs'),
('side_swept_braided');

INSERT INTO  hairdressing_project_db.hair_lengths(`hair_length_name`)
VALUES 
('short'),
('medium'),
('long');
