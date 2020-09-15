-- phpMyAdmin SQL Dump
-- version 4.9.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Sep 14, 2020 at 09:41 PM
-- Server version: 5.6.49-cll-lve
-- PHP Version: 7.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `EF_Applicant`
--

-- --------------------------------------------------------

--
-- Table structure for table `file_list`
--

CREATE TABLE `file_list` (
  `No` int(20) NOT NULL,
  `File_name` text NOT NULL,
  `Path` text NOT NULL,
  `URL` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `file_list`
--

INSERT INTO `file_list` (`No`, `File_name`, `Path`, `URL`) VALUES
(1, '', 'F:Xampphtdocs	estLive tableDynamic-Database-With-bulk-mailupload_file/2220490481555590627-512.png', 'http://localhost/test/Live table/Dynamic-Database-With-bulk-mail/upload_file/2220490481555590627-512.png'),
(3, 'eco_farms.sql', 'F:Xampphtdocs	estLive tableDynamic-Database-With-bulk-mailupload_file/eco_farms.sql', 'http://localhost/test/Live table/Dynamic-Database-With-bulk-mail/upload_file/eco_farms.sql'),
(4, '2-Contemporary-Living-Room-Top-Decorator-Best-Interior-Designers-Boston-South-End-Back-Bay-Seaport-Dane-Austin-Design.jpg', '/home/eiewranb8upx/public_html/client/upload_file/2-Contemporary-Living-Room-Top-Decorator-Best-Interior-Designers-Boston-South-End-Back-Bay-Seaport-Dane-Austin-Design.jpg', 'http://client.paxzonebd.com/upload_file/2-Contemporary-Living-Room-Top-Decorator-Best-Interior-Designers-Boston-South-End-Back-Bay-Seaport-Dane-Austin-Design.jpg'),
(5, 'unnamed.jpg', '/home/eiewranb8upx/public_html/client/upload_file/unnamed.jpg', 'http://client.paxzonebd.com/upload_file/unnamed.jpg'),
(6, 'delivery man circular.docx', '/home/eiewranb8upx/public_html/client/upload_file/delivery man circular.docx', 'http://client.paxzonebd.com/upload_file/delivery man circular.docx'),
(7, 'Paxzone Brochure.pdf', '/home/eiewranb8upx/public_html/client/upload_file/Paxzone Brochure.pdf', 'http://client.paxzonebd.com/upload_file/Paxzone Brochure.pdf'),
(8, 'Snowtex.docx', '/home/eiewranb8upx/public_html/test/upload_file/Snowtex.docx', 'http://ecofarmsbd.com/test/upload_file/Snowtex.docx'),
(9, 'Laravel restful api.txt', '/home/eiewranb8upx/public_html/test/upload_file/Laravel restful api.txt', 'http://ecofarmsbd.com/test/upload_file/Laravel restful api.txt'),
(10, 'Hazaribag  Bill - 21.07.2020.doc', '/home/eiewranb8upx/public_html/test/upload_file/Hazaribag  Bill - 21.07.2020.doc', 'http://ecofarmsbd.com/test/upload_file/Hazaribag  Bill - 21.07.2020.doc'),
(11, '2-Contemporary-Living-Room-Top-Decorator-Best-Interior-Designers-Boston-South-End-Back-Bay-Seaport-Dane-Austin-Design.jpg', '/home/eiewranb8upx/public_html/test/upload_file/2-Contemporary-Living-Room-Top-Decorator-Best-Interior-Designers-Boston-South-End-Back-Bay-Seaport-Dane-Austin-Design.jpg', 'http://ecofarmsbd.com/test/upload_file/2-Contemporary-Living-Room-Top-Decorator-Best-Interior-Designers-Boston-South-End-Back-Bay-Seaport-Dane-Austin-Design.jpg'),
(12, 'company all information 29.08.2020.xlsx', '/home/eiewranb8upx/public_html/test/upload_file/company all information 29.08.2020.xlsx', 'http://ecofarmsbd.com/test/upload_file/company all information 29.08.2020.xlsx'),
(13, 'pax 1.svg', '/home/eiewranb8upx/public_html/test/upload_file/pax 1.svg', 'http://ecofarmsbd.com/test/upload_file/pax 1.svg'),
(14, 'pax 2.svg', '/home/eiewranb8upx/public_html/test/upload_file/pax 2.svg', 'http://ecofarmsbd.com/test/upload_file/pax 2.svg'),
(15, 'Paxzone Brochure.pdf', '/home/eiewranb8upx/public_html/test/upload_file/Paxzone Brochure.pdf', 'http://ecofarmsbd.com/test/upload_file/Paxzone%20Brochure.pdf');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `file_list`
--
ALTER TABLE `file_list`
  ADD PRIMARY KEY (`No`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `file_list`
--
ALTER TABLE `file_list`
  MODIFY `No` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
