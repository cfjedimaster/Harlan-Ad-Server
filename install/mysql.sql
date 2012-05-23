# MySQL-Front 3.2  (Build 10.21)

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES */;

/*!40101 SET NAMES latin1 */;
/*!40103 SET TIME_ZONE='SYSTEM' */;

# Host: localhost    Database: adserver
# ------------------------------------------------------
# Server version 4.1.11-nt

#
# Table structure for table ads
#

DROP TABLE IF EXISTS `ads`;
CREATE TABLE `ads` (
  `Id` varchar(35) NOT NULL default '',
  `clientidfk` varchar(35) NOT NULL default '',
  `name` varchar(50) NOT NULL default '',
  `source` varchar(255) NOT NULL default '',
  `height` int(11) default NULL,
  `width` int(11) default NULL,
  `title` varchar(255) NOT NULL default '',
  `body` varchar(255) NOT NULL default '',
  `url` varchar(255) NOT NULL default '',
  `active` tinyint(1) NOT NULL default '0',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `updated` datetime NOT NULL default '0000-00-00 00:00:00',
  `target` varchar(255) default NULL,
  `html` mediumtext NOT NULL,  
  PRIMARY KEY  (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


#
# Table structure for table ads_clicks
#

DROP TABLE IF EXISTS `ads_clicks`;
CREATE TABLE `ads_clicks` (
  `thetime` datetime NOT NULL default '0000-00-00 00:00:00',
  `adidfk` varchar(35) NOT NULL default '',
  `campaignidfk` varchar(35) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


#
# Table structure for table ads_impressions
#

DROP TABLE IF EXISTS `ads_impressions`;
CREATE TABLE `ads_impressions` (
  `thetime` datetime NOT NULL default '0000-00-00 00:00:00',
  `adidfk` varchar(35) NOT NULL default '',
  `campaignidfk` varchar(35) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `ads_impressions` VALUES ('2006-01-24 17:29:40','FEB33C8F-123F-6B7B-AC3CF6FFAB5658AB','FEB38291-123F-6B7B-ACE3AC4EE9F3339C');

#
# Table structure for table campaigns
#

DROP TABLE IF EXISTS `campaigns`;
CREATE TABLE `campaigns` (
  `Id` varchar(35) NOT NULL default '',
  `name` varchar(50) NOT NULL default '',
  `active` tinyint(1) NOT NULL default '0',
  `created` datetime NOT NULL default '0000-00-00 00:00:00',
  `updated` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


#
# Table structure for table campaigns_ads
#

DROP TABLE IF EXISTS `campaigns_ads`;
CREATE TABLE `campaigns_ads` (
  `Id` varchar(35) NOT NULL default '',
  `campaignidfk` varchar(35) NOT NULL default '',
  `adidfk` varchar(35) NOT NULL default '',
  `weight` int(11) NOT NULL default '0',
  `datebegin` datetime default '0000-00-00 00:00:00',
  `dateend` datetime default '0000-00-00 00:00:00',
  `timebegin` datetime default '0000-00-00 00:00:00',
  `timeend` datetime default '0000-00-00 00:00:00',
  PRIMARY KEY  (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


#
# Table structure for table clients
#

DROP TABLE IF EXISTS `clients`;
CREATE TABLE `clients` (
  `Id` varchar(35) NOT NULL default '',
  `name` varchar(50) NOT NULL default '',
  `emailaddress` varchar(255) NOT NULL default '',
  `notes` mediumtext NOT NULL,
  PRIMARY KEY  (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


#
# Table structure for table groups
#

DROP TABLE IF EXISTS `groups`;
CREATE TABLE `groups` (
  `Id` varchar(35) NOT NULL default '',
  `name` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#
# Dumping data for table groups
#

INSERT INTO `groups` VALUES ('99C5AACE-92B3-7D72-6E5B4017FD38ACED','admin');

#
# Table structure for table users
#

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `Id` varchar(35) NOT NULL default '',
  `name` varchar(50) NOT NULL default '',
  `emailaddress` varchar(255) NOT NULL default '',
  `username` varchar(50) NOT NULL default '',
  `password` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#
# Dumping data for table users
#

INSERT INTO `users` VALUES ('94CC6A2B-A60E-187D-5BFEA49A0FB60145','Raymond Camden','ray@camdenfamily.com','admin','password');

#
# Table structure for table users_groups
#

DROP TABLE IF EXISTS `users_groups`;
CREATE TABLE `users_groups` (
  `useridfk` varchar(35) NOT NULL default '',
  `groupidfk` varchar(35) NOT NULL default ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

#
# Dumping data for table users_groups
#

INSERT INTO `users_groups` VALUES ('94CC6A2B-A60E-187D-5BFEA49A0FB60145','99C5AACE-92B3-7D72-6E5B4017FD38ACED');
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
