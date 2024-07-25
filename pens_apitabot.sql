-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 25, 2024 at 07:16 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pens/apitabot`
--

-- --------------------------------------------------------

--
-- Table structure for table `jadwal_pakan`
--

CREATE TABLE `jadwal_pakan` (
  `id` int(255) NOT NULL,
  `hari` int(255) NOT NULL DEFAULT 1,
  `jam` int(255) NOT NULL DEFAULT 0,
  `menit` int(255) NOT NULL DEFAULT 0,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `manual`
--

CREATE TABLE `manual` (
  `id` int(255) NOT NULL,
  `mode` varchar(255) NOT NULL,
  `is_run` int(255) NOT NULL,
  `timestamp` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `monitoring`
--

CREATE TABLE `monitoring` (
  `id` int(255) NOT NULL,
  `kelembapan_udara` int(255) NOT NULL,
  `kualitas_air` int(255) NOT NULL,
  `ph_air` int(255) NOT NULL,
  `suhu_air` int(255) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `jadwal_pakan`
--
ALTER TABLE `jadwal_pakan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `manual`
--
ALTER TABLE `manual`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `monitoring`
--
ALTER TABLE `monitoring`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `jadwal_pakan`
--
ALTER TABLE `jadwal_pakan`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `manual`
--
ALTER TABLE `manual`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `monitoring`
--
ALTER TABLE `monitoring`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
