CREATE TABLE `identity_zone` (
  `id` varchar(36) NOT NULL,
  `subdomain` varchar(255) NOT NULL,
  `service_instance_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `subdomain` (`subdomain`),
  UNIQUE KEY `service_instance_id` (`service_instance_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `identity_provider` (
  `id` varchar(36) NOT NULL,
  `identity_zone_id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `origin_key` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `config` longtext,
  PRIMARY KEY (`id`),
  UNIQUE KEY `key_in_zone` (`identity_zone_id`,`origin_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE users ADD COLUMN identity_provider_id varchar(36) DEFAULT NULL;
ALTER TABLE users ADD UNIQUE KEY `username_in_idp` (`identity_provider_id`,`username`);
-- we would do this later, when we're ready to remove users.origin
-- ALTER TABLE users drop key users_unique_key; ALTER TABLE users DROP COLUMN `origin`;

ALTER TABLE oauth_client_details ADD COLUMN `identity_zone_id` varchar(36) DEFAULT NULL;
ALTER TABLE oauth_client_details ADD KEY `identity_zone_id` (`identity_zone_id`);

CREATE TABLE `client_idp` (
  `client_id` varchar(255) NOT NULL,
  `identity_provider_id` varchar(36) NOT NULL,
  PRIMARY KEY (`client_id`,`identity_provider_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
