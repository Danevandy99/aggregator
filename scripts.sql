# create newsfeeds table

drop table newsfeeds;
CREATE TABLE `newsfeeds` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(768) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `url` varchar(768) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT '',
  `lastcheck` int NOT NULL DEFAULT '0',
  `lastupdate` int NOT NULL DEFAULT '0',
  `lastmod` int NOT NULL DEFAULT '0',
  `createdon` int NOT NULL DEFAULT '0',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `link` varchar(768) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `errors` int NOT NULL DEFAULT '0',
  `updated` tinyint NOT NULL DEFAULT '0',
  `lastitemid` varchar(768) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `pubdate` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `contenthash` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `lasthttpstatus` int NOT NULL DEFAULT '0',
  `lastgoodhttpstatus` int NOT NULL DEFAULT '0',
  `dead` tinyint NOT NULL DEFAULT '0',
  `contenttype` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `itunes_id` bigint DEFAULT NULL,
  `duplicateof` bigint DEFAULT NULL,
  `original_url` varchar(768) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `artwork_url_600` varchar(768) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `description` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `itunes_author` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `itunes_owner_email` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `itunes_owner_name` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `itunes_new_feed_url` varchar(768) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `explicit` tinyint NOT NULL DEFAULT '0',
  `image` varchar(768) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT '',
  `itunes_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `type` tinyint NOT NULL DEFAULT '0',
  `generator` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `parse_errors` int NOT NULL DEFAULT '0',
  `lastparse` int NOT NULL DEFAULT '0',
  `pullnow` tinyint NOT NULL DEFAULT '0' COMMENT 'Scan this feed immediately.',
  `parsenow` tinyint NOT NULL DEFAULT '0' COMMENT 'Scan this feed immediately.',
  `newest_item_pubdate` int NOT NULL DEFAULT '0',
  `update_frequency` tinyint NOT NULL DEFAULT '0',
  `priority` tinyint NOT NULL DEFAULT '0',
  `language` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'Language in the feed.',
  `detected_language` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'Language we detected.',
  `chash` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `oldest_item_pubdate` int NOT NULL DEFAULT '0',
  `item_count` int NOT NULL DEFAULT '0',
  `popularity` int NOT NULL DEFAULT '0',
  `podcast_chapters` varchar(768) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `podcast_locked` tinyint NOT NULL DEFAULT '0',
  `podcast_owner` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `title` (`title`),
  KEY `itunes_id` (`itunes_id`),
  KEY `updated` (`updated`),
  KEY `errors` (`errors`),
  KEY `lasthttpstatus` (`lasthttpstatus`),
  KEY `lastgoodhttpstatus` (`lastgoodhttpstatus`),
  KEY `dead` (`dead`),
  KEY `original_url` (`original_url`),
  KEY `lastcheck` (`lastcheck`),
  KEY `lastupdate` (`lastupdate`),
  KEY `pullnow` (`pullnow`),
  KEY `parsenow` (`parsenow`),
  KEY `newest_item_pubdate` (`newest_item_pubdate`),
  KEY `update_frequency` (`update_frequency`),
  KEY `language` (`language`),
  KEY `priority` (`priority`),
  KEY `chash` (`chash`),
  KEY `item_count` (`item_count`),
  KEY `podcast_locked` (`podcast_locked`),
  KEY `podcast_owner` (`podcast_owner`)
  #CONSTRAINT `newsfeeds_ibfk_3` FOREIGN KEY (`itunes_id`) REFERENCES `directory_apple` (`itunes_id`) ON DELETE SET NULL ON UPDATE CASCADE
)

# move data from csv to newsfeeds table

LOAD DATA LOCAL INFILE '/Users/danevanderbilt/Downloads/podcasts.csv'
INTO TABLE newsfeeds
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
  @id,
  @url,
  @title,
  @lastUpdate,
  @link,
  @lastHttpStatus,
  @dead,
  @contentType,
  @itunesId,
  @originalUrl,
  @itunesAuthor,
  @itunesOwnerName,
  @explicit,
  @imageUrl,
  @itunesType,
  @generator,
  @newestItemPubdate,
  @language,
  @oldestItemPubDate,
  @episodeCount,
  @popularityScore,
  @createdOn,
  @updateFrequency,
  @chash,
  @host,
  @newestEnclosureUrl,
  @podcastGuid
 )
 SET
	id = @id,
   	url = @url,
   	title = coalesce(@title, ''),
   content = '',
   description = '';

CREATE TABLE directory_apple (
  itunes_id int not null,
  feed_url varchar(255) NOT NULL DEFAULT ''
);

CREATE TABLE nfitems (
  id bigint not null AUTO_INCREMENT,
  feedid bigint not null,
  primary key (`id`)
);

CREATE TABLE nfguids (
  guid varchar(255) not null default '',
  feedid bigint not null,
);

CREATE TABLE newsfeed_items (
  id bigint not null AUTO_INCREMENT,
  feedid bigint not null,
  title text,
  link text,
  description text,
  guid varchar(255),
  timestamp bigint,
  timeadded bigint,
  enclosure_url text,
  enclosure_length bigint,
  enclosure_type varchar(255),
  itunes_episode int,
  itunes_episode_type varchar(255),
  itunes_explicit boolean,
  itunes_duration bigint,
  itunes_season bigint,
  `purge` boolean,
  image text,
  primary key (`id`)
);

create table nfcategories (
  id bigint not null AUTO_INCREMENT,
  feedid bigint not null,
  catid1 BIGINT not null,
  catid2 BIGINT not null,
  catid3 BIGINT not null,
  catid4 BIGINT not null,
  catid5 BIGINT not null,
  catid6 BIGINT not null,
  catid7 BIGINT not null,
  catid8 BIGINT not null,
  catid9 BIGINT not null,
  catid10 BIGINT not null,
  primary key (`id`)
);

create table pubsub (
  id bigint not null AUTO_INCREMENT,
  feedid bigint not null,
  hub_url text,
  self_url text,
  primary key (`id`)
);

create table nfitem_soundbites (
  id bigint not null AUTO_INCREMENT,
  itemid bigint not null,
  title text,
  start_time bigint,
  duration bigint,
  primary key (`id`)
);

create table nfitem_persons (
  id bigint not null AUTO_INCREMENT,
  itemid bigint not null,
  name text,
  role text,
  grp text,
  img text,
  href text,
  primary key (`id`)
);

create table nfitem_transcripts (
  id bigint not null AUTO_INCREMENT,
  itemid bigint not null,
  url text,
  type varchar(255),
  primary key (`id`)
);

create table nffunding (
  id bigint not null AUTO_INCREMENT,
  itemid bigint not null,
  url text,
  message text,
  primary key (`id`)
);

create table nfitem_chapters (
  id bigint not null AUTO_INCREMENT,
  itemid bigint not null,
  url text,
  type varchar(255),
  primary key (`id`)
);
