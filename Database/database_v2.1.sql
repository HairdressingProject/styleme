-- Log in to MySQL as root
-- mysql -u root

-- Clean things up just in case
DROP USER IF EXISTS 'dev_admin'@'localhost';
DROP DATABASE IF EXISTS hair_project_db;

-- Create database
CREATE DATABASE IF NOT EXISTS hair_project_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- Create user
CREATE USER IF NOT EXISTS 'dev_admin'@'localhost' IDENTIFIED BY 'administrator';

-- Provide all permissions on the database for the user
GRANT ALL PRIVILEGES ON hair_project_db.* TO 'dev_admin'@'localhost';
FLUSH PRIVILEGES;

-- Log out as root then login as the admin user:
-- exit
-- mysql -u dev_admin -p

-- Select database
USE hair_project_db;

-- Create USERS table
-- InnoDB is the default MySQL storage engine
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

-- ACCOUNTS table: utilities and security-related data
CREATE TABLE IF NOT EXISTS hair_project_db.accounts (
    `user_id` 					BIGINT UNSIGNED NOT NULL PRIMARY KEY,
    `recover_password_token` 	BINARY(16) UNIQUE DEFAULT NULL,
    `account_confirmed` 		BOOL DEFAULT FALSE,
    `unusual_activity` 			BOOL DEFAULT FALSE,
    `date_created` 				DATETIME DEFAULT NOW(),
    `date_modified` 			DATETIME DEFAULT NULL ON UPDATE NOW(),
    CONSTRAINT fk_user_id 		FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;

-- USER_FEATURES table
CREATE TABLE IF NOT EXISTS hair_project_db.user_features
(
    `id`             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    `user_id`        BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `face_shape_id`  BIGINT NOT NULL,
    `skin_tone_id`   BIGINT NOT NULL,
    `hair_style_id`  BIGINT NOT NULL,
    `hair_length_id` BIGINT NOT NULL,
    `hair_colour_id` BIGINT NOT NULL,
    `date_created`   DATETIME DEFAULT NOW(),
    `date_modified`  DATETIME DEFAULT NULL ON UPDATE NOW(),
    UNIQUE (`user_id`, `face_shape_id`,`skin_tone_id`,`hair_style_id`,`hair_length_id`,`hair_colour_id`),
    INDEX (`id`),
    FOREIGN KEY (`user_id`)
        REFERENCES hair_project_db.users (`id`)
        ON DELETE CASCADE
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;

-- FACE_SHAPES table
CREATE TABLE IF NOT EXISTS hair_project_db.face_shapes
(
    `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    `shape_name`    VARCHAR(128) NOT NULL DEFAULT '** ERROR: missing category **',
    `date_created`  DATETIME DEFAULT NOW(),
    `date_modified` DATETIME DEFAULT NULL ON UPDATE NOW(),
    INDEX (`id`)
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;

-- FACE_SHAPE_LINKS table
CREATE TABLE IF NOT EXISTS hair_project_db.face_shape_links
(
    `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    `face_shape_id` BIGINT UNSIGNED NOT NULL,
    `link_name`     VARCHAR(128) NOT NULL DEFAULT '** ERROR: missing category **',
    `link_url`      VARCHAR(512) NOT NULL DEFAULT '** ERROR: missing category **',
    `date_created`  DATETIME DEFAULT NOW(),
    `date_modified` DATETIME DEFAULT NULL ON UPDATE NOW(),
    INDEX(`id`),
    FOREIGN KEY (`face_shape_id`)
        REFERENCES hair_project_db.face_shapes (`id`)
        ON DELETE CASCADE
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;

-- HAIR_STYLES table
CREATE TABLE IF NOT EXISTS hair_project_db.hair_styles
(
    `id`              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    `hair_style_name` VARCHAR(128) NOT NULL DEFAULT '** ERROR: missing category **',
    `date_created`    DATETIME NOT NULL DEFAULT NOW(),
    `date_modified`   DATETIME DEFAULT NULL ON UPDATE NOW(),
    INDEX (`id`)
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;

-- HAIR_STYLE_LINKS table
CREATE TABLE IF NOT EXISTS hair_project_db.hair_style_links
(
    `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    `hair_style_id` BIGINT UNSIGNED NOT NULL,
    `link_name`     VARCHAR(128) NOT NULL DEFAULT '** ERROR: missing category **',
    `link_url`      VARCHAR(512) NOT NULL DEFAULT '** ERROR: missing category **',
    `date_created`  DATETIME DEFAULT NOW(),
    `date_modified` DATETIME DEFAULT NULL ON UPDATE NOW(),
    INDEX(`id`),
    FOREIGN KEY (`hair_style_id`)
        REFERENCES hair_project_db.hair_styles (`id`)
        ON DELETE CASCADE
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;

-- HAIR_LENGTHS table
CREATE TABLE IF NOT EXISTS hair_project_db.hair_lengths
(
    `id`               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    `hair_length_name` VARCHAR(128) NOT NULL DEFAULT '** ERROR: missing category **',
    `date_created`     DATETIME NOT NULL DEFAULT NOW(),
    `date_modified`    DATETIME DEFAULT NULL ON UPDATE NOW(),
    INDEX (`id`)
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;

-- HAIR_LENGTH_LINKS table
CREATE TABLE IF NOT EXISTS hair_project_db.hair_length_links
(
    `id`             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    `hair_length_id` BIGINT UNSIGNED NOT NULL,
    `link_name`      VARCHAR(128) NOT NULL DEFAULT '** ERROR: missing category **',
    `link_url`       VARCHAR(512) NOT NULL DEFAULT '** ERROR: missing category **',
    `date_created`   DATETIME NOT NULL DEFAULT NOW(),
    `date_modified`  DATETIME DEFAULT NULL ON UPDATE NOW(),
    INDEX(`id`),
    FOREIGN KEY (`hair_length_id`)
        REFERENCES hair_project_db.hair_lengths (`id`)
        ON DELETE CASCADE
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;

-- SKIN_TONES table
CREATE TABLE IF NOT EXISTS hair_project_db.skin_tones
(
    `id`             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    `skin_tone_name` VARCHAR(128) NOT NULL DEFAULT '** ERROR: missing category **',
    `date_created`   DATETIME NOT NULL DEFAULT NOW(),
    `date_modified`  DATETIME DEFAULT NULL ON UPDATE NOW(),
    INDEX (`id`)
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;

-- SKIN_TONE_LINKS table
CREATE TABLE IF NOT EXISTS hair_project_db.skin_tone_links
(
    `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    `skin_tone_id`  BIGINT UNSIGNED NOT NULL,
    `link_name`     VARCHAR(128) NOT NULL DEFAULT '** ERROR: missing category **',
    `link_url`      VARCHAR(512) NOT NULL DEFAULT '** ERROR: missing category **',
    `date_created`  DATETIME DEFAULT NOW(),
    `date_modified` DATETIME DEFAULT NULL ON UPDATE NOW(),
    INDEX(`id`),
    FOREIGN KEY (`skin_tone_id`)
        REFERENCES hair_project_db.skin_tones (`id`)
        ON DELETE CASCADE
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;

-- COLOURS table
CREATE TABLE IF NOT EXISTS hair_project_db.colours
(
    `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,
    `colour_name`   VARCHAR(64) NOT NULL DEFAULT '** ERROR: missing category **',
    `colour_hash`   VARCHAR(64) NOT NULL DEFAULT '** ERROR: missing category **',
    `date_created`  DATETIME DEFAULT NOW(),
    `date_modified` DATETIME DEFAULT NULL ON UPDATE NOW(),
    INDEX(`id`)
)
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
ENGINE = INNODB;


-- DATABASE SEED --

-- INSERT INTO hair_project_db.users(`user_name`, `user_password_hash`, `user_password_salt`, `user_email`, `first_name`, `user_role`)
-- VALUES
-- ('admin', '123456', 'admin@mail.com', 'Admin', 'admin');

-- INSERT INTO hair_project_db.accounts(`user_id`) VALUES (1);

-- INSERT INTO hair_project_db.colours(`colour_name`, `colour_hash`)
-- VALUES 
-- ('very_light_blonde','#'),
-- ('light_blonde', '#'),
-- ('medium_blonde', '#'),
-- ('dark_blond', '#'),
-- ('light_brown', '#'),
-- ('medium_brown', '#'),
-- ('dark_brown', '#'),
-- ('black/brown', '#'), 
-- ('dark_black/brown', '#'),
-- ('black', '#');

-- INSERT INTO hair_project_db.face_shapes(`shape_name`)
-- VALUES
-- ('heart'),
-- ('square'),
-- ('rectangular'),
-- ('diamond'), 
-- ('triangular'),
-- ('inverted_triangular'),
-- ('round'),
-- ('oval'),
-- ('oblong');

-- INSERT INTO  hair_project_db.skin_tones(`skin_tone_name`)
-- VALUES
-- ('fair'),
-- ('olive'),
-- ('light_brown'),
-- ('brown'),
-- ('dark_brown'),
-- ('black_brown');
 
-- INSERT INTO  hair_project_db.hair_styles(`hair_style_name`)
-- VALUES 
-- ('bob cut'),
-- ('layered'),
-- ('bangs'),
-- ('pixie cut');

-- INSERT INTO  hair_project_db.hair_lengths(`hair_length_name`)
-- VALUES 
-- ('forme_massive'),
-- ('forme_degradee'),
-- ('forme_progressive'),
-- ('forme_uniforme');

-- INSERT INTO hair_project_db.user_features(`user_id`, `face_shape_id`, `skin_tone_id`, `hair_style_id`, `hair_length_id`, `hair_colour_id`)
-- VALUES
-- ('1', '1', '1', '1', '1', '1');

-- INSERT INTO hair_project_db.face_shape_links(`face_shape_id`, `link_name`, `link_url`)
-- VALUES 
-- (1, 'heart', 'linkUrl'),
-- (2, 'square', 'linkUrl'),
-- (3, 'rectangular', 'linkUrl'),
-- (4, 'diamond', 'linkUrl'),
-- (5, 'triangular', 'linkUrl'),
-- (6, 'inverted_triangular', 'linkUrl');

-- INSERT INTO hair_project_db.hair_style_links(`hair_style_id`, `link_name`, `link_url`)
-- VALUES 
-- (1, 'bob cut', 'linkUrl'),
-- (2, 'layered', 'linkUrl'),
-- (3, 'bangs', 'linkUrl'),
-- (4, 'pixie', 'linkUrl');

-- INSERT INTO hair_project_db.hair_length_links(`hair_length_id`, `link_name`, `link_url`)
-- VALUES
-- (1, 'forme_massive', 'linkUrl'),
-- (2, 'forme_degradee', 'linkUrl'),
-- (3, 'forme_progressive', 'linkUrl'),
-- (4, 'forme_uniforme', 'linkUrl');

-- INSERT INTO hair_project_db.skin_tone_links(`skin_tone_id`, `link_name`, `link_url`)
-- VALUES
-- (1, 'fair', 'linkUrl'),
-- (2, 'olive', 'linkUrl'),
-- (3, 'light_brown', 'linkUrl'),
-- (4, 'brown', 'linkUrl'),
-- (5, 'dark_brown', 'linkUrl'),
-- (6, 'black_brown', 'linkUrl');


-- TODO
-- waiting for client to supply example images and more information abot hair styles needed to add to links table
