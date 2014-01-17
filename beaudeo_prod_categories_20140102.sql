-- MySQL dump 10.13  Distrib 5.5.34, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: beaudeo_production
-- ------------------------------------------------------
-- Server version	5.5.34-0ubuntu0.12.10.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `video_categories`
--

DROP TABLE IF EXISTS `video_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `video_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `view_count` int(11) DEFAULT NULL,
  `slug` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_video_categories_on_slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `video_categories`
--

LOCK TABLES `video_categories` WRITE;
/*!40000 ALTER TABLE `video_categories` DISABLE KEYS */;
INSERT INTO `video_categories` VALUES (1,'LOOK',NULL,'2013-11-14 05:04:36','2014-01-02 07:40:44',1200,'look'),(2,'Base',NULL,'2013-11-14 05:04:56','2014-01-02 07:12:44',1066,'base'),(3,'Eyes',NULL,'2013-11-14 05:05:07','2014-01-02 07:15:59',2372,'eyes'),(4,'Lips',NULL,'2013-11-14 05:05:15','2014-01-02 02:45:46',598,'lips'),(5,'BEAUDEO Pick',NULL,'2013-11-14 05:05:34','2014-01-02 07:39:29',480,'beaudeo-pick'),(6,'데일리/네츄럴',1,'2013-11-14 05:06:21','2014-01-02 02:19:25',239,''),(7,'파티/클럽',1,'2013-11-14 05:06:31','2014-01-02 06:56:40',146,'--2'),(8,'할로윈',1,'2013-11-14 05:06:42','2014-01-02 02:03:52',36,'--3'),(9,'데이트',1,'2013-11-14 05:06:53','2014-01-02 02:28:13',92,'--4'),(10,'면접',1,'2013-11-14 05:07:07','2014-01-01 22:30:19',44,'--5'),(11,'하객',1,'2013-11-14 05:07:17','2014-01-02 00:46:35',40,'--6'),(12,'웨딩',1,'2013-11-14 05:07:27','2014-01-02 01:18:23',49,'--7'),(13,'연예인',1,'2013-11-14 05:07:36','2014-01-02 01:50:10',309,'--8'),(14,'여드름',5,'2013-11-14 05:07:53','2014-01-02 07:18:13',46,'--9'),(15,'짝눈',5,'2013-11-14 05:08:03','2014-01-01 10:04:01',33,'--10'),(16,'건성',5,'2013-11-14 05:08:14','2014-01-02 00:41:41',34,'--11'),(17,'지성',5,'2013-11-14 05:08:23','2014-01-02 00:27:46',43,'--12'),(18,'홑꺼풀',5,'2013-11-14 05:08:47','2014-01-01 22:10:52',40,'--13'),(19,'쌍꺼풀',5,'2013-11-14 05:09:07','2013-12-31 10:26:15',149,'--14'),(20,'성형 메이크업',5,'2013-11-14 05:09:26','2013-12-19 18:40:18',5,'--15'),(21,'탈모',5,'2013-11-14 05:09:39','2013-12-25 05:05:44',4,'--16'),(22,'BASIC',NULL,'2013-11-14 08:12:02','2014-01-02 03:54:13',634,'basic'),(23,'SKIN Care',NULL,'2013-11-14 08:29:54','2014-01-02 07:17:55',583,'skin-care'),(24,'GROOMING',NULL,'2013-11-14 09:10:22','2014-01-02 02:46:41',350,'grooming'),(25,'Hair',NULL,'2013-11-14 13:11:58','2014-01-02 07:17:37',2347,'hair'),(26,'Nail',NULL,'2013-11-14 13:12:20','2014-01-02 07:11:04',419,'nail');
/*!40000 ALTER TABLE `video_categories` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-01-02  7:41:14
