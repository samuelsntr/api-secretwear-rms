-- phpMyAdmin SQL Dump
-- version 5.1.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 15, 2025 at 12:16 PM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 7.4.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `secret_wear`
--

-- --------------------------------------------------------

--
-- Table structure for table `barangs`
--

CREATE TABLE `barangs` (
  `id` int(11) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `sku` varchar(255) NOT NULL,
  `barcode` varchar(255) DEFAULT NULL,
  `kategoriId` int(11) NOT NULL,
  `warnaId` int(11) DEFAULT NULL,
  `ukuranId` int(11) DEFAULT NULL,
  `stok` int(11) NOT NULL DEFAULT 0,
  `harga_beli` decimal(15,2) NOT NULL,
  `harga_jual` decimal(15,2) NOT NULL,
  `gambar` varchar(255) DEFAULT NULL,
  `deskripsi` text DEFAULT NULL,
  `is_aktif` tinyint(1) DEFAULT 1,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `barangs`
--

INSERT INTO `barangs` (`id`, `nama`, `sku`, `barcode`, `kategoriId`, `warnaId`, `ukuranId`, `stok`, `harga_beli`, `harga_jual`, `gambar`, `deskripsi`, `is_aktif`, `createdAt`, `updatedAt`) VALUES
(1, 'Uniqlo', 'TSH-WHT-S-1001', '', 1, 5, 3, 0, '25000.00', '30000.00', '', '', 1, '2025-07-01 09:30:53', '2025-07-01 09:30:53'),
(2, 'Zara', 'TSH-WHT-S-1002', '', 2, 4, 3, 0, '30000.00', '35000.00', '', '', 1, '2025-07-01 09:31:21', '2025-07-01 09:31:21'),
(3, 'Ralp', 'TSH-WHT-S-1003', '', 3, 1, 2, 0, '49000.00', '55000.00', '', '', 1, '2025-07-01 09:32:11', '2025-07-14 09:45:32'),
(5, 'Storm', 'TSH-WHT-S-1004', '', 3, 6, 2, 0, '60000.00', '85000.00', '', '', 1, '2025-07-01 09:32:45', '2025-07-09 13:23:16'),
(6, 'Showw', 'TSH-WHT-S-1006', '', 3, 7, 4, 0, '54000.00', '80000.00', '', '', 1, '2025-07-01 11:04:52', '2025-07-09 13:38:04'),
(8, 'Slowboy', 'TSH-WHT-S-1009', '', 2, 6, 3, 0, '46000.00', '55000.00', '', '', 1, '2025-07-11 06:28:18', '2025-07-14 09:45:32');

-- --------------------------------------------------------

--
-- Table structure for table `companies`
--

CREATE TABLE `companies` (
  `id` int(11) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `alamat` text NOT NULL,
  `phone` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `companies`
--

INSERT INTO `companies` (`id`, `nama`, `alamat`, `phone`, `email`, `createdAt`, `updatedAt`) VALUES
(1, 'Secret Wear', 'Jl, Teuku Umar Barat No 88', '089564552189', 'secretwear@gmail.com', '2025-07-02 10:36:45', '2025-07-14 07:11:05');

-- --------------------------------------------------------

--
-- Table structure for table `expenses`
--

CREATE TABLE `expenses` (
  `id` int(11) NOT NULL,
  `date` date NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `category` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `expenses`
--

INSERT INTO `expenses` (`id`, `date`, `amount`, `category`, `description`, `createdAt`, `updatedAt`) VALUES
(1, '2025-07-08', '5000000.00', 'Listrik', '', '2025-07-15 07:38:19', '2025-07-15 08:24:33'),
(2, '2025-07-09', '10000000.00', 'Sewa', 'nice', '2025-07-15 08:01:38', '2025-07-15 08:24:26'),
(3, '2025-07-08', '1000000.00', 'Air', '', '2025-07-15 08:11:41', '2025-07-15 08:24:20');

-- --------------------------------------------------------

--
-- Table structure for table `good_receipts`
--

CREATE TABLE `good_receipts` (
  `id` int(11) NOT NULL,
  `kode` varchar(255) NOT NULL,
  `tanggal` date DEFAULT NULL,
  `purchaseOrderId` int(11) DEFAULT NULL,
  `catatan` text DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `status` enum('outstanding','closed') DEFAULT 'outstanding'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `good_receipts`
--

INSERT INTO `good_receipts` (`id`, `kode`, `tanggal`, `purchaseOrderId`, `catatan`, `createdAt`, `updatedAt`, `status`) VALUES
(1, 'GR-20250701-001', '2025-07-03', 1, 'Nicee', '2025-07-01 09:48:07', '2025-07-01 09:48:07', 'outstanding'),
(2, 'GR-20250701-002', '2025-07-01', 3, 'Nicee semua', '2025-07-01 11:27:12', '2025-07-01 11:27:12', 'outstanding'),
(3, 'GR-20250701-003', '2025-07-01', 4, '', '2025-07-01 11:40:34', '2025-07-01 11:40:34', 'outstanding'),
(4, 'GR-20250701-004', '2025-07-01', 5, '', '2025-07-01 11:57:12', '2025-07-01 11:57:12', 'outstanding'),
(5, 'GR-20250701-005', '2025-07-01', 6, '', '2025-07-01 11:59:29', '2025-07-01 11:59:29', 'outstanding'),
(6, 'GR-20250701-006', '2025-07-01', 7, '', '2025-07-01 12:15:30', '2025-07-01 12:15:30', 'outstanding'),
(7, 'GR-20250701-007', '2025-07-01', 7, '', '2025-07-01 12:17:37', '2025-07-01 12:17:37', 'closed'),
(8, 'GR-20250703-001', '2025-07-03', 9, '', '2025-07-03 13:49:02', '2025-07-03 13:49:02', 'closed'),
(10, 'GR-20250708-001', '2025-07-08', 11, '', '2025-07-08 13:39:21', '2025-07-08 13:39:21', 'closed'),
(11, 'GR-20250709-001', '2025-07-09', 12, '', '2025-07-09 13:38:04', '2025-07-09 13:38:04', 'closed'),
(12, 'GR-20250711-001', '2025-07-11', 13, '', '2025-07-11 06:32:36', '2025-07-11 06:32:36', 'closed'),
(13, 'GR-20250714-001', '2025-07-14', 14, '', '2025-07-14 09:45:32', '2025-07-14 09:45:32', 'closed');

-- --------------------------------------------------------

--
-- Table structure for table `good_receipt_items`
--

CREATE TABLE `good_receipt_items` (
  `id` int(11) NOT NULL,
  `goodReceiptId` int(11) DEFAULT NULL,
  `barangId` int(11) DEFAULT NULL,
  `qty_diterima` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `good_receipt_items`
--

INSERT INTO `good_receipt_items` (`id`, `goodReceiptId`, `barangId`, `qty_diterima`, `createdAt`, `updatedAt`) VALUES
(1, 1, 5, 100, '2025-07-01 09:48:07', '2025-07-01 09:48:07'),
(2, 1, 3, 150, '2025-07-01 09:48:07', '2025-07-01 09:48:07'),
(3, 2, 6, 100, '2025-07-01 11:27:12', '2025-07-01 11:27:12'),
(4, 3, 6, 20, '2025-07-01 11:40:34', '2025-07-01 11:40:34'),
(5, 4, 6, 50, '2025-07-01 11:57:12', '2025-07-01 11:57:12'),
(6, 5, 6, 10, '2025-07-01 11:59:29', '2025-07-01 11:59:29'),
(7, 6, 6, 10, '2025-07-01 12:15:30', '2025-07-01 12:15:30'),
(8, 7, 6, 10, '2025-07-01 12:17:37', '2025-07-01 12:17:37'),
(9, 8, 6, 2, '2025-07-03 13:49:02', '2025-07-03 13:49:02'),
(10, 10, 6, 3, '2025-07-08 13:39:21', '2025-07-08 13:39:21'),
(11, 10, 5, 2, '2025-07-08 13:39:21', '2025-07-08 13:39:21'),
(12, 11, 6, 10, '2025-07-09 13:38:04', '2025-07-09 13:38:04'),
(13, 12, 8, 100, '2025-07-11 06:32:36', '2025-07-11 06:32:36'),
(14, 13, 8, 100, '2025-07-14 09:45:32', '2025-07-14 09:45:32'),
(15, 13, 3, 52, '2025-07-14 09:45:32', '2025-07-14 09:45:32');

-- --------------------------------------------------------

--
-- Table structure for table `kategoris`
--

CREATE TABLE `kategoris` (
  `id` int(11) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `kategoris`
--

INSERT INTO `kategoris` (`id`, `nama`, `createdAt`, `updatedAt`) VALUES
(1, 'Outer', '2025-07-01 09:28:01', '2025-07-01 09:28:01'),
(2, 'Jacket', '2025-07-01 09:28:05', '2025-07-01 09:28:05'),
(3, 'Pants', '2025-07-01 09:28:18', '2025-07-01 09:28:18'),
(4, 'Underwear', '2025-07-01 09:28:27', '2025-07-01 09:28:27');

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE `logs` (
  `id` int(11) NOT NULL,
  `userId` int(11) DEFAULT NULL,
  `action` varchar(255) NOT NULL,
  `module` varchar(255) NOT NULL,
  `level` enum('info','warning','error','success') DEFAULT 'info',
  `description` text NOT NULL,
  `details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`details`)),
  `ipAddress` varchar(255) DEFAULT NULL,
  `userAgent` text DEFAULT NULL,
  `resourceType` varchar(255) DEFAULT NULL,
  `resourceId` int(11) DEFAULT NULL,
  `oldValues` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`oldValues`)),
  `newValues` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`newValues`)),
  `sessionId` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `logs`
--

INSERT INTO `logs` (`id`, `userId`, `action`, `module`, `level`, `description`, `details`, `ipAddress`, `userAgent`, `resourceType`, `resourceId`, `oldValues`, `newValues`, `sessionId`, `createdAt`, `updatedAt`) VALUES
(41689, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'DELETE /api/logs - 200 (101ms)', '{\"statusCode\":200,\"duration\":101,\"requestData\":{\"method\":\"DELETE\",\"url\":\"/api/logs\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 09:18:59', '2025-07-15 09:18:59'),
(41690, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/logs?page=1&limit=50', '{\"method\":\"GET\",\"url\":\"/api/logs?page=1&limit=50\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 09:18:59', '2025-07-15 09:18:59'),
(41691, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/logs/stats', '{\"method\":\"GET\",\"url\":\"/api/logs/stats\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 09:18:59', '2025-07-15 09:18:59'),
(41692, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/logs?page=1&limit=50 - 200 (5ms)', '{\"statusCode\":200,\"duration\":5,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/logs?page=1&limit=50\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 09:18:59', '2025-07-15 09:18:59'),
(41693, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/logs/stats - 200 (4ms)', '{\"statusCode\":200,\"duration\":4,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/logs/stats\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 09:18:59', '2025-07-15 09:18:59'),
(41694, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/laporan/dashboard-summary?period=month', '{\"method\":\"GET\",\"url\":\"/api/laporan/dashboard-summary?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:44', '2025-07-15 10:14:44'),
(41695, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/laporan/dashboard-summary?period=month - 304 (113ms)', '{\"statusCode\":304,\"duration\":113,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/laporan/dashboard-summary?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:45', '2025-07-15 10:14:45'),
(41696, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/laporan/dashboard-summary?period=month', '{\"method\":\"GET\",\"url\":\"/api/laporan/dashboard-summary?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:45', '2025-07-15 10:14:45'),
(41697, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/laporan/dashboard-summary?period=month - 304 (20ms)', '{\"statusCode\":304,\"duration\":20,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/laporan/dashboard-summary?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:45', '2025-07-15 10:14:45'),
(41698, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/laporan/dashboard-summary?period=month', '{\"method\":\"GET\",\"url\":\"/api/laporan/dashboard-summary?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:48', '2025-07-15 10:14:48'),
(41699, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/laporan/dashboard-summary?period=month - 304 (20ms)', '{\"statusCode\":304,\"duration\":20,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/laporan/dashboard-summary?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:48', '2025-07-15 10:14:48'),
(41700, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/laporan/dashboard-summary?period=month', '{\"method\":\"GET\",\"url\":\"/api/laporan/dashboard-summary?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:48', '2025-07-15 10:14:48'),
(41701, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/laporan/dashboard-summary?period=month - 304 (20ms)', '{\"statusCode\":304,\"duration\":20,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/laporan/dashboard-summary?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:48', '2025-07-15 10:14:48'),
(41702, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/kategori?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/kategori?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:50', '2025-07-15 10:14:50'),
(41703, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/laporan/sales?period=month', '{\"method\":\"GET\",\"url\":\"/api/laporan/sales?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:50', '2025-07-15 10:14:50'),
(41704, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stores?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/stores?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:50', '2025-07-15 10:14:50'),
(41705, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stores?limit=1000 - 304 (8ms)', '{\"statusCode\":304,\"duration\":8,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stores?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:50', '2025-07-15 10:14:50'),
(41706, NULL, 'REPORT_ACCESS', 'REPORTS', 'info', 'Accessed SALES report', '{\"reportType\":\"SALES\",\"filters\":{\"period\":\"month\"}}', '::1', NULL, NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:50', '2025-07-15 10:14:50'),
(41707, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/kategori?limit=1000 - 304 (7ms)', '{\"statusCode\":304,\"duration\":7,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/kategori?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:50', '2025-07-15 10:14:50'),
(41708, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/laporan/sales?period=month - 304 (10ms)', '{\"statusCode\":304,\"duration\":10,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/laporan/sales?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:50', '2025-07-15 10:14:50'),
(41709, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/kategori?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/kategori?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:50', '2025-07-15 10:14:50'),
(41710, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/kategori?limit=1000 - 304 (5ms)', '{\"statusCode\":304,\"duration\":5,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/kategori?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:50', '2025-07-15 10:14:50'),
(41711, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stores?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/stores?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:50', '2025-07-15 10:14:50'),
(41712, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stores?limit=1000 - 304 (5ms)', '{\"statusCode\":304,\"duration\":5,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stores?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:50', '2025-07-15 10:14:50'),
(41713, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/laporan/sales?period=month', '{\"method\":\"GET\",\"url\":\"/api/laporan/sales?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:50', '2025-07-15 10:14:50'),
(41714, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/laporan/sales?period=month - 304 (64ms)', '{\"statusCode\":304,\"duration\":64,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/laporan/sales?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:50', '2025-07-15 10:14:50'),
(41715, NULL, 'REPORT_ACCESS', 'REPORTS', 'info', 'Accessed SALES report', '{\"reportType\":\"SALES\",\"filters\":{\"period\":\"month\"}}', '::1', NULL, NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:50', '2025-07-15 10:14:50'),
(41716, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/laporan/dashboard-summary?period=month', '{\"method\":\"GET\",\"url\":\"/api/laporan/dashboard-summary?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:50', '2025-07-15 10:14:50'),
(41717, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/laporan/dashboard-summary?period=month - 304 (20ms)', '{\"statusCode\":304,\"duration\":20,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/laporan/dashboard-summary?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:50', '2025-07-15 10:14:50'),
(41718, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/laporan/dashboard-summary?period=month', '{\"method\":\"GET\",\"url\":\"/api/laporan/dashboard-summary?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:50', '2025-07-15 10:14:50'),
(41719, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/laporan/dashboard-summary?period=month - 304 (21ms)', '{\"statusCode\":304,\"duration\":21,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/laporan/dashboard-summary?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:50', '2025-07-15 10:14:50'),
(41720, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stores?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/stores?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:51', '2025-07-15 10:14:51'),
(41721, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/kategori?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/kategori?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:51', '2025-07-15 10:14:51'),
(41722, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/laporan/sales?period=month', '{\"method\":\"GET\",\"url\":\"/api/laporan/sales?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:51', '2025-07-15 10:14:51'),
(41723, NULL, 'REPORT_ACCESS', 'REPORTS', 'info', 'Accessed SALES report', '{\"reportType\":\"SALES\",\"filters\":{\"period\":\"month\"}}', '::1', NULL, NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:51', '2025-07-15 10:14:51'),
(41724, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/kategori?limit=1000 - 304 (4ms)', '{\"statusCode\":304,\"duration\":4,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/kategori?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:51', '2025-07-15 10:14:51'),
(41725, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stores?limit=1000 - 304 (9ms)', '{\"statusCode\":304,\"duration\":9,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stores?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:51', '2025-07-15 10:14:51'),
(41726, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/laporan/sales?period=month - 304 (10ms)', '{\"statusCode\":304,\"duration\":10,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/laporan/sales?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:51', '2025-07-15 10:14:51'),
(41727, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/kategori?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/kategori?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:51', '2025-07-15 10:14:51'),
(41728, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stores?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/stores?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:51', '2025-07-15 10:14:51'),
(41729, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/kategori?limit=1000 - 304 (2ms)', '{\"statusCode\":304,\"duration\":2,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/kategori?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:51', '2025-07-15 10:14:51'),
(41730, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stores?limit=1000 - 304 (73ms)', '{\"statusCode\":304,\"duration\":73,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stores?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:51', '2025-07-15 10:14:51'),
(41731, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/laporan/sales?period=month', '{\"method\":\"GET\",\"url\":\"/api/laporan/sales?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:51', '2025-07-15 10:14:51'),
(41732, NULL, 'REPORT_ACCESS', 'REPORTS', 'info', 'Accessed SALES report', '{\"reportType\":\"SALES\",\"filters\":{\"period\":\"month\"}}', '::1', NULL, NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:51', '2025-07-15 10:14:51'),
(41733, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/laporan/sales?period=month - 304 (119ms)', '{\"statusCode\":304,\"duration\":119,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/laporan/sales?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:51', '2025-07-15 10:14:51'),
(41734, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stores?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/stores?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:51', '2025-07-15 10:14:51'),
(41735, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/kategori?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/kategori?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:51', '2025-07-15 10:14:51'),
(41736, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/laporan/inventory?', '{\"method\":\"GET\",\"url\":\"/api/laporan/inventory?\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:51', '2025-07-15 10:14:51'),
(41737, NULL, 'REPORT_ACCESS', 'REPORTS', 'info', 'Accessed INVENTORY report', '{\"reportType\":\"INVENTORY\",\"filters\":{}}', '::1', NULL, NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:51', '2025-07-15 10:14:51'),
(41738, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stores?limit=1000 - 304 (6ms)', '{\"statusCode\":304,\"duration\":6,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stores?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:51', '2025-07-15 10:14:51'),
(41739, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/kategori?limit=1000 - 304 (5ms)', '{\"statusCode\":304,\"duration\":5,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/kategori?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:51', '2025-07-15 10:14:51'),
(41740, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/laporan/inventory? - 304 (68ms)', '{\"statusCode\":304,\"duration\":68,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/laporan/inventory?\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:51', '2025-07-15 10:14:51'),
(41741, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stores?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/stores?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:52', '2025-07-15 10:14:52'),
(41742, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stores?limit=1000 - 304 (3ms)', '{\"statusCode\":304,\"duration\":3,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stores?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:52', '2025-07-15 10:14:52'),
(41743, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/kategori?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/kategori?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:52', '2025-07-15 10:14:52'),
(41744, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/kategori?limit=1000 - 304 (179ms)', '{\"statusCode\":304,\"duration\":179,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/kategori?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:52', '2025-07-15 10:14:52'),
(41745, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/laporan/inventory?', '{\"method\":\"GET\",\"url\":\"/api/laporan/inventory?\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:52', '2025-07-15 10:14:52'),
(41746, NULL, 'REPORT_ACCESS', 'REPORTS', 'info', 'Accessed INVENTORY report', '{\"reportType\":\"INVENTORY\",\"filters\":{}}', '::1', NULL, NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:52', '2025-07-15 10:14:52'),
(41747, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/laporan/inventory? - 304 (126ms)', '{\"statusCode\":304,\"duration\":126,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/laporan/inventory?\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:52', '2025-07-15 10:14:52'),
(41748, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/supplier?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/supplier?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:52', '2025-07-15 10:14:52'),
(41749, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/kategori?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/kategori?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:52', '2025-07-15 10:14:52'),
(41750, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/laporan/purchase?period=month', '{\"method\":\"GET\",\"url\":\"/api/laporan/purchase?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:52', '2025-07-15 10:14:52'),
(41751, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/supplier?limit=1000 - 304 (3ms)', '{\"statusCode\":304,\"duration\":3,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/supplier?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:52', '2025-07-15 10:14:52'),
(41752, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/kategori?limit=1000 - 304 (3ms)', '{\"statusCode\":304,\"duration\":3,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/kategori?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:52', '2025-07-15 10:14:52'),
(41753, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/laporan/purchase?period=month - 304 (161ms)', '{\"statusCode\":304,\"duration\":161,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/laporan/purchase?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:52', '2025-07-15 10:14:52'),
(41754, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/supplier?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/supplier?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:52', '2025-07-15 10:14:52'),
(41755, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/supplier?limit=1000 - 304 (2ms)', '{\"statusCode\":304,\"duration\":2,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/supplier?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:52', '2025-07-15 10:14:52'),
(41756, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/kategori?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/kategori?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:52', '2025-07-15 10:14:52'),
(41757, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/laporan/purchase?period=month', '{\"method\":\"GET\",\"url\":\"/api/laporan/purchase?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:52', '2025-07-15 10:14:52'),
(41758, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/kategori?limit=1000 - 304 (68ms)', '{\"statusCode\":304,\"duration\":68,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/kategori?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:52', '2025-07-15 10:14:52'),
(41759, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/laporan/purchase?period=month - 304 (75ms)', '{\"statusCode\":304,\"duration\":75,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/laporan/purchase?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:52', '2025-07-15 10:14:52'),
(41760, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/laporan/financial?period=month', '{\"method\":\"GET\",\"url\":\"/api/laporan/financial?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:52', '2025-07-15 10:14:52'),
(41761, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/laporan/financial?period=month - 304 (119ms)', '{\"statusCode\":304,\"duration\":119,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/laporan/financial?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:52', '2025-07-15 10:14:52'),
(41762, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/laporan/financial?period=month', '{\"method\":\"GET\",\"url\":\"/api/laporan/financial?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:53', '2025-07-15 10:14:53'),
(41763, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/laporan/financial?period=month - 304 (10ms)', '{\"statusCode\":304,\"duration\":10,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/laporan/financial?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:53', '2025-07-15 10:14:53'),
(41764, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/kategori?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/kategori?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:54', '2025-07-15 10:14:54'),
(41765, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/laporan/product-performance?period=month', '{\"method\":\"GET\",\"url\":\"/api/laporan/product-performance?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:54', '2025-07-15 10:14:54'),
(41766, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/kategori?limit=1000 - 304 (4ms)', '{\"statusCode\":304,\"duration\":4,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/kategori?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:54', '2025-07-15 10:14:54'),
(41767, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/laporan/product-performance?period=month - 304 (5ms)', '{\"statusCode\":304,\"duration\":5,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/laporan/product-performance?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:54', '2025-07-15 10:14:54'),
(41768, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/laporan/product-performance?period=month', '{\"method\":\"GET\",\"url\":\"/api/laporan/product-performance?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:54', '2025-07-15 10:14:54'),
(41769, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/laporan/product-performance?period=month - 304 (3ms)', '{\"statusCode\":304,\"duration\":3,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/laporan/product-performance?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:54', '2025-07-15 10:14:54'),
(41770, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/kategori?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/kategori?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:54', '2025-07-15 10:14:54'),
(41771, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/kategori?limit=1000 - 304 (2ms)', '{\"statusCode\":304,\"duration\":2,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/kategori?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:54', '2025-07-15 10:14:54'),
(41772, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stores', '{\"method\":\"GET\",\"url\":\"/api/stores\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:54', '2025-07-15 10:14:54'),
(41773, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/laporan/moving-stock?period=month', '{\"method\":\"GET\",\"url\":\"/api/laporan/moving-stock?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:54', '2025-07-15 10:14:54'),
(41774, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stores - 304 (6ms)', '{\"statusCode\":304,\"duration\":6,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stores\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:54', '2025-07-15 10:14:54'),
(41775, NULL, 'REPORT_ACCESS', 'REPORTS', 'info', 'Accessed MOVING_STOCK report', '{\"reportType\":\"MOVING_STOCK\",\"filters\":{\"period\":\"month\"}}', '::1', NULL, NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:54', '2025-07-15 10:14:54'),
(41776, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stores', '{\"method\":\"GET\",\"url\":\"/api/stores\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:54', '2025-07-15 10:14:54'),
(41777, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stores - 304 (1ms)', '{\"statusCode\":304,\"duration\":1,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stores\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:54', '2025-07-15 10:14:54'),
(41778, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/laporan/moving-stock?period=month - 200 (93ms)', '{\"statusCode\":200,\"duration\":93,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/laporan/moving-stock?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:54', '2025-07-15 10:14:54'),
(41779, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/laporan/moving-stock?period=month', '{\"method\":\"GET\",\"url\":\"/api/laporan/moving-stock?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:55', '2025-07-15 10:14:55'),
(41780, NULL, 'REPORT_ACCESS', 'REPORTS', 'info', 'Accessed MOVING_STOCK report', '{\"reportType\":\"MOVING_STOCK\",\"filters\":{\"period\":\"month\"}}', '::1', NULL, NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:55', '2025-07-15 10:14:55'),
(41781, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/laporan/moving-stock?period=month - 304 (69ms)', '{\"statusCode\":304,\"duration\":69,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/laporan/moving-stock?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:55', '2025-07-15 10:14:55'),
(41782, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/payment-methods?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/payment-methods?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:58', '2025-07-15 10:14:58'),
(41783, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/payment-methods?page=1&limit=10&search= - 304 (18ms)', '{\"statusCode\":304,\"duration\":18,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/payment-methods?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:58', '2025-07-15 10:14:58'),
(41784, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/payment-methods?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/payment-methods?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:58', '2025-07-15 10:14:58'),
(41785, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/payment-methods?page=1&limit=10&search= - 304 (1ms)', '{\"statusCode\":304,\"duration\":1,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/payment-methods?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:58', '2025-07-15 10:14:58'),
(41786, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/companies', '{\"method\":\"GET\",\"url\":\"/api/companies\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:58', '2025-07-15 10:14:58'),
(41787, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/companies - 304 (196ms)', '{\"statusCode\":304,\"duration\":196,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/companies\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:59', '2025-07-15 10:14:59');
INSERT INTO `logs` (`id`, `userId`, `action`, `module`, `level`, `description`, `details`, `ipAddress`, `userAgent`, `resourceType`, `resourceId`, `oldValues`, `newValues`, `sessionId`, `createdAt`, `updatedAt`) VALUES
(41788, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/companies', '{\"method\":\"GET\",\"url\":\"/api/companies\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:59', '2025-07-15 10:14:59'),
(41789, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/companies - 304 (1ms)', '{\"statusCode\":304,\"duration\":1,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/companies\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:59', '2025-07-15 10:14:59'),
(41790, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/user', '{\"method\":\"GET\",\"url\":\"/api/user\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:59', '2025-07-15 10:14:59'),
(41791, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/user - 304 (2ms)', '{\"statusCode\":304,\"duration\":2,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/user\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:59', '2025-07-15 10:14:59'),
(41792, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/user', '{\"method\":\"GET\",\"url\":\"/api/user\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:59', '2025-07-15 10:14:59'),
(41793, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/user - 304 (1ms)', '{\"statusCode\":304,\"duration\":1,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/user\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:59', '2025-07-15 10:14:59'),
(41794, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/laporan/dashboard-summary?period=month', '{\"method\":\"GET\",\"url\":\"/api/laporan/dashboard-summary?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:14:59', '2025-07-15 10:14:59'),
(41795, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/laporan/dashboard-summary?period=month - 304 (342ms)', '{\"statusCode\":304,\"duration\":342,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/laporan/dashboard-summary?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:00', '2025-07-15 10:15:00'),
(41796, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/laporan/dashboard-summary?period=month', '{\"method\":\"GET\",\"url\":\"/api/laporan/dashboard-summary?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:00', '2025-07-15 10:15:00'),
(41797, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/laporan/dashboard-summary?period=month - 304 (22ms)', '{\"statusCode\":304,\"duration\":22,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/laporan/dashboard-summary?period=month\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:00', '2025-07-15 10:15:00'),
(41798, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/payment-methods?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/payment-methods?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:00', '2025-07-15 10:15:00'),
(41799, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/payment-methods?page=1&limit=10&search= - 304 (2ms)', '{\"statusCode\":304,\"duration\":2,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/payment-methods?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:00', '2025-07-15 10:15:00'),
(41800, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/payment-methods?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/payment-methods?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:00', '2025-07-15 10:15:00'),
(41801, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/payment-methods?page=1&limit=10&search= - 304 (2ms)', '{\"statusCode\":304,\"duration\":2,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/payment-methods?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:00', '2025-07-15 10:15:00'),
(41802, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/expenses?category=&page=1&limit=10', '{\"method\":\"GET\",\"url\":\"/api/expenses?category=&page=1&limit=10\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:05', '2025-07-15 10:15:05'),
(41803, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/expenses?category=&page=1&limit=10 - 304 (2ms)', '{\"statusCode\":304,\"duration\":2,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/expenses?category=&page=1&limit=10\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:05', '2025-07-15 10:15:05'),
(41804, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/expenses?category=&page=1&limit=10', '{\"method\":\"GET\",\"url\":\"/api/expenses?category=&page=1&limit=10\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:05', '2025-07-15 10:15:05'),
(41805, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/expenses?category=&page=1&limit=10 - 304 (3ms)', '{\"statusCode\":304,\"duration\":3,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/expenses?category=&page=1&limit=10\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:05', '2025-07-15 10:15:05'),
(41806, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/expenses?category=&page=1&limit=10', '{\"method\":\"GET\",\"url\":\"/api/expenses?category=&page=1&limit=10\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:17', '2025-07-15 10:15:17'),
(41807, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/expenses?category=&page=1&limit=10 - 304 (5ms)', '{\"statusCode\":304,\"duration\":5,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/expenses?category=&page=1&limit=10\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:18', '2025-07-15 10:15:18'),
(41808, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stores/active', '{\"method\":\"GET\",\"url\":\"/api/stores/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:19', '2025-07-15 10:15:19'),
(41809, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/barang?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/barang?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:19', '2025-07-15 10:15:19'),
(41810, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/payment-methods/active', '{\"method\":\"GET\",\"url\":\"/api/payment-methods/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:19', '2025-07-15 10:15:19'),
(41811, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stores/active - 304 (5ms)', '{\"statusCode\":304,\"duration\":5,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stores/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:19', '2025-07-15 10:15:19'),
(41812, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/barang?limit=1000 - 304 (7ms)', '{\"statusCode\":304,\"duration\":7,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/barang?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:19', '2025-07-15 10:15:19'),
(41813, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/payment-methods/active - 304 (5ms)', '{\"statusCode\":304,\"duration\":5,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/payment-methods/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:19', '2025-07-15 10:15:19'),
(41814, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/sales?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/sales?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:19', '2025-07-15 10:15:19'),
(41815, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stores/active', '{\"method\":\"GET\",\"url\":\"/api/stores/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41816, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/payment-methods/active', '{\"method\":\"GET\",\"url\":\"/api/payment-methods/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41817, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stores/active - 304 (1ms)', '{\"statusCode\":304,\"duration\":1,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stores/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41818, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/sales?page=1&limit=10&search= - 304 (129ms)', '{\"statusCode\":304,\"duration\":129,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/sales?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41819, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/payment-methods/active - 304 (31ms)', '{\"statusCode\":304,\"duration\":31,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/payment-methods/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41820, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/barang?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/barang?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41821, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-gudang-toko?storeId=3&limit=1000', '{\"method\":\"GET\",\"url\":\"/api/stock-gudang-toko?storeId=3&limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41822, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/barang?limit=1000 - 304 (9ms)', '{\"statusCode\":304,\"duration\":9,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/barang?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41823, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-gudang-toko?storeId=3&limit=1000 - 304 (34ms)', '{\"statusCode\":304,\"duration\":34,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-gudang-toko?storeId=3&limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41824, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/payment-methods/active', '{\"method\":\"GET\",\"url\":\"/api/payment-methods/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41825, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/sales?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/sales?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41826, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stores/active', '{\"method\":\"GET\",\"url\":\"/api/stores/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41827, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/payment-methods/active - 304 (84ms)', '{\"statusCode\":304,\"duration\":84,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/payment-methods/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41828, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stores/active - 304 (31ms)', '{\"statusCode\":304,\"duration\":31,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stores/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41829, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/sales?page=1&limit=10&search= - 304 (69ms)', '{\"statusCode\":304,\"duration\":69,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/sales?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41830, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/payment-methods/active', '{\"method\":\"GET\",\"url\":\"/api/payment-methods/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41831, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/payment-methods/active - 304 (3ms)', '{\"statusCode\":304,\"duration\":3,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/payment-methods/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41832, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stores/active', '{\"method\":\"GET\",\"url\":\"/api/stores/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41833, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stores/active - 304 (1ms)', '{\"statusCode\":304,\"duration\":1,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stores/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41834, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/sale-returns?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/sale-returns?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41835, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/sale-returns?page=1&limit=10&search= - 304 (93ms)', '{\"statusCode\":304,\"duration\":93,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/sale-returns?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41836, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/sale-returns?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/sale-returns?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41837, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/sale-returns?page=1&limit=10&search= - 304 (66ms)', '{\"statusCode\":304,\"duration\":66,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/sale-returns?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41838, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stores/active', '{\"method\":\"GET\",\"url\":\"/api/stores/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41839, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/barang?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/barang?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41840, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/payment-methods/active', '{\"method\":\"GET\",\"url\":\"/api/payment-methods/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41841, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/sales?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/sales?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41842, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stores/active - 304 (4ms)', '{\"statusCode\":304,\"duration\":4,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stores/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41843, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/barang?limit=1000 - 304 (5ms)', '{\"statusCode\":304,\"duration\":5,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/barang?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41844, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/payment-methods/active - 304 (9ms)', '{\"statusCode\":304,\"duration\":9,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/payment-methods/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41845, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/sales?page=1&limit=10&search= - 304 (133ms)', '{\"statusCode\":304,\"duration\":133,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/sales?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:20', '2025-07-15 10:15:20'),
(41846, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/barang?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/barang?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:21', '2025-07-15 10:15:21'),
(41847, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/payment-methods/active', '{\"method\":\"GET\",\"url\":\"/api/payment-methods/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:21', '2025-07-15 10:15:21'),
(41848, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stores/active', '{\"method\":\"GET\",\"url\":\"/api/stores/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:21', '2025-07-15 10:15:21'),
(41849, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-gudang-toko?storeId=3&limit=1000', '{\"method\":\"GET\",\"url\":\"/api/stock-gudang-toko?storeId=3&limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:21', '2025-07-15 10:15:21'),
(41850, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/payment-methods/active - 304 (6ms)', '{\"statusCode\":304,\"duration\":6,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/payment-methods/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:21', '2025-07-15 10:15:21'),
(41851, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/barang?limit=1000 - 304 (10ms)', '{\"statusCode\":304,\"duration\":10,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/barang?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:21', '2025-07-15 10:15:21'),
(41852, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stores/active - 304 (6ms)', '{\"statusCode\":304,\"duration\":6,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stores/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:21', '2025-07-15 10:15:21'),
(41853, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-gudang-toko?storeId=3&limit=1000 - 304 (52ms)', '{\"statusCode\":304,\"duration\":52,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-gudang-toko?storeId=3&limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:21', '2025-07-15 10:15:21'),
(41854, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/sales?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/sales?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:21', '2025-07-15 10:15:21'),
(41855, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/payment-methods/active', '{\"method\":\"GET\",\"url\":\"/api/payment-methods/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:21', '2025-07-15 10:15:21'),
(41856, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/payment-methods/active - 304 (3ms)', '{\"statusCode\":304,\"duration\":3,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/payment-methods/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:21', '2025-07-15 10:15:21'),
(41857, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stores/active', '{\"method\":\"GET\",\"url\":\"/api/stores/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:21', '2025-07-15 10:15:21'),
(41858, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/sales?page=1&limit=10&search= - 304 (142ms)', '{\"statusCode\":304,\"duration\":142,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/sales?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:21', '2025-07-15 10:15:21'),
(41859, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stores/active - 304 (53ms)', '{\"statusCode\":304,\"duration\":53,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stores/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:21', '2025-07-15 10:15:21'),
(41860, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/payment-methods/active', '{\"method\":\"GET\",\"url\":\"/api/payment-methods/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:21', '2025-07-15 10:15:21'),
(41861, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/payment-methods/active - 304 (2ms)', '{\"statusCode\":304,\"duration\":2,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/payment-methods/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:21', '2025-07-15 10:15:21'),
(41862, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stores/active', '{\"method\":\"GET\",\"url\":\"/api/stores/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:21', '2025-07-15 10:15:21'),
(41863, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stores/active - 304 (2ms)', '{\"statusCode\":304,\"duration\":2,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stores/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:21', '2025-07-15 10:15:21'),
(41864, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/purchase-requests?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/purchase-requests?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:21', '2025-07-15 10:15:21'),
(41865, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/purchase-requests?page=1&limit=10&search= - 304 (214ms)', '{\"statusCode\":304,\"duration\":214,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/purchase-requests?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:22', '2025-07-15 10:15:22'),
(41866, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/purchase-requests?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/purchase-requests?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:22', '2025-07-15 10:15:22'),
(41867, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/purchase-requests?page=1&limit=10&search= - 304 (8ms)', '{\"statusCode\":304,\"duration\":8,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/purchase-requests?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:22', '2025-07-15 10:15:22'),
(41868, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/purchase-orders?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/purchase-orders?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:22', '2025-07-15 10:15:22'),
(41869, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/purchase-orders?page=1&limit=10&search= - 304 (108ms)', '{\"statusCode\":304,\"duration\":108,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/purchase-orders?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:22', '2025-07-15 10:15:22'),
(41870, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/purchase-orders?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/purchase-orders?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:22', '2025-07-15 10:15:22'),
(41871, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/purchase-orders?page=1&limit=10&search= - 304 (28ms)', '{\"statusCode\":304,\"duration\":28,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/purchase-orders?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:22', '2025-07-15 10:15:22'),
(41872, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/purchase-requests', '{\"method\":\"GET\",\"url\":\"/api/purchase-requests\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:22', '2025-07-15 10:15:22'),
(41873, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/purchase-requests - 304 (11ms)', '{\"statusCode\":304,\"duration\":11,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/purchase-requests\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:22', '2025-07-15 10:15:22'),
(41874, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/purchase-requests', '{\"method\":\"GET\",\"url\":\"/api/purchase-requests\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:22', '2025-07-15 10:15:22'),
(41875, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/purchase-requests - 304 (30ms)', '{\"statusCode\":304,\"duration\":30,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/purchase-requests\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:22', '2025-07-15 10:15:22'),
(41876, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/purchase-returns?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/purchase-returns?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:22', '2025-07-15 10:15:22'),
(41877, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/purchase-returns?page=1&limit=10&search= - 304 (186ms)', '{\"statusCode\":304,\"duration\":186,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/purchase-returns?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:23', '2025-07-15 10:15:23'),
(41878, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/purchase-returns?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/purchase-returns?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:23', '2025-07-15 10:15:23'),
(41879, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/purchase-returns?page=1&limit=10&search= - 304 (82ms)', '{\"statusCode\":304,\"duration\":82,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/purchase-returns?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:23', '2025-07-15 10:15:23'),
(41880, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/barang?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/barang?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:23', '2025-07-15 10:15:23'),
(41881, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-gudang-pusat?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/stock-gudang-pusat?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:23', '2025-07-15 10:15:23');
INSERT INTO `logs` (`id`, `userId`, `action`, `module`, `level`, `description`, `details`, `ipAddress`, `userAgent`, `resourceType`, `resourceId`, `oldValues`, `newValues`, `sessionId`, `createdAt`, `updatedAt`) VALUES
(41882, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-gudang-pusat?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/stock-gudang-pusat?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:23', '2025-07-15 10:15:23'),
(41883, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/barang?limit=1000 - 304 (6ms)', '{\"statusCode\":304,\"duration\":6,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/barang?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:23', '2025-07-15 10:15:23'),
(41884, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-gudang-pusat?page=1&limit=10&search= - 304 (31ms)', '{\"statusCode\":304,\"duration\":31,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-gudang-pusat?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:23', '2025-07-15 10:15:23'),
(41885, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-gudang-pusat?limit=1000 - 304 (34ms)', '{\"statusCode\":304,\"duration\":34,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-gudang-pusat?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:23', '2025-07-15 10:15:23'),
(41886, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-gudang-pusat?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/stock-gudang-pusat?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:23', '2025-07-15 10:15:23'),
(41887, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/barang?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/barang?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:23', '2025-07-15 10:15:23'),
(41888, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-gudang-pusat?page=1&limit=10&search= - 304 (5ms)', '{\"statusCode\":304,\"duration\":5,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-gudang-pusat?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:23', '2025-07-15 10:15:23'),
(41889, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/barang?limit=1000 - 304 (4ms)', '{\"statusCode\":304,\"duration\":4,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/barang?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:23', '2025-07-15 10:15:23'),
(41890, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-gudang-pusat?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/stock-gudang-pusat?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:23', '2025-07-15 10:15:23'),
(41891, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-gudang-pusat?limit=1000 - 304 (53ms)', '{\"statusCode\":304,\"duration\":53,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-gudang-pusat?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:23', '2025-07-15 10:15:23'),
(41892, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-gudang-pusat?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/stock-gudang-pusat?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:23', '2025-07-15 10:15:23'),
(41893, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-gudang-pusat?page=1&limit=10&search= - 304 (116ms)', '{\"statusCode\":304,\"duration\":116,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-gudang-pusat?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41894, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stores/active', '{\"method\":\"GET\",\"url\":\"/api/stores/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41895, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/barang?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/barang?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41896, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-gudang-toko?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/stock-gudang-toko?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41897, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-gudang-toko?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/stock-gudang-toko?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41898, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stores/active - 304 (4ms)', '{\"statusCode\":304,\"duration\":4,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stores/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41899, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/barang?limit=1000 - 304 (120ms)', '{\"statusCode\":304,\"duration\":120,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/barang?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41900, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-gudang-toko?limit=1000 - 304 (149ms)', '{\"statusCode\":304,\"duration\":149,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-gudang-toko?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41901, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-gudang-toko?page=1&limit=10&search= - 304 (151ms)', '{\"statusCode\":304,\"duration\":151,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-gudang-toko?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41902, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-gudang-pusat?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/stock-gudang-pusat?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41903, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-gudang-pusat?page=1&limit=10&search= - 304 (102ms)', '{\"statusCode\":304,\"duration\":102,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-gudang-pusat?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41904, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stores/active', '{\"method\":\"GET\",\"url\":\"/api/stores/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41905, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/barang?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/barang?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41906, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-gudang-toko?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/stock-gudang-toko?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41907, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-gudang-toko?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/stock-gudang-toko?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41908, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stores/active - 304 (68ms)', '{\"statusCode\":304,\"duration\":68,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stores/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41909, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-gudang-toko?limit=1000 - 304 (72ms)', '{\"statusCode\":304,\"duration\":72,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-gudang-toko?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41910, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/barang?limit=1000 - 304 (71ms)', '{\"statusCode\":304,\"duration\":71,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/barang?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41911, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-requests?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/stock-requests?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41912, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-gudang-toko?page=1&limit=10&search= - 304 (60ms)', '{\"statusCode\":304,\"duration\":60,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-gudang-toko?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41913, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-gudang-pusat?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/stock-gudang-pusat?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41914, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-requests?page=1&limit=10&search= - 304 (102ms)', '{\"statusCode\":304,\"duration\":102,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-requests?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41915, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-gudang-pusat?page=1&limit=10&search= - 304 (69ms)', '{\"statusCode\":304,\"duration\":69,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-gudang-pusat?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41916, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stores/active', '{\"method\":\"GET\",\"url\":\"/api/stores/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41917, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/barang?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/barang?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41918, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stores/active - 304 (31ms)', '{\"statusCode\":304,\"duration\":31,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stores/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41919, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/barang?limit=1000 - 304 (93ms)', '{\"statusCode\":304,\"duration\":93,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/barang?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41920, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-gudang-toko?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/stock-gudang-toko?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41921, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-requests?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/stock-requests?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41922, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-gudang-pusat?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/stock-gudang-pusat?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41923, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-transfers?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/stock-transfers?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41924, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-gudang-toko?page=1&limit=10&search= - 304 (38ms)', '{\"statusCode\":304,\"duration\":38,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-gudang-toko?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41925, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-requests?page=1&limit=10&search= - 304 (40ms)', '{\"statusCode\":304,\"duration\":40,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-requests?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41926, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-gudang-pusat?page=1&limit=10&search= - 304 (82ms)', '{\"statusCode\":304,\"duration\":82,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-gudang-pusat?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41927, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stores/active', '{\"method\":\"GET\",\"url\":\"/api/stores/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41928, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/barang?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/barang?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41929, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-transfers?page=1&limit=10&search= - 304 (117ms)', '{\"statusCode\":304,\"duration\":117,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-transfers?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41930, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stores/active - 304 (70ms)', '{\"statusCode\":304,\"duration\":70,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stores/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:24', '2025-07-15 10:15:24'),
(41931, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-requests?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/stock-requests?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:25', '2025-07-15 10:15:25'),
(41932, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-gudang-toko?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/stock-gudang-toko?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:25', '2025-07-15 10:15:25'),
(41933, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/barang?limit=1000 - 304 (132ms)', '{\"statusCode\":304,\"duration\":132,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/barang?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:25', '2025-07-15 10:15:25'),
(41934, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-requests?page=1&limit=10&search= - 304 (51ms)', '{\"statusCode\":304,\"duration\":51,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-requests?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:25', '2025-07-15 10:15:25'),
(41935, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-gudang-toko?page=1&limit=10&search= - 304 (51ms)', '{\"statusCode\":304,\"duration\":51,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-gudang-toko?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:25', '2025-07-15 10:15:25'),
(41936, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stores/active', '{\"method\":\"GET\",\"url\":\"/api/stores/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:25', '2025-07-15 10:15:25'),
(41937, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-transfers?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/stock-transfers?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:25', '2025-07-15 10:15:25'),
(41938, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stores/active - 304 (143ms)', '{\"statusCode\":304,\"duration\":143,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stores/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:25', '2025-07-15 10:15:25'),
(41939, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-transfers?page=1&limit=10&search= - 304 (146ms)', '{\"statusCode\":304,\"duration\":146,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-transfers?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:25', '2025-07-15 10:15:25'),
(41940, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-gudang-toko?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/stock-gudang-toko?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:25', '2025-07-15 10:15:25'),
(41941, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-requests?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/stock-requests?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:25', '2025-07-15 10:15:25'),
(41942, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/kategori?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/kategori?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:25', '2025-07-15 10:15:25'),
(41943, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-gudang-toko?page=1&limit=10&search= - 304 (8ms)', '{\"statusCode\":304,\"duration\":8,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-gudang-toko?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:25', '2025-07-15 10:15:25'),
(41944, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-requests?page=1&limit=10&search= - 304 (106ms)', '{\"statusCode\":304,\"duration\":106,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-requests?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:25', '2025-07-15 10:15:25'),
(41945, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/warna?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/warna?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:25', '2025-07-15 10:15:25'),
(41946, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/ukuran?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/ukuran?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:25', '2025-07-15 10:15:25'),
(41947, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/kategori?limit=1000 - 304 (105ms)', '{\"statusCode\":304,\"duration\":105,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/kategori?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:25', '2025-07-15 10:15:25'),
(41948, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/barang?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/barang?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:25', '2025-07-15 10:15:25'),
(41949, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/warna?limit=1000 - 304 (41ms)', '{\"statusCode\":304,\"duration\":41,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/warna?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:25', '2025-07-15 10:15:25'),
(41950, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/ukuran?limit=1000 - 304 (95ms)', '{\"statusCode\":304,\"duration\":95,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/ukuran?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:25', '2025-07-15 10:15:25'),
(41951, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/barang?page=1&limit=10&search= - 304 (129ms)', '{\"statusCode\":304,\"duration\":129,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/barang?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:25', '2025-07-15 10:15:25'),
(41952, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stores/active', '{\"method\":\"GET\",\"url\":\"/api/stores/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:25', '2025-07-15 10:15:25'),
(41953, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-transfers?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/stock-transfers?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:25', '2025-07-15 10:15:25'),
(41954, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-gudang-toko?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/stock-gudang-toko?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:25', '2025-07-15 10:15:25'),
(41955, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stores/active - 304 (58ms)', '{\"statusCode\":304,\"duration\":58,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stores/active\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41956, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-transfers?page=1&limit=10&search= - 304 (61ms)', '{\"statusCode\":304,\"duration\":61,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-transfers?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41957, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-gudang-toko?page=1&limit=10&search= - 304 (131ms)', '{\"statusCode\":304,\"duration\":131,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-gudang-toko?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41958, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/kategori?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/kategori?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41959, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-requests?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/stock-requests?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41960, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/warna?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/warna?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41961, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/kategori?limit=1000 - 304 (81ms)', '{\"statusCode\":304,\"duration\":81,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/kategori?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41962, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-requests?page=1&limit=10&search= - 304 (84ms)', '{\"statusCode\":304,\"duration\":84,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-requests?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41963, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/warna?limit=1000 - 304 (97ms)', '{\"statusCode\":304,\"duration\":97,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/warna?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41964, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/ukuran?limit=1000', '{\"method\":\"GET\",\"url\":\"/api/ukuran?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41965, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/supplier', '{\"method\":\"GET\",\"url\":\"/api/supplier\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41966, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/barang?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/barang?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41967, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/ukuran?limit=1000 - 304 (37ms)', '{\"statusCode\":304,\"duration\":37,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/ukuran?limit=1000\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41968, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/supplier - 304 (36ms)', '{\"statusCode\":304,\"duration\":36,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/supplier\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41969, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/barang?page=1&limit=10&search= - 304 (38ms)', '{\"statusCode\":304,\"duration\":38,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/barang?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41970, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-transfers?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/stock-transfers?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41971, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-requests?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/stock-requests?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41972, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/kategori?page=1&limit=10', '{\"method\":\"GET\",\"url\":\"/api/kategori?page=1&limit=10\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41973, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-transfers?page=1&limit=10&search= - 304 (93ms)', '{\"statusCode\":304,\"duration\":93,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-transfers?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26');
INSERT INTO `logs` (`id`, `userId`, `action`, `module`, `level`, `description`, `details`, `ipAddress`, `userAgent`, `resourceType`, `resourceId`, `oldValues`, `newValues`, `sessionId`, `createdAt`, `updatedAt`) VALUES
(41974, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-requests?page=1&limit=10&search= - 304 (119ms)', '{\"statusCode\":304,\"duration\":119,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-requests?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41975, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/supplier', '{\"method\":\"GET\",\"url\":\"/api/supplier\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41976, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/kategori?page=1&limit=10 - 304 (38ms)', '{\"statusCode\":304,\"duration\":38,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/kategori?page=1&limit=10\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41977, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/barang?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/barang?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41978, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/supplier - 304 (32ms)', '{\"statusCode\":304,\"duration\":32,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/supplier\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41979, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/barang?page=1&limit=10&search= - 304 (94ms)', '{\"statusCode\":304,\"duration\":94,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/barang?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41980, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-transfers?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/stock-transfers?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41981, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-requests?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/stock-requests?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41982, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-transfers?page=1&limit=10&search= - 304 (33ms)', '{\"statusCode\":304,\"duration\":33,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-transfers?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41983, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/kategori?page=1&limit=10', '{\"method\":\"GET\",\"url\":\"/api/kategori?page=1&limit=10\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41984, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-requests?page=1&limit=10&search= - 304 (9ms)', '{\"statusCode\":304,\"duration\":9,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-requests?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41985, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/barang?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/barang?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41986, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/kategori?page=1&limit=10 - 304 (64ms)', '{\"statusCode\":304,\"duration\":64,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/kategori?page=1&limit=10\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41987, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/warna?page=1&limit=10', '{\"method\":\"GET\",\"url\":\"/api/warna?page=1&limit=10\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41988, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/barang?page=1&limit=10&search= - 304 (6ms)', '{\"statusCode\":304,\"duration\":6,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/barang?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41989, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/warna?page=1&limit=10 - 304 (30ms)', '{\"statusCode\":304,\"duration\":30,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/warna?page=1&limit=10\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41990, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-transfers?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/stock-transfers?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41991, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-requests?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/stock-requests?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41992, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-transfers?page=1&limit=10&search= - 304 (50ms)', '{\"statusCode\":304,\"duration\":50,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-transfers?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41993, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-requests?page=1&limit=10&search= - 304 (10ms)', '{\"statusCode\":304,\"duration\":10,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-requests?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41994, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/barang?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/barang?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:26', '2025-07-15 10:15:26'),
(41995, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/warna?page=1&limit=10', '{\"method\":\"GET\",\"url\":\"/api/warna?page=1&limit=10\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:27', '2025-07-15 10:15:27'),
(41996, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/barang?page=1&limit=10&search= - 304 (95ms)', '{\"statusCode\":304,\"duration\":95,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/barang?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:27', '2025-07-15 10:15:27'),
(41997, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-transfers?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/stock-transfers?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:27', '2025-07-15 10:15:27'),
(41998, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/warna?page=1&limit=10 - 304 (4ms)', '{\"statusCode\":304,\"duration\":4,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/warna?page=1&limit=10\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:27', '2025-07-15 10:15:27'),
(41999, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-transfers?page=1&limit=10&search= - 304 (34ms)', '{\"statusCode\":304,\"duration\":34,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-transfers?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:27', '2025-07-15 10:15:27'),
(42000, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/barang?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/barang?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:27', '2025-07-15 10:15:27'),
(42001, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/barang?page=1&limit=10&search= - 304 (6ms)', '{\"statusCode\":304,\"duration\":6,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/barang?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:27', '2025-07-15 10:15:27'),
(42002, NULL, 'HTTP_REQUEST', 'SYSTEM', 'info', 'GET /api/stock-transfers?page=1&limit=10&search=', '{\"method\":\"GET\",\"url\":\"/api/stock-transfers?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:27', '2025-07-15 10:15:27'),
(42003, NULL, 'HTTP_RESPONSE', 'SYSTEM', 'info', 'GET /api/stock-transfers?page=1&limit=10&search= - 304 (8ms)', '{\"statusCode\":304,\"duration\":8,\"requestData\":{\"method\":\"GET\",\"url\":\"/api/stock-transfers?page=1&limit=10&search=\",\"ip\":\"::1\",\"userAgent\":\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36\"}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', NULL, NULL, NULL, NULL, NULL, '2025-07-15 10:15:27', '2025-07-15 10:15:27');

-- --------------------------------------------------------

--
-- Table structure for table `payment_methods`
--

CREATE TABLE `payment_methods` (
  `id` int(11) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `is_aktif` tinyint(1) NOT NULL DEFAULT 1,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `payment_methods`
--

INSERT INTO `payment_methods` (`id`, `nama`, `deskripsi`, `is_aktif`, `createdAt`, `updatedAt`) VALUES
(1, 'Cash', '', 1, '2025-07-02 11:28:57', '2025-07-11 06:15:35'),
(2, 'Qris', '', 1, '2025-07-02 12:40:10', '2025-07-02 12:40:10'),
(3, 'Transfer', '', 1, '2025-07-02 12:40:16', '2025-07-05 12:24:15'),
(4, 'Bank', '', 1, '2025-07-02 12:40:19', '2025-07-15 07:16:15'),
(5, 'Dana', '', 0, '2025-07-14 07:11:15', '2025-07-14 07:11:17');

-- --------------------------------------------------------

--
-- Table structure for table `purchase_orders`
--

CREATE TABLE `purchase_orders` (
  `id` int(11) NOT NULL,
  `kode` varchar(255) NOT NULL,
  `tanggal` date DEFAULT NULL,
  `status` enum('draft','dikirim','partial_received','diterima','dibatalkan') DEFAULT 'draft',
  `catatan` text DEFAULT NULL,
  `purchaseRequestId` int(11) DEFAULT NULL,
  `supplierId` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `purchase_orders`
--

INSERT INTO `purchase_orders` (`id`, `kode`, `tanggal`, `status`, `catatan`, `purchaseRequestId`, `supplierId`, `createdAt`, `updatedAt`) VALUES
(1, 'PO-20250701-001', '2025-07-03', 'diterima', 'Test', 1, 2, '2025-07-01 09:46:37', '2025-07-01 09:48:07'),
(3, 'PO-20250701-002', '2025-07-01', 'diterima', 'Okee gas', 2, 1, '2025-07-01 11:26:34', '2025-07-01 11:27:12'),
(4, 'PO-20250701-003', '2025-07-01', 'diterima', '', 3, 2, '2025-07-01 11:35:52', '2025-07-01 11:40:34'),
(5, 'PO-20250701-004', '2025-10-24', '', NULL, 4, 2, '2025-07-01 11:53:53', '2025-07-01 11:57:12'),
(6, 'PO-20250701-005', '2025-07-01', 'diterima', '', 5, 2, '2025-07-01 11:59:13', '2025-07-01 11:59:29'),
(7, 'PO-20250701-006', '2025-07-01', 'diterima', '', 6, 2, '2025-07-01 12:14:41', '2025-07-01 12:17:37'),
(9, 'PO-20250703-001', '2025-07-03', 'diterima', '', 7, 2, '2025-07-03 13:47:32', '2025-07-03 13:49:02'),
(10, 'PO-20250703-002', '2025-07-03', 'draft', NULL, 7, 1, '2025-07-03 13:50:26', '2025-07-03 13:50:26'),
(11, 'PO-20250708-001', '2025-07-08', 'diterima', '', 8, 2, '2025-07-08 13:29:37', '2025-07-08 13:39:21'),
(12, 'PO-20250709-001', '2025-07-09', 'diterima', 'Niceee', 9, 2, '2025-07-09 13:37:05', '2025-07-09 13:38:04'),
(13, 'PO-20250711-001', '2025-07-11', 'diterima', 'beres barang baru', 10, 2, '2025-07-11 06:30:34', '2025-07-11 06:32:36'),
(14, 'PO-20250714-001', '2025-07-14', 'diterima', '', 13, 2, '2025-07-14 09:43:50', '2025-07-14 09:45:32');

-- --------------------------------------------------------

--
-- Table structure for table `purchase_order_items`
--

CREATE TABLE `purchase_order_items` (
  `id` int(11) NOT NULL,
  `purchaseOrderId` int(11) DEFAULT NULL,
  `barangId` int(11) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `harga` decimal(15,2) DEFAULT NULL,
  `subtotal` decimal(15,2) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `purchase_order_items`
--

INSERT INTO `purchase_order_items` (`id`, `purchaseOrderId`, `barangId`, `qty`, `harga`, `subtotal`, `createdAt`, `updatedAt`) VALUES
(3, 1, 5, 100, '30000.00', '3000000.00', '2025-07-01 09:47:35', '2025-07-01 09:47:35'),
(4, 1, 3, 150, '25000.00', '3750000.00', '2025-07-01 09:47:35', '2025-07-01 09:47:35'),
(7, 3, 6, 100, '45000.00', '4500000.00', '2025-07-01 11:26:57', '2025-07-01 11:26:57'),
(9, 4, 6, 20, '50000.00', '1000000.00', '2025-07-01 11:36:16', '2025-07-01 11:36:16'),
(10, 5, 6, 100, '0.00', '0.00', '2025-07-01 11:53:53', '2025-07-01 11:53:53'),
(12, 6, 6, 10, '65000.00', '650000.00', '2025-07-01 11:59:23', '2025-07-01 11:59:23'),
(14, 7, 6, 20, '50000.00', '1000000.00', '2025-07-01 12:14:55', '2025-07-01 12:14:55'),
(17, 9, 6, 2, '75000.00', '150000.00', '2025-07-03 13:48:09', '2025-07-03 13:48:09'),
(18, 10, 6, 2, '0.00', '0.00', '2025-07-03 13:50:26', '2025-07-03 13:50:26'),
(21, 11, 6, 3, '55000.00', '165000.00', '2025-07-08 13:38:10', '2025-07-08 13:38:10'),
(22, 11, 5, 2, '60000.00', '120000.00', '2025-07-08 13:38:10', '2025-07-08 13:38:10'),
(24, 12, 6, 10, '54000.00', '540000.00', '2025-07-09 13:37:28', '2025-07-09 13:37:28'),
(26, 13, 8, 100, '47000.00', '4700000.00', '2025-07-11 06:31:28', '2025-07-11 06:31:28'),
(29, 14, 8, 100, '46000.00', '4600000.00', '2025-07-14 09:44:35', '2025-07-14 09:44:35'),
(30, 14, 3, 52, '49000.00', '2548000.00', '2025-07-14 09:44:35', '2025-07-14 09:44:35');

-- --------------------------------------------------------

--
-- Table structure for table `purchase_requests`
--

CREATE TABLE `purchase_requests` (
  `id` int(11) NOT NULL,
  `kode` varchar(255) NOT NULL,
  `tanggal` date DEFAULT NULL,
  `status` enum('draft','diajukan','disetujui','ditolak') DEFAULT 'draft',
  `catatan` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `approved_by` int(11) DEFAULT NULL,
  `approved_at` datetime DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `purchase_requests`
--

INSERT INTO `purchase_requests` (`id`, `kode`, `tanggal`, `status`, `catatan`, `created_by`, `approved_by`, `approved_at`, `rejection_reason`, `createdAt`, `updatedAt`) VALUES
(1, 'PR-20250701-001', '2025-07-01', 'disetujui', '', 2, 3, '2025-07-01 09:46:14', NULL, '2025-07-01 09:43:32', '2025-07-01 09:46:14'),
(2, 'PR-20250701-002', '2025-08-08', 'disetujui', '', 2, 3, '2025-07-01 11:07:22', NULL, '2025-07-01 11:06:33', '2025-07-01 11:07:22'),
(3, 'PR-20250701-003', '2025-07-01', 'disetujui', '', 3, 3, '2025-07-01 11:35:46', NULL, '2025-07-01 11:34:50', '2025-07-01 11:35:46'),
(4, 'PR-20250701-004', '2025-09-19', 'disetujui', '', 3, 3, '2025-07-01 11:53:43', NULL, '2025-07-01 11:53:34', '2025-07-01 11:53:43'),
(5, 'PR-20250701-005', '2025-07-01', 'disetujui', '', 3, 3, '2025-07-01 11:58:57', NULL, '2025-07-01 11:58:50', '2025-07-01 11:58:57'),
(6, 'PR-20250701-006', '2025-07-05', 'disetujui', '', 3, 3, '2025-07-01 12:14:36', NULL, '2025-07-01 12:14:27', '2025-07-01 12:14:36'),
(7, 'PR-20250703-001', '2025-07-03', 'disetujui', '', 7, 3, '2025-07-03 13:45:14', NULL, '2025-07-03 13:33:43', '2025-07-03 13:45:14'),
(8, 'PR-20250708-001', '2025-07-08', 'disetujui', '', 3, 3, '2025-07-08 13:29:12', NULL, '2025-07-08 13:28:30', '2025-07-08 13:29:12'),
(9, 'PR-20250709-001', '2025-07-09', 'disetujui', '', 7, 3, '2025-07-09 13:36:22', NULL, '2025-07-09 13:34:51', '2025-07-09 13:36:22'),
(10, 'PR-20250711-001', '2025-07-11', 'disetujui', 'barang baru', 7, 3, '2025-07-11 06:30:08', NULL, '2025-07-11 06:29:44', '2025-07-11 06:30:08'),
(11, 'PR-20250712-001', '2025-07-12', 'disetujui', '', 7, 3, '2025-07-12 08:27:00', NULL, '2025-07-12 08:26:04', '2025-07-12 08:27:00'),
(12, 'PR-20250714-001', '2025-07-14', 'ditolak', '', 7, 3, '2025-07-14 09:40:44', 'no money', '2025-07-14 09:37:20', '2025-07-14 09:40:44'),
(13, 'PR-20250714-002', '2025-07-14', 'disetujui', '', 7, 3, '2025-07-14 09:43:10', NULL, '2025-07-14 09:42:40', '2025-07-14 09:43:10');

-- --------------------------------------------------------

--
-- Table structure for table `purchase_request_items`
--

CREATE TABLE `purchase_request_items` (
  `id` int(11) NOT NULL,
  `purchaseRequestId` int(11) NOT NULL,
  `barangId` int(11) NOT NULL,
  `qty` int(11) NOT NULL,
  `satuan` varchar(255) DEFAULT NULL,
  `keterangan` text DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `purchase_request_items`
--

INSERT INTO `purchase_request_items` (`id`, `purchaseRequestId`, `barangId`, `qty`, `satuan`, `keterangan`, `createdAt`, `updatedAt`) VALUES
(1, 1, 5, 100, 'pcs', 'need fast', '2025-07-01 09:43:32', '2025-07-01 09:43:32'),
(2, 1, 3, 150, 'pcs', 'udah tipis', '2025-07-01 09:43:32', '2025-07-01 09:43:32'),
(3, 2, 6, 100, 'pcs', '', '2025-07-01 11:06:33', '2025-07-01 11:06:33'),
(4, 3, 6, 20, 'pcs', '', '2025-07-01 11:34:50', '2025-07-01 11:34:50'),
(5, 4, 6, 100, 'pcs', '', '2025-07-01 11:53:34', '2025-07-01 11:53:34'),
(6, 5, 6, 10, 'pcs', '', '2025-07-01 11:58:50', '2025-07-01 11:58:50'),
(7, 6, 6, 20, 'pcs', '', '2025-07-01 12:14:28', '2025-07-01 12:14:28'),
(8, 7, 6, 2, 'pcs', 'butuh', '2025-07-03 13:33:43', '2025-07-03 13:33:43'),
(9, 8, 6, 3, 'pcs', '', '2025-07-08 13:28:30', '2025-07-08 13:28:30'),
(10, 8, 5, 2, 'pcs', '', '2025-07-08 13:28:30', '2025-07-08 13:28:30'),
(13, 9, 6, 10, 'pcs', 'test', '2025-07-09 13:35:18', '2025-07-09 13:35:18'),
(14, 10, 8, 100, 'pcs', '', '2025-07-11 06:29:44', '2025-07-11 06:29:44'),
(15, 11, 8, 160, 'pcs', 'butuh', '2025-07-12 08:26:04', '2025-07-12 08:26:04'),
(20, 12, 8, 100, 'pcs', 'stok tipis', '2025-07-14 09:37:46', '2025-07-14 09:37:46'),
(21, 12, 3, 52, 'pcs', '', '2025-07-14 09:37:46', '2025-07-14 09:37:46'),
(22, 13, 8, 100, 'pcs', 'stok tipis', '2025-07-14 09:42:40', '2025-07-14 09:42:40'),
(23, 13, 3, 52, 'pcs', '', '2025-07-14 09:42:40', '2025-07-14 09:42:40');

-- --------------------------------------------------------

--
-- Table structure for table `purchase_returns`
--

CREATE TABLE `purchase_returns` (
  `id` int(11) NOT NULL,
  `kode` varchar(255) NOT NULL,
  `tanggal` date DEFAULT NULL,
  `goodReceiptId` int(11) DEFAULT NULL,
  `catatan` text DEFAULT NULL,
  `status` enum('draft','approved','completed') DEFAULT 'draft',
  `return_reason` text DEFAULT NULL,
  `total_amount` decimal(15,2) DEFAULT 0.00,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `purchase_returns`
--

INSERT INTO `purchase_returns` (`id`, `kode`, `tanggal`, `goodReceiptId`, `catatan`, `status`, `return_reason`, `total_amount`, `createdAt`, `updatedAt`) VALUES
(1, 'PRET-20250709-001', '2025-07-09', 10, '', 'completed', 'not really godd', '150000.00', '2025-07-09 12:35:21', '2025-07-09 12:36:10'),
(4, 'PRET-20250709-002', '2025-07-09', 11, '', 'completed', 'Santuyy', '162000.00', '2025-07-09 13:45:36', '2025-07-09 13:47:45'),
(6, 'PRET-20250711-001', '2025-07-11', 12, '', 'completed', 'tidak sesuai request', '94000.00', '2025-07-11 06:34:21', '2025-07-11 06:34:32');

-- --------------------------------------------------------

--
-- Table structure for table `purchase_return_items`
--

CREATE TABLE `purchase_return_items` (
  `id` int(11) NOT NULL,
  `purchaseReturnId` int(11) DEFAULT NULL,
  `barangId` int(11) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `unit_price` decimal(15,2) DEFAULT 0.00,
  `subtotal` decimal(15,2) DEFAULT 0.00,
  `return_reason` text DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `purchase_return_items`
--

INSERT INTO `purchase_return_items` (`id`, `purchaseReturnId`, `barangId`, `qty`, `unit_price`, `subtotal`, `return_reason`, `createdAt`, `updatedAt`) VALUES
(1, 1, 6, 3, '50000.00', '150000.00', 'not good', '2025-07-09 12:35:21', '2025-07-09 12:35:21'),
(9, 4, 6, 3, '54000.00', '162000.00', '', '2025-07-09 13:47:27', '2025-07-09 13:47:27'),
(11, 6, 8, 2, '47000.00', '94000.00', '', '2025-07-11 06:34:21', '2025-07-11 06:34:21');

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

CREATE TABLE `sales` (
  `id` int(11) NOT NULL,
  `kode` varchar(255) NOT NULL,
  `tanggal` date NOT NULL,
  `userId` int(11) NOT NULL,
  `total` decimal(15,2) NOT NULL DEFAULT 0.00,
  `catatan` text DEFAULT NULL,
  `storeId` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `discount_mode` enum('item','bill') NOT NULL DEFAULT 'item',
  `bill_discount_percent` float NOT NULL DEFAULT 0,
  `paymentMethodId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `sales`
--

INSERT INTO `sales` (`id`, `kode`, `tanggal`, `userId`, `total`, `catatan`, `storeId`, `createdAt`, `updatedAt`, `discount_mode`, `bill_discount_percent`, `paymentMethodId`) VALUES
(1, 'SALE-20250702-001', '2025-07-02', 3, '165000.00', '', 1, '2025-07-02 07:20:32', '2025-07-02 07:20:32', 'item', 0, NULL),
(2, 'SALE-20250702-002', '2025-07-02', 3, '165000.00', '', 3, '2025-07-02 07:21:43', '2025-07-02 07:21:43', 'item', 0, NULL),
(3, 'SALE-20250702-003', '2025-07-02', 4, '140000.00', 'Test toko jakarta', 3, '2025-07-02 08:27:04', '2025-07-02 08:27:04', 'item', 0, NULL),
(4, 'SALE-20250702-004', '2025-07-02', 5, '70000.00', '', 1, '2025-07-02 08:36:08', '2025-07-02 08:36:08', 'item', 0, NULL),
(5, 'SALE-20250702-005', '2025-07-02', 3, '49500.00', '', 1, '2025-07-02 09:19:02', '2025-07-02 09:19:02', 'item', 0, NULL),
(6, 'SALE-20250702-006', '2025-07-02', 3, '153000.00', '', 1, '2025-07-02 10:08:45', '2025-07-02 10:08:45', 'bill', 15, NULL),
(7, 'SALE-20250702-007', '2025-09-20', 3, '398000.00', 'Test new payment method', 1, '2025-07-02 12:43:28', '2025-07-02 12:43:28', 'item', 0, 1),
(8, 'SALE-20250702-008', '2025-07-02', 3, '80750.00', 'niceee', 3, '2025-07-02 12:58:30', '2025-07-02 12:58:30', 'bill', 5, 2),
(9, 'SALE-20250703-001', '2025-07-03', 6, '72000.00', '', 2, '2025-07-03 13:53:44', '2025-07-03 13:53:44', 'item', 0, 2),
(10, 'SALE-20250707-001', '2025-07-19', 4, '700000.00', 'Test sales return', 3, '2025-07-07 09:04:32', '2025-07-07 09:04:32', 'item', 0, 3),
(11, 'SALE-20250707-002', '2025-07-07', 6, '76000.00', 'Niceee', 2, '2025-07-07 09:33:37', '2025-07-07 09:33:37', 'item', 0, NULL),
(12, 'SALE-20250709-001', '2025-07-09', 4, '105000.00', 'Test', 3, '2025-07-09 13:57:01', '2025-07-09 13:57:01', 'item', 0, 1),
(13, 'SALE-20250709-002', '2025-07-09', 4, '983250.00', '', 3, '2025-07-09 13:58:52', '2025-07-09 13:58:52', 'item', 0, 4),
(14, 'SALE-20250711-001', '2025-07-11', 6, '365000.00', 'penjualan hari ini', 2, '2025-07-11 11:23:20', '2025-07-11 11:23:20', 'item', 0, 1),
(15, 'SALE-20250712-001', '2025-07-12', 4, '17665000.00', '', 3, '2025-07-12 09:11:44', '2025-07-12 09:11:44', 'item', 0, 4),
(16, 'SALE-20250712-002', '2025-07-12', 6, '4550000.00', 'Test', 2, '2025-07-12 09:15:13', '2025-07-12 09:15:13', 'item', 0, 2),
(17, 'SALE-20250712-003', '2025-06-21', 2, '550000.00', '', 3, '2025-07-12 09:19:26', '2025-07-12 09:19:26', 'item', 0, NULL),
(18, 'SALE-20250714-001', '2025-07-14', 10, '2328000.00', '', 2, '2025-07-14 09:51:08', '2025-07-14 09:51:08', 'item', 0, 2);

-- --------------------------------------------------------

--
-- Table structure for table `sale_items`
--

CREATE TABLE `sale_items` (
  `id` int(11) NOT NULL,
  `saleId` int(11) DEFAULT NULL,
  `barangId` int(11) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `harga` decimal(15,2) DEFAULT NULL,
  `subtotal` decimal(15,2) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `discount_percent` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `sale_items`
--

INSERT INTO `sale_items` (`id`, `saleId`, `barangId`, `qty`, `harga`, `subtotal`, `createdAt`, `updatedAt`, `discount_percent`) VALUES
(1, 1, 3, 3, '55000.00', '165000.00', '2025-07-02 07:20:32', '2025-07-02 07:20:32', 0),
(2, 2, 3, 3, '55000.00', '165000.00', '2025-07-02 07:21:43', '2025-07-02 07:21:43', 0),
(3, 3, 3, 2, '55000.00', '110000.00', '2025-07-02 08:27:04', '2025-07-02 08:27:04', 0),
(4, 3, 1, 1, '30000.00', '30000.00', '2025-07-02 08:27:04', '2025-07-02 08:27:04', 0),
(5, 4, 2, 2, '35000.00', '70000.00', '2025-07-02 08:36:08', '2025-07-02 08:36:08', 0),
(6, 5, 3, 1, '55000.00', '55000.00', '2025-07-02 09:19:02', '2025-07-02 09:19:02', 10),
(7, 6, 2, 2, '35000.00', '70000.00', '2025-07-02 10:08:45', '2025-07-02 10:08:45', 0),
(8, 6, 3, 2, '55000.00', '110000.00', '2025-07-02 10:08:45', '2025-07-02 10:08:45', 0),
(9, 7, 3, 4, '55000.00', '220000.00', '2025-07-02 12:43:28', '2025-07-02 12:43:28', 5),
(10, 7, 2, 6, '35000.00', '210000.00', '2025-07-02 12:43:28', '2025-07-02 12:43:28', 10),
(11, 8, 3, 1, '55000.00', '55000.00', '2025-07-02 12:58:30', '2025-07-02 12:58:30', 0),
(12, 8, 1, 1, '30000.00', '30000.00', '2025-07-02 12:58:31', '2025-07-02 12:58:31', 0),
(13, 9, 6, 1, '80000.00', '80000.00', '2025-07-03 13:53:44', '2025-07-03 13:53:44', 10),
(14, 10, 3, 10, '55000.00', '550000.00', '2025-07-07 09:04:32', '2025-07-07 09:04:32', 0),
(15, 10, 1, 5, '30000.00', '150000.00', '2025-07-07 09:04:32', '2025-07-07 09:04:32', 0),
(16, 11, 6, 1, '80000.00', '80000.00', '2025-07-07 09:33:37', '2025-07-07 09:33:37', 5),
(17, 12, 1, 3, '35000.00', '105000.00', '2025-07-09 13:57:01', '2025-07-09 13:57:01', 0),
(18, 13, 1, 7, '30000.00', '210000.00', '2025-07-09 13:58:52', '2025-07-09 13:58:52', 5),
(19, 13, 3, 15, '55000.00', '825000.00', '2025-07-09 13:58:52', '2025-07-09 13:58:52', 5),
(20, 14, 8, 5, '55000.00', '275000.00', '2025-07-11 11:23:20', '2025-07-11 11:23:20', 0),
(21, 14, 1, 3, '30000.00', '90000.00', '2025-07-11 11:23:20', '2025-07-11 11:23:20', 0),
(22, 15, 3, 163, '55000.00', '8965000.00', '2025-07-12 09:11:44', '2025-07-12 09:11:44', 0),
(23, 15, 1, 290, '30000.00', '8700000.00', '2025-07-12 09:11:44', '2025-07-12 09:11:44', 0),
(24, 16, 6, 50, '80000.00', '4000000.00', '2025-07-12 09:15:13', '2025-07-12 09:15:13', 0),
(25, 16, 8, 10, '55000.00', '550000.00', '2025-07-12 09:15:13', '2025-07-12 09:15:13', 0),
(26, 17, 3, 10, '55000.00', '550000.00', '2025-07-12 09:19:26', '2025-07-12 09:19:26', 0),
(27, 18, 6, 30, '80000.00', '2400000.00', '2025-07-14 09:51:08', '2025-07-14 09:51:08', 3);

-- --------------------------------------------------------

--
-- Table structure for table `sale_returns`
--

CREATE TABLE `sale_returns` (
  `id` int(11) NOT NULL,
  `kode` varchar(255) NOT NULL,
  `tanggal` date NOT NULL,
  `saleId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `storeId` int(11) NOT NULL,
  `total_return` decimal(15,2) NOT NULL DEFAULT 0.00,
  `return_reason` text DEFAULT NULL,
  `refund_method` varchar(255) DEFAULT NULL,
  `status` enum('pending','approved','completed') DEFAULT 'pending',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `refundMethodId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `sale_returns`
--

INSERT INTO `sale_returns` (`id`, `kode`, `tanggal`, `saleId`, `userId`, `storeId`, `total_return`, `return_reason`, `refund_method`, `status`, `createdAt`, `updatedAt`, `refundMethodId`) VALUES
(3, 'RETURN-20250707-001', '2025-07-07', 9, 2, 2, '72000.00', 'rusakk', NULL, 'completed', '2025-07-07 08:43:38', '2025-07-07 08:45:42', NULL),
(4, 'RETURN-20250707-002', '2025-07-07', 10, 4, 3, '225000.00', 'Waduhh', NULL, 'completed', '2025-07-07 09:09:25', '2025-07-07 09:17:31', NULL),
(5, 'RETURN-20250707-003', '2025-07-07', 10, 4, 3, '110000.00', 'Test', NULL, 'completed', '2025-07-07 09:19:24', '2025-07-07 09:20:12', NULL),
(6, 'RETURN-20250707-004', '2025-07-07', 10, 4, 3, '55000.00', 'sad', NULL, 'completed', '2025-07-07 09:21:27', '2025-07-07 09:21:30', NULL),
(7, 'RETURN-20250707-005', '2025-07-07', 11, 6, 2, '76000.00', 'Test', NULL, 'completed', '2025-07-07 09:34:56', '2025-07-07 09:35:01', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sale_return_items`
--

CREATE TABLE `sale_return_items` (
  `id` int(11) NOT NULL,
  `saleReturnId` int(11) NOT NULL,
  `barangId` int(11) NOT NULL,
  `qty` int(11) NOT NULL,
  `harga` decimal(15,2) NOT NULL,
  `subtotal` decimal(15,2) NOT NULL,
  `return_reason` text DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `sale_return_items`
--

INSERT INTO `sale_return_items` (`id`, `saleReturnId`, `barangId`, `qty`, `harga`, `subtotal`, `return_reason`, `createdAt`, `updatedAt`) VALUES
(1, 3, 6, 1, '72000.00', '72000.00', 'terlalu kecil', '2025-07-07 08:43:38', '2025-07-07 08:43:38'),
(2, 4, 3, 3, '55000.00', '165000.00', '', '2025-07-07 09:09:25', '2025-07-07 09:09:25'),
(3, 4, 1, 2, '30000.00', '60000.00', '', '2025-07-07 09:09:25', '2025-07-07 09:09:25'),
(4, 5, 3, 2, '55000.00', '110000.00', '', '2025-07-07 09:19:24', '2025-07-07 09:19:24'),
(5, 6, 3, 1, '55000.00', '55000.00', '', '2025-07-07 09:21:27', '2025-07-07 09:21:27'),
(6, 7, 6, 1, '76000.00', '76000.00', '', '2025-07-07 09:34:56', '2025-07-07 09:34:56');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `sid` varchar(36) NOT NULL,
  `expires` datetime DEFAULT NULL,
  `data` text DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`sid`, `expires`, `data`, `createdAt`, `updatedAt`) VALUES
('MkobG-DgRwqcZ42CXJlXET-owdnX97Cl', '2025-07-16 10:15:27', '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"secure\":false,\"httpOnly\":true,\"path\":\"/\"},\"user\":{\"id\":2,\"username\":\"admin\",\"role\":\"admin\",\"storeId\":null,\"store\":null}}', '2025-07-14 09:53:53', '2025-07-15 10:15:27');

-- --------------------------------------------------------

--
-- Table structure for table `stock_gudang_pusat`
--

CREATE TABLE `stock_gudang_pusat` (
  `id` int(11) NOT NULL,
  `barangId` int(11) NOT NULL,
  `stok` int(11) NOT NULL DEFAULT 0,
  `maximum_stock` int(11) DEFAULT NULL COMMENT 'Maximum stock level for this product in central warehouse',
  `minimum_stock` int(11) DEFAULT NULL COMMENT 'Minimum stock level before reorder alert for central warehouse',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `stock_gudang_pusat`
--

INSERT INTO `stock_gudang_pusat` (`id`, `barangId`, `stok`, `maximum_stock`, `minimum_stock`, `createdAt`, `updatedAt`) VALUES
(1, 5, 597, 500, 100, '2025-07-01 09:48:07', '2025-07-14 11:00:53'),
(2, 3, 172, 500, 100, '2025-07-01 09:48:07', '2025-07-14 09:45:32'),
(3, 2, 230, 500, 50, '2025-07-01 10:19:47', '2025-07-14 11:00:53'),
(4, 1, 349, 800, 50, '2025-07-01 10:20:07', '2025-07-14 11:00:53'),
(5, 6, 207, NULL, NULL, '2025-07-01 11:27:12', '2025-07-09 13:47:45'),
(6, 8, 123, NULL, NULL, '2025-07-11 06:32:36', '2025-07-14 09:45:32');

-- --------------------------------------------------------

--
-- Table structure for table `stock_gudang_toko`
--

CREATE TABLE `stock_gudang_toko` (
  `id` int(11) NOT NULL,
  `barangId` int(11) NOT NULL,
  `stok` int(11) NOT NULL DEFAULT 0,
  `storeId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `stock_gudang_toko`
--

INSERT INTO `stock_gudang_toko` (`id`, `barangId`, `stok`, `storeId`, `createdAt`, `updatedAt`) VALUES
(1, 5, 21, 1, '2025-07-01 10:18:01', '2025-07-14 11:00:53'),
(2, 3, 308, 3, '2025-07-01 10:18:01', '2025-07-12 09:19:26'),
(4, 1, 197, 3, '2025-07-01 10:21:35', '2025-07-12 09:11:44'),
(5, 2, 150, 1, '2025-07-01 10:45:54', '2025-07-14 11:00:53'),
(6, 3, 140, 1, '2025-07-01 10:50:20', '2025-07-02 12:43:28'),
(7, 6, 170, 2, '2025-07-03 13:30:36', '2025-07-14 09:51:08'),
(8, 8, 60, 2, '2025-07-11 11:19:33', '2025-07-12 09:15:13'),
(9, 1, 42, 2, '2025-07-11 11:19:33', '2025-07-11 11:39:07'),
(10, 1, 6, 1, '2025-07-14 07:03:29', '2025-07-14 11:00:53');

-- --------------------------------------------------------

--
-- Table structure for table `stock_requests`
--

CREATE TABLE `stock_requests` (
  `id` int(11) NOT NULL,
  `kode` varchar(255) NOT NULL,
  `fromWarehouse` varchar(255) NOT NULL,
  `status` enum('pending','approved','rejected','fulfilled') DEFAULT 'pending',
  `toStoreId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `stock_requests`
--

INSERT INTO `stock_requests` (`id`, `kode`, `fromWarehouse`, `status`, `toStoreId`, `createdAt`, `updatedAt`) VALUES
(1, 'REQ-20250701-001', 'gudang_pusat', 'fulfilled', 1, '2025-07-01 10:00:02', '2025-07-01 10:18:01'),
(2, 'REQ-20250701-002', 'gudang_pusat', 'fulfilled', 3, '2025-07-01 10:20:59', '2025-07-01 10:21:35'),
(4, 'REQ-20250701-003', 'gudang_pusat', 'fulfilled', 3, '2025-07-01 10:24:36', '2025-07-01 10:28:56'),
(5, 'REQ-20250703-001', 'gudang_pusat', 'fulfilled', 2, '2025-07-03 13:28:46', '2025-07-03 13:30:36'),
(6, 'REQ-20250711-001', 'gudang_pusat', 'fulfilled', 2, '2025-07-11 10:53:48', '2025-07-11 11:39:07'),
(8, 'REQ-20250712-001', 'gudang_pusat', 'fulfilled', 1, '2025-07-12 07:56:07', '2025-07-14 07:03:28'),
(9, 'REQ-20250712-002', 'gudang_pusat', 'rejected', 1, '2025-07-12 07:59:58', '2025-07-12 08:00:10');

-- --------------------------------------------------------

--
-- Table structure for table `stock_request_items`
--

CREATE TABLE `stock_request_items` (
  `id` int(11) NOT NULL,
  `stockRequestId` int(11) NOT NULL,
  `barangId` int(11) NOT NULL,
  `qty` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `stock_request_items`
--

INSERT INTO `stock_request_items` (`id`, `stockRequestId`, `barangId`, `qty`, `createdAt`, `updatedAt`) VALUES
(1, 1, 5, 15, '2025-07-01 10:00:02', '2025-07-01 10:00:02'),
(2, 1, 3, 30, '2025-07-01 10:00:02', '2025-07-01 10:00:02'),
(3, 2, 2, 60, '2025-07-01 10:20:59', '2025-07-01 10:20:59'),
(4, 2, 1, 80, '2025-07-01 10:20:59', '2025-07-01 10:20:59'),
(6, 4, 1, 2, '2025-07-01 10:24:36', '2025-07-01 10:24:36'),
(7, 5, 6, 2, '2025-07-03 13:28:46', '2025-07-03 13:28:46'),
(8, 6, 8, 25, '2025-07-11 10:53:48', '2025-07-11 10:53:48'),
(9, 6, 1, 15, '2025-07-11 10:53:48', '2025-07-11 10:53:48'),
(13, 8, 5, 3, '2025-07-12 07:57:07', '2025-07-12 07:57:07'),
(14, 8, 2, 5, '2025-07-12 07:57:07', '2025-07-12 07:57:07'),
(15, 8, 1, 3, '2025-07-12 07:57:07', '2025-07-12 07:57:07'),
(16, 9, 8, 5, '2025-07-12 07:59:58', '2025-07-12 07:59:58'),
(17, 9, 2, 6, '2025-07-12 07:59:58', '2025-07-12 07:59:58');

-- --------------------------------------------------------

--
-- Table structure for table `stock_transfers`
--

CREATE TABLE `stock_transfers` (
  `id` int(11) NOT NULL,
  `kode` varchar(255) NOT NULL,
  `stockRequestId` int(11) NOT NULL,
  `status` enum('pending','completed') DEFAULT 'pending',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `storeId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `stock_transfers`
--

INSERT INTO `stock_transfers` (`id`, `kode`, `stockRequestId`, `status`, `createdAt`, `updatedAt`, `storeId`) VALUES
(1, 'TRF-20250701-001', 1, 'completed', '2025-07-01 10:17:32', '2025-07-01 10:18:01', 1),
(2, 'TRF-20250701-002', 2, 'completed', '2025-07-01 10:21:26', '2025-07-01 10:21:35', 3),
(3, 'TRF-20250701-003', 4, 'completed', '2025-07-01 10:25:28', '2025-07-01 10:28:56', 3),
(4, 'TRF-20250703-001', 5, 'completed', '2025-07-03 13:30:28', '2025-07-03 13:30:36', 2),
(5, 'TRF-20250711-001', 6, 'completed', '2025-07-11 11:19:16', '2025-07-11 11:19:33', 2),
(6, 'TRF-20250711-002', 6, 'completed', '2025-07-11 11:29:39', '2025-07-11 11:29:42', 2),
(7, 'TRF-20250711-003', 6, 'completed', '2025-07-11 11:38:58', '2025-07-11 11:39:07', 2),
(8, 'TRF-20250712-001', 8, 'completed', '2025-07-12 08:06:22', '2025-07-14 11:00:53', 1),
(9, 'TRF-20250714-001', 8, 'completed', '2025-07-14 07:03:22', '2025-07-14 07:03:28', 1);

-- --------------------------------------------------------

--
-- Table structure for table `stock_transfer_items`
--

CREATE TABLE `stock_transfer_items` (
  `id` int(11) NOT NULL,
  `stockTransferId` int(11) NOT NULL,
  `barangId` int(11) NOT NULL,
  `qty` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `stock_transfer_items`
--

INSERT INTO `stock_transfer_items` (`id`, `stockTransferId`, `barangId`, `qty`, `createdAt`, `updatedAt`) VALUES
(1, 1, 5, 15, '2025-07-01 10:17:32', '2025-07-01 10:17:32'),
(2, 1, 3, 30, '2025-07-01 10:17:32', '2025-07-01 10:17:32'),
(3, 2, 2, 60, '2025-07-01 10:21:26', '2025-07-01 10:21:26'),
(4, 2, 1, 80, '2025-07-01 10:21:26', '2025-07-01 10:21:26'),
(5, 3, 1, 2, '2025-07-01 10:25:28', '2025-07-01 10:25:28'),
(6, 4, 6, 2, '2025-07-03 13:30:28', '2025-07-03 13:30:28'),
(7, 5, 8, 25, '2025-07-11 11:19:16', '2025-07-11 11:19:16'),
(8, 5, 1, 15, '2025-07-11 11:19:16', '2025-07-11 11:19:16'),
(9, 6, 8, 25, '2025-07-11 11:29:39', '2025-07-11 11:29:39'),
(10, 6, 1, 15, '2025-07-11 11:29:39', '2025-07-11 11:29:39'),
(11, 7, 8, 25, '2025-07-11 11:38:58', '2025-07-11 11:38:58'),
(12, 7, 1, 15, '2025-07-11 11:38:58', '2025-07-11 11:38:58'),
(13, 8, 5, 3, '2025-07-12 08:06:22', '2025-07-12 08:06:22'),
(14, 8, 2, 5, '2025-07-12 08:06:22', '2025-07-12 08:06:22'),
(15, 8, 1, 3, '2025-07-12 08:06:22', '2025-07-12 08:06:22'),
(16, 9, 5, 3, '2025-07-14 07:03:22', '2025-07-14 07:03:22'),
(17, 9, 2, 5, '2025-07-14 07:03:22', '2025-07-14 07:03:22'),
(18, 9, 1, 3, '2025-07-14 07:03:22', '2025-07-14 07:03:22');

-- --------------------------------------------------------

--
-- Table structure for table `stores`
--

CREATE TABLE `stores` (
  `id` int(11) NOT NULL,
  `kode` varchar(255) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `alamat` text DEFAULT NULL,
  `telepon` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `manager` varchar(255) DEFAULT NULL,
  `is_aktif` tinyint(1) NOT NULL DEFAULT 1,
  `catatan` text DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `stores`
--

INSERT INTO `stores` (`id`, `kode`, `nama`, `alamat`, `telepon`, `email`, `manager`, `is_aktif`, `catatan`, `createdAt`, `updatedAt`) VALUES
(1, 'STORE-20250701-001', 'Toko Lombok', 'Jl, Bedugul Gang Yehning No 5, Sidakarya, Denpasar Selatan, Bali', '089562114522', '', 'Bobby', 1, 'Test toko baru', '2025-07-01 09:33:34', '2025-07-11 09:53:44'),
(2, 'STORE-20250701-002', 'Toko Surabaya', 'Jl, Raya Surabaya No 88', '089564221566', '', 'John Doe', 1, '', '2025-07-01 09:34:49', '2025-07-02 07:34:40'),
(3, 'STORE-20250701-003', 'Toko Jakarta', 'Jl, Raya Kalideres Nio 78', '089564225122', '', 'Sony', 1, '', '2025-07-01 09:35:45', '2025-07-11 06:15:19');

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `id` int(11) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `kontak` varchar(255) NOT NULL,
  `alamat` text DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `suppliers`
--

INSERT INTO `suppliers` (`id`, `nama`, `kontak`, `alamat`, `createdAt`, `updatedAt`) VALUES
(1, 'PT Cleo Jaya', '089545224562', 'Sidakarya, Denpasar Selatan', '2025-07-01 09:29:26', '2025-07-01 09:29:26'),
(2, 'PT Timun Jelita', '089564221587', 'Jl. Teuku Umar Barat No 66', '2025-07-01 09:29:49', '2025-07-01 09:29:49');

-- --------------------------------------------------------

--
-- Table structure for table `ukurans`
--

CREATE TABLE `ukurans` (
  `id` int(11) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `ukurans`
--

INSERT INTO `ukurans` (`id`, `nama`, `createdAt`, `updatedAt`) VALUES
(1, 'S', '2025-07-01 09:28:31', '2025-07-01 09:28:31'),
(2, 'M', '2025-07-01 09:28:33', '2025-07-01 09:28:33'),
(3, 'XL', '2025-07-01 09:28:36', '2025-07-01 09:28:36'),
(4, 'XXL', '2025-07-01 09:28:40', '2025-07-01 09:28:40');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','owner','staff_gudang','staff_sales') NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `storeId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`, `createdAt`, `updatedAt`, `storeId`) VALUES
(2, 'admin', '$2b$10$bf0pEktb1EgpvcCLZHsAIOsodhaFXW5DmpQZVu6Cu3YofpHgA8HkS', 'admin', '2025-07-01 09:26:44', '2025-07-01 09:26:44', NULL),
(3, 'doddy', '$2b$10$fI6Nwiuz1LoWatm85KH8buEQi4ZLrhTE0JFsq/IXylO9C9FlhMzKC', 'owner', '2025-07-01 09:45:59', '2025-07-03 11:23:06', NULL),
(4, 'bobby', '$2b$10$b9ulLjiJxprvLQcAQ1eCAONd5jS/w05HaqRDvkB/vTTvhmEucjivW', 'staff_sales', '2025-07-02 08:03:46', '2025-07-03 11:08:47', 3),
(5, 'john', '$2b$10$ncM2cQHDeTNgP2SM8dqNQ.uuKn6cqvH0/c5f.iJ8HZwCaL3ZvstEW', 'staff_sales', '2025-07-02 08:28:34', '2025-07-03 11:08:45', 1),
(6, 'marry', '$2b$10$PKNbgHqWQWML.oSO759UZeZY6E.E0758yHiEEES1/Fzdi6Ty7wtKC', 'staff_sales', '2025-07-02 08:37:21', '2025-07-03 11:08:42', 2),
(7, 'yono', '$2b$10$qFNMRa0N7O2plQ7ScC0kp.QdcAKja1Ob6R3bSspVOn/fvND2gvCry', 'staff_gudang', '2025-07-03 11:09:13', '2025-07-03 11:09:13', NULL),
(8, 'admin2', '$2b$10$nzaeYQbhjaWQW9fNbFprU.OauHXEAlnN8FqlDYOW7YA34WRK4n9Ai', 'admin', '2025-07-03 13:15:01', '2025-07-03 13:15:01', NULL),
(9, 'jenny', '$2b$10$1kXpzHAkixleH13YcXYiM.g4SeCYEyRBl2JsFyknqZ7wP82RKVpGe', 'staff_sales', '2025-07-14 07:09:53', '2025-07-14 07:10:12', 3),
(10, 'nomi', '$2b$10$hQkWXL8brR1fEvYsDXd5Wu9Tg7Nj2g.tRbKI2aaBiNBgaqmpWk.wu', 'staff_sales', '2025-07-14 09:50:11', '2025-07-14 09:50:11', 2);

-- --------------------------------------------------------

--
-- Table structure for table `warnas`
--

CREATE TABLE `warnas` (
  `id` int(11) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `warnas`
--

INSERT INTO `warnas` (`id`, `nama`, `createdAt`, `updatedAt`) VALUES
(1, 'Merah', '2025-07-01 09:28:46', '2025-07-01 09:28:46'),
(2, 'Hijau', '2025-07-01 09:28:50', '2025-07-01 09:28:50'),
(3, 'Putih', '2025-07-01 09:28:55', '2025-07-01 09:28:55'),
(4, 'Hitam', '2025-07-01 09:28:58', '2025-07-01 09:28:58'),
(5, 'Biru', '2025-07-01 09:29:01', '2025-07-01 09:29:01'),
(6, 'Kuning', '2025-07-01 09:29:04', '2025-07-01 09:29:04'),
(7, 'Abu', '2025-07-01 09:29:07', '2025-07-01 09:29:07');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `barangs`
--
ALTER TABLE `barangs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sku` (`sku`),
  ADD UNIQUE KEY `sku_2` (`sku`),
  ADD UNIQUE KEY `sku_3` (`sku`),
  ADD UNIQUE KEY `sku_4` (`sku`),
  ADD UNIQUE KEY `sku_5` (`sku`),
  ADD UNIQUE KEY `sku_6` (`sku`),
  ADD UNIQUE KEY `sku_7` (`sku`),
  ADD UNIQUE KEY `sku_8` (`sku`),
  ADD UNIQUE KEY `sku_9` (`sku`),
  ADD UNIQUE KEY `sku_10` (`sku`),
  ADD KEY `kategoriId` (`kategoriId`),
  ADD KEY `warnaId` (`warnaId`),
  ADD KEY `ukuranId` (`ukuranId`);

--
-- Indexes for table `companies`
--
ALTER TABLE `companies`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `expenses`
--
ALTER TABLE `expenses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `good_receipts`
--
ALTER TABLE `good_receipts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `kode` (`kode`),
  ADD UNIQUE KEY `kode_2` (`kode`),
  ADD UNIQUE KEY `kode_3` (`kode`),
  ADD UNIQUE KEY `kode_4` (`kode`),
  ADD UNIQUE KEY `kode_5` (`kode`),
  ADD UNIQUE KEY `kode_6` (`kode`),
  ADD UNIQUE KEY `kode_7` (`kode`),
  ADD UNIQUE KEY `kode_8` (`kode`),
  ADD UNIQUE KEY `kode_9` (`kode`),
  ADD UNIQUE KEY `kode_10` (`kode`),
  ADD KEY `purchaseOrderId` (`purchaseOrderId`);

--
-- Indexes for table `good_receipt_items`
--
ALTER TABLE `good_receipt_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `goodReceiptId` (`goodReceiptId`),
  ADD KEY `barangId` (`barangId`);

--
-- Indexes for table `kategoris`
--
ALTER TABLE `kategoris`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `userId` (`userId`);

--
-- Indexes for table `payment_methods`
--
ALTER TABLE `payment_methods`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nama` (`nama`),
  ADD UNIQUE KEY `nama_2` (`nama`);

--
-- Indexes for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `kode` (`kode`),
  ADD UNIQUE KEY `kode_2` (`kode`),
  ADD UNIQUE KEY `kode_3` (`kode`),
  ADD UNIQUE KEY `kode_4` (`kode`),
  ADD UNIQUE KEY `kode_5` (`kode`),
  ADD UNIQUE KEY `kode_6` (`kode`),
  ADD UNIQUE KEY `kode_7` (`kode`),
  ADD UNIQUE KEY `kode_8` (`kode`),
  ADD UNIQUE KEY `kode_9` (`kode`),
  ADD UNIQUE KEY `kode_10` (`kode`),
  ADD KEY `purchaseRequestId` (`purchaseRequestId`),
  ADD KEY `supplierId` (`supplierId`);

--
-- Indexes for table `purchase_order_items`
--
ALTER TABLE `purchase_order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `purchaseOrderId` (`purchaseOrderId`),
  ADD KEY `barangId` (`barangId`);

--
-- Indexes for table `purchase_requests`
--
ALTER TABLE `purchase_requests`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `kode` (`kode`),
  ADD UNIQUE KEY `kode_2` (`kode`),
  ADD UNIQUE KEY `kode_3` (`kode`),
  ADD UNIQUE KEY `kode_4` (`kode`),
  ADD UNIQUE KEY `kode_5` (`kode`),
  ADD UNIQUE KEY `kode_6` (`kode`),
  ADD UNIQUE KEY `kode_7` (`kode`),
  ADD UNIQUE KEY `kode_8` (`kode`),
  ADD UNIQUE KEY `kode_9` (`kode`),
  ADD UNIQUE KEY `kode_10` (`kode`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `approved_by` (`approved_by`);

--
-- Indexes for table `purchase_request_items`
--
ALTER TABLE `purchase_request_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `purchaseRequestId` (`purchaseRequestId`),
  ADD KEY `barangId` (`barangId`);

--
-- Indexes for table `purchase_returns`
--
ALTER TABLE `purchase_returns`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `kode` (`kode`),
  ADD UNIQUE KEY `kode_2` (`kode`),
  ADD UNIQUE KEY `kode_3` (`kode`),
  ADD UNIQUE KEY `kode_4` (`kode`),
  ADD UNIQUE KEY `kode_5` (`kode`),
  ADD UNIQUE KEY `kode_6` (`kode`),
  ADD UNIQUE KEY `kode_7` (`kode`),
  ADD UNIQUE KEY `kode_8` (`kode`),
  ADD UNIQUE KEY `kode_9` (`kode`),
  ADD UNIQUE KEY `kode_10` (`kode`),
  ADD KEY `goodReceiptId` (`goodReceiptId`);

--
-- Indexes for table `purchase_return_items`
--
ALTER TABLE `purchase_return_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `purchaseReturnId` (`purchaseReturnId`),
  ADD KEY `barangId` (`barangId`);

--
-- Indexes for table `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `kode` (`kode`),
  ADD UNIQUE KEY `kode_2` (`kode`),
  ADD UNIQUE KEY `kode_3` (`kode`),
  ADD UNIQUE KEY `kode_4` (`kode`),
  ADD UNIQUE KEY `kode_5` (`kode`),
  ADD UNIQUE KEY `kode_6` (`kode`),
  ADD UNIQUE KEY `kode_7` (`kode`),
  ADD UNIQUE KEY `kode_8` (`kode`),
  ADD UNIQUE KEY `kode_9` (`kode`),
  ADD UNIQUE KEY `kode_10` (`kode`),
  ADD KEY `userId` (`userId`),
  ADD KEY `storeId` (`storeId`),
  ADD KEY `paymentMethodId` (`paymentMethodId`);

--
-- Indexes for table `sale_items`
--
ALTER TABLE `sale_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `saleId` (`saleId`),
  ADD KEY `barangId` (`barangId`);

--
-- Indexes for table `sale_returns`
--
ALTER TABLE `sale_returns`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `kode` (`kode`),
  ADD UNIQUE KEY `kode_2` (`kode`),
  ADD UNIQUE KEY `kode_3` (`kode`),
  ADD UNIQUE KEY `kode_4` (`kode`),
  ADD UNIQUE KEY `kode_5` (`kode`),
  ADD UNIQUE KEY `kode_6` (`kode`),
  ADD UNIQUE KEY `kode_7` (`kode`),
  ADD UNIQUE KEY `kode_8` (`kode`),
  ADD UNIQUE KEY `kode_9` (`kode`),
  ADD UNIQUE KEY `kode_10` (`kode`),
  ADD KEY `saleId` (`saleId`),
  ADD KEY `userId` (`userId`),
  ADD KEY `storeId` (`storeId`),
  ADD KEY `refundMethodId` (`refundMethodId`);

--
-- Indexes for table `sale_return_items`
--
ALTER TABLE `sale_return_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `saleReturnId` (`saleReturnId`),
  ADD KEY `barangId` (`barangId`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`sid`);

--
-- Indexes for table `stock_gudang_pusat`
--
ALTER TABLE `stock_gudang_pusat`
  ADD PRIMARY KEY (`id`),
  ADD KEY `barangId` (`barangId`);

--
-- Indexes for table `stock_gudang_toko`
--
ALTER TABLE `stock_gudang_toko`
  ADD PRIMARY KEY (`id`),
  ADD KEY `barangId` (`barangId`),
  ADD KEY `storeId` (`storeId`);

--
-- Indexes for table `stock_requests`
--
ALTER TABLE `stock_requests`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `kode` (`kode`),
  ADD UNIQUE KEY `kode_2` (`kode`),
  ADD UNIQUE KEY `kode_3` (`kode`),
  ADD UNIQUE KEY `kode_4` (`kode`),
  ADD UNIQUE KEY `kode_5` (`kode`),
  ADD UNIQUE KEY `kode_6` (`kode`),
  ADD UNIQUE KEY `kode_7` (`kode`),
  ADD UNIQUE KEY `kode_8` (`kode`),
  ADD UNIQUE KEY `kode_9` (`kode`),
  ADD UNIQUE KEY `kode_10` (`kode`),
  ADD KEY `toStoreId` (`toStoreId`);

--
-- Indexes for table `stock_request_items`
--
ALTER TABLE `stock_request_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `stockRequestId` (`stockRequestId`),
  ADD KEY `barangId` (`barangId`);

--
-- Indexes for table `stock_transfers`
--
ALTER TABLE `stock_transfers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `kode` (`kode`),
  ADD UNIQUE KEY `kode_2` (`kode`),
  ADD UNIQUE KEY `kode_3` (`kode`),
  ADD UNIQUE KEY `kode_4` (`kode`),
  ADD UNIQUE KEY `kode_5` (`kode`),
  ADD UNIQUE KEY `kode_6` (`kode`),
  ADD UNIQUE KEY `kode_7` (`kode`),
  ADD UNIQUE KEY `kode_8` (`kode`),
  ADD UNIQUE KEY `kode_9` (`kode`),
  ADD UNIQUE KEY `kode_10` (`kode`),
  ADD KEY `stockRequestId` (`stockRequestId`),
  ADD KEY `storeId` (`storeId`);

--
-- Indexes for table `stock_transfer_items`
--
ALTER TABLE `stock_transfer_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `stockTransferId` (`stockTransferId`),
  ADD KEY `barangId` (`barangId`);

--
-- Indexes for table `stores`
--
ALTER TABLE `stores`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `kode` (`kode`),
  ADD UNIQUE KEY `kode_2` (`kode`),
  ADD UNIQUE KEY `kode_3` (`kode`),
  ADD UNIQUE KEY `kode_4` (`kode`),
  ADD UNIQUE KEY `kode_5` (`kode`),
  ADD UNIQUE KEY `kode_6` (`kode`),
  ADD UNIQUE KEY `kode_7` (`kode`),
  ADD UNIQUE KEY `kode_8` (`kode`),
  ADD UNIQUE KEY `kode_9` (`kode`),
  ADD UNIQUE KEY `kode_10` (`kode`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ukurans`
--
ALTER TABLE `ukurans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `username_2` (`username`),
  ADD UNIQUE KEY `username_3` (`username`),
  ADD UNIQUE KEY `username_4` (`username`),
  ADD UNIQUE KEY `username_5` (`username`),
  ADD UNIQUE KEY `username_6` (`username`),
  ADD UNIQUE KEY `username_7` (`username`),
  ADD UNIQUE KEY `username_8` (`username`),
  ADD UNIQUE KEY `username_9` (`username`),
  ADD UNIQUE KEY `username_10` (`username`),
  ADD KEY `storeId` (`storeId`);

--
-- Indexes for table `warnas`
--
ALTER TABLE `warnas`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `barangs`
--
ALTER TABLE `barangs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `companies`
--
ALTER TABLE `companies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `expenses`
--
ALTER TABLE `expenses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `good_receipts`
--
ALTER TABLE `good_receipts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `good_receipt_items`
--
ALTER TABLE `good_receipt_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `kategoris`
--
ALTER TABLE `kategoris`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42004;

--
-- AUTO_INCREMENT for table `payment_methods`
--
ALTER TABLE `payment_methods`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `purchase_order_items`
--
ALTER TABLE `purchase_order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `purchase_requests`
--
ALTER TABLE `purchase_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `purchase_request_items`
--
ALTER TABLE `purchase_request_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `purchase_returns`
--
ALTER TABLE `purchase_returns`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `purchase_return_items`
--
ALTER TABLE `purchase_return_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `sales`
--
ALTER TABLE `sales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `sale_items`
--
ALTER TABLE `sale_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `sale_returns`
--
ALTER TABLE `sale_returns`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `sale_return_items`
--
ALTER TABLE `sale_return_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `stock_gudang_pusat`
--
ALTER TABLE `stock_gudang_pusat`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `stock_gudang_toko`
--
ALTER TABLE `stock_gudang_toko`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `stock_requests`
--
ALTER TABLE `stock_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `stock_request_items`
--
ALTER TABLE `stock_request_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `stock_transfers`
--
ALTER TABLE `stock_transfers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `stock_transfer_items`
--
ALTER TABLE `stock_transfer_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `stores`
--
ALTER TABLE `stores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `ukurans`
--
ALTER TABLE `ukurans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `warnas`
--
ALTER TABLE `warnas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `barangs`
--
ALTER TABLE `barangs`
  ADD CONSTRAINT `barangs_ibfk_28` FOREIGN KEY (`kategoriId`) REFERENCES `kategoris` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `barangs_ibfk_29` FOREIGN KEY (`warnaId`) REFERENCES `warnas` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `barangs_ibfk_30` FOREIGN KEY (`ukuranId`) REFERENCES `ukurans` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `good_receipts`
--
ALTER TABLE `good_receipts`
  ADD CONSTRAINT `good_receipts_ibfk_1` FOREIGN KEY (`purchaseOrderId`) REFERENCES `purchase_orders` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `good_receipt_items`
--
ALTER TABLE `good_receipt_items`
  ADD CONSTRAINT `good_receipt_items_ibfk_19` FOREIGN KEY (`goodReceiptId`) REFERENCES `good_receipts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `good_receipt_items_ibfk_20` FOREIGN KEY (`barangId`) REFERENCES `barangs` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `logs`
--
ALTER TABLE `logs`
  ADD CONSTRAINT `logs_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  ADD CONSTRAINT `purchase_orders_ibfk_19` FOREIGN KEY (`purchaseRequestId`) REFERENCES `purchase_requests` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `purchase_orders_ibfk_20` FOREIGN KEY (`supplierId`) REFERENCES `suppliers` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `purchase_order_items`
--
ALTER TABLE `purchase_order_items`
  ADD CONSTRAINT `purchase_order_items_ibfk_19` FOREIGN KEY (`purchaseOrderId`) REFERENCES `purchase_orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `purchase_order_items_ibfk_20` FOREIGN KEY (`barangId`) REFERENCES `barangs` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `purchase_requests`
--
ALTER TABLE `purchase_requests`
  ADD CONSTRAINT `purchase_requests_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `purchase_requests_ibfk_2` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `purchase_request_items`
--
ALTER TABLE `purchase_request_items`
  ADD CONSTRAINT `purchase_request_items_ibfk_19` FOREIGN KEY (`purchaseRequestId`) REFERENCES `purchase_requests` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `purchase_request_items_ibfk_20` FOREIGN KEY (`barangId`) REFERENCES `barangs` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `purchase_returns`
--
ALTER TABLE `purchase_returns`
  ADD CONSTRAINT `purchase_returns_ibfk_1` FOREIGN KEY (`goodReceiptId`) REFERENCES `good_receipts` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `purchase_return_items`
--
ALTER TABLE `purchase_return_items`
  ADD CONSTRAINT `purchase_return_items_ibfk_19` FOREIGN KEY (`purchaseReturnId`) REFERENCES `purchase_returns` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `purchase_return_items_ibfk_20` FOREIGN KEY (`barangId`) REFERENCES `barangs` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `sales_ibfk_21` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `sales_ibfk_22` FOREIGN KEY (`storeId`) REFERENCES `stores` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sales_ibfk_23` FOREIGN KEY (`paymentMethodId`) REFERENCES `payment_methods` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `sale_items`
--
ALTER TABLE `sale_items`
  ADD CONSTRAINT `sale_items_ibfk_19` FOREIGN KEY (`saleId`) REFERENCES `sales` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sale_items_ibfk_20` FOREIGN KEY (`barangId`) REFERENCES `barangs` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `sale_returns`
--
ALTER TABLE `sale_returns`
  ADD CONSTRAINT `sale_returns_ibfk_29` FOREIGN KEY (`saleId`) REFERENCES `sales` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `sale_returns_ibfk_30` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `sale_returns_ibfk_31` FOREIGN KEY (`storeId`) REFERENCES `stores` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sale_returns_ibfk_32` FOREIGN KEY (`refundMethodId`) REFERENCES `payment_methods` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `sale_return_items`
--
ALTER TABLE `sale_return_items`
  ADD CONSTRAINT `sale_return_items_ibfk_19` FOREIGN KEY (`saleReturnId`) REFERENCES `sale_returns` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sale_return_items_ibfk_20` FOREIGN KEY (`barangId`) REFERENCES `barangs` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `stock_gudang_pusat`
--
ALTER TABLE `stock_gudang_pusat`
  ADD CONSTRAINT `stock_gudang_pusat_ibfk_1` FOREIGN KEY (`barangId`) REFERENCES `barangs` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `stock_gudang_toko`
--
ALTER TABLE `stock_gudang_toko`
  ADD CONSTRAINT `stock_gudang_toko_ibfk_19` FOREIGN KEY (`barangId`) REFERENCES `barangs` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `stock_gudang_toko_ibfk_20` FOREIGN KEY (`storeId`) REFERENCES `stores` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `stock_requests`
--
ALTER TABLE `stock_requests`
  ADD CONSTRAINT `stock_requests_ibfk_1` FOREIGN KEY (`toStoreId`) REFERENCES `stores` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `stock_request_items`
--
ALTER TABLE `stock_request_items`
  ADD CONSTRAINT `stock_request_items_ibfk_19` FOREIGN KEY (`stockRequestId`) REFERENCES `stock_requests` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `stock_request_items_ibfk_20` FOREIGN KEY (`barangId`) REFERENCES `barangs` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `stock_transfers`
--
ALTER TABLE `stock_transfers`
  ADD CONSTRAINT `stock_transfers_ibfk_19` FOREIGN KEY (`stockRequestId`) REFERENCES `stock_requests` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `stock_transfers_ibfk_20` FOREIGN KEY (`storeId`) REFERENCES `stores` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `stock_transfer_items`
--
ALTER TABLE `stock_transfer_items`
  ADD CONSTRAINT `stock_transfer_items_ibfk_19` FOREIGN KEY (`stockTransferId`) REFERENCES `stock_transfers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `stock_transfer_items_ibfk_20` FOREIGN KEY (`barangId`) REFERENCES `barangs` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`storeId`) REFERENCES `stores` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
