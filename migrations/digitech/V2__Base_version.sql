CREATE TABLE `transaction` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `destination` varchar(100) NOT NULL,
  `callback_url` varchar(255) NOT NULL,
  `callback_attempt` TINYINT(1) NOT NULL DEFAULT '0',
  `amount` decimal(18,2) NOT NULL,
  `service` VARCHAR(100) NULL DEFAULT '',
  `ptn` varchar(36) NOT NULL,
  `ip` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `processed_at` timestamp NULL DEFAULT NULL,
  `status` varchar(100) NOT NULL,
  `jobId` varchar(100) DEFAULT NULL,
  `error` varchar(2048) DEFAULT NULL,
  `message`  TEXT NULL,
  `int_txid` varchar(50) DEFAULT NULL,
  `spref` VARCHAR(100) NULL,
  `type` VARCHAR(20) NOT NULL,
  `ext_txid` varchar(50) DEFAULT NULL,
  `is_callback_sent` TINYINT(1) NULL DEFAULT '0',
  `status_check_attempt` TINYINT(1) DEFAULT 0,
  `status_check_last` timestamp NULL DEFAULT NULL,
  `callback_type` VARCHAR(50) DEFAULT null,
  `customer_first_name` VARCHAR(100) DEFAULT null,
  `customer_last_name` VARCHAR(100) DEFAULT null,
  `customer_dob` DATE DEFAULT null,
  `customer_document_type_id` VARCHAR(50) DEFAULT null,
  `customer_document_number_id` VARCHAR(50) DEFAULT null,
  `customer_document_country_code_id` VARCHAR(50) DEFAULT null,
  `customer_cdata` TEXT null,
  `agent_id` VARCHAR(50) NOT NULL,
  `agent_name` VARCHAR(100) NOT NULL,
  `agent_location_lng` DOUBLE DEFAULT NULL,
  `agent_location_lat` DOUBLE DEFAULT NULL,
  `collector_company_id` VARCHAR(50) NOT NULL,
  `collector_company_name` VARCHAR(255) NOT NULL,
  `cdata` TEXT null,
  `customer_address` VARCHAR(255) DEFAULT NULL,
  `customer_phone` VARCHAR(255) DEFAULT NULL,
  `error_code` VARCHAR (20) NULL,
  `payload` VARCHAR(1024) DEFAULT NULL,
  `flag` JSON DEFAULT NULL,
  `notification_destination` varchar(100) DEFAULT null,
  `notification_message` TEXT null,
  `notification_type` ENUM('SMS', 'EMAIL', 'DEFAULT') DEFAULT 'DEFAULT',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_general_ci;

CREATE TABLE `callback` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uuid` VARCHAR(36) NOT NULL COLLATE 'utf8mb4_general_ci',
  `payload` VARCHAR(2048) NOT NULL COLLATE 'utf8mb4_general_ci',
  `url` VARCHAR(255) NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
  `sent_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_successful` TINYINT(1) NOT NULL DEFAULT 0,
  `error` VARCHAR(2048) NOT NULL DEFAULT '',
  `return_body` VARCHAR(2048) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
  `return_status` VARCHAR(20) NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
  `status` VARCHAR(50) NOT NULL,
  `transaction_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `callback_transaction_FK` (`transaction_id`),
  CONSTRAINT `callback_transaction_FK` FOREIGN KEY (`transaction_id`) REFERENCES `transaction` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_general_ci;


CREATE TABLE IF NOT EXISTS `balance` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `sent_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_successful` TINYINT(1) NOT NULL DEFAULT '0',
  `error` VARCHAR(2048) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_general_ci;


CREATE TABLE IF NOT EXISTS health
(
    `id` bigint(20)   NOT NULL AUTO_INCREMENT,    
    `checked_at`   timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_general_ci;


CREATE TABLE IF NOT EXISTS customer
(
    `id`           bigint(20)   NOT NULL AUTO_INCREMENT,    
    `cname`        varchar(255) NOT null,
    `cident`       varchar(255) NOT null,
    `created_at`   timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `health_result` (
	`id` BIGINT(20) NOT NULL AUTO_INCREMENT,
	`health_id` BIGINT(20) NOT NULL,
	`is_healthy` TINYINT(1) NOT NULL DEFAULT 0,
	`info` VARCHAR(2048) NULL DEFAULT '',
	`label` VARCHAR(128) NOT NULL DEFAULT '',
	PRIMARY KEY (`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS audit_log
(
    `id`				bigint(20)		NOT NULL AUTO_INCREMENT,    
    `transaction_uuid`	varchar(40)		NOT NULL,
    `message`			TEXT			NOT NULL,
    `context`			JSON			NOT NULL,
    `time` 				timestamp 		NOT NULL,
    PRIMARY KEY (`id`),
	INDEX(`transaction_uuid`,`time`)
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_general_ci;
