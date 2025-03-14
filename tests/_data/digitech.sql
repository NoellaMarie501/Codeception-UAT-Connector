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

 
LOCK TABLES `health` WRITE;
/*!40000 ALTER TABLE `health` DISABLE KEYS */;
INSERT INTO `health` VALUES (1,'2021-01-20 08:10:01'),(2,'2022-03-28 09:30:01'),(3,'2022-06-06 08:40:01'),(4,'2022-06-06 08:45:01'),(5,'2022-06-06 08:50:01'),(6,'2022-06-06 08:55:01'),(7,'2022-06-16 16:20:01'),(8,'2022-06-16 16:25:01');
/*!40000 ALTER TABLE `health` ENABLE KEYS */;
UNLOCK TABLES;
 

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

 
LOCK TABLES `health_result` WRITE;
/*!40000 ALTER TABLE `health_result` DISABLE KEYS */;
INSERT INTO `health_result` VALUES (49,1,0,'0.91','cpu'),(50,1,0,'9.7','memory'),(51,1,1,'46','disk'),(52,1,1,'0','error'),(53,1,1,'0','success'),(54,1,1,'0','pending'),(55,1,1,'OK','db'),(56,1,1,'OK','remote'),(57,2,0,'1.24','cpu'),(58,2,0,'70.5','memory'),(59,2,0,'85','disk'),(60,2,1,'0','error'),(61,2,1,'0','success'),(62,2,1,'0','pending'),(63,2,1,'OK','db'),(64,2,1,'OK','remote'),(65,3,0,'0.8','cpu'),(66,3,0,'63.4','memory'),(67,3,1,'35','disk'),(68,3,1,'0','error'),(69,3,1,'0','success'),(70,3,1,'0','pending'),(71,3,1,'OK','db'),(72,3,1,'OK','remote'),(73,4,0,'0.48','cpu'),(74,4,0,'63.4','memory'),(75,4,1,'35','disk'),(76,4,1,'0','error'),(77,4,1,'0','success'),(78,4,1,'0','pending'),(79,4,1,'OK','db'),(80,4,1,'OK','remote'),(81,5,0,'0.28','cpu'),(82,5,0,'63.3','memory'),(83,5,1,'35','disk'),(84,5,1,'0','error'),(85,5,1,'0','success'),(86,5,1,'0','pending'),(87,5,1,'OK','db'),(88,5,1,'OK','remote'),(89,6,0,'0.34','cpu'),(90,6,0,'63.2','memory'),(91,6,1,'35','disk'),(92,6,1,'0','error'),(93,6,1,'0','success'),(94,6,1,'0','pending'),(95,6,1,'OK','db'),(96,6,1,'OK','remote'),(97,7,0,'3.21','cpu'),(98,7,0,'16','memory'),(99,7,1,'54','disk'),(100,7,1,'0','error'),(101,7,1,'0','success'),(102,7,1,'0','pending'),(103,7,1,'OK','db'),(104,7,1,'OK','remote'),(105,8,0,'5.29','cpu'),(106,8,0,'16.6','memory'),(107,8,1,'54','disk'),(108,8,1,'0','error'),(109,8,1,'0','success'),(110,8,1,'0','pending'),(111,8,1,'OK','db'),(112,8,1,'OK','remote');
/*!40000 ALTER TABLE `health_result` ENABLE KEYS */;
UNLOCK TABLES;
 
 
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
