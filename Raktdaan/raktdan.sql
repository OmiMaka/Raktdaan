-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 06, 2022 at 01:34 PM
-- Server version: 10.4.20-MariaDB
-- PHP Version: 7.3.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `raktdan`
--

-- --------------------------------------------------------

--
-- Table structure for table `bloodbags`
--

CREATE TABLE `bloodbags` (
  `bbid` char(10) NOT NULL,
  `donation_type` char(20) NOT NULL,
  `quantity_CC` decimal(5,2) NOT NULL,
  `blood_type` char(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `bloodbags`
--

INSERT INTO `bloodbags` (`bbid`, `donation_type`, `quantity_CC`, `blood_type`) VALUES
('b09', 'Plasma', '320.00', 'B+'),
('b1', 'Blood', '513.00', 'O+'),
('b14', 'Blood', '100.00', 'O+'),
('b17', 'Platelets', '210.11', 'AB+'),
('b2', 'Blood', '210.11', 'O+'),
('b3', 'Plasma', '200.00', 'A+'),
('b31', 'Power Red', '123.00', 'A+');

-- --------------------------------------------------------

--
-- Table structure for table `donation`
--

CREATE TABLE `donation` (
  `did` char(8) NOT NULL,
  `pid` char(8) NOT NULL,
  `peid` char(8) NOT NULL,
  `nurse` char(8) NOT NULL,
  `amount_donated_CC` decimal(5,2) NOT NULL,
  `donation_type` char(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `donation`
--

INSERT INTO `donation` (`did`, `pid`, `peid`, `nurse`, `amount_donated_CC`, `donation_type`) VALUES
('d1', 'p1', 'pe1', 'p4', '513.00', 'Blood'),
('d2', 'p1', 'pe2', 'p4', '200.00', 'Blood'),
('d3', 'p7', 'pe1', 'p4', '200.00', 'Blood'),
('d4', 'p4', 'pe1', 'p20', '240.00', 'Blood'),
('d5', 'p4', 'pe1', 'p12', '130.00', 'Plasma'),
('d6', 'p4', 'pe2', 'p12', '120.00', 'Power Red'),
('d7', 'p12', 'pe3', 'p16', '230.00', 'Plasma'),
('d8', 'p11', 'pe2', 'p20', '128.00', 'Platelets'),
('d9', 'p7', 'pe2', 'p16', '180.00', 'Plasma');

--
-- Triggers `donation`
--
DELIMITER $$
CREATE TRIGGER `check_date_before_donation` BEFORE INSERT ON `donation` FOR EACH ROW begin
    DECLARE msg VARCHAR(128);
    DECLARE cdate date;
    SELECT nextSafeDonation into cdate from donor where donor.pid = new.pid;
    if (sysdate() < cdate) then
        set msg = concat('Error: Your next safe donation date is due on ...',cdate);
        signal sqlstate '45001' set message_text = msg;
    end if;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check_donation_amount` BEFORE INSERT ON `donation` FOR EACH ROW begin 
declare msg varchar(128); 
if (new.amount_donated_CC > 350) then 
set msg = concat('Error: You cannot donate more than 350 ml.'); 
signal sqlstate '45001' set message_text = msg; 
end if; 
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check_nurse_before_Donation` BEFORE INSERT ON `donation` FOR EACH ROW begin 
 
declare c_pid int; 
declare msg varchar(128); 
 

if new.pid = new.nurse THEN 
set msg = concat('Error: Donator and nurse can not be same.'); 
signal sqlstate '45001' set message_text = msg; 
end if; 
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `donation_records`
--

CREATE TABLE `donation_records` (
  `did` char(8) NOT NULL,
  `lid` char(4) NOT NULL,
  `donation_date` date NOT NULL,
  `bbid` char(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `donation_records`
--

INSERT INTO `donation_records` (`did`, `lid`, `donation_date`, `bbid`) VALUES
('d1', 'l1', '2022-04-29', 'b1'),
('d2', 'l2', '2022-03-07', 'b17'),
('d3', 'l2', '2022-05-05', 'b2'),
('d9', 'l3', '2022-01-11', 'b14');

--
-- Triggers `donation_records`
--
DELIMITER $$
CREATE TRIGGER `before_delete_d_records` BEFORE DELETE ON `donation_records` FOR EACH ROW BEGIN
delete from donation where did = old.did;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_next_donation_date` BEFORE INSERT ON `donation_records` FOR EACH ROW BEGIN
	DECLARE wait_d int;
    DECLARE d_date DATE;
    DECLARE u_did char(8);
    SET d_date = NEW.donation_date;
    SET u_did = NEW.did;
    SELECT donation_types.frequency_days INTO wait_d FROM donation INNER JOIN donation_types ON donation.donation_type = donation_types.type WHERE donation.did = u_did;
    UPDATE donor SET nextSafeDonation = DATE_ADD(NEW.donation_date , INTERVAL 56 DAY)  WHERE donor.pid in (SELECT donor.pid
FROM donation INNER JOIN donation_records ON donation.did = donation_records.did
INNER JOIN donor ON donor.pid = donation.pid
WHERE donation.did = u_did);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `donation_types`
--

CREATE TABLE `donation_types` (
  `type` char(20) NOT NULL,
  `frequency_days` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `donation_types`
--

INSERT INTO `donation_types` (`type`, `frequency_days`) VALUES
('Blood', 56),
('Plasma', 28),
('Platelets', 7),
('Power Red', 112);

-- --------------------------------------------------------

--
-- Table structure for table `donor`
--

CREATE TABLE `donor` (
  `pid` char(8) NOT NULL,
  `blood_type` char(3) NOT NULL,
  `weight` int(11) NOT NULL,
  `height` int(11) NOT NULL,
  `gender` char(1) NOT NULL,
  `nextSafeDonation` date DEFAULT NULL
) ;

--
-- Dumping data for table `donor`
--

INSERT INTO `donor` (`pid`, `blood_type`, `weight`, `height`, `gender`, `nextSafeDonation`) VALUES
('p1', 'O+', 65, 161, 'F', '2022-04-04'),
('p11', 'O+', 70, 179, 'M', '2022-04-06'),
('p12', 'O-', 70, 165, 'F', '2022-05-04'),
('p15', 'AB+', 59, 149, 'F', NULL),
('p16', 'AB+', 60, 155, 'F', '2022-02-14'),
('p21', 'B+', 80, 168, 'M', '2022-06-11'),
('p4', 'AB+', 80, 179, 'M', '2022-05-01'),
('p7', 'A+', 80, 179, 'M', '2022-05-03');

--
-- Triggers `donor`
--
DELIMITER $$
CREATE TRIGGER `check_donor_age` BEFORE INSERT ON `donor` FOR EACH ROW begin 
declare msg varchar(128);
DECLARE myage integer;
select age into myage from persons where pid=new.pid;
if (myage < 18 OR myage > 65) 
then set msg = concat('Error: Your age is not valid');
signal sqlstate '45001' set message_text = msg; 
end if;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check_weight_donor` BEFORE INSERT ON `donor` FOR EACH ROW begin 
declare msg varchar(128); 
if (new.weight < 45) then 
set msg = concat('Error: Your weight should be atleast 45 KGs.'); 
signal sqlstate '45001' set message_text = msg; 
end if; 
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `global_inventory`
--

CREATE TABLE `global_inventory` (
  `bbid` char(10) NOT NULL,
  `lid` char(6) NOT NULL,
  `available` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `global_inventory`
--

INSERT INTO `global_inventory` (`bbid`, `lid`, `available`) VALUES
('b09', 'l2', 1),
('b1', 'l1', 0),
('b14', 'l1', 0),
('b17', 'l2', 1),
('b17', 'l3', 0),
('b2', 'l2', 0),
('b3', 'l1', 0);

-- --------------------------------------------------------

--
-- Table structure for table `locations`
--

CREATE TABLE `locations` (
  `lid` char(6) NOT NULL,
  `name` text NOT NULL,
  `lc` char(4) NOT NULL,
  `city` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `locations`
--

INSERT INTO `locations` (`lid`, `name`, `lc`, `city`) VALUES
('l1', 'Sterling Hospital', 'HSPT', 'Ahmedabad'),
('l2', 'ABC Hospital', 'HSPT', 'Ahmedabad'),
('l3', 'Rakt Blood Donation', 'BDCP', 'Surat');

-- --------------------------------------------------------

--
-- Table structure for table `location_codes`
--

CREATE TABLE `location_codes` (
  `lc` char(4) NOT NULL,
  `descrip` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `location_codes`
--

INSERT INTO `location_codes` (`lc`, `descrip`) VALUES
('BDCP', 'Blood Donation Camp'),
('CLIN', 'Clinic'),
('HSPT', 'Hospital'),
('NGOS', 'NGO');

-- --------------------------------------------------------

--
-- Table structure for table `nurse`
--

CREATE TABLE `nurse` (
  `pid` char(8) NOT NULL,
  `years_experienced` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `nurse`
--

INSERT INTO `nurse` (`pid`, `years_experienced`) VALUES
('p12', 4),
('p13', 1),
('p16', 2),
('p20', 3),
('p4', 2);

-- --------------------------------------------------------

--
-- Table structure for table `patient`
--

CREATE TABLE `patient` (
  `pid` char(8) NOT NULL,
  `blood_type` char(3) NOT NULL,
  `need_status` text NOT NULL,
  `weight` int(11) NOT NULL
) ;

--
-- Dumping data for table `patient`
--

INSERT INTO `patient` (`pid`, `blood_type`, `need_status`, `weight`) VALUES
('p12', 'AB+', 'low', 57),
('p20', 'O+', 'high', 50),
('p4', 'A+', 'low', 56),
('p93', 'A+', 'high', 60);

-- --------------------------------------------------------

--
-- Table structure for table `persons`
--

CREATE TABLE `persons` (
  `pid` char(8) NOT NULL,
  `first_name` text NOT NULL,
  `last_name` text NOT NULL,
  `age` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `persons`
--

INSERT INTO `persons` (`pid`, `first_name`, `last_name`, `age`) VALUES
('p1', 'Shreya', 'Karia', 19),
('p11', 'Jungkook', 'Jeon', 23),
('p12', 'Taehyung', 'Kim', 25),
('p13', 'Jimin', 'Park', 25),
('p14', 'Hoseok', 'Jung', 28),
('p15', 'Seokjin', 'Kim', 30),
('p16', 'Yoongi', 'Min', 29),
('p2', 'Namjoon', 'Kim', 27),
('p20', 'Twinkle ', 'Popat', 19),
('p21', 'Tom', 'Holland', 28),
('p3', 'Astha', 'Bhalodiya', 19),
('p4', 'Heet', 'Dedakiya', 19),
('p7', 'Omi', 'Makadia', 23),
('p78', 'Hitarth', 'Karia', 17),
('p93', 'Harsh', 'Goplani', 56);

--
-- Triggers `persons`
--
DELIMITER $$
CREATE TRIGGER `before_delete_on_persons` BEFORE DELETE ON `persons` FOR EACH ROW BEGIN
delete from nurse where pid = old.pid;
delete from patient where pid = old.pid;
delete from donor where pid = old.pid;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `pre_exam`
--

CREATE TABLE `pre_exam` (
  `peid` char(8) NOT NULL,
  `hemoglobin_gDL` decimal(5,2) NOT NULL,
  `temperature_F` decimal(5,2) NOT NULL,
  `blood_pressure` char(8) NOT NULL,
  `pulse_rate_BPM` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `pre_exam`
--

INSERT INTO `pre_exam` (`peid`, `hemoglobin_gDL`, `temperature_F`, `blood_pressure`, `pulse_rate_BPM`) VALUES
('pe1', '13.20', '97.00', '120/70', 77),
('pe2', '12.30', '96.00', '120/70', 77),
('pe3', '14.50', '98.00', '110/65', 70);

-- --------------------------------------------------------

--
-- Table structure for table `requests`
--

CREATE TABLE `requests` (
  `rqid` char(8) NOT NULL,
  `lid` char(6) NOT NULL,
  `blood_type_requested` char(8) NOT NULL,
  `date_requested` date NOT NULL,
  `quantity_requested_cc` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `requests`
--

INSERT INTO `requests` (`rqid`, `lid`, `blood_type_requested`, `date_requested`, `quantity_requested_cc`) VALUES
('r1', 'l1', 'O+', '2022-05-04', 200),
('r2', 'l1', 'O+', '2022-05-03', 400),
('r3', 'l3', 'A+', '2022-05-01', 200);

-- --------------------------------------------------------

--
-- Table structure for table `transfusion`
--

CREATE TABLE `transfusion` (
  `tid` char(8) NOT NULL,
  `pid` char(8) NOT NULL,
  `peid` char(8) NOT NULL,
  `nurse` char(8) NOT NULL,
  `amount_recieved_CC` decimal(5,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `transfusion`
--

INSERT INTO `transfusion` (`tid`, `pid`, `peid`, `nurse`, `amount_recieved_CC`) VALUES
('t1', 'p20', 'pe3', 'p4', '200.00'),
('t18', 'p4', 'pe3', 'p20', '126.00'),
('t2', 'p4', 'pe1', 'p12', '200.00'),
('t3', 'p12', 'pe2', 'p20', '120.00'),
('t4', 'p20', 'pe3', 'p16', '130.00'),
('t6', 'p4', 'pe2', 'p12', '210.00');

--
-- Triggers `transfusion`
--
DELIMITER $$
CREATE TRIGGER `check_nurse_before_Transfusion` BEFORE INSERT ON `transfusion` FOR EACH ROW begin 
 
declare c_pid int; 
declare msg varchar(128); 
 

if new.pid = new.nurse THEN 
set msg = concat('Error: Patient and nurse can not be same.'); 
signal sqlstate '45002' set message_text = msg; 
end if; 
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `transfusion_records`
--

CREATE TABLE `transfusion_records` (
  `tid` char(8) NOT NULL,
  `lid` char(4) NOT NULL,
  `transfusion_date` date NOT NULL,
  `bbid` char(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `transfusion_records`
--

INSERT INTO `transfusion_records` (`tid`, `lid`, `transfusion_date`, `bbid`) VALUES
('t1', 'l2', '2022-05-05', 'b1'),
('t18', 'l2', '2022-03-14', 'b1'),
('t2', 'l2', '2021-02-16', 'b2'),
('t6', 'l2', '2020-08-18', 'b3');

--
-- Triggers `transfusion_records`
--
DELIMITER $$
CREATE TRIGGER `before_delete_t_records` BEFORE DELETE ON `transfusion_records` FOR EACH ROW BEGIN
delete from transfusion where tid = old.tid;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_status` BEFORE INSERT ON `transfusion_records` FOR EACH ROW BEGIN
	UPDATE global_inventory SET available = FALSE WHERE bbid = new.bbid;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bloodbags`
--
ALTER TABLE `bloodbags`
  ADD PRIMARY KEY (`bbid`),
  ADD UNIQUE KEY `bbid` (`bbid`);

--
-- Indexes for table `donation`
--
ALTER TABLE `donation`
  ADD PRIMARY KEY (`did`),
  ADD KEY `p_id_fk` (`pid`),
  ADD KEY `pe_id_fk` (`peid`),
  ADD KEY `nurse_id` (`nurse`);

--
-- Indexes for table `donation_records`
--
ALTER TABLE `donation_records`
  ADD PRIMARY KEY (`did`),
  ADD KEY `l_fk` (`lid`),
  ADD KEY `bb_id_fk` (`bbid`);

--
-- Indexes for table `donation_types`
--
ALTER TABLE `donation_types`
  ADD PRIMARY KEY (`type`),
  ADD UNIQUE KEY `type` (`type`);

--
-- Indexes for table `donor`
--
ALTER TABLE `donor`
  ADD PRIMARY KEY (`pid`);

--
-- Indexes for table `global_inventory`
--
ALTER TABLE `global_inventory`
  ADD PRIMARY KEY (`bbid`,`lid`),
  ADD KEY `l_id_fk` (`lid`);

--
-- Indexes for table `locations`
--
ALTER TABLE `locations`
  ADD PRIMARY KEY (`lid`),
  ADD UNIQUE KEY `lid` (`lid`),
  ADD KEY `lc_fk` (`lc`);

--
-- Indexes for table `location_codes`
--
ALTER TABLE `location_codes`
  ADD PRIMARY KEY (`lc`),
  ADD UNIQUE KEY `lc` (`lc`);

--
-- Indexes for table `nurse`
--
ALTER TABLE `nurse`
  ADD PRIMARY KEY (`pid`);

--
-- Indexes for table `patient`
--
ALTER TABLE `patient`
  ADD PRIMARY KEY (`pid`);

--
-- Indexes for table `persons`
--
ALTER TABLE `persons`
  ADD PRIMARY KEY (`pid`),
  ADD UNIQUE KEY `pid` (`pid`);

--
-- Indexes for table `pre_exam`
--
ALTER TABLE `pre_exam`
  ADD PRIMARY KEY (`peid`);

--
-- Indexes for table `requests`
--
ALTER TABLE `requests`
  ADD PRIMARY KEY (`rqid`),
  ADD UNIQUE KEY `rqid` (`rqid`),
  ADD KEY `lid` (`lid`);

--
-- Indexes for table `transfusion`
--
ALTER TABLE `transfusion`
  ADD PRIMARY KEY (`tid`),
  ADD KEY `nurse_id_fk` (`nurse`),
  ADD KEY `pid` (`pid`),
  ADD KEY `peid` (`peid`);

--
-- Indexes for table `transfusion_records`
--
ALTER TABLE `transfusion_records`
  ADD PRIMARY KEY (`tid`),
  ADD KEY `lid` (`lid`),
  ADD KEY `bbid` (`bbid`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `donation`
--
ALTER TABLE `donation`
  ADD CONSTRAINT `nurse_id` FOREIGN KEY (`nurse`) REFERENCES `nurse` (`pid`),
  ADD CONSTRAINT `p_id_fk` FOREIGN KEY (`pid`) REFERENCES `donor` (`pid`),
  ADD CONSTRAINT `pe_id_fk` FOREIGN KEY (`peid`) REFERENCES `pre_exam` (`peid`);

--
-- Constraints for table `donation_records`
--
ALTER TABLE `donation_records`
  ADD CONSTRAINT `bb_id_fk` FOREIGN KEY (`bbid`) REFERENCES `bloodbags` (`bbid`),
  ADD CONSTRAINT `did_fk` FOREIGN KEY (`did`) REFERENCES `donation` (`did`),
  ADD CONSTRAINT `l_fk` FOREIGN KEY (`lid`) REFERENCES `locations` (`lid`);

--
-- Constraints for table `donor`
--
ALTER TABLE `donor`
  ADD CONSTRAINT `donor_id_fk` FOREIGN KEY (`pid`) REFERENCES `persons` (`pid`);

--
-- Constraints for table `global_inventory`
--
ALTER TABLE `global_inventory`
  ADD CONSTRAINT `bbid_fk` FOREIGN KEY (`bbid`) REFERENCES `bloodbags` (`bbid`),
  ADD CONSTRAINT `l_id_fk` FOREIGN KEY (`lid`) REFERENCES `locations` (`lid`);

--
-- Constraints for table `locations`
--
ALTER TABLE `locations`
  ADD CONSTRAINT `lc_fk` FOREIGN KEY (`lc`) REFERENCES `location_codes` (`lc`);

--
-- Constraints for table `nurse`
--
ALTER TABLE `nurse`
  ADD CONSTRAINT `nurse_fk` FOREIGN KEY (`pid`) REFERENCES `persons` (`pid`);

--
-- Constraints for table `patient`
--
ALTER TABLE `patient`
  ADD CONSTRAINT `patient_fk` FOREIGN KEY (`pid`) REFERENCES `persons` (`pid`);

--
-- Constraints for table `requests`
--
ALTER TABLE `requests`
  ADD CONSTRAINT `requests_ibfk_1` FOREIGN KEY (`lid`) REFERENCES `locations` (`lid`);

--
-- Constraints for table `transfusion`
--
ALTER TABLE `transfusion`
  ADD CONSTRAINT `nurse_id_fk` FOREIGN KEY (`nurse`) REFERENCES `nurse` (`pid`),
  ADD CONSTRAINT `transfusion_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `patient` (`pid`),
  ADD CONSTRAINT `transfusion_ibfk_2` FOREIGN KEY (`peid`) REFERENCES `pre_exam` (`peid`);

--
-- Constraints for table `transfusion_records`
--
ALTER TABLE `transfusion_records`
  ADD CONSTRAINT `transfusion_records_ibfk_1` FOREIGN KEY (`tid`) REFERENCES `transfusion` (`tid`),
  ADD CONSTRAINT `transfusion_records_ibfk_2` FOREIGN KEY (`lid`) REFERENCES `locations` (`lid`),
  ADD CONSTRAINT `transfusion_records_ibfk_3` FOREIGN KEY (`bbid`) REFERENCES `bloodbags` (`bbid`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
