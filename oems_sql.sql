-- MySQL dump 10.13  Distrib 9.0.1, for macos14 (arm64)
--
-- Host: localhost    Database: oems
-- ------------------------------------------------------
-- Server version	9.0.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `attempted_answers`
--

DROP TABLE IF EXISTS `attempted_answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attempted_answers` (
  `answer_id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `exam_id` int NOT NULL,
  `question_id` int NOT NULL,
  `student_answer` char(1) NOT NULL,
  `marks_awarded` int DEFAULT '0',
  PRIMARY KEY (`answer_id`),
  UNIQUE KEY `unique_student_exam_question_ids` (`student_id`,`exam_id`,`question_id`),
  KEY `exam_id` (`exam_id`),
  KEY `attempted_answers_ibfk_3` (`question_id`),
  CONSTRAINT `attempted_answers_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`),
  CONSTRAINT `attempted_answers_ibfk_2` FOREIGN KEY (`exam_id`) REFERENCES `exam` (`exam_id`),
  CONSTRAINT `attempted_answers_ibfk_3` FOREIGN KEY (`question_id`) REFERENCES `question` (`question_id`),
  CONSTRAINT `attempted_answers_chk_1` CHECK ((`student_answer` in (_utf8mb4'A',_utf8mb4'B',_utf8mb4'C',_utf8mb4'D')))
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attempted_answers`
--

LOCK TABLES `attempted_answers` WRITE;
/*!40000 ALTER TABLE `attempted_answers` DISABLE KEYS */;
INSERT INTO `attempted_answers` VALUES (4,1,789,1,'D',0),(5,1,789,2,'D',0),(6,1,789,3,'D',0),(7,1,789,4,'D',0),(8,1,676,1,'B',1),(9,1,676,2,'A',5),(10,1,676,3,'B',10),(11,1,676,4,'C',3),(12,1,345,1,'B',1),(13,1,345,2,'A',5),(14,1,345,3,'B',10),(15,1,345,4,'C',3),(16,123,12345,1,'B',1),(17,123,12345,3,'A',0),(18,123,12345,5,'C',3),(19,123,12345,6,'A',2),(20,123,100,1,'B',1),(21,123,100,2,'B',0),(22,123,100,3,'B',10),(23,1,12345,1,'B',1),(24,1,12345,3,'B',10),(25,1,12345,5,'C',3),(26,1,12345,6,'A',2),(27,1,100,1,'B',1),(28,1,100,2,'A',5),(29,1,100,3,'B',10),(30,20,100,1,'D',0),(31,20,100,2,'A',5),(32,20,100,3,'D',0),(33,20,12345,1,'C',0),(34,20,12345,3,'B',10),(35,20,12345,5,'B',0),(36,20,12345,6,'D',0),(37,1,2132,7,'A',3),(38,1,2132,8,'B',4),(39,1,2132,9,'D',3),(40,1,2132,10,'A',6);
/*!40000 ALTER TABLE `attempted_answers` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `set_marks_awarded` BEFORE INSERT ON `attempted_answers` FOR EACH ROW BEGIN
    DECLARE correct_answer CHAR(1);
    DECLARE question_mark INT;

    -- Retrieve the correct answer and mark for the question
    SELECT answer, mark INTO correct_answer, question_mark
    FROM question
    WHERE question_id = NEW.question_id;

    -- Check if the student's answer matches the correct answer
    IF NEW.student_answer = correct_answer THEN
        SET NEW.marks_awarded = question_mark;
    ELSE
        SET NEW.marks_awarded = 0;  -- Set to 0 if the answer is incorrect
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_result_after_attempt` AFTER INSERT ON `attempted_answers` FOR EACH ROW BEGIN
    DECLARE total_marks DECIMAL(10, 2);  -- Use DECIMAL to handle fractional calculations
    DECLARE current_marks DECIMAL(10, 2); -- Use DECIMAL for accurate percentage calculation
    DECLARE percentage DECIMAL(5, 2);
    DECLARE calculated_grade CHAR(1);

    -- Get the total marks for the exam
    SELECT total_marks INTO total_marks
    FROM exam
    WHERE exam_id = NEW.exam_id;

    -- Check if there's already a result entry for this student and exam
    IF EXISTS (SELECT 1 FROM result WHERE student_id = NEW.student_id AND exam_id = NEW.exam_id) THEN
        -- Update existing result entry: add the new marks_awarded to current marks_attained
        UPDATE result
        SET marks_attained = marks_attained + NEW.marks_awarded
        WHERE student_id = NEW.student_id AND exam_id = NEW.exam_id;

        -- Get the updated marks_attained for grade calculation
        SELECT marks_attained INTO current_marks
        FROM result
        WHERE student_id = NEW.student_id AND exam_id = NEW.exam_id;

    ELSE
        -- Insert a new result entry if it doesn’t exist
        INSERT INTO result (student_id, exam_id, marks_attained)
        VALUES (NEW.student_id, NEW.exam_id, NEW.marks_awarded);

        -- Set current_marks to marks_awarded for grade calculation
        SET current_marks = NEW.marks_awarded;
    END IF;

    -- Calculate percentage and determine grade
    SET percentage = current_marks / total_marks * 100;  -- Ensure you multiply by 100 to get the percentage

    -- Assign grade based on percentage
    IF percentage >= 90 THEN
        SET calculated_grade = 'S';
    ELSEIF percentage >= 80 THEN
        SET calculated_grade = 'A';
    ELSEIF percentage >= 70 THEN
        SET calculated_grade = 'B';
    ELSEIF percentage >= 60 THEN
        SET calculated_grade = 'C';
    ELSEIF percentage >= 50 THEN
        SET calculated_grade = 'D';
    ELSEIF percentage >= 40 THEN
        SET calculated_grade = 'E';
    ELSE
        SET calculated_grade = 'F';
    END IF;

    -- Update the grade in the result table
    UPDATE result
    SET grade = calculated_grade
    WHERE student_id = NEW.student_id AND exam_id = NEW.exam_id;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `exam`
--

DROP TABLE IF EXISTS `exam`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exam` (
  `exam_id` int NOT NULL,
  `type` enum('ISA','ESA') NOT NULL,
  `date` date NOT NULL,
  `duration` int NOT NULL,
  `course` varchar(100) NOT NULL,
  `total_marks` int DEFAULT '0',
  `examiner_id` int NOT NULL,
  PRIMARY KEY (`exam_id`),
  KEY `examiner_id` (`examiner_id`),
  CONSTRAINT `exam_ibfk_1` FOREIGN KEY (`examiner_id`) REFERENCES `examiner` (`examiner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exam`
--

LOCK TABLES `exam` WRITE;
/*!40000 ALTER TABLE `exam` DISABLE KEYS */;
INSERT INTO `exam` VALUES (12,'ISA','2024-11-07',60,'history',24,1),(17,'ESA','2024-11-08',100,'english literature',15,1),(18,'ESA','2024-11-09',8,'physical education ',3,1),(26,'ISA','2024-11-09',10,'anatomy',0,1),(99,'ISA','2024-11-14',1,'sample',13,1),(100,'ESA','2024-11-14',120,'kannada',16,1),(345,'ISA','2024-11-10',10,'social science ',19,1),(455,'ISA','2024-11-07',30,'general knowledge',19,1),(676,'ESA','2024-11-10',20,'biochemistry ',19,1),(789,'ESA','2024-11-10',180,'physics ',19,1),(2132,'ESA','2024-11-20',30,'dbms',16,1),(12345,'ISA','2024-11-14',1,'agility scrum',16,21),(123445,'ISA','2024-11-20',1,'software testing ',0,1),(2341234,'ISA','2024-11-20',1,'software testing',0,1);
/*!40000 ALTER TABLE `exam` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exam_question`
--

DROP TABLE IF EXISTS `exam_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exam_question` (
  `exam_id` int NOT NULL,
  `question_id` int NOT NULL,
  PRIMARY KEY (`exam_id`,`question_id`),
  KEY `exam_question_ibfk_2` (`question_id`),
  CONSTRAINT `exam_question_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `question` (`question_id`),
  CONSTRAINT `fk_exam_id` FOREIGN KEY (`exam_id`) REFERENCES `exam` (`exam_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exam_question`
--

LOCK TABLES `exam_question` WRITE;
/*!40000 ALTER TABLE `exam_question` DISABLE KEYS */;
INSERT INTO `exam_question` VALUES (12,1),(99,1),(100,1),(345,1),(455,1),(676,1),(789,1),(12345,1),(12,2),(17,2),(100,2),(345,2),(455,2),(676,2),(789,2),(12,3),(17,3),(99,3),(100,3),(345,3),(455,3),(676,3),(789,3),(12345,3),(12,4),(18,4),(345,4),(455,4),(676,4),(789,4),(12345,5),(12,6),(99,6),(12345,6),(12,7),(2132,7),(2132,8),(2132,9),(2132,10);
/*!40000 ALTER TABLE `exam_question` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_total_marks_after_insert` AFTER INSERT ON `exam_question` FOR EACH ROW BEGIN
    DECLARE question_mark INT;

    -- Get the mark for the question being added
    SELECT mark INTO question_mark 
    FROM question 
    WHERE question_id = NEW.question_id;

    -- Update the total_marks in the exam table
    UPDATE exam
    SET total_marks = total_marks + question_mark
    WHERE exam_id = NEW.exam_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_total_marks_after_delete` AFTER DELETE ON `exam_question` FOR EACH ROW BEGIN
    DECLARE question_mark INT;

    -- Get the mark for the question being deleted
    SELECT mark INTO question_mark 
    FROM question 
    WHERE question_id = OLD.question_id;

    -- Update the total_marks in the exam table
    UPDATE exam
    SET total_marks = total_marks - question_mark
    WHERE exam_id = OLD.exam_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `examiner`
--

DROP TABLE IF EXISTS `examiner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `examiner` (
  `examiner_id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`examiner_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `examiner`
--

LOCK TABLES `examiner` WRITE;
/*!40000 ALTER TABLE `examiner` DISABLE KEYS */;
INSERT INTO `examiner` VALUES (1,'cbr','cbr@gmail.com','ccc'),(2,'francis','gmail','12345'),(3,'grs','mm','12'),(5,'visha','vvv','1111'),(21,'a','a','21'),(234,'mm','234@gmail.com','mmm');
/*!40000 ALTER TABLE `examiner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `question`
--

DROP TABLE IF EXISTS `question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `question` (
  `question_id` int NOT NULL AUTO_INCREMENT,
  `question_body` text NOT NULL,
  `opt_A` text NOT NULL,
  `opt_B` text NOT NULL,
  `opt_C` text NOT NULL,
  `opt_D` text NOT NULL,
  `answer` char(1) NOT NULL,
  `examiner_id` int NOT NULL,
  `mark` int NOT NULL,
  PRIMARY KEY (`question_id`),
  KEY `examiner_id` (`examiner_id`),
  CONSTRAINT `question_ibfk_1` FOREIGN KEY (`examiner_id`) REFERENCES `examiner` (`examiner_id`),
  CONSTRAINT `question_chk_1` CHECK ((`answer` in (_utf8mb4'A',_utf8mb4'B',_utf8mb4'C',_utf8mb4'D')))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `question`
--

LOCK TABLES `question` WRITE;
/*!40000 ALTER TABLE `question` DISABLE KEYS */;
INSERT INTO `question` VALUES (1,'which is the national bird of india ?','hen','peacock','mynah','crow','B',1,1),(2,'which was the capital of vijayanagara empire ? ','hampi','mysuru','chitradurga','bengaluru','A',1,5),(3,'when was Mysuru state renamed as Karnataka ?','1954','1973','1982','1947','B',1,10),(4,'Kaveri river origin is in which district of karnataka ? ','Udupi','Mangaluru','Kodagu','Dakshina kannada','C',1,3),(5,'how many bones does human body have ?','204','205','206','207','C',1,3),(6,'who is most agile','chettah','q','w','e','A',21,2),(7,'which of these statements are DDL ? ','Create','insert','select ','none','A',1,3),(8,'which of the following is used to delete the rows of the table but not the structure ?','delete','truncate','create','modify','B',1,4),(9,'commit and rollback belongs to which of the follwing','DDL','DML','DCL','TCL','D',1,3),(10,'Which operation is used to extract specified columns from a table?','project','join','extract','substitute','A',1,6);
/*!40000 ALTER TABLE `question` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `result`
--

DROP TABLE IF EXISTS `result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `result` (
  `result_id` int NOT NULL AUTO_INCREMENT,
  `student_id` int DEFAULT NULL,
  `exam_id` int DEFAULT NULL,
  `marks_attained` int DEFAULT NULL,
  `grade` char(1) DEFAULT NULL,
  PRIMARY KEY (`result_id`),
  KEY `student_id` (`student_id`),
  KEY `exam_id` (`exam_id`),
  CONSTRAINT `result_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`),
  CONSTRAINT `result_ibfk_2` FOREIGN KEY (`exam_id`) REFERENCES `exam` (`exam_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `result`
--

LOCK TABLES `result` WRITE;
/*!40000 ALTER TABLE `result` DISABLE KEYS */;
INSERT INTO `result` VALUES (2,1,789,0,'F'),(3,1,676,19,'S'),(4,1,345,19,'S'),(5,123,12345,6,'F'),(6,123,100,11,'C'),(7,1,12345,16,'S'),(8,1,100,16,'S'),(9,20,100,5,'F'),(10,20,12345,10,'C'),(11,1,2132,16,'S');
/*!40000 ALTER TABLE `result` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student`
--

DROP TABLE IF EXISTS `student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student` (
  `student_id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`student_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student`
--

LOCK TABLES `student` WRITE;
/*!40000 ALTER TABLE `student` DISABLE KEYS */;
INSERT INTO `student` VALUES (1,'madhu','m@gmail.com','mmm'),(2,'m','mm','1234'),(3,'chintu','chintu@gmail.com','chintu123'),(20,'1','a@a.c','1'),(123,'as','as','123'),(1234,'mmmm','1234@gmail.com','1234');
/*!40000 ALTER TABLE `student` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_exam`
--

DROP TABLE IF EXISTS `student_exam`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_exam` (
  `student_id` int NOT NULL,
  `exam_id` int NOT NULL,
  PRIMARY KEY (`student_id`,`exam_id`),
  KEY `exam_id` (`exam_id`),
  CONSTRAINT `student_exam_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`),
  CONSTRAINT `student_exam_ibfk_2` FOREIGN KEY (`exam_id`) REFERENCES `exam` (`exam_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_exam`
--

LOCK TABLES `student_exam` WRITE;
/*!40000 ALTER TABLE `student_exam` DISABLE KEYS */;
INSERT INTO `student_exam` VALUES (1,100),(20,100),(123,100),(1,345),(1,676),(1,789),(1,2132),(1,12345),(20,12345),(123,12345);
/*!40000 ALTER TABLE `student_exam` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-20 14:53:49
