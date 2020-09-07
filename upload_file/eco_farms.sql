-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 12, 2020 at 06:10 AM
-- Server version: 10.4.13-MariaDB
-- PHP Version: 7.4.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `eco_farms`
--

DELIMITER $$
--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `get_url_path_of_category` (`categoryId` INT, `localeCode` VARCHAR(255)) RETURNS VARCHAR(255) CHARSET utf8mb4 BEGIN

                DECLARE urlPath VARCHAR(255);

                IF NOT EXISTS (
                    SELECT id
                    FROM categories
                    WHERE
                        id = categoryId
                        AND parent_id IS NULL
                )
                THEN
                    SELECT
                        GROUP_CONCAT(parent_translations.slug SEPARATOR '/') INTO urlPath
                    FROM
                        categories AS node,
                        categories AS parent
                        JOIN category_translations AS parent_translations ON parent.id = parent_translations.category_id
                    WHERE
                        node._lft >= parent._lft
                        AND node._rgt <= parent._rgt
                        AND node.id = categoryId
                        AND node.parent_id IS NOT NULL
                        AND parent.parent_id IS NOT NULL
                        AND parent_translations.locale = localeCode
                    GROUP BY
                        node.id;

                    IF urlPath IS NULL
                    THEN
                        SET urlPath = (SELECT slug FROM category_translations WHERE category_translations.category_id = categoryId);
                    END IF;
                 ELSE
                    SET urlPath = '';
                 END IF;

                 RETURN urlPath;
            END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `addresses`
--

CREATE TABLE `addresses` (
  `id` int(10) UNSIGNED NOT NULL,
  `address_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `customer_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'null if guest checkout',
  `cart_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'only for cart_addresses',
  `order_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'only for order_addresses',
  `first_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `gender` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `company_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address1` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address2` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `postcode` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vat_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `default_address` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'only for customer_addresses',
  `additional` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`additional`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `api_token` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `role_id` int(10) UNSIGNED NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `name`, `email`, `password`, `api_token`, `status`, `role_id`, `remember_token`, `created_at`, `updated_at`) VALUES
(2, 'Ameer', 'spameer.bd@gmail.com', '$2y$10$3TBKdLGHaoUsyshqdeWy/OSt4iAXlLboYnZ4LGAZHggv6uhBiwtAm', NULL, 1, 1, NULL, NULL, NULL),
(3, 'Abir', 'abirabdur249@gmail.com', '$2y$10$NGhuvm2b0e1d/TcTEnmtzOMG1zXGIctQIeUwimm9Bc9lA6FG.QDk6', 'NjozmhPkFk0nku7AwTP4bYmge6WX3jdoBVP7G8zTpvVZzNNvj7G4xWDX3cMYnIHLuqkubzsqiF6kCWcn', 1, 2, NULL, '2020-07-20 09:39:20', '2020-07-20 09:41:20');

-- --------------------------------------------------------

--
-- Table structure for table `admin_password_resets`
--

CREATE TABLE `admin_password_resets` (
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `attributes`
--

CREATE TABLE `attributes` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `admin_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `validation` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `is_required` tinyint(1) NOT NULL DEFAULT 0,
  `is_unique` tinyint(1) NOT NULL DEFAULT 0,
  `value_per_locale` tinyint(1) NOT NULL DEFAULT 0,
  `value_per_channel` tinyint(1) NOT NULL DEFAULT 0,
  `is_filterable` tinyint(1) NOT NULL DEFAULT 0,
  `is_configurable` tinyint(1) NOT NULL DEFAULT 0,
  `is_user_defined` tinyint(1) NOT NULL DEFAULT 1,
  `is_visible_on_front` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `swatch_type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `use_in_flat` tinyint(1) NOT NULL DEFAULT 1,
  `is_comparable` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `attributes`
--

INSERT INTO `attributes` (`id`, `code`, `admin_name`, `type`, `validation`, `position`, `is_required`, `is_unique`, `value_per_locale`, `value_per_channel`, `is_filterable`, `is_configurable`, `is_user_defined`, `is_visible_on_front`, `created_at`, `updated_at`, `swatch_type`, `use_in_flat`, `is_comparable`) VALUES
(1, 'sku', 'SKU', 'text', NULL, 1, 1, 1, 0, 0, 0, 0, 0, 0, '2020-07-20 08:43:17', '2020-07-20 08:43:17', NULL, 1, 0),
(2, 'name', 'Name', 'text', NULL, 2, 1, 0, 1, 1, 0, 0, 0, 0, '2020-07-20 08:43:17', '2020-07-20 08:43:17', NULL, 1, 1),
(3, 'url_key', 'URL Key', 'text', NULL, 3, 1, 1, 0, 0, 0, 0, 0, 0, '2020-07-20 08:43:17', '2020-07-20 08:43:17', NULL, 1, 0),
(4, 'tax_category_id', 'Tax Category', 'select', NULL, 4, 0, 0, 0, 1, 0, 0, 0, 0, '2020-07-20 08:43:17', '2020-07-20 08:43:17', NULL, 1, 0),
(5, 'new', 'New', 'boolean', NULL, 5, 0, 0, 0, 0, 0, 0, 0, 0, '2020-07-20 08:43:17', '2020-07-20 08:43:17', NULL, 1, 0),
(6, 'featured', 'Featured', 'boolean', NULL, 6, 0, 0, 0, 0, 0, 0, 0, 0, '2020-07-20 08:43:17', '2020-07-20 08:43:17', NULL, 1, 0),
(7, 'visible_individually', 'Visible Individually', 'boolean', NULL, 7, 1, 0, 0, 0, 0, 0, 0, 0, '2020-07-20 08:43:17', '2020-07-20 08:43:17', NULL, 1, 0),
(8, 'status', 'Status', 'boolean', NULL, 8, 1, 0, 0, 0, 0, 0, 0, 0, '2020-07-20 08:43:17', '2020-07-20 08:43:17', NULL, 1, 0),
(9, 'short_description', 'Short Description', 'textarea', NULL, 9, 1, 0, 1, 1, 0, 0, 0, 0, '2020-07-20 08:43:17', '2020-07-20 08:43:17', NULL, 1, 0),
(10, 'description', 'Description', 'textarea', NULL, 10, 1, 0, 1, 1, 0, 0, 0, 0, '2020-07-20 08:43:17', '2020-07-20 08:43:17', NULL, 1, 1),
(11, 'price', 'Price', 'price', 'decimal', 11, 1, 0, 0, 0, 1, 0, 0, 0, '2020-07-20 08:43:17', '2020-07-20 08:43:17', NULL, 1, 1),
(12, 'cost', 'Cost', 'price', 'decimal', 12, 0, 0, 0, 1, 0, 0, 1, 0, '2020-07-20 08:43:17', '2020-07-20 08:43:17', NULL, 1, 0),
(13, 'special_price', 'Special Price', 'price', 'decimal', 13, 0, 0, 0, 0, 0, 0, 0, 0, '2020-07-20 08:43:17', '2020-07-20 08:43:17', NULL, 1, 0),
(14, 'special_price_from', 'Special Price From', 'date', NULL, 14, 0, 0, 0, 1, 0, 0, 0, 0, '2020-07-20 08:43:17', '2020-07-20 08:43:17', NULL, 1, 0),
(15, 'special_price_to', 'Special Price To', 'date', NULL, 15, 0, 0, 0, 1, 0, 0, 0, 0, '2020-07-20 08:43:17', '2020-07-20 08:43:17', NULL, 1, 0),
(16, 'meta_title', 'Meta Title', 'textarea', NULL, 16, 0, 0, 1, 1, 0, 0, 0, 0, '2020-07-20 08:43:17', '2020-07-20 08:43:17', NULL, 1, 0),
(17, 'meta_keywords', 'Meta Keywords', 'textarea', NULL, 17, 0, 0, 1, 1, 0, 0, 0, 0, '2020-07-20 08:43:17', '2020-07-20 08:43:17', NULL, 1, 0),
(18, 'meta_description', 'Meta Description', 'textarea', NULL, 18, 0, 0, 1, 1, 0, 0, 1, 0, '2020-07-20 08:43:17', '2020-07-20 08:43:17', NULL, 1, 0),
(19, 'width', 'Width', 'text', 'decimal', 19, 0, 0, 0, 0, 0, 0, 1, 0, '2020-07-20 08:43:17', '2020-07-20 08:43:17', NULL, 1, 0),
(20, 'height', 'Height', 'text', 'decimal', 20, 0, 0, 0, 0, 0, 0, 1, 0, '2020-07-20 08:43:17', '2020-07-20 08:43:17', NULL, 1, 0),
(21, 'depth', 'Depth', 'text', 'decimal', 21, 0, 0, 0, 0, 0, 0, 1, 0, '2020-07-20 08:43:17', '2020-07-20 08:43:17', NULL, 1, 0),
(22, 'weight', 'Weight', 'text', 'decimal', 22, 1, 0, 0, 0, 0, 0, 0, 0, '2020-07-20 08:43:17', '2020-07-20 08:43:17', NULL, 1, 0),
(23, 'color', 'Color', 'select', NULL, 23, 0, 0, 0, 0, 1, 1, 1, 0, '2020-07-20 08:43:17', '2020-07-20 08:43:17', NULL, 1, 0),
(24, 'size', 'Size', 'select', NULL, 24, 0, 0, 0, 0, 1, 1, 1, 0, '2020-07-20 08:43:17', '2020-07-20 08:43:17', NULL, 1, 0),
(25, 'brand', 'Brand', 'select', NULL, 25, 0, 0, 0, 0, 1, 0, 0, 1, '2020-07-20 08:43:17', '2020-07-20 08:43:17', NULL, 1, 0),
(26, 'guest_checkout', 'Guest Checkout', 'boolean', NULL, 8, 1, 0, 0, 0, 0, 0, 0, 0, '2020-07-20 08:43:17', '2020-07-20 08:43:17', NULL, 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `attribute_families`
--

CREATE TABLE `attribute_families` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `is_user_defined` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `attribute_families`
--

INSERT INTO `attribute_families` (`id`, `code`, `name`, `status`, `is_user_defined`) VALUES
(1, 'default', 'Default', 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `attribute_groups`
--

CREATE TABLE `attribute_groups` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `position` int(11) NOT NULL,
  `is_user_defined` tinyint(1) NOT NULL DEFAULT 1,
  `attribute_family_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `attribute_groups`
--

INSERT INTO `attribute_groups` (`id`, `name`, `position`, `is_user_defined`, `attribute_family_id`) VALUES
(1, 'General', 1, 0, 1),
(2, 'Description', 2, 0, 1),
(3, 'Meta Description', 3, 0, 1),
(4, 'Price', 4, 0, 1),
(5, 'Shipping', 5, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `attribute_group_mappings`
--

CREATE TABLE `attribute_group_mappings` (
  `attribute_id` int(10) UNSIGNED NOT NULL,
  `attribute_group_id` int(10) UNSIGNED NOT NULL,
  `position` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `attribute_group_mappings`
--

INSERT INTO `attribute_group_mappings` (`attribute_id`, `attribute_group_id`, `position`) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 1, 3),
(4, 1, 4),
(5, 1, 5),
(6, 1, 6),
(7, 1, 7),
(8, 1, 8),
(9, 2, 1),
(10, 2, 2),
(11, 4, 1),
(12, 4, 2),
(13, 4, 3),
(14, 4, 4),
(15, 4, 5),
(16, 3, 1),
(17, 3, 2),
(18, 3, 3),
(19, 5, 1),
(20, 5, 2),
(21, 5, 3),
(22, 5, 4),
(23, 1, 10),
(24, 1, 11),
(25, 1, 12),
(26, 1, 9);

-- --------------------------------------------------------

--
-- Table structure for table `attribute_options`
--

CREATE TABLE `attribute_options` (
  `id` int(10) UNSIGNED NOT NULL,
  `admin_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `attribute_id` int(10) UNSIGNED NOT NULL,
  `swatch_value` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `attribute_options`
--

INSERT INTO `attribute_options` (`id`, `admin_name`, `sort_order`, `attribute_id`, `swatch_value`) VALUES
(1, 'Red', 1, 23, NULL),
(2, 'Green', 2, 23, NULL),
(3, 'Yellow', 3, 23, NULL),
(4, 'Black', 4, 23, NULL),
(5, 'White', 5, 23, NULL),
(6, 'S', 1, 24, NULL),
(7, 'M', 2, 24, NULL),
(8, 'L', 3, 24, NULL),
(9, 'XL', 4, 24, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `attribute_option_translations`
--

CREATE TABLE `attribute_option_translations` (
  `id` int(10) UNSIGNED NOT NULL,
  `locale` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `attribute_option_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `attribute_option_translations`
--

INSERT INTO `attribute_option_translations` (`id`, `locale`, `label`, `attribute_option_id`) VALUES
(1, 'en', 'Red', 1),
(2, 'en', 'Green', 2),
(3, 'en', 'Yellow', 3),
(4, 'en', 'Black', 4),
(5, 'en', 'White', 5),
(6, 'en', 'S', 6),
(7, 'en', 'M', 7),
(8, 'en', 'L', 8),
(9, 'en', 'XL', 9);

-- --------------------------------------------------------

--
-- Table structure for table `attribute_translations`
--

CREATE TABLE `attribute_translations` (
  `id` int(10) UNSIGNED NOT NULL,
  `locale` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `attribute_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `attribute_translations`
--

INSERT INTO `attribute_translations` (`id`, `locale`, `name`, `attribute_id`) VALUES
(1, 'en', 'SKU', 1),
(2, 'en', 'Name', 2),
(3, 'en', 'URL Key', 3),
(4, 'en', 'Tax Category', 4),
(5, 'en', 'New', 5),
(6, 'en', 'Featured', 6),
(7, 'en', 'Visible Individually', 7),
(8, 'en', 'Status', 8),
(9, 'en', 'Short Description', 9),
(10, 'en', 'Description', 10),
(11, 'en', 'Price', 11),
(12, 'en', 'Cost', 12),
(13, 'en', 'Special Price', 13),
(14, 'en', 'Special Price From', 14),
(15, 'en', 'Special Price To', 15),
(16, 'en', 'Meta Description', 16),
(17, 'en', 'Meta Keywords', 17),
(18, 'en', 'Meta Description', 18),
(19, 'en', 'Width', 19),
(20, 'en', 'Height', 20),
(21, 'en', 'Depth', 21),
(22, 'en', 'Weight', 22),
(23, 'en', 'Color', 23),
(24, 'en', 'Size', 24),
(25, 'en', 'Brand', 25),
(26, 'en', 'Allow Guest Checkout', 26);

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `qty` int(11) DEFAULT 0,
  `from` int(11) DEFAULT NULL,
  `to` int(11) DEFAULT NULL,
  `order_item_id` int(10) UNSIGNED DEFAULT NULL,
  `booking_product_event_ticket_id` int(10) UNSIGNED DEFAULT NULL,
  `order_id` int(10) UNSIGNED DEFAULT NULL,
  `product_id` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `booking_products`
--

CREATE TABLE `booking_products` (
  `id` int(10) UNSIGNED NOT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `qty` int(11) DEFAULT 0,
  `location` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `show_location` tinyint(1) NOT NULL DEFAULT 0,
  `available_every_week` tinyint(1) DEFAULT NULL,
  `available_from` datetime DEFAULT NULL,
  `available_to` datetime DEFAULT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `booking_product_appointment_slots`
--

CREATE TABLE `booking_product_appointment_slots` (
  `id` int(10) UNSIGNED NOT NULL,
  `duration` int(11) DEFAULT NULL,
  `break_time` int(11) DEFAULT NULL,
  `same_slot_all_days` tinyint(1) DEFAULT NULL,
  `slots` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`slots`)),
  `booking_product_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `booking_product_default_slots`
--

CREATE TABLE `booking_product_default_slots` (
  `id` int(10) UNSIGNED NOT NULL,
  `booking_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `duration` int(11) DEFAULT NULL,
  `break_time` int(11) DEFAULT NULL,
  `slots` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`slots`)),
  `booking_product_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `booking_product_event_tickets`
--

CREATE TABLE `booking_product_event_tickets` (
  `id` int(10) UNSIGNED NOT NULL,
  `price` decimal(12,4) DEFAULT 0.0000,
  `qty` int(11) DEFAULT 0,
  `booking_product_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `booking_product_event_ticket_translations`
--

CREATE TABLE `booking_product_event_ticket_translations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `locale` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `booking_product_event_ticket_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `booking_product_rental_slots`
--

CREATE TABLE `booking_product_rental_slots` (
  `id` int(10) UNSIGNED NOT NULL,
  `renting_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `daily_price` decimal(12,4) DEFAULT 0.0000,
  `hourly_price` decimal(12,4) DEFAULT 0.0000,
  `same_slot_all_days` tinyint(1) DEFAULT NULL,
  `slots` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`slots`)),
  `booking_product_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `booking_product_table_slots`
--

CREATE TABLE `booking_product_table_slots` (
  `id` int(10) UNSIGNED NOT NULL,
  `price_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `guest_limit` int(11) NOT NULL DEFAULT 0,
  `duration` int(11) NOT NULL,
  `break_time` int(11) NOT NULL,
  `prevent_scheduling_before` int(11) NOT NULL,
  `same_slot_all_days` tinyint(1) DEFAULT NULL,
  `slots` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`slots`)),
  `booking_product_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id` int(10) UNSIGNED NOT NULL,
  `customer_email` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_first_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_last_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipping_method` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `coupon_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_gift` tinyint(1) NOT NULL DEFAULT 0,
  `items_count` int(11) DEFAULT NULL,
  `items_qty` decimal(12,4) DEFAULT NULL,
  `exchange_rate` decimal(12,4) DEFAULT NULL,
  `global_currency_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `base_currency_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `channel_currency_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cart_currency_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `grand_total` decimal(12,4) DEFAULT 0.0000,
  `base_grand_total` decimal(12,4) DEFAULT 0.0000,
  `sub_total` decimal(12,4) DEFAULT 0.0000,
  `base_sub_total` decimal(12,4) DEFAULT 0.0000,
  `tax_total` decimal(12,4) DEFAULT 0.0000,
  `base_tax_total` decimal(12,4) DEFAULT 0.0000,
  `discount_amount` decimal(12,4) DEFAULT 0.0000,
  `base_discount_amount` decimal(12,4) DEFAULT 0.0000,
  `checkout_method` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_guest` tinyint(1) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `conversion_time` datetime DEFAULT NULL,
  `customer_id` int(10) UNSIGNED DEFAULT NULL,
  `channel_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `applied_cart_rule_ids` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `cart_items`
--

CREATE TABLE `cart_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `quantity` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `sku` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `coupon_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `weight` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `total_weight` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_total_weight` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `price` decimal(12,4) NOT NULL DEFAULT 1.0000,
  `base_price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `total` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_total` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `tax_percent` decimal(12,4) DEFAULT 0.0000,
  `tax_amount` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount` decimal(12,4) DEFAULT 0.0000,
  `discount_percent` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `discount_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_discount_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `additional` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`additional`)),
  `parent_id` int(10) UNSIGNED DEFAULT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `cart_id` int(10) UNSIGNED NOT NULL,
  `tax_category_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `custom_price` decimal(12,4) DEFAULT NULL,
  `applied_cart_rule_ids` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `cart_item_inventories`
--

CREATE TABLE `cart_item_inventories` (
  `id` int(10) UNSIGNED NOT NULL,
  `qty` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `inventory_source_id` int(10) UNSIGNED DEFAULT NULL,
  `cart_item_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `cart_payment`
--

CREATE TABLE `cart_payment` (
  `id` int(10) UNSIGNED NOT NULL,
  `method` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `method_title` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cart_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `cart_rules`
--

CREATE TABLE `cart_rules` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `starts_from` datetime DEFAULT NULL,
  `ends_till` datetime DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `coupon_type` int(11) NOT NULL DEFAULT 1,
  `use_auto_generation` tinyint(1) NOT NULL DEFAULT 0,
  `usage_per_customer` int(11) NOT NULL DEFAULT 0,
  `uses_per_coupon` int(11) NOT NULL DEFAULT 0,
  `times_used` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `condition_type` tinyint(1) NOT NULL DEFAULT 1,
  `conditions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`conditions`)),
  `end_other_rules` tinyint(1) NOT NULL DEFAULT 0,
  `uses_attribute_conditions` tinyint(1) NOT NULL DEFAULT 0,
  `action_type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `discount_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `discount_quantity` int(11) NOT NULL DEFAULT 1,
  `discount_step` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1',
  `apply_to_shipping` tinyint(1) NOT NULL DEFAULT 0,
  `free_shipping` tinyint(1) NOT NULL DEFAULT 0,
  `sort_order` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `cart_rule_channels`
--

CREATE TABLE `cart_rule_channels` (
  `cart_rule_id` int(10) UNSIGNED NOT NULL,
  `channel_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `cart_rule_coupons`
--

CREATE TABLE `cart_rule_coupons` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `usage_limit` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `usage_per_customer` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `times_used` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `type` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `is_primary` tinyint(1) NOT NULL DEFAULT 0,
  `expired_at` date DEFAULT NULL,
  `cart_rule_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `cart_rule_coupon_usage`
--

CREATE TABLE `cart_rule_coupon_usage` (
  `id` int(10) UNSIGNED NOT NULL,
  `times_used` int(11) NOT NULL DEFAULT 0,
  `cart_rule_coupon_id` int(10) UNSIGNED NOT NULL,
  `customer_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `cart_rule_customers`
--

CREATE TABLE `cart_rule_customers` (
  `id` int(10) UNSIGNED NOT NULL,
  `times_used` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `cart_rule_id` int(10) UNSIGNED NOT NULL,
  `customer_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `cart_rule_customer_groups`
--

CREATE TABLE `cart_rule_customer_groups` (
  `cart_rule_id` int(10) UNSIGNED NOT NULL,
  `customer_group_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `cart_rule_translations`
--

CREATE TABLE `cart_rule_translations` (
  `id` int(10) UNSIGNED NOT NULL,
  `locale` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cart_rule_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `cart_shipping_rates`
--

CREATE TABLE `cart_shipping_rates` (
  `id` int(10) UNSIGNED NOT NULL,
  `carrier` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `carrier_title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `method` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `method_title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `method_description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` double DEFAULT 0,
  `base_price` double DEFAULT 0,
  `cart_address_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `discount_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_discount_amount` decimal(12,4) NOT NULL DEFAULT 0.0000
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `catalog_rules`
--

CREATE TABLE `catalog_rules` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `starts_from` date DEFAULT NULL,
  `ends_till` date DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `condition_type` tinyint(1) NOT NULL DEFAULT 1,
  `conditions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`conditions`)),
  `end_other_rules` tinyint(1) NOT NULL DEFAULT 0,
  `action_type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `discount_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `sort_order` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `catalog_rule_channels`
--

CREATE TABLE `catalog_rule_channels` (
  `catalog_rule_id` int(10) UNSIGNED NOT NULL,
  `channel_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `catalog_rule_customer_groups`
--

CREATE TABLE `catalog_rule_customer_groups` (
  `catalog_rule_id` int(10) UNSIGNED NOT NULL,
  `customer_group_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `catalog_rule_products`
--

CREATE TABLE `catalog_rule_products` (
  `id` int(10) UNSIGNED NOT NULL,
  `starts_from` datetime DEFAULT NULL,
  `ends_till` datetime DEFAULT NULL,
  `end_other_rules` tinyint(1) NOT NULL DEFAULT 0,
  `action_type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `discount_amount` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `sort_order` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `product_id` int(10) UNSIGNED NOT NULL,
  `customer_group_id` int(10) UNSIGNED NOT NULL,
  `catalog_rule_id` int(10) UNSIGNED NOT NULL,
  `channel_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `catalog_rule_product_prices`
--

CREATE TABLE `catalog_rule_product_prices` (
  `id` int(10) UNSIGNED NOT NULL,
  `price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `rule_date` date NOT NULL,
  `starts_from` datetime DEFAULT NULL,
  `ends_till` datetime DEFAULT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `customer_group_id` int(10) UNSIGNED NOT NULL,
  `catalog_rule_id` int(10) UNSIGNED NOT NULL,
  `channel_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(10) UNSIGNED NOT NULL,
  `position` int(11) NOT NULL DEFAULT 0,
  `image` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `_lft` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `_rgt` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `parent_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `display_mode` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT 'products_and_description',
  `category_icon_path` text COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `position`, `image`, `status`, `_lft`, `_rgt`, `parent_id`, `created_at`, `updated_at`, `display_mode`, `category_icon_path`) VALUES
(1, 1, NULL, 1, 1, 14, NULL, '2020-07-20 08:43:13', '2020-07-20 08:43:13', 'products_and_description', NULL),
(2, 1, NULL, 1, 15, 16, NULL, '2020-07-20 09:16:36', '2020-07-20 09:16:36', 'products_only', NULL),
(3, 2, NULL, 1, 17, 18, NULL, '2020-07-20 09:17:17', '2020-07-20 09:17:17', 'products_only', NULL);

--
-- Triggers `categories`
--
DELIMITER $$
CREATE TRIGGER `trig_categories_insert` AFTER INSERT ON `categories` FOR EACH ROW BEGIN
                            DECLARE urlPath VARCHAR(255);
            DECLARE localeCode VARCHAR(255);
            DECLARE done INT;
            DECLARE curs CURSOR FOR (SELECT category_translations.locale
                    FROM category_translations
                    WHERE category_id = NEW.id);
            DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;


            IF EXISTS (
                SELECT *
                FROM category_translations
                WHERE category_id = NEW.id
            )
            THEN

                OPEN curs;

            	SET done = 0;
                REPEAT
                	FETCH curs INTO localeCode;

                    SELECT get_url_path_of_category(NEW.id, localeCode) INTO urlPath;

                    IF NEW.parent_id IS NULL
                    THEN
                        SET urlPath = '';
                    END IF;

                    UPDATE category_translations
                    SET url_path = urlPath
                    WHERE
                        category_translations.category_id = NEW.id
                        AND category_translations.locale = localeCode;

                UNTIL done END REPEAT;

                CLOSE curs;

            END IF;
            END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trig_categories_update` AFTER UPDATE ON `categories` FOR EACH ROW BEGIN
                            DECLARE urlPath VARCHAR(255);
            DECLARE localeCode VARCHAR(255);
            DECLARE done INT;
            DECLARE curs CURSOR FOR (SELECT category_translations.locale
                    FROM category_translations
                    WHERE category_id = NEW.id);
            DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;


            IF EXISTS (
                SELECT *
                FROM category_translations
                WHERE category_id = NEW.id
            )
            THEN

                OPEN curs;

            	SET done = 0;
                REPEAT
                	FETCH curs INTO localeCode;

                    SELECT get_url_path_of_category(NEW.id, localeCode) INTO urlPath;

                    IF NEW.parent_id IS NULL
                    THEN
                        SET urlPath = '';
                    END IF;

                    UPDATE category_translations
                    SET url_path = urlPath
                    WHERE
                        category_translations.category_id = NEW.id
                        AND category_translations.locale = localeCode;

                UNTIL done END REPEAT;

                CLOSE curs;

            END IF;
            END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `category_filterable_attributes`
--

CREATE TABLE `category_filterable_attributes` (
  `category_id` int(10) UNSIGNED NOT NULL,
  `attribute_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `category_filterable_attributes`
--

INSERT INTO `category_filterable_attributes` (`category_id`, `attribute_id`) VALUES
(2, 11),
(3, 11);

-- --------------------------------------------------------

--
-- Table structure for table `category_translations`
--

CREATE TABLE `category_translations` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_title` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_keywords` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category_id` int(10) UNSIGNED NOT NULL,
  `locale` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `locale_id` int(10) UNSIGNED DEFAULT NULL,
  `url_path` varchar(2048) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'maintained by database triggers'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `category_translations`
--

INSERT INTO `category_translations` (`id`, `name`, `slug`, `description`, `meta_title`, `meta_description`, `meta_keywords`, `category_id`, `locale`, `locale_id`, `url_path`) VALUES
(1, 'Root', 'root', 'Root', '', '', '', 1, 'en', NULL, ''),
(2, 'Fruits', 'fruits', '', '', '', '', 2, 'en', 1, ''),
(3, 'Fruits', 'fruits', '', '', '', '', 2, 'fr', 2, ''),
(4, 'Fruits', 'fruits', '', '', '', '', 2, 'nl', 3, ''),
(5, 'Vegetable', 'vegetable', '', '', '', '', 3, 'en', 1, ''),
(6, 'Vegetable', 'vegetable', '', '', '', '', 3, 'fr', 2, ''),
(7, 'Vegetable', 'vegetable', '', '', '', '', 3, 'nl', 3, '');

--
-- Triggers `category_translations`
--
DELIMITER $$
CREATE TRIGGER `trig_category_translations_insert` BEFORE INSERT ON `category_translations` FOR EACH ROW BEGIN
                            DECLARE parentUrlPath varchar(255);
            DECLARE urlPath varchar(255);

            IF NOT EXISTS (
                SELECT id
                FROM categories
                WHERE
                    id = NEW.category_id
                    AND parent_id IS NULL
            )
            THEN

                SELECT
                    GROUP_CONCAT(parent_translations.slug SEPARATOR '/') INTO parentUrlPath
                FROM
                    categories AS node,
                    categories AS parent
                    JOIN category_translations AS parent_translations ON parent.id = parent_translations.category_id
                WHERE
                    node._lft >= parent._lft
                    AND node._rgt <= parent._rgt
                    AND node.id = (SELECT parent_id FROM categories WHERE id = NEW.category_id)
                    AND node.parent_id IS NOT NULL
                    AND parent.parent_id IS NOT NULL
                    AND parent_translations.locale = NEW.locale
                GROUP BY
                    node.id;

                IF parentUrlPath IS NULL
                THEN
                    SET urlPath = NEW.slug;
                ELSE
                    SET urlPath = concat(parentUrlPath, '/', NEW.slug);
                END IF;

                SET NEW.url_path = urlPath;

            END IF;
            END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trig_category_translations_update` BEFORE UPDATE ON `category_translations` FOR EACH ROW BEGIN
                            DECLARE parentUrlPath varchar(255);
            DECLARE urlPath varchar(255);

            IF NOT EXISTS (
                SELECT id
                FROM categories
                WHERE
                    id = NEW.category_id
                    AND parent_id IS NULL
            )
            THEN

                SELECT
                    GROUP_CONCAT(parent_translations.slug SEPARATOR '/') INTO parentUrlPath
                FROM
                    categories AS node,
                    categories AS parent
                    JOIN category_translations AS parent_translations ON parent.id = parent_translations.category_id
                WHERE
                    node._lft >= parent._lft
                    AND node._rgt <= parent._rgt
                    AND node.id = (SELECT parent_id FROM categories WHERE id = NEW.category_id)
                    AND node.parent_id IS NOT NULL
                    AND parent.parent_id IS NOT NULL
                    AND parent_translations.locale = NEW.locale
                GROUP BY
                    node.id;

                IF parentUrlPath IS NULL
                THEN
                    SET urlPath = NEW.slug;
                ELSE
                    SET urlPath = concat(parentUrlPath, '/', NEW.slug);
                END IF;

                SET NEW.url_path = urlPath;

            END IF;
            END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `channels`
--

CREATE TABLE `channels` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `timezone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `theme` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hostname` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `logo` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `favicon` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `home_page_content` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `footer_content` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `default_locale_id` int(10) UNSIGNED NOT NULL,
  `base_currency_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `root_category_id` int(10) UNSIGNED DEFAULT NULL,
  `home_seo` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`home_seo`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `channels`
--

INSERT INTO `channels` (`id`, `code`, `name`, `description`, `timezone`, `theme`, `hostname`, `logo`, `favicon`, `home_page_content`, `footer_content`, `default_locale_id`, `base_currency_id`, `created_at`, `updated_at`, `root_category_id`, `home_seo`) VALUES
(1, 'default', 'Default', NULL, NULL, 'velocity', NULL, NULL, NULL, '<p>@include(\"shop::home.slider\") @include(\"shop::home.featured-products\") @include(\"shop::home.new-products\")</p><div class=\"banner-container\"><div class=\"left-banner\"><img src=\"https://s3-ap-southeast-1.amazonaws.com/cdn.uvdesk.com/website/1/201902045c581f9494b8a1.png\" /></div><div class=\"right-banner\"><img src=\"https://s3-ap-southeast-1.amazonaws.com/cdn.uvdesk.com/website/1/201902045c581fb045cf02.png\" /> <img src=\"https://s3-ap-southeast-1.amazonaws.com/cdn.uvdesk.com/website/1/201902045c581fc352d803.png\" /></div></div>', '<div class=\"list-container\"><span class=\"list-heading\">Quick Links</span><ul class=\"list-group\"><li><a href=\"@php echo route(\'shop.cms.page\', \'about-us\') @endphp\">About Us</a></li><li><a href=\"@php echo route(\'shop.cms.page\', \'return-policy\') @endphp\">Return Policy</a></li><li><a href=\"@php echo route(\'shop.cms.page\', \'refund-policy\') @endphp\">Refund Policy</a></li><li><a href=\"@php echo route(\'shop.cms.page\', \'terms-conditions\') @endphp\">Terms and conditions</a></li><li><a href=\"@php echo route(\'shop.cms.page\', \'terms-of-use\') @endphp\">Terms of Use</a></li><li><a href=\"@php echo route(\'shop.cms.page\', \'contact-us\') @endphp\">Contact Us</a></li></ul></div><div class=\"list-container\"><span class=\"list-heading\">Connect With Us</span><ul class=\"list-group\"><li><a href=\"#\"><span class=\"icon icon-facebook\"></span>Facebook </a></li><li><a href=\"#\"><span class=\"icon icon-twitter\"></span> Twitter </a></li><li><a href=\"#\"><span class=\"icon icon-instagram\"></span> Instagram </a></li><li><a href=\"#\"> <span class=\"icon icon-google-plus\"></span>Google+ </a></li><li><a href=\"#\"> <span class=\"icon icon-linkedin\"></span>LinkedIn </a></li></ul></div>', 1, 1, NULL, NULL, 1, '{\"meta_title\": \"Demo store\", \"meta_keywords\": \"Demo store meta keyword\", \"meta_description\": \"Demo store meta description\"}');

-- --------------------------------------------------------

--
-- Table structure for table `channel_currencies`
--

CREATE TABLE `channel_currencies` (
  `channel_id` int(10) UNSIGNED NOT NULL,
  `currency_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `channel_currencies`
--

INSERT INTO `channel_currencies` (`channel_id`, `currency_id`) VALUES
(1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `channel_inventory_sources`
--

CREATE TABLE `channel_inventory_sources` (
  `channel_id` int(10) UNSIGNED NOT NULL,
  `inventory_source_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `channel_inventory_sources`
--

INSERT INTO `channel_inventory_sources` (`channel_id`, `inventory_source_id`) VALUES
(1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `channel_locales`
--

CREATE TABLE `channel_locales` (
  `channel_id` int(10) UNSIGNED NOT NULL,
  `locale_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `channel_locales`
--

INSERT INTO `channel_locales` (`channel_id`, `locale_id`) VALUES
(1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `cms_pages`
--

CREATE TABLE `cms_pages` (
  `id` int(10) UNSIGNED NOT NULL,
  `layout` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `cms_pages`
--

INSERT INTO `cms_pages` (`id`, `layout`, `created_at`, `updated_at`) VALUES
(1, NULL, '2020-07-20 08:43:18', '2020-07-20 08:43:18'),
(2, NULL, '2020-07-20 08:43:18', '2020-07-20 08:43:18'),
(3, NULL, '2020-07-20 08:43:18', '2020-07-20 08:43:18'),
(4, NULL, '2020-07-20 08:43:18', '2020-07-20 08:43:18'),
(5, NULL, '2020-07-20 08:43:18', '2020-07-20 08:43:18'),
(6, NULL, '2020-07-20 08:43:18', '2020-07-20 08:43:18');

-- --------------------------------------------------------

--
-- Table structure for table `cms_page_channels`
--

CREATE TABLE `cms_page_channels` (
  `cms_page_id` int(10) UNSIGNED NOT NULL,
  `channel_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `cms_page_translations`
--

CREATE TABLE `cms_page_translations` (
  `id` int(10) UNSIGNED NOT NULL,
  `page_title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `url_key` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `html_content` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_title` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_keywords` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `locale` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cms_page_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `cms_page_translations`
--

INSERT INTO `cms_page_translations` (`id`, `page_title`, `url_key`, `html_content`, `meta_title`, `meta_description`, `meta_keywords`, `locale`, `cms_page_id`) VALUES
(13, 'About Us', 'about-us', '<div class=\"static-container\"><div class=\"mb-5\">About us page content</div></div>', 'about us', '', 'aboutus', 'en', 1),
(14, 'Return Policy', 'return-policy', '<div class=\"static-container\"><div class=\"mb-5\">Return policy page content</div></div>', 'return policy', '', 'return, policy', 'en', 2),
(15, 'Refund Policy', 'refund-policy', '<div class=\"static-container\"><div class=\"mb-5\">Refund policy page content</div></div>', 'Refund policy', '', 'refund, policy', 'en', 3),
(16, 'Terms & Conditions', 'terms-conditions', '<div class=\"static-container\"><div class=\"mb-5\">Terms & conditions page content</div></div>', 'Terms & Conditions', '', 'term, conditions', 'en', 4),
(17, 'Terms of use', 'terms-of-use', '<div class=\"static-container\"><div class=\"mb-5\">Terms of use page content</div></div>', 'Terms of use', '', 'term, use', 'en', 5),
(18, 'Contact Us', 'contact-us', '<div class=\"static-container\"><div class=\"mb-5\">Contact us page content</div></div>', 'Contact Us', '', 'contact, us', 'en', 6);

-- --------------------------------------------------------

--
-- Table structure for table `core_config`
--

CREATE TABLE `core_config` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `channel_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `locale_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `core_config`
--

INSERT INTO `core_config` (`id`, `code`, `value`, `channel_code`, `locale_code`, `created_at`, `updated_at`) VALUES
(1, 'catalog.products.guest-checkout.allow-guest-checkout', '1', NULL, NULL, '2020-07-20 08:43:16', '2020-07-20 08:43:16'),
(2, 'emails.general.notifications.emails.general.notifications.verification', '1', NULL, NULL, '2020-07-20 08:43:16', '2020-07-20 08:43:16'),
(3, 'emails.general.notifications.emails.general.notifications.registration', '1', NULL, NULL, '2020-07-20 08:43:16', '2020-07-20 08:43:16'),
(4, 'emails.general.notifications.emails.general.notifications.customer', '1', NULL, NULL, '2020-07-20 08:43:16', '2020-07-20 08:43:16'),
(5, 'emails.general.notifications.emails.general.notifications.new-order', '1', NULL, NULL, '2020-07-20 08:43:16', '2020-07-20 08:43:16'),
(6, 'emails.general.notifications.emails.general.notifications.new-admin', '1', NULL, NULL, '2020-07-20 08:43:16', '2020-07-20 08:43:16'),
(7, 'emails.general.notifications.emails.general.notifications.new-invoice', '1', NULL, NULL, '2020-07-20 08:43:16', '2020-07-20 08:43:16'),
(8, 'emails.general.notifications.emails.general.notifications.new-refund', '1', NULL, NULL, '2020-07-20 08:43:16', '2020-07-20 08:43:16'),
(9, 'emails.general.notifications.emails.general.notifications.new-shipment', '1', NULL, NULL, '2020-07-20 08:43:16', '2020-07-20 08:43:16'),
(10, 'emails.general.notifications.emails.general.notifications.new-inventory-source', '1', NULL, NULL, '2020-07-20 08:43:16', '2020-07-20 08:43:16'),
(11, 'emails.general.notifications.emails.general.notifications.cancel-order', '1', NULL, NULL, '2020-07-20 08:43:16', '2020-07-20 08:43:16');

-- --------------------------------------------------------

--
-- Table structure for table `countries`
--

CREATE TABLE `countries` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `countries`
--

INSERT INTO `countries` (`id`, `code`, `name`) VALUES
(1, 'AF', 'Afghanistan'),
(2, 'AX', 'Åland Islands'),
(3, 'AL', 'Albania'),
(4, 'DZ', 'Algeria'),
(5, 'AS', 'American Samoa'),
(6, 'AD', 'Andorra'),
(7, 'AO', 'Angola'),
(8, 'AI', 'Anguilla'),
(9, 'AQ', 'Antarctica'),
(10, 'AG', 'Antigua & Barbuda'),
(11, 'AR', 'Argentina'),
(12, 'AM', 'Armenia'),
(13, 'AW', 'Aruba'),
(14, 'AC', 'Ascension Island'),
(15, 'AU', 'Australia'),
(16, 'AT', 'Austria'),
(17, 'AZ', 'Azerbaijan'),
(18, 'BS', 'Bahamas'),
(19, 'BH', 'Bahrain'),
(20, 'BD', 'Bangladesh'),
(21, 'BB', 'Barbados'),
(22, 'BY', 'Belarus'),
(23, 'BE', 'Belgium'),
(24, 'BZ', 'Belize'),
(25, 'BJ', 'Benin'),
(26, 'BM', 'Bermuda'),
(27, 'BT', 'Bhutan'),
(28, 'BO', 'Bolivia'),
(29, 'BA', 'Bosnia & Herzegovina'),
(30, 'BW', 'Botswana'),
(31, 'BR', 'Brazil'),
(32, 'IO', 'British Indian Ocean Territory'),
(33, 'VG', 'British Virgin Islands'),
(34, 'BN', 'Brunei'),
(35, 'BG', 'Bulgaria'),
(36, 'BF', 'Burkina Faso'),
(37, 'BI', 'Burundi'),
(38, 'KH', 'Cambodia'),
(39, 'CM', 'Cameroon'),
(40, 'CA', 'Canada'),
(41, 'IC', 'Canary Islands'),
(42, 'CV', 'Cape Verde'),
(43, 'BQ', 'Caribbean Netherlands'),
(44, 'KY', 'Cayman Islands'),
(45, 'CF', 'Central African Republic'),
(46, 'EA', 'Ceuta & Melilla'),
(47, 'TD', 'Chad'),
(48, 'CL', 'Chile'),
(49, 'CN', 'China'),
(50, 'CX', 'Christmas Island'),
(51, 'CC', 'Cocos (Keeling) Islands'),
(52, 'CO', 'Colombia'),
(53, 'KM', 'Comoros'),
(54, 'CG', 'Congo - Brazzaville'),
(55, 'CD', 'Congo - Kinshasa'),
(56, 'CK', 'Cook Islands'),
(57, 'CR', 'Costa Rica'),
(58, 'CI', 'Côte d’Ivoire'),
(59, 'HR', 'Croatia'),
(60, 'CU', 'Cuba'),
(61, 'CW', 'Curaçao'),
(62, 'CY', 'Cyprus'),
(63, 'CZ', 'Czechia'),
(64, 'DK', 'Denmark'),
(65, 'DG', 'Diego Garcia'),
(66, 'DJ', 'Djibouti'),
(67, 'DM', 'Dominica'),
(68, 'DO', 'Dominican Republic'),
(69, 'EC', 'Ecuador'),
(70, 'EG', 'Egypt'),
(71, 'SV', 'El Salvador'),
(72, 'GQ', 'Equatorial Guinea'),
(73, 'ER', 'Eritrea'),
(74, 'EE', 'Estonia'),
(75, 'ET', 'Ethiopia'),
(76, 'EZ', 'Eurozone'),
(77, 'FK', 'Falkland Islands'),
(78, 'FO', 'Faroe Islands'),
(79, 'FJ', 'Fiji'),
(80, 'FI', 'Finland'),
(81, 'FR', 'France'),
(82, 'GF', 'French Guiana'),
(83, 'PF', 'French Polynesia'),
(84, 'TF', 'French Southern Territories'),
(85, 'GA', 'Gabon'),
(86, 'GM', 'Gambia'),
(87, 'GE', 'Georgia'),
(88, 'DE', 'Germany'),
(89, 'GH', 'Ghana'),
(90, 'GI', 'Gibraltar'),
(91, 'GR', 'Greece'),
(92, 'GL', 'Greenland'),
(93, 'GD', 'Grenada'),
(94, 'GP', 'Guadeloupe'),
(95, 'GU', 'Guam'),
(96, 'GT', 'Guatemala'),
(97, 'GG', 'Guernsey'),
(98, 'GN', 'Guinea'),
(99, 'GW', 'Guinea-Bissau'),
(100, 'GY', 'Guyana'),
(101, 'HT', 'Haiti'),
(102, 'HN', 'Honduras'),
(103, 'HK', 'Hong Kong SAR China'),
(104, 'HU', 'Hungary'),
(105, 'IS', 'Iceland'),
(106, 'IN', 'India'),
(107, 'ID', 'Indonesia'),
(108, 'IR', 'Iran'),
(109, 'IQ', 'Iraq'),
(110, 'IE', 'Ireland'),
(111, 'IM', 'Isle of Man'),
(112, 'IL', 'Israel'),
(113, 'IT', 'Italy'),
(114, 'JM', 'Jamaica'),
(115, 'JP', 'Japan'),
(116, 'JE', 'Jersey'),
(117, 'JO', 'Jordan'),
(118, 'KZ', 'Kazakhstan'),
(119, 'KE', 'Kenya'),
(120, 'KI', 'Kiribati'),
(121, 'XK', 'Kosovo'),
(122, 'KW', 'Kuwait'),
(123, 'KG', 'Kyrgyzstan'),
(124, 'LA', 'Laos'),
(125, 'LV', 'Latvia'),
(126, 'LB', 'Lebanon'),
(127, 'LS', 'Lesotho'),
(128, 'LR', 'Liberia'),
(129, 'LY', 'Libya'),
(130, 'LI', 'Liechtenstein'),
(131, 'LT', 'Lithuania'),
(132, 'LU', 'Luxembourg'),
(133, 'MO', 'Macau SAR China'),
(134, 'MK', 'Macedonia'),
(135, 'MG', 'Madagascar'),
(136, 'MW', 'Malawi'),
(137, 'MY', 'Malaysia'),
(138, 'MV', 'Maldives'),
(139, 'ML', 'Mali'),
(140, 'MT', 'Malta'),
(141, 'MH', 'Marshall Islands'),
(142, 'MQ', 'Martinique'),
(143, 'MR', 'Mauritania'),
(144, 'MU', 'Mauritius'),
(145, 'YT', 'Mayotte'),
(146, 'MX', 'Mexico'),
(147, 'FM', 'Micronesia'),
(148, 'MD', 'Moldova'),
(149, 'MC', 'Monaco'),
(150, 'MN', 'Mongolia'),
(151, 'ME', 'Montenegro'),
(152, 'MS', 'Montserrat'),
(153, 'MA', 'Morocco'),
(154, 'MZ', 'Mozambique'),
(155, 'MM', 'Myanmar (Burma)'),
(156, 'NA', 'Namibia'),
(157, 'NR', 'Nauru'),
(158, 'NP', 'Nepal'),
(159, 'NL', 'Netherlands'),
(160, 'NC', 'New Caledonia'),
(161, 'NZ', 'New Zealand'),
(162, 'NI', 'Nicaragua'),
(163, 'NE', 'Niger'),
(164, 'NG', 'Nigeria'),
(165, 'NU', 'Niue'),
(166, 'NF', 'Norfolk Island'),
(167, 'KP', 'North Korea'),
(168, 'MP', 'Northern Mariana Islands'),
(169, 'NO', 'Norway'),
(170, 'OM', 'Oman'),
(171, 'PK', 'Pakistan'),
(172, 'PW', 'Palau'),
(173, 'PS', 'Palestinian Territories'),
(174, 'PA', 'Panama'),
(175, 'PG', 'Papua New Guinea'),
(176, 'PY', 'Paraguay'),
(177, 'PE', 'Peru'),
(178, 'PH', 'Philippines'),
(179, 'PN', 'Pitcairn Islands'),
(180, 'PL', 'Poland'),
(181, 'PT', 'Portugal'),
(182, 'PR', 'Puerto Rico'),
(183, 'QA', 'Qatar'),
(184, 'RE', 'Réunion'),
(185, 'RO', 'Romania'),
(186, 'RU', 'Russia'),
(187, 'RW', 'Rwanda'),
(188, 'WS', 'Samoa'),
(189, 'SM', 'San Marino'),
(190, 'ST', 'São Tomé & Príncipe'),
(191, 'SA', 'Saudi Arabia'),
(192, 'SN', 'Senegal'),
(193, 'RS', 'Serbia'),
(194, 'SC', 'Seychelles'),
(195, 'SL', 'Sierra Leone'),
(196, 'SG', 'Singapore'),
(197, 'SX', 'Sint Maarten'),
(198, 'SK', 'Slovakia'),
(199, 'SI', 'Slovenia'),
(200, 'SB', 'Solomon Islands'),
(201, 'SO', 'Somalia'),
(202, 'ZA', 'South Africa'),
(203, 'GS', 'South Georgia & South Sandwich Islands'),
(204, 'KR', 'South Korea'),
(205, 'SS', 'South Sudan'),
(206, 'ES', 'Spain'),
(207, 'LK', 'Sri Lanka'),
(208, 'BL', 'St. Barthélemy'),
(209, 'SH', 'St. Helena'),
(210, 'KN', 'St. Kitts & Nevis'),
(211, 'LC', 'St. Lucia'),
(212, 'MF', 'St. Martin'),
(213, 'PM', 'St. Pierre & Miquelon'),
(214, 'VC', 'St. Vincent & Grenadines'),
(215, 'SD', 'Sudan'),
(216, 'SR', 'Suriname'),
(217, 'SJ', 'Svalbard & Jan Mayen'),
(218, 'SZ', 'Swaziland'),
(219, 'SE', 'Sweden'),
(220, 'CH', 'Switzerland'),
(221, 'SY', 'Syria'),
(222, 'TW', 'Taiwan'),
(223, 'TJ', 'Tajikistan'),
(224, 'TZ', 'Tanzania'),
(225, 'TH', 'Thailand'),
(226, 'TL', 'Timor-Leste'),
(227, 'TG', 'Togo'),
(228, 'TK', 'Tokelau'),
(229, 'TO', 'Tonga'),
(230, 'TT', 'Trinidad & Tobago'),
(231, 'TA', 'Tristan da Cunha'),
(232, 'TN', 'Tunisia'),
(233, 'TR', 'Turkey'),
(234, 'TM', 'Turkmenistan'),
(235, 'TC', 'Turks & Caicos Islands'),
(236, 'TV', 'Tuvalu'),
(237, 'UM', 'U.S. Outlying Islands'),
(238, 'VI', 'U.S. Virgin Islands'),
(239, 'UG', 'Uganda'),
(240, 'UA', 'Ukraine'),
(241, 'AE', 'United Arab Emirates'),
(242, 'GB', 'United Kingdom'),
(243, 'UN', 'United Nations'),
(244, 'US', 'United States'),
(245, 'UY', 'Uruguay'),
(246, 'UZ', 'Uzbekistan'),
(247, 'VU', 'Vanuatu'),
(248, 'VA', 'Vatican City'),
(249, 'VE', 'Venezuela'),
(250, 'VN', 'Vietnam'),
(251, 'WF', 'Wallis & Futuna'),
(252, 'EH', 'Western Sahara'),
(253, 'YE', 'Yemen'),
(254, 'ZM', 'Zambia'),
(255, 'ZW', 'Zimbabwe');

-- --------------------------------------------------------

--
-- Table structure for table `country_states`
--

CREATE TABLE `country_states` (
  `id` int(10) UNSIGNED NOT NULL,
  `country_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `default_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country_id` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `country_states`
--

INSERT INTO `country_states` (`id`, `country_code`, `code`, `default_name`, `country_id`) VALUES
(1, 'US', 'AL', 'Alabama', 244),
(2, 'US', 'AK', 'Alaska', 244),
(3, 'US', 'AS', 'American Samoa', 244),
(4, 'US', 'AZ', 'Arizona', 244),
(5, 'US', 'AR', 'Arkansas', 244),
(6, 'US', 'AE', 'Armed Forces Africa', 244),
(7, 'US', 'AA', 'Armed Forces Americas', 244),
(8, 'US', 'AE', 'Armed Forces Canada', 244),
(9, 'US', 'AE', 'Armed Forces Europe', 244),
(10, 'US', 'AE', 'Armed Forces Middle East', 244),
(11, 'US', 'AP', 'Armed Forces Pacific', 244),
(12, 'US', 'CA', 'California', 244),
(13, 'US', 'CO', 'Colorado', 244),
(14, 'US', 'CT', 'Connecticut', 244),
(15, 'US', 'DE', 'Delaware', 244),
(16, 'US', 'DC', 'District of Columbia', 244),
(17, 'US', 'FM', 'Federated States Of Micronesia', 244),
(18, 'US', 'FL', 'Florida', 244),
(19, 'US', 'GA', 'Georgia', 244),
(20, 'US', 'GU', 'Guam', 244),
(21, 'US', 'HI', 'Hawaii', 244),
(22, 'US', 'ID', 'Idaho', 244),
(23, 'US', 'IL', 'Illinois', 244),
(24, 'US', 'IN', 'Indiana', 244),
(25, 'US', 'IA', 'Iowa', 244),
(26, 'US', 'KS', 'Kansas', 244),
(27, 'US', 'KY', 'Kentucky', 244),
(28, 'US', 'LA', 'Louisiana', 244),
(29, 'US', 'ME', 'Maine', 244),
(30, 'US', 'MH', 'Marshall Islands', 244),
(31, 'US', 'MD', 'Maryland', 244),
(32, 'US', 'MA', 'Massachusetts', 244),
(33, 'US', 'MI', 'Michigan', 244),
(34, 'US', 'MN', 'Minnesota', 244),
(35, 'US', 'MS', 'Mississippi', 244),
(36, 'US', 'MO', 'Missouri', 244),
(37, 'US', 'MT', 'Montana', 244),
(38, 'US', 'NE', 'Nebraska', 244),
(39, 'US', 'NV', 'Nevada', 244),
(40, 'US', 'NH', 'New Hampshire', 244),
(41, 'US', 'NJ', 'New Jersey', 244),
(42, 'US', 'NM', 'New Mexico', 244),
(43, 'US', 'NY', 'New York', 244),
(44, 'US', 'NC', 'North Carolina', 244),
(45, 'US', 'ND', 'North Dakota', 244),
(46, 'US', 'MP', 'Northern Mariana Islands', 244),
(47, 'US', 'OH', 'Ohio', 244),
(48, 'US', 'OK', 'Oklahoma', 244),
(49, 'US', 'OR', 'Oregon', 244),
(50, 'US', 'PW', 'Palau', 244),
(51, 'US', 'PA', 'Pennsylvania', 244),
(52, 'US', 'PR', 'Puerto Rico', 244),
(53, 'US', 'RI', 'Rhode Island', 244),
(54, 'US', 'SC', 'South Carolina', 244),
(55, 'US', 'SD', 'South Dakota', 244),
(56, 'US', 'TN', 'Tennessee', 244),
(57, 'US', 'TX', 'Texas', 244),
(58, 'US', 'UT', 'Utah', 244),
(59, 'US', 'VT', 'Vermont', 244),
(60, 'US', 'VI', 'Virgin Islands', 244),
(61, 'US', 'VA', 'Virginia', 244),
(62, 'US', 'WA', 'Washington', 244),
(63, 'US', 'WV', 'West Virginia', 244),
(64, 'US', 'WI', 'Wisconsin', 244),
(65, 'US', 'WY', 'Wyoming', 244),
(66, 'CA', 'AB', 'Alberta', 40),
(67, 'CA', 'BC', 'British Columbia', 40),
(68, 'CA', 'MB', 'Manitoba', 40),
(69, 'CA', 'NL', 'Newfoundland and Labrador', 40),
(70, 'CA', 'NB', 'New Brunswick', 40),
(71, 'CA', 'NS', 'Nova Scotia', 40),
(72, 'CA', 'NT', 'Northwest Territories', 40),
(73, 'CA', 'NU', 'Nunavut', 40),
(74, 'CA', 'ON', 'Ontario', 40),
(75, 'CA', 'PE', 'Prince Edward Island', 40),
(76, 'CA', 'QC', 'Quebec', 40),
(77, 'CA', 'SK', 'Saskatchewan', 40),
(78, 'CA', 'YT', 'Yukon Territory', 40),
(79, 'DE', 'NDS', 'Niedersachsen', 88),
(80, 'DE', 'BAW', 'Baden-Württemberg', 88),
(81, 'DE', 'BAY', 'Bayern', 88),
(82, 'DE', 'BER', 'Berlin', 88),
(83, 'DE', 'BRG', 'Brandenburg', 88),
(84, 'DE', 'BRE', 'Bremen', 88),
(85, 'DE', 'HAM', 'Hamburg', 88),
(86, 'DE', 'HES', 'Hessen', 88),
(87, 'DE', 'MEC', 'Mecklenburg-Vorpommern', 88),
(88, 'DE', 'NRW', 'Nordrhein-Westfalen', 88),
(89, 'DE', 'RHE', 'Rheinland-Pfalz', 88),
(90, 'DE', 'SAR', 'Saarland', 88),
(91, 'DE', 'SAS', 'Sachsen', 88),
(92, 'DE', 'SAC', 'Sachsen-Anhalt', 88),
(93, 'DE', 'SCN', 'Schleswig-Holstein', 88),
(94, 'DE', 'THE', 'Thüringen', 88),
(95, 'AT', 'WI', 'Wien', 16),
(96, 'AT', 'NO', 'Niederösterreich', 16),
(97, 'AT', 'OO', 'Oberösterreich', 16),
(98, 'AT', 'SB', 'Salzburg', 16),
(99, 'AT', 'KN', 'Kärnten', 16),
(100, 'AT', 'ST', 'Steiermark', 16),
(101, 'AT', 'TI', 'Tirol', 16),
(102, 'AT', 'BL', 'Burgenland', 16),
(103, 'AT', 'VB', 'Vorarlberg', 16),
(104, 'CH', 'AG', 'Aargau', 220),
(105, 'CH', 'AI', 'Appenzell Innerrhoden', 220),
(106, 'CH', 'AR', 'Appenzell Ausserrhoden', 220),
(107, 'CH', 'BE', 'Bern', 220),
(108, 'CH', 'BL', 'Basel-Landschaft', 220),
(109, 'CH', 'BS', 'Basel-Stadt', 220),
(110, 'CH', 'FR', 'Freiburg', 220),
(111, 'CH', 'GE', 'Genf', 220),
(112, 'CH', 'GL', 'Glarus', 220),
(113, 'CH', 'GR', 'Graubünden', 220),
(114, 'CH', 'JU', 'Jura', 220),
(115, 'CH', 'LU', 'Luzern', 220),
(116, 'CH', 'NE', 'Neuenburg', 220),
(117, 'CH', 'NW', 'Nidwalden', 220),
(118, 'CH', 'OW', 'Obwalden', 220),
(119, 'CH', 'SG', 'St. Gallen', 220),
(120, 'CH', 'SH', 'Schaffhausen', 220),
(121, 'CH', 'SO', 'Solothurn', 220),
(122, 'CH', 'SZ', 'Schwyz', 220),
(123, 'CH', 'TG', 'Thurgau', 220),
(124, 'CH', 'TI', 'Tessin', 220),
(125, 'CH', 'UR', 'Uri', 220),
(126, 'CH', 'VD', 'Waadt', 220),
(127, 'CH', 'VS', 'Wallis', 220),
(128, 'CH', 'ZG', 'Zug', 220),
(129, 'CH', 'ZH', 'Zürich', 220),
(130, 'ES', 'A Coruсa', 'A Coruña', 206),
(131, 'ES', 'Alava', 'Alava', 206),
(132, 'ES', 'Albacete', 'Albacete', 206),
(133, 'ES', 'Alicante', 'Alicante', 206),
(134, 'ES', 'Almeria', 'Almeria', 206),
(135, 'ES', 'Asturias', 'Asturias', 206),
(136, 'ES', 'Avila', 'Avila', 206),
(137, 'ES', 'Badajoz', 'Badajoz', 206),
(138, 'ES', 'Baleares', 'Baleares', 206),
(139, 'ES', 'Barcelona', 'Barcelona', 206),
(140, 'ES', 'Burgos', 'Burgos', 206),
(141, 'ES', 'Caceres', 'Caceres', 206),
(142, 'ES', 'Cadiz', 'Cadiz', 206),
(143, 'ES', 'Cantabria', 'Cantabria', 206),
(144, 'ES', 'Castellon', 'Castellon', 206),
(145, 'ES', 'Ceuta', 'Ceuta', 206),
(146, 'ES', 'Ciudad Real', 'Ciudad Real', 206),
(147, 'ES', 'Cordoba', 'Cordoba', 206),
(148, 'ES', 'Cuenca', 'Cuenca', 206),
(149, 'ES', 'Girona', 'Girona', 206),
(150, 'ES', 'Granada', 'Granada', 206),
(151, 'ES', 'Guadalajara', 'Guadalajara', 206),
(152, 'ES', 'Guipuzcoa', 'Guipuzcoa', 206),
(153, 'ES', 'Huelva', 'Huelva', 206),
(154, 'ES', 'Huesca', 'Huesca', 206),
(155, 'ES', 'Jaen', 'Jaen', 206),
(156, 'ES', 'La Rioja', 'La Rioja', 206),
(157, 'ES', 'Las Palmas', 'Las Palmas', 206),
(158, 'ES', 'Leon', 'Leon', 206),
(159, 'ES', 'Lleida', 'Lleida', 206),
(160, 'ES', 'Lugo', 'Lugo', 206),
(161, 'ES', 'Madrid', 'Madrid', 206),
(162, 'ES', 'Malaga', 'Malaga', 206),
(163, 'ES', 'Melilla', 'Melilla', 206),
(164, 'ES', 'Murcia', 'Murcia', 206),
(165, 'ES', 'Navarra', 'Navarra', 206),
(166, 'ES', 'Ourense', 'Ourense', 206),
(167, 'ES', 'Palencia', 'Palencia', 206),
(168, 'ES', 'Pontevedra', 'Pontevedra', 206),
(169, 'ES', 'Salamanca', 'Salamanca', 206),
(170, 'ES', 'Santa Cruz de Tenerife', 'Santa Cruz de Tenerife', 206),
(171, 'ES', 'Segovia', 'Segovia', 206),
(172, 'ES', 'Sevilla', 'Sevilla', 206),
(173, 'ES', 'Soria', 'Soria', 206),
(174, 'ES', 'Tarragona', 'Tarragona', 206),
(175, 'ES', 'Teruel', 'Teruel', 206),
(176, 'ES', 'Toledo', 'Toledo', 206),
(177, 'ES', 'Valencia', 'Valencia', 206),
(178, 'ES', 'Valladolid', 'Valladolid', 206),
(179, 'ES', 'Vizcaya', 'Vizcaya', 206),
(180, 'ES', 'Zamora', 'Zamora', 206),
(181, 'ES', 'Zaragoza', 'Zaragoza', 206),
(182, 'FR', '1', 'Ain', 81),
(183, 'FR', '2', 'Aisne', 81),
(184, 'FR', '3', 'Allier', 81),
(185, 'FR', '4', 'Alpes-de-Haute-Provence', 81),
(186, 'FR', '5', 'Hautes-Alpes', 81),
(187, 'FR', '6', 'Alpes-Maritimes', 81),
(188, 'FR', '7', 'Ardèche', 81),
(189, 'FR', '8', 'Ardennes', 81),
(190, 'FR', '9', 'Ariège', 81),
(191, 'FR', '10', 'Aube', 81),
(192, 'FR', '11', 'Aude', 81),
(193, 'FR', '12', 'Aveyron', 81),
(194, 'FR', '13', 'Bouches-du-Rhône', 81),
(195, 'FR', '14', 'Calvados', 81),
(196, 'FR', '15', 'Cantal', 81),
(197, 'FR', '16', 'Charente', 81),
(198, 'FR', '17', 'Charente-Maritime', 81),
(199, 'FR', '18', 'Cher', 81),
(200, 'FR', '19', 'Corrèze', 81),
(201, 'FR', '2A', 'Corse-du-Sud', 81),
(202, 'FR', '2B', 'Haute-Corse', 81),
(203, 'FR', '21', 'Côte-d\'Or', 81),
(204, 'FR', '22', 'Côtes-d\'Armor', 81),
(205, 'FR', '23', 'Creuse', 81),
(206, 'FR', '24', 'Dordogne', 81),
(207, 'FR', '25', 'Doubs', 81),
(208, 'FR', '26', 'Drôme', 81),
(209, 'FR', '27', 'Eure', 81),
(210, 'FR', '28', 'Eure-et-Loir', 81),
(211, 'FR', '29', 'Finistère', 81),
(212, 'FR', '30', 'Gard', 81),
(213, 'FR', '31', 'Haute-Garonne', 81),
(214, 'FR', '32', 'Gers', 81),
(215, 'FR', '33', 'Gironde', 81),
(216, 'FR', '34', 'Hérault', 81),
(217, 'FR', '35', 'Ille-et-Vilaine', 81),
(218, 'FR', '36', 'Indre', 81),
(219, 'FR', '37', 'Indre-et-Loire', 81),
(220, 'FR', '38', 'Isère', 81),
(221, 'FR', '39', 'Jura', 81),
(222, 'FR', '40', 'Landes', 81),
(223, 'FR', '41', 'Loir-et-Cher', 81),
(224, 'FR', '42', 'Loire', 81),
(225, 'FR', '43', 'Haute-Loire', 81),
(226, 'FR', '44', 'Loire-Atlantique', 81),
(227, 'FR', '45', 'Loiret', 81),
(228, 'FR', '46', 'Lot', 81),
(229, 'FR', '47', 'Lot-et-Garonne', 81),
(230, 'FR', '48', 'Lozère', 81),
(231, 'FR', '49', 'Maine-et-Loire', 81),
(232, 'FR', '50', 'Manche', 81),
(233, 'FR', '51', 'Marne', 81),
(234, 'FR', '52', 'Haute-Marne', 81),
(235, 'FR', '53', 'Mayenne', 81),
(236, 'FR', '54', 'Meurthe-et-Moselle', 81),
(237, 'FR', '55', 'Meuse', 81),
(238, 'FR', '56', 'Morbihan', 81),
(239, 'FR', '57', 'Moselle', 81),
(240, 'FR', '58', 'Nièvre', 81),
(241, 'FR', '59', 'Nord', 81),
(242, 'FR', '60', 'Oise', 81),
(243, 'FR', '61', 'Orne', 81),
(244, 'FR', '62', 'Pas-de-Calais', 81),
(245, 'FR', '63', 'Puy-de-Dôme', 81),
(246, 'FR', '64', 'Pyrénées-Atlantiques', 81),
(247, 'FR', '65', 'Hautes-Pyrénées', 81),
(248, 'FR', '66', 'Pyrénées-Orientales', 81),
(249, 'FR', '67', 'Bas-Rhin', 81),
(250, 'FR', '68', 'Haut-Rhin', 81),
(251, 'FR', '69', 'Rhône', 81),
(252, 'FR', '70', 'Haute-Saône', 81),
(253, 'FR', '71', 'Saône-et-Loire', 81),
(254, 'FR', '72', 'Sarthe', 81),
(255, 'FR', '73', 'Savoie', 81),
(256, 'FR', '74', 'Haute-Savoie', 81),
(257, 'FR', '75', 'Paris', 81),
(258, 'FR', '76', 'Seine-Maritime', 81),
(259, 'FR', '77', 'Seine-et-Marne', 81),
(260, 'FR', '78', 'Yvelines', 81),
(261, 'FR', '79', 'Deux-Sèvres', 81),
(262, 'FR', '80', 'Somme', 81),
(263, 'FR', '81', 'Tarn', 81),
(264, 'FR', '82', 'Tarn-et-Garonne', 81),
(265, 'FR', '83', 'Var', 81),
(266, 'FR', '84', 'Vaucluse', 81),
(267, 'FR', '85', 'Vendée', 81),
(268, 'FR', '86', 'Vienne', 81),
(269, 'FR', '87', 'Haute-Vienne', 81),
(270, 'FR', '88', 'Vosges', 81),
(271, 'FR', '89', 'Yonne', 81),
(272, 'FR', '90', 'Territoire-de-Belfort', 81),
(273, 'FR', '91', 'Essonne', 81),
(274, 'FR', '92', 'Hauts-de-Seine', 81),
(275, 'FR', '93', 'Seine-Saint-Denis', 81),
(276, 'FR', '94', 'Val-de-Marne', 81),
(277, 'FR', '95', 'Val-d\'Oise', 81),
(278, 'RO', 'AB', 'Alba', 185),
(279, 'RO', 'AR', 'Arad', 185),
(280, 'RO', 'AG', 'Argeş', 185),
(281, 'RO', 'BC', 'Bacău', 185),
(282, 'RO', 'BH', 'Bihor', 185),
(283, 'RO', 'BN', 'Bistriţa-Năsăud', 185),
(284, 'RO', 'BT', 'Botoşani', 185),
(285, 'RO', 'BV', 'Braşov', 185),
(286, 'RO', 'BR', 'Brăila', 185),
(287, 'RO', 'B', 'Bucureşti', 185),
(288, 'RO', 'BZ', 'Buzău', 185),
(289, 'RO', 'CS', 'Caraş-Severin', 185),
(290, 'RO', 'CL', 'Călăraşi', 185),
(291, 'RO', 'CJ', 'Cluj', 185),
(292, 'RO', 'CT', 'Constanţa', 185),
(293, 'RO', 'CV', 'Covasna', 185),
(294, 'RO', 'DB', 'Dâmboviţa', 185),
(295, 'RO', 'DJ', 'Dolj', 185),
(296, 'RO', 'GL', 'Galaţi', 185),
(297, 'RO', 'GR', 'Giurgiu', 185),
(298, 'RO', 'GJ', 'Gorj', 185),
(299, 'RO', 'HR', 'Harghita', 185),
(300, 'RO', 'HD', 'Hunedoara', 185),
(301, 'RO', 'IL', 'Ialomiţa', 185),
(302, 'RO', 'IS', 'Iaşi', 185),
(303, 'RO', 'IF', 'Ilfov', 185),
(304, 'RO', 'MM', 'Maramureş', 185),
(305, 'RO', 'MH', 'Mehedinţi', 185),
(306, 'RO', 'MS', 'Mureş', 185),
(307, 'RO', 'NT', 'Neamţ', 185),
(308, 'RO', 'OT', 'Olt', 185),
(309, 'RO', 'PH', 'Prahova', 185),
(310, 'RO', 'SM', 'Satu-Mare', 185),
(311, 'RO', 'SJ', 'Sălaj', 185),
(312, 'RO', 'SB', 'Sibiu', 185),
(313, 'RO', 'SV', 'Suceava', 185),
(314, 'RO', 'TR', 'Teleorman', 185),
(315, 'RO', 'TM', 'Timiş', 185),
(316, 'RO', 'TL', 'Tulcea', 185),
(317, 'RO', 'VS', 'Vaslui', 185),
(318, 'RO', 'VL', 'Vâlcea', 185),
(319, 'RO', 'VN', 'Vrancea', 185),
(320, 'FI', 'Lappi', 'Lappi', 80),
(321, 'FI', 'Pohjois-Pohjanmaa', 'Pohjois-Pohjanmaa', 80),
(322, 'FI', 'Kainuu', 'Kainuu', 80),
(323, 'FI', 'Pohjois-Karjala', 'Pohjois-Karjala', 80),
(324, 'FI', 'Pohjois-Savo', 'Pohjois-Savo', 80),
(325, 'FI', 'Etelä-Savo', 'Etelä-Savo', 80),
(326, 'FI', 'Etelä-Pohjanmaa', 'Etelä-Pohjanmaa', 80),
(327, 'FI', 'Pohjanmaa', 'Pohjanmaa', 80),
(328, 'FI', 'Pirkanmaa', 'Pirkanmaa', 80),
(329, 'FI', 'Satakunta', 'Satakunta', 80),
(330, 'FI', 'Keski-Pohjanmaa', 'Keski-Pohjanmaa', 80),
(331, 'FI', 'Keski-Suomi', 'Keski-Suomi', 80),
(332, 'FI', 'Varsinais-Suomi', 'Varsinais-Suomi', 80),
(333, 'FI', 'Etelä-Karjala', 'Etelä-Karjala', 80),
(334, 'FI', 'Päijät-Häme', 'Päijät-Häme', 80),
(335, 'FI', 'Kanta-Häme', 'Kanta-Häme', 80),
(336, 'FI', 'Uusimaa', 'Uusimaa', 80),
(337, 'FI', 'Itä-Uusimaa', 'Itä-Uusimaa', 80),
(338, 'FI', 'Kymenlaakso', 'Kymenlaakso', 80),
(339, 'FI', 'Ahvenanmaa', 'Ahvenanmaa', 80),
(340, 'EE', 'EE-37', 'Harjumaa', 74),
(341, 'EE', 'EE-39', 'Hiiumaa', 74),
(342, 'EE', 'EE-44', 'Ida-Virumaa', 74),
(343, 'EE', 'EE-49', 'Jõgevamaa', 74),
(344, 'EE', 'EE-51', 'Järvamaa', 74),
(345, 'EE', 'EE-57', 'Läänemaa', 74),
(346, 'EE', 'EE-59', 'Lääne-Virumaa', 74),
(347, 'EE', 'EE-65', 'Põlvamaa', 74),
(348, 'EE', 'EE-67', 'Pärnumaa', 74),
(349, 'EE', 'EE-70', 'Raplamaa', 74),
(350, 'EE', 'EE-74', 'Saaremaa', 74),
(351, 'EE', 'EE-78', 'Tartumaa', 74),
(352, 'EE', 'EE-82', 'Valgamaa', 74),
(353, 'EE', 'EE-84', 'Viljandimaa', 74),
(354, 'EE', 'EE-86', 'Võrumaa', 74),
(355, 'LV', 'LV-DGV', 'Daugavpils', 125),
(356, 'LV', 'LV-JEL', 'Jelgava', 125),
(357, 'LV', 'Jēkabpils', 'Jēkabpils', 125),
(358, 'LV', 'LV-JUR', 'Jūrmala', 125),
(359, 'LV', 'LV-LPX', 'Liepāja', 125),
(360, 'LV', 'LV-LE', 'Liepājas novads', 125),
(361, 'LV', 'LV-REZ', 'Rēzekne', 125),
(362, 'LV', 'LV-RIX', 'Rīga', 125),
(363, 'LV', 'LV-RI', 'Rīgas novads', 125),
(364, 'LV', 'Valmiera', 'Valmiera', 125),
(365, 'LV', 'LV-VEN', 'Ventspils', 125),
(366, 'LV', 'Aglonas novads', 'Aglonas novads', 125),
(367, 'LV', 'LV-AI', 'Aizkraukles novads', 125),
(368, 'LV', 'Aizputes novads', 'Aizputes novads', 125),
(369, 'LV', 'Aknīstes novads', 'Aknīstes novads', 125),
(370, 'LV', 'Alojas novads', 'Alojas novads', 125),
(371, 'LV', 'Alsungas novads', 'Alsungas novads', 125),
(372, 'LV', 'LV-AL', 'Alūksnes novads', 125),
(373, 'LV', 'Amatas novads', 'Amatas novads', 125),
(374, 'LV', 'Apes novads', 'Apes novads', 125),
(375, 'LV', 'Auces novads', 'Auces novads', 125),
(376, 'LV', 'Babītes novads', 'Babītes novads', 125),
(377, 'LV', 'Baldones novads', 'Baldones novads', 125),
(378, 'LV', 'Baltinavas novads', 'Baltinavas novads', 125),
(379, 'LV', 'LV-BL', 'Balvu novads', 125),
(380, 'LV', 'LV-BU', 'Bauskas novads', 125),
(381, 'LV', 'Beverīnas novads', 'Beverīnas novads', 125),
(382, 'LV', 'Brocēnu novads', 'Brocēnu novads', 125),
(383, 'LV', 'Burtnieku novads', 'Burtnieku novads', 125),
(384, 'LV', 'Carnikavas novads', 'Carnikavas novads', 125),
(385, 'LV', 'Cesvaines novads', 'Cesvaines novads', 125),
(386, 'LV', 'Ciblas novads', 'Ciblas novads', 125),
(387, 'LV', 'LV-CE', 'Cēsu novads', 125),
(388, 'LV', 'Dagdas novads', 'Dagdas novads', 125),
(389, 'LV', 'LV-DA', 'Daugavpils novads', 125),
(390, 'LV', 'LV-DO', 'Dobeles novads', 125),
(391, 'LV', 'Dundagas novads', 'Dundagas novads', 125),
(392, 'LV', 'Durbes novads', 'Durbes novads', 125),
(393, 'LV', 'Engures novads', 'Engures novads', 125),
(394, 'LV', 'Garkalnes novads', 'Garkalnes novads', 125),
(395, 'LV', 'Grobiņas novads', 'Grobiņas novads', 125),
(396, 'LV', 'LV-GU', 'Gulbenes novads', 125),
(397, 'LV', 'Iecavas novads', 'Iecavas novads', 125),
(398, 'LV', 'Ikšķiles novads', 'Ikšķiles novads', 125),
(399, 'LV', 'Ilūkstes novads', 'Ilūkstes novads', 125),
(400, 'LV', 'Inčukalna novads', 'Inčukalna novads', 125),
(401, 'LV', 'Jaunjelgavas novads', 'Jaunjelgavas novads', 125),
(402, 'LV', 'Jaunpiebalgas novads', 'Jaunpiebalgas novads', 125),
(403, 'LV', 'Jaunpils novads', 'Jaunpils novads', 125),
(404, 'LV', 'LV-JL', 'Jelgavas novads', 125),
(405, 'LV', 'LV-JK', 'Jēkabpils novads', 125),
(406, 'LV', 'Kandavas novads', 'Kandavas novads', 125),
(407, 'LV', 'Kokneses novads', 'Kokneses novads', 125),
(408, 'LV', 'Krimuldas novads', 'Krimuldas novads', 125),
(409, 'LV', 'Krustpils novads', 'Krustpils novads', 125),
(410, 'LV', 'LV-KR', 'Krāslavas novads', 125),
(411, 'LV', 'LV-KU', 'Kuldīgas novads', 125),
(412, 'LV', 'Kārsavas novads', 'Kārsavas novads', 125),
(413, 'LV', 'Lielvārdes novads', 'Lielvārdes novads', 125),
(414, 'LV', 'LV-LM', 'Limbažu novads', 125),
(415, 'LV', 'Lubānas novads', 'Lubānas novads', 125),
(416, 'LV', 'LV-LU', 'Ludzas novads', 125),
(417, 'LV', 'Līgatnes novads', 'Līgatnes novads', 125),
(418, 'LV', 'Līvānu novads', 'Līvānu novads', 125),
(419, 'LV', 'LV-MA', 'Madonas novads', 125),
(420, 'LV', 'Mazsalacas novads', 'Mazsalacas novads', 125),
(421, 'LV', 'Mālpils novads', 'Mālpils novads', 125),
(422, 'LV', 'Mārupes novads', 'Mārupes novads', 125),
(423, 'LV', 'Naukšēnu novads', 'Naukšēnu novads', 125),
(424, 'LV', 'Neretas novads', 'Neretas novads', 125),
(425, 'LV', 'Nīcas novads', 'Nīcas novads', 125),
(426, 'LV', 'LV-OG', 'Ogres novads', 125),
(427, 'LV', 'Olaines novads', 'Olaines novads', 125),
(428, 'LV', 'Ozolnieku novads', 'Ozolnieku novads', 125),
(429, 'LV', 'LV-PR', 'Preiļu novads', 125),
(430, 'LV', 'Priekules novads', 'Priekules novads', 125),
(431, 'LV', 'Priekuļu novads', 'Priekuļu novads', 125),
(432, 'LV', 'Pārgaujas novads', 'Pārgaujas novads', 125),
(433, 'LV', 'Pāvilostas novads', 'Pāvilostas novads', 125),
(434, 'LV', 'Pļaviņu novads', 'Pļaviņu novads', 125),
(435, 'LV', 'Raunas novads', 'Raunas novads', 125),
(436, 'LV', 'Riebiņu novads', 'Riebiņu novads', 125),
(437, 'LV', 'Rojas novads', 'Rojas novads', 125),
(438, 'LV', 'Ropažu novads', 'Ropažu novads', 125),
(439, 'LV', 'Rucavas novads', 'Rucavas novads', 125),
(440, 'LV', 'Rugāju novads', 'Rugāju novads', 125),
(441, 'LV', 'Rundāles novads', 'Rundāles novads', 125),
(442, 'LV', 'LV-RE', 'Rēzeknes novads', 125),
(443, 'LV', 'Rūjienas novads', 'Rūjienas novads', 125),
(444, 'LV', 'Salacgrīvas novads', 'Salacgrīvas novads', 125),
(445, 'LV', 'Salas novads', 'Salas novads', 125),
(446, 'LV', 'Salaspils novads', 'Salaspils novads', 125),
(447, 'LV', 'LV-SA', 'Saldus novads', 125),
(448, 'LV', 'Saulkrastu novads', 'Saulkrastu novads', 125),
(449, 'LV', 'Siguldas novads', 'Siguldas novads', 125),
(450, 'LV', 'Skrundas novads', 'Skrundas novads', 125),
(451, 'LV', 'Skrīveru novads', 'Skrīveru novads', 125),
(452, 'LV', 'Smiltenes novads', 'Smiltenes novads', 125),
(453, 'LV', 'Stopiņu novads', 'Stopiņu novads', 125),
(454, 'LV', 'Strenču novads', 'Strenču novads', 125),
(455, 'LV', 'Sējas novads', 'Sējas novads', 125),
(456, 'LV', 'LV-TA', 'Talsu novads', 125),
(457, 'LV', 'LV-TU', 'Tukuma novads', 125),
(458, 'LV', 'Tērvetes novads', 'Tērvetes novads', 125),
(459, 'LV', 'Vaiņodes novads', 'Vaiņodes novads', 125),
(460, 'LV', 'LV-VK', 'Valkas novads', 125),
(461, 'LV', 'LV-VM', 'Valmieras novads', 125),
(462, 'LV', 'Varakļānu novads', 'Varakļānu novads', 125),
(463, 'LV', 'Vecpiebalgas novads', 'Vecpiebalgas novads', 125),
(464, 'LV', 'Vecumnieku novads', 'Vecumnieku novads', 125),
(465, 'LV', 'LV-VE', 'Ventspils novads', 125),
(466, 'LV', 'Viesītes novads', 'Viesītes novads', 125),
(467, 'LV', 'Viļakas novads', 'Viļakas novads', 125),
(468, 'LV', 'Viļānu novads', 'Viļānu novads', 125),
(469, 'LV', 'Vārkavas novads', 'Vārkavas novads', 125),
(470, 'LV', 'Zilupes novads', 'Zilupes novads', 125),
(471, 'LV', 'Ādažu novads', 'Ādažu novads', 125),
(472, 'LV', 'Ērgļu novads', 'Ērgļu novads', 125),
(473, 'LV', 'Ķeguma novads', 'Ķeguma novads', 125),
(474, 'LV', 'Ķekavas novads', 'Ķekavas novads', 125),
(475, 'LT', 'LT-AL', 'Alytaus Apskritis', 131),
(476, 'LT', 'LT-KU', 'Kauno Apskritis', 131),
(477, 'LT', 'LT-KL', 'Klaipėdos Apskritis', 131),
(478, 'LT', 'LT-MR', 'Marijampolės Apskritis', 131),
(479, 'LT', 'LT-PN', 'Panevėžio Apskritis', 131),
(480, 'LT', 'LT-SA', 'Šiaulių Apskritis', 131),
(481, 'LT', 'LT-TA', 'Tauragės Apskritis', 131),
(482, 'LT', 'LT-TE', 'Telšių Apskritis', 131),
(483, 'LT', 'LT-UT', 'Utenos Apskritis', 131),
(484, 'LT', 'LT-VL', 'Vilniaus Apskritis', 131),
(485, 'BR', 'AC', 'Acre', 31),
(486, 'BR', 'AL', 'Alagoas', 31),
(487, 'BR', 'AP', 'Amapá', 31),
(488, 'BR', 'AM', 'Amazonas', 31),
(489, 'BR', 'BA', 'Bahia', 31),
(490, 'BR', 'CE', 'Ceará', 31),
(491, 'BR', 'ES', 'Espírito Santo', 31),
(492, 'BR', 'GO', 'Goiás', 31),
(493, 'BR', 'MA', 'Maranhão', 31),
(494, 'BR', 'MT', 'Mato Grosso', 31),
(495, 'BR', 'MS', 'Mato Grosso do Sul', 31),
(496, 'BR', 'MG', 'Minas Gerais', 31),
(497, 'BR', 'PA', 'Pará', 31),
(498, 'BR', 'PB', 'Paraíba', 31),
(499, 'BR', 'PR', 'Paraná', 31),
(500, 'BR', 'PE', 'Pernambuco', 31),
(501, 'BR', 'PI', 'Piauí', 31),
(502, 'BR', 'RJ', 'Rio de Janeiro', 31),
(503, 'BR', 'RN', 'Rio Grande do Norte', 31),
(504, 'BR', 'RS', 'Rio Grande do Sul', 31),
(505, 'BR', 'RO', 'Rondônia', 31),
(506, 'BR', 'RR', 'Roraima', 31),
(507, 'BR', 'SC', 'Santa Catarina', 31),
(508, 'BR', 'SP', 'São Paulo', 31),
(509, 'BR', 'SE', 'Sergipe', 31),
(510, 'BR', 'TO', 'Tocantins', 31),
(511, 'BR', 'DF', 'Distrito Federal', 31),
(512, 'HR', 'HR-01', 'Zagrebačka županija', 59),
(513, 'HR', 'HR-02', 'Krapinsko-zagorska županija', 59),
(514, 'HR', 'HR-03', 'Sisačko-moslavačka županija', 59),
(515, 'HR', 'HR-04', 'Karlovačka županija', 59),
(516, 'HR', 'HR-05', 'Varaždinska županija', 59),
(517, 'HR', 'HR-06', 'Koprivničko-križevačka županija', 59),
(518, 'HR', 'HR-07', 'Bjelovarsko-bilogorska županija', 59),
(519, 'HR', 'HR-08', 'Primorsko-goranska županija', 59),
(520, 'HR', 'HR-09', 'Ličko-senjska županija', 59),
(521, 'HR', 'HR-10', 'Virovitičko-podravska županija', 59),
(522, 'HR', 'HR-11', 'Požeško-slavonska županija', 59),
(523, 'HR', 'HR-12', 'Brodsko-posavska županija', 59),
(524, 'HR', 'HR-13', 'Zadarska županija', 59),
(525, 'HR', 'HR-14', 'Osječko-baranjska županija', 59),
(526, 'HR', 'HR-15', 'Šibensko-kninska županija', 59),
(527, 'HR', 'HR-16', 'Vukovarsko-srijemska županija', 59),
(528, 'HR', 'HR-17', 'Splitsko-dalmatinska županija', 59),
(529, 'HR', 'HR-18', 'Istarska županija', 59),
(530, 'HR', 'HR-19', 'Dubrovačko-neretvanska županija', 59),
(531, 'HR', 'HR-20', 'Međimurska županija', 59),
(532, 'HR', 'HR-21', 'Grad Zagreb', 59),
(533, 'IN', 'AN', 'Andaman and Nicobar Islands', 106),
(534, 'IN', 'AP', 'Andhra Pradesh', 106),
(535, 'IN', 'AR', 'Arunachal Pradesh', 106),
(536, 'IN', 'AS', 'Assam', 106),
(537, 'IN', 'BR', 'Bihar', 106),
(538, 'IN', 'CH', 'Chandigarh', 106),
(539, 'IN', 'CT', 'Chhattisgarh', 106),
(540, 'IN', 'DN', 'Dadra and Nagar Haveli', 106),
(541, 'IN', 'DD', 'Daman and Diu', 106),
(542, 'IN', 'DL', 'Delhi', 106),
(543, 'IN', 'GA', 'Goa', 106),
(544, 'IN', 'GJ', 'Gujarat', 106),
(545, 'IN', 'HR', 'Haryana', 106),
(546, 'IN', 'HP', 'Himachal Pradesh', 106),
(547, 'IN', 'JK', 'Jammu and Kashmir', 106),
(548, 'IN', 'JH', 'Jharkhand', 106),
(549, 'IN', 'KA', 'Karnataka', 106),
(550, 'IN', 'KL', 'Kerala', 106),
(551, 'IN', 'LD', 'Lakshadweep', 106),
(552, 'IN', 'MP', 'Madhya Pradesh', 106),
(553, 'IN', 'MH', 'Maharashtra', 106),
(554, 'IN', 'MN', 'Manipur', 106),
(555, 'IN', 'ML', 'Meghalaya', 106),
(556, 'IN', 'MZ', 'Mizoram', 106),
(557, 'IN', 'NL', 'Nagaland', 106),
(558, 'IN', 'OR', 'Odisha', 106),
(559, 'IN', 'PY', 'Puducherry', 106),
(560, 'IN', 'PB', 'Punjab', 106),
(561, 'IN', 'RJ', 'Rajasthan', 106),
(562, 'IN', 'SK', 'Sikkim', 106),
(563, 'IN', 'TN', 'Tamil Nadu', 106),
(564, 'IN', 'TG', 'Telangana', 106),
(565, 'IN', 'TR', 'Tripura', 106),
(566, 'IN', 'UP', 'Uttar Pradesh', 106),
(567, 'IN', 'UT', 'Uttarakhand', 106),
(568, 'IN', 'WB', 'West Bengal', 106);

-- --------------------------------------------------------

--
-- Table structure for table `country_state_translations`
--

CREATE TABLE `country_state_translations` (
  `id` int(10) UNSIGNED NOT NULL,
  `locale` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `default_name` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country_state_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `country_state_translations`
--

INSERT INTO `country_state_translations` (`id`, `locale`, `default_name`, `country_state_id`) VALUES
(3409, 'ar', 'ألاباما', 1),
(3410, 'ar', 'ألاسكا', 2),
(3411, 'ar', 'ساموا الأمريكية', 3),
(3412, 'ar', 'أريزونا', 4),
(3413, 'ar', 'أركنساس', 5),
(3414, 'ar', 'القوات المسلحة أفريقيا', 6),
(3415, 'ar', 'القوات المسلحة الأمريكية', 7),
(3416, 'ar', 'القوات المسلحة الكندية', 8),
(3417, 'ar', 'القوات المسلحة أوروبا', 9),
(3418, 'ar', 'القوات المسلحة الشرق الأوسط', 10),
(3419, 'ar', 'القوات المسلحة في المحيط الهادئ', 11),
(3420, 'ar', 'كاليفورنيا', 12),
(3421, 'ar', 'كولورادو', 13),
(3422, 'ar', 'كونيتيكت', 14),
(3423, 'ar', 'ديلاوير', 15),
(3424, 'ar', 'مقاطعة كولومبيا', 16),
(3425, 'ar', 'ولايات ميكرونيزيا الموحدة', 17),
(3426, 'ar', 'فلوريدا', 18),
(3427, 'ar', 'جورجيا', 19),
(3428, 'ar', 'غوام', 20),
(3429, 'ar', 'هاواي', 21),
(3430, 'ar', 'ايداهو', 22),
(3431, 'ar', 'إلينوي', 23),
(3432, 'ar', 'إنديانا', 24),
(3433, 'ar', 'أيوا', 25),
(3434, 'ar', 'كانساس', 26),
(3435, 'ar', 'كنتاكي', 27),
(3436, 'ar', 'لويزيانا', 28),
(3437, 'ar', 'مين', 29),
(3438, 'ar', 'جزر مارشال', 30),
(3439, 'ar', 'ماريلاند', 31),
(3440, 'ar', 'ماساتشوستس', 32),
(3441, 'ar', 'ميشيغان', 33),
(3442, 'ar', 'مينيسوتا', 34),
(3443, 'ar', 'ميسيسيبي', 35),
(3444, 'ar', 'ميسوري', 36),
(3445, 'ar', 'مونتانا', 37),
(3446, 'ar', 'نبراسكا', 38),
(3447, 'ar', 'نيفادا', 39),
(3448, 'ar', 'نيو هامبشاير', 40),
(3449, 'ar', 'نيو جيرسي', 41),
(3450, 'ar', 'المكسيك جديدة', 42),
(3451, 'ar', 'نيويورك', 43),
(3452, 'ar', 'شمال كارولينا', 44),
(3453, 'ar', 'شمال داكوتا', 45),
(3454, 'ar', 'جزر مريانا الشمالية', 46),
(3455, 'ar', 'أوهايو', 47),
(3456, 'ar', 'أوكلاهوما', 48),
(3457, 'ar', 'ولاية أوريغون', 49),
(3458, 'ar', 'بالاو', 50),
(3459, 'ar', 'بنسلفانيا', 51),
(3460, 'ar', 'بورتوريكو', 52),
(3461, 'ar', 'جزيرة رود', 53),
(3462, 'ar', 'كارولينا الجنوبية', 54),
(3463, 'ar', 'جنوب داكوتا', 55),
(3464, 'ar', 'تينيسي', 56),
(3465, 'ar', 'تكساس', 57),
(3466, 'ar', 'يوتا', 58),
(3467, 'ar', 'فيرمونت', 59),
(3468, 'ar', 'جزر فيرجن', 60),
(3469, 'ar', 'فرجينيا', 61),
(3470, 'ar', 'واشنطن', 62),
(3471, 'ar', 'فرجينيا الغربية', 63),
(3472, 'ar', 'ولاية ويسكونسن', 64),
(3473, 'ar', 'وايومنغ', 65),
(3474, 'ar', 'ألبرتا', 66),
(3475, 'ar', 'كولومبيا البريطانية', 67),
(3476, 'ar', 'مانيتوبا', 68),
(3477, 'ar', 'نيوفاوندلاند ولابرادور', 69),
(3478, 'ar', 'برونزيك جديد', 70),
(3479, 'ar', 'مقاطعة نفوفا سكوشيا', 71),
(3480, 'ar', 'الاقاليم الشمالية الغربية', 72),
(3481, 'ar', 'نونافوت', 73),
(3482, 'ar', 'أونتاريو', 74),
(3483, 'ar', 'جزيرة الأمير ادوارد', 75),
(3484, 'ar', 'كيبيك', 76),
(3485, 'ar', 'ساسكاتشوان', 77),
(3486, 'ar', 'إقليم يوكون', 78),
(3487, 'ar', 'Niedersachsen', 79),
(3488, 'ar', 'بادن فورتمبيرغ', 80),
(3489, 'ar', 'بايرن ميونيخ', 81),
(3490, 'ar', 'برلين', 82),
(3491, 'ar', 'براندنبورغ', 83),
(3492, 'ar', 'بريمن', 84),
(3493, 'ar', 'هامبورغ', 85),
(3494, 'ar', 'هيسن', 86),
(3495, 'ar', 'مكلنبورغ-فوربومرن', 87),
(3496, 'ar', 'نوردراين فيستفالن', 88),
(3497, 'ar', 'راينلاند-بفالز', 89),
(3498, 'ar', 'سارلاند', 90),
(3499, 'ar', 'ساكسن', 91),
(3500, 'ar', 'سكسونيا أنهالت', 92),
(3501, 'ar', 'شليسفيغ هولشتاين', 93),
(3502, 'ar', 'تورنغن', 94),
(3503, 'ar', 'فيينا', 95),
(3504, 'ar', 'النمسا السفلى', 96),
(3505, 'ar', 'النمسا العليا', 97),
(3506, 'ar', 'سالزبورغ', 98),
(3507, 'ar', 'Каринтия', 99),
(3508, 'ar', 'STEIERMARK', 100),
(3509, 'ar', 'تيرول', 101),
(3510, 'ar', 'بورغنلاند', 102),
(3511, 'ar', 'فورارلبرغ', 103),
(3512, 'ar', 'أرجاو', 104),
(3513, 'ar', 'Appenzell Innerrhoden', 105),
(3514, 'ar', 'أبنزل أوسيرهودن', 106),
(3515, 'ar', 'برن', 107),
(3516, 'ar', 'كانتون ريف بازل', 108),
(3517, 'ar', 'بازل شتات', 109),
(3518, 'ar', 'فرايبورغ', 110),
(3519, 'ar', 'Genf', 111),
(3520, 'ar', 'جلاروس', 112),
(3521, 'ar', 'غراوبوندن', 113),
(3522, 'ar', 'العصر الجوارسي أو الجوري', 114),
(3523, 'ar', 'لوزيرن', 115),
(3524, 'ar', 'في Neuenburg', 116),
(3525, 'ar', 'نيدوالدن', 117),
(3526, 'ar', 'أوبوالدن', 118),
(3527, 'ar', 'سانت غالن', 119),
(3528, 'ar', 'شافهاوزن', 120),
(3529, 'ar', 'سولوتورن', 121),
(3530, 'ar', 'شفيتس', 122),
(3531, 'ar', 'ثورجو', 123),
(3532, 'ar', 'تيتشينو', 124),
(3533, 'ar', 'أوري', 125),
(3534, 'ar', 'وادت', 126),
(3535, 'ar', 'اليس', 127),
(3536, 'ar', 'زوغ', 128),
(3537, 'ar', 'زيورخ', 129),
(3538, 'ar', 'Corunha', 130),
(3539, 'ar', 'ألافا', 131),
(3540, 'ar', 'الباسيتي', 132),
(3541, 'ar', 'اليكانتي', 133),
(3542, 'ar', 'الميريا', 134),
(3543, 'ar', 'أستورياس', 135),
(3544, 'ar', 'أفيلا', 136),
(3545, 'ar', 'بطليوس', 137),
(3546, 'ar', 'البليار', 138),
(3547, 'ar', 'برشلونة', 139),
(3548, 'ar', 'برغش', 140),
(3549, 'ar', 'كاسيريس', 141),
(3550, 'ar', 'كاديز', 142),
(3551, 'ar', 'كانتابريا', 143),
(3552, 'ar', 'كاستيلون', 144),
(3553, 'ar', 'سبتة', 145),
(3554, 'ar', 'سيوداد ريال', 146),
(3555, 'ar', 'قرطبة', 147),
(3556, 'ar', 'كوينكا', 148),
(3557, 'ar', 'جيرونا', 149),
(3558, 'ar', 'غرناطة', 150),
(3559, 'ar', 'غوادالاخارا', 151),
(3560, 'ar', 'بجويبوزكوا', 152),
(3561, 'ar', 'هويلفا', 153),
(3562, 'ar', 'هويسكا', 154),
(3563, 'ar', 'خاين', 155),
(3564, 'ar', 'لاريوخا', 156),
(3565, 'ar', 'لاس بالماس', 157),
(3566, 'ar', 'ليون', 158),
(3567, 'ar', 'يدا', 159),
(3568, 'ar', 'لوغو', 160),
(3569, 'ar', 'مدريد', 161),
(3570, 'ar', 'ملقة', 162),
(3571, 'ar', 'مليلية', 163),
(3572, 'ar', 'مورسيا', 164),
(3573, 'ar', 'نافارا', 165),
(3574, 'ar', 'أورينس', 166),
(3575, 'ar', 'بلنسية', 167),
(3576, 'ar', 'بونتيفيدرا', 168),
(3577, 'ar', 'سالامانكا', 169),
(3578, 'ar', 'سانتا كروز دي تينيريفي', 170),
(3579, 'ar', 'سيغوفيا', 171),
(3580, 'ar', 'اشبيلية', 172),
(3581, 'ar', 'سوريا', 173),
(3582, 'ar', 'تاراغونا', 174),
(3583, 'ar', 'تيرويل', 175),
(3584, 'ar', 'توليدو', 176),
(3585, 'ar', 'فالنسيا', 177),
(3586, 'ar', 'بلد الوليد', 178),
(3587, 'ar', 'فيزكايا', 179),
(3588, 'ar', 'زامورا', 180),
(3589, 'ar', 'سرقسطة', 181),
(3590, 'ar', 'عين', 182),
(3591, 'ar', 'أيسن', 183),
(3592, 'ar', 'اليي', 184),
(3593, 'ar', 'ألب البروفنس العليا', 185),
(3594, 'ar', 'أوتس ألب', 186),
(3595, 'ar', 'ألب ماريتيم', 187),
(3596, 'ar', 'ARDECHE', 188),
(3597, 'ar', 'Ardennes', 189),
(3598, 'ar', 'آردن', 190),
(3599, 'ar', 'أوب', 191),
(3600, 'ar', 'اود', 192),
(3601, 'ar', 'أفيرون', 193),
(3602, 'ar', 'بوكاس دو رون', 194),
(3603, 'ar', 'كالفادوس', 195),
(3604, 'ar', 'كانتال', 196),
(3605, 'ar', 'شارانت', 197),
(3606, 'ar', 'سيين إت مارن', 198),
(3607, 'ar', 'شير', 199),
(3608, 'ar', 'كوريز', 200),
(3609, 'ar', 'سود كورس-دو-', 201),
(3610, 'ar', 'هوت كورس', 202),
(3611, 'ar', 'كوستا دوركوريز', 203),
(3612, 'ar', 'كوتس دورمور', 204),
(3613, 'ar', 'كروز', 205),
(3614, 'ar', 'دوردوني', 206),
(3615, 'ar', 'دوبس', 207),
(3616, 'ar', 'DrômeFinistère', 208),
(3617, 'ar', 'أور', 209),
(3618, 'ar', 'أور ولوار', 210),
(3619, 'ar', 'فينيستير', 211),
(3620, 'ar', 'جارد', 212),
(3621, 'ar', 'هوت غارون', 213),
(3622, 'ar', 'الخيام', 214),
(3623, 'ar', 'جيروند', 215),
(3624, 'ar', 'هيرولت', 216),
(3625, 'ar', 'إيل وفيلان', 217),
(3626, 'ar', 'إندر', 218),
(3627, 'ar', 'أندر ولوار', 219),
(3628, 'ar', 'إيسر', 220),
(3629, 'ar', 'العصر الجوارسي أو الجوري', 221),
(3630, 'ar', 'اندز', 222),
(3631, 'ar', 'لوار وشير', 223),
(3632, 'ar', 'لوار', 224),
(3633, 'ar', 'هوت-لوار', 225),
(3634, 'ar', 'وار أتلانتيك', 226),
(3635, 'ar', 'لورا', 227),
(3636, 'ar', 'كثيرا', 228),
(3637, 'ar', 'الكثير غارون', 229),
(3638, 'ar', 'لوزر', 230),
(3639, 'ar', 'مين-إي-لوار', 231),
(3640, 'ar', 'المانش', 232),
(3641, 'ar', 'مارن', 233),
(3642, 'ar', 'هوت مارن', 234),
(3643, 'ar', 'مايين', 235),
(3644, 'ar', 'مورت وموزيل', 236),
(3645, 'ar', 'ميوز', 237),
(3646, 'ar', 'موربيهان', 238),
(3647, 'ar', 'موسيل', 239),
(3648, 'ar', 'نيفر', 240),
(3649, 'ar', 'نورد', 241),
(3650, 'ar', 'إيل دو فرانس', 242),
(3651, 'ar', 'أورن', 243),
(3652, 'ar', 'با-دو-كاليه', 244),
(3653, 'ar', 'بوي دي دوم', 245),
(3654, 'ar', 'البرانيس ​​الأطلسية', 246),
(3655, 'ar', 'أوتس-بيرينيهs', 247),
(3656, 'ar', 'بيرينيه-أورينتال', 248),
(3657, 'ar', 'بس رين', 249),
(3658, 'ar', 'أوت رين', 250),
(3659, 'ar', 'رون [3]', 251),
(3660, 'ar', 'هوت-سون', 252),
(3661, 'ar', 'سون ولوار', 253),
(3662, 'ar', 'سارت', 254),
(3663, 'ar', 'سافوا', 255),
(3664, 'ar', 'هاوت سافوي', 256),
(3665, 'ar', 'باريس', 257),
(3666, 'ar', 'سين البحرية', 258),
(3667, 'ar', 'سيين إت مارن', 259),
(3668, 'ar', 'إيفلين', 260),
(3669, 'ar', 'دوكس سفرس', 261),
(3670, 'ar', 'السوم', 262),
(3671, 'ar', 'تارن', 263),
(3672, 'ar', 'تارن وغارون', 264),
(3673, 'ar', 'فار', 265),
(3674, 'ar', 'فوكلوز', 266),
(3675, 'ar', 'تارن', 267),
(3676, 'ar', 'فيين', 268),
(3677, 'ar', 'هوت فيين', 269),
(3678, 'ar', 'الفوج', 270),
(3679, 'ar', 'يون', 271),
(3680, 'ar', 'تيريتوير-دي-بلفور', 272),
(3681, 'ar', 'إيسون', 273),
(3682, 'ar', 'هوت دو سين', 274),
(3683, 'ar', 'سين سان دوني', 275),
(3684, 'ar', 'فال دو مارن', 276),
(3685, 'ar', 'فال دواز', 277),
(3686, 'ar', 'ألبا', 278),
(3687, 'ar', 'اراد', 279),
(3688, 'ar', 'ARGES', 280),
(3689, 'ar', 'باكاو', 281),
(3690, 'ar', 'بيهور', 282),
(3691, 'ar', 'بيستريتا ناسود', 283),
(3692, 'ar', 'بوتوساني', 284),
(3693, 'ar', 'براشوف', 285),
(3694, 'ar', 'برايلا', 286),
(3695, 'ar', 'بوخارست', 287),
(3696, 'ar', 'بوزاو', 288),
(3697, 'ar', 'كاراس سيفيرين', 289),
(3698, 'ar', 'كالاراسي', 290),
(3699, 'ar', 'كلوج', 291),
(3700, 'ar', 'كونستانتا', 292),
(3701, 'ar', 'كوفاسنا', 293),
(3702, 'ar', 'دامبوفيتا', 294),
(3703, 'ar', 'دولج', 295),
(3704, 'ar', 'جالاتي', 296),
(3705, 'ar', 'Giurgiu', 297),
(3706, 'ar', 'غيورغيو', 298),
(3707, 'ar', 'هارغيتا', 299),
(3708, 'ar', 'هونيدوارا', 300),
(3709, 'ar', 'ايالوميتا', 301),
(3710, 'ar', 'ياشي', 302),
(3711, 'ar', 'إيلفوف', 303),
(3712, 'ar', 'مارامريس', 304),
(3713, 'ar', 'MEHEDINTI', 305),
(3714, 'ar', 'موريس', 306),
(3715, 'ar', 'نيامتس', 307),
(3716, 'ar', 'أولت', 308),
(3717, 'ar', 'براهوفا', 309),
(3718, 'ar', 'ساتو ماري', 310),
(3719, 'ar', 'سالاج', 311),
(3720, 'ar', 'سيبيو', 312),
(3721, 'ar', 'سوسيفا', 313),
(3722, 'ar', 'تيليورمان', 314),
(3723, 'ar', 'تيم هو', 315),
(3724, 'ar', 'تولسيا', 316),
(3725, 'ar', 'فاسلوي', 317),
(3726, 'ar', 'فالسيا', 318),
(3727, 'ar', 'فرانتشا', 319),
(3728, 'ar', 'Lappi', 320),
(3729, 'ar', 'Pohjois-Pohjanmaa', 321),
(3730, 'ar', 'كاينو', 322),
(3731, 'ar', 'Pohjois-كارجالا', 323),
(3732, 'ar', 'Pohjois-سافو', 324),
(3733, 'ar', 'Etelä-سافو', 325),
(3734, 'ar', 'Etelä-Pohjanmaa', 326),
(3735, 'ar', 'Pohjanmaa', 327),
(3736, 'ar', 'بيركنما', 328),
(3737, 'ar', 'ساتا كونتا', 329),
(3738, 'ar', 'كسكي-Pohjanmaa', 330),
(3739, 'ar', 'كسكي-سومي', 331),
(3740, 'ar', 'Varsinais-سومي', 332),
(3741, 'ar', 'Etelä-كارجالا', 333),
(3742, 'ar', 'Päijät-Häme', 334),
(3743, 'ar', 'كانتا-HAME', 335),
(3744, 'ar', 'أوسيما', 336),
(3745, 'ar', 'أوسيما', 337),
(3746, 'ar', 'كومنلاكسو', 338),
(3747, 'ar', 'Ahvenanmaa', 339),
(3748, 'ar', 'Harjumaa', 340),
(3749, 'ar', 'هيوما', 341),
(3750, 'ar', 'المؤسسة الدولية للتنمية فيروما', 342),
(3751, 'ar', 'جوغفما', 343),
(3752, 'ar', 'يارفا', 344),
(3753, 'ar', 'انيما', 345),
(3754, 'ar', 'اني فيريوما', 346),
(3755, 'ar', 'بولفاما', 347),
(3756, 'ar', 'بارنوما', 348),
(3757, 'ar', 'Raplamaa', 349),
(3758, 'ar', 'Saaremaa', 350),
(3759, 'ar', 'Tartumaa', 351),
(3760, 'ar', 'Valgamaa', 352),
(3761, 'ar', 'Viljandimaa', 353),
(3762, 'ar', 'روايات Salacgr novvas', 354),
(3763, 'ar', 'داوجافبيلس', 355),
(3764, 'ar', 'يلغافا', 356),
(3765, 'ar', 'يكاب', 357),
(3766, 'ar', 'يورمال', 358),
(3767, 'ar', 'يابايا', 359),
(3768, 'ar', 'ليباج أبريس', 360),
(3769, 'ar', 'ريزكن', 361),
(3770, 'ar', 'ريغا', 362),
(3771, 'ar', 'مقاطعة ريغا', 363),
(3772, 'ar', 'فالميرا', 364),
(3773, 'ar', 'فنتسبيلز', 365),
(3774, 'ar', 'روايات Aglonas', 366),
(3775, 'ar', 'Aizkraukles novads', 367),
(3776, 'ar', 'Aizkraukles novads', 368),
(3777, 'ar', 'Aknīstes novads', 369),
(3778, 'ar', 'Alojas novads', 370),
(3779, 'ar', 'روايات Alsungas', 371),
(3780, 'ar', 'ألكسنس أبريز', 372),
(3781, 'ar', 'روايات أماتاس', 373),
(3782, 'ar', 'قرود الروايات', 374),
(3783, 'ar', 'روايات أوسيس', 375),
(3784, 'ar', 'بابيت الروايات', 376),
(3785, 'ar', 'Baldones الروايات', 377),
(3786, 'ar', 'بالتينافاس الروايات', 378),
(3787, 'ar', 'روايات بالفو', 379),
(3788, 'ar', 'Bauskas الروايات', 380),
(3789, 'ar', 'Beverīnas novads', 381),
(3790, 'ar', 'Novads Brocēnu', 382),
(3791, 'ar', 'Novads Burtnieku', 383),
(3792, 'ar', 'Carnikavas novads', 384),
(3793, 'ar', 'Cesvaines novads', 385),
(3794, 'ar', 'Ciblas novads', 386),
(3795, 'ar', 'تسو أبريس', 387),
(3796, 'ar', 'Dagdas novads', 388),
(3797, 'ar', 'Daugavpils novads', 389),
(3798, 'ar', 'روايات دوبيليس', 390),
(3799, 'ar', 'ديربيس الروايات', 391),
(3800, 'ar', 'ديربيس الروايات', 392),
(3801, 'ar', 'يشرك الروايات', 393),
(3802, 'ar', 'Garkalnes novads', 394),
(3803, 'ar', 'Grobiņas novads', 395),
(3804, 'ar', 'غولبينيس الروايات', 396),
(3805, 'ar', 'إيكافاس روايات', 397),
(3806, 'ar', 'Ikškiles novads', 398),
(3807, 'ar', 'Ilūkstes novads', 399),
(3808, 'ar', 'روايات Inčukalna', 400),
(3809, 'ar', 'Jaunjelgavas novads', 401),
(3810, 'ar', 'Jaunpiebalgas novads', 402),
(3811, 'ar', 'روايات Jaunpiebalgas', 403),
(3812, 'ar', 'Jelgavas novads', 404),
(3813, 'ar', 'جيكابيلس أبريز', 405),
(3814, 'ar', 'روايات كاندافاس', 406),
(3815, 'ar', 'Kokneses الروايات', 407),
(3816, 'ar', 'Krimuldas novads', 408),
(3817, 'ar', 'Krustpils الروايات', 409),
(3818, 'ar', 'Krāslavas Apriņķis', 410),
(3819, 'ar', 'كولدوغاس أبريز', 411),
(3820, 'ar', 'Kārsavas novads', 412),
(3821, 'ar', 'روايات ييلفاريس', 413),
(3822, 'ar', 'ليمباو أبريز', 414),
(3823, 'ar', 'روايات لباناس', 415),
(3824, 'ar', 'روايات لودزاس', 416),
(3825, 'ar', 'مقاطعة ليجاتني', 417),
(3826, 'ar', 'مقاطعة ليفاني', 418),
(3827, 'ar', 'مادونا روايات', 419),
(3828, 'ar', 'Mazsalacas novads', 420),
(3829, 'ar', 'روايات مالبلز', 421),
(3830, 'ar', 'Mārupes novads', 422),
(3831, 'ar', 'نوفاو نوكشنو', 423),
(3832, 'ar', 'روايات نيريتاس', 424),
(3833, 'ar', 'روايات نيكاس', 425),
(3834, 'ar', 'أغنام الروايات', 426),
(3835, 'ar', 'أولينيس الروايات', 427),
(3836, 'ar', 'روايات Ozolnieku', 428),
(3837, 'ar', 'بريسيو أبرييس', 429),
(3838, 'ar', 'Priekules الروايات', 430),
(3839, 'ar', 'كوندادو دي بريكوي', 431),
(3840, 'ar', 'Pärgaujas novads', 432),
(3841, 'ar', 'روايات بافيلوستاس', 433),
(3842, 'ar', 'بلافيناس مقاطعة', 434),
(3843, 'ar', 'روناس روايات', 435),
(3844, 'ar', 'Riebiņu novads', 436),
(3845, 'ar', 'روجاس روايات', 437),
(3846, 'ar', 'Novads روباو', 438),
(3847, 'ar', 'روكافاس روايات', 439),
(3848, 'ar', 'روغاجو روايات', 440),
(3849, 'ar', 'رندلس الروايات', 441),
(3850, 'ar', 'Radzeknes novads', 442),
(3851, 'ar', 'Rūjienas novads', 443),
(3852, 'ar', 'بلدية سالاسغريفا', 444),
(3853, 'ar', 'روايات سالاس', 445),
(3854, 'ar', 'Salaspils novads', 446),
(3855, 'ar', 'روايات سالدوس', 447),
(3856, 'ar', 'Novuls Saulkrastu', 448),
(3857, 'ar', 'سيغولداس روايات', 449),
(3858, 'ar', 'Skrundas novads', 450),
(3859, 'ar', 'مقاطعة Skrīveri', 451),
(3860, 'ar', 'يبتسم الروايات', 452),
(3861, 'ar', 'روايات Stopiņu', 453),
(3862, 'ar', 'روايات Stren novu', 454),
(3863, 'ar', 'سجاس روايات', 455),
(3864, 'ar', 'روايات تالسو', 456),
(3865, 'ar', 'توكوما الروايات', 457),
(3866, 'ar', 'Tērvetes novads', 458),
(3867, 'ar', 'Vaiņodes novads', 459),
(3868, 'ar', 'فالكاس الروايات', 460),
(3869, 'ar', 'فالميراس الروايات', 461),
(3870, 'ar', 'مقاطعة فاكلاني', 462),
(3871, 'ar', 'Vecpiebalgas novads', 463),
(3872, 'ar', 'روايات Vecumnieku', 464),
(3873, 'ar', 'فنتسبيلس الروايات', 465),
(3874, 'ar', 'Viesītes Novads', 466),
(3875, 'ar', 'Viļakas novads', 467),
(3876, 'ar', 'روايات فيناو', 468),
(3877, 'ar', 'Vārkavas novads', 469),
(3878, 'ar', 'روايات زيلوبس', 470),
(3879, 'ar', 'مقاطعة أدازي', 471),
(3880, 'ar', 'مقاطعة Erglu', 472),
(3881, 'ar', 'مقاطعة كيغمس', 473),
(3882, 'ar', 'مقاطعة كيكافا', 474),
(3883, 'ar', 'Alytaus Apskritis', 475),
(3884, 'ar', 'كاونو ابكريتيس', 476),
(3885, 'ar', 'Klaipėdos apskritis', 477),
(3886, 'ar', 'Marijampol\'s apskritis', 478),
(3887, 'ar', 'Panevėžio apskritis', 479),
(3888, 'ar', 'uliaulių apskritis', 480),
(3889, 'ar', 'Taurag\'s apskritis', 481),
(3890, 'ar', 'Telšių apskritis', 482),
(3891, 'ar', 'Utenos apskritis', 483),
(3892, 'ar', 'فيلنياوس ابكريتيس', 484),
(3893, 'ar', 'فدان', 485),
(3894, 'ar', 'ألاغواس', 486),
(3895, 'ar', 'أمابا', 487),
(3896, 'ar', 'أمازوناس', 488),
(3897, 'ar', 'باهيا', 489),
(3898, 'ar', 'سيارا', 490),
(3899, 'ar', 'إسبيريتو سانتو', 491),
(3900, 'ar', 'غوياس', 492),
(3901, 'ar', 'مارانهاو', 493),
(3902, 'ar', 'ماتو جروسو', 494),
(3903, 'ar', 'ماتو جروسو دو سول', 495),
(3904, 'ar', 'ميناس جريس', 496),
(3905, 'ar', 'بارا', 497),
(3906, 'ar', 'بارايبا', 498),
(3907, 'ar', 'بارانا', 499),
(3908, 'ar', 'بيرنامبوكو', 500),
(3909, 'ar', 'بياوي', 501),
(3910, 'ar', 'ريو دي جانيرو', 502),
(3911, 'ar', 'ريو غراندي دو نورتي', 503),
(3912, 'ar', 'ريو غراندي دو سول', 504),
(3913, 'ar', 'روندونيا', 505),
(3914, 'ar', 'رورايما', 506),
(3915, 'ar', 'سانتا كاتارينا', 507),
(3916, 'ar', 'ساو باولو', 508),
(3917, 'ar', 'سيرغيبي', 509),
(3918, 'ar', 'توكانتينز', 510),
(3919, 'ar', 'وفي مقاطعة الاتحادية', 511),
(3920, 'ar', 'Zagrebačka زوبانيا', 512),
(3921, 'ar', 'Krapinsko-zagorska زوبانيا', 513),
(3922, 'ar', 'Sisačko-moslavačka زوبانيا', 514),
(3923, 'ar', 'كارلوفيتش شوبانيا', 515),
(3924, 'ar', 'فارادينسكا زوبانيجا', 516),
(3925, 'ar', 'Koprivničko-križevačka زوبانيجا', 517),
(3926, 'ar', 'بيلوفارسكو-بيلوجورسكا', 518),
(3927, 'ar', 'بريمورسكو غورانسكا سوبانيا', 519),
(3928, 'ar', 'ليكو سينيسكا زوبانيا', 520),
(3929, 'ar', 'Virovitičko-podravska زوبانيا', 521),
(3930, 'ar', 'Požeško-slavonska županija', 522),
(3931, 'ar', 'Brodsko-posavska županija', 523),
(3932, 'ar', 'زادارسكا زوبانيجا', 524),
(3933, 'ar', 'Osječko-baranjska županija', 525),
(3934, 'ar', 'شيبنسكو-كنينسكا سوبانيا', 526),
(3935, 'ar', 'Virovitičko-podravska زوبانيا', 527),
(3936, 'ar', 'Splitsko-dalmatinska زوبانيا', 528),
(3937, 'ar', 'Istarska زوبانيا', 529),
(3938, 'ar', 'Dubrovačko-neretvanska زوبانيا', 530),
(3939, 'ar', 'Međimurska زوبانيا', 531),
(3940, 'ar', 'غراد زغرب', 532),
(3941, 'ar', 'جزر أندامان ونيكوبار', 533),
(3942, 'ar', 'ولاية اندرا براديش', 534),
(3943, 'ar', 'اروناتشال براديش', 535),
(3944, 'ar', 'أسام', 536),
(3945, 'ar', 'بيهار', 537),
(3946, 'ar', 'شانديغار', 538),
(3947, 'ar', 'تشهاتيسجاره', 539),
(3948, 'ar', 'دادرا ونجار هافيلي', 540),
(3949, 'ar', 'دامان وديو', 541),
(3950, 'ar', 'دلهي', 542),
(3951, 'ar', 'غوا', 543),
(3952, 'ar', 'غوجارات', 544),
(3953, 'ar', 'هاريانا', 545),
(3954, 'ar', 'هيماشال براديش', 546),
(3955, 'ar', 'جامو وكشمير', 547),
(3956, 'ar', 'جهارخاند', 548),
(3957, 'ar', 'كارناتاكا', 549),
(3958, 'ar', 'ولاية كيرالا', 550),
(3959, 'ar', 'اكشادويب', 551),
(3960, 'ar', 'ماديا براديش', 552),
(3961, 'ar', 'ماهاراشترا', 553),
(3962, 'ar', 'مانيبور', 554),
(3963, 'ar', 'ميغالايا', 555),
(3964, 'ar', 'ميزورام', 556),
(3965, 'ar', 'ناجالاند', 557),
(3966, 'ar', 'أوديشا', 558),
(3967, 'ar', 'بودوتشيري', 559),
(3968, 'ar', 'البنجاب', 560),
(3969, 'ar', 'راجستان', 561),
(3970, 'ar', 'سيكيم', 562),
(3971, 'ar', 'تاميل نادو', 563),
(3972, 'ar', 'تيلانجانا', 564),
(3973, 'ar', 'تريبورا', 565),
(3974, 'ar', 'ولاية اوتار براديش', 566),
(3975, 'ar', 'أوتارانتشال', 567),
(3976, 'ar', 'البنغال الغربية', 568),
(3977, 'fa', 'آلاباما', 1),
(3978, 'fa', 'آلاسکا', 2),
(3979, 'fa', 'ساموآ آمریکایی', 3),
(3980, 'fa', 'آریزونا', 4),
(3981, 'fa', 'آرکانزاس', 5),
(3982, 'fa', 'نیروهای مسلح آفریقا', 6),
(3983, 'fa', 'Armed Forces America', 7),
(3984, 'fa', 'نیروهای مسلح کانادا', 8),
(3985, 'fa', 'نیروهای مسلح اروپا', 9),
(3986, 'fa', 'نیروهای مسلح خاورمیانه', 10),
(3987, 'fa', 'نیروهای مسلح اقیانوس آرام', 11),
(3988, 'fa', 'کالیفرنیا', 12),
(3989, 'fa', 'کلرادو', 13),
(3990, 'fa', 'کانکتیکات', 14),
(3991, 'fa', 'دلاور', 15),
(3992, 'fa', 'منطقه کلمبیا', 16),
(3993, 'fa', 'ایالات فدرال میکرونزی', 17),
(3994, 'fa', 'فلوریدا', 18),
(3995, 'fa', 'جورجیا', 19),
(3996, 'fa', 'گوام', 20),
(3997, 'fa', 'هاوایی', 21),
(3998, 'fa', 'آیداهو', 22),
(3999, 'fa', 'ایلینویز', 23),
(4000, 'fa', 'ایندیانا', 24),
(4001, 'fa', 'آیووا', 25),
(4002, 'fa', 'کانزاس', 26),
(4003, 'fa', 'کنتاکی', 27),
(4004, 'fa', 'لوئیزیانا', 28),
(4005, 'fa', 'ماین', 29),
(4006, 'fa', 'مای', 30),
(4007, 'fa', 'مریلند', 31),
(4008, 'fa', ' ', 32),
(4009, 'fa', 'میشیگان', 33),
(4010, 'fa', 'مینه سوتا', 34),
(4011, 'fa', 'می سی سی پی', 35),
(4012, 'fa', 'میسوری', 36),
(4013, 'fa', 'مونتانا', 37),
(4014, 'fa', 'نبراسکا', 38),
(4015, 'fa', 'نواد', 39),
(4016, 'fa', 'نیوهمپشایر', 40),
(4017, 'fa', 'نیوجرسی', 41),
(4018, 'fa', 'نیومکزیکو', 42),
(4019, 'fa', 'نیویورک', 43),
(4020, 'fa', 'کارولینای شمالی', 44),
(4021, 'fa', 'داکوتای شمالی', 45),
(4022, 'fa', 'جزایر ماریانای شمالی', 46),
(4023, 'fa', 'اوهایو', 47),
(4024, 'fa', 'اوکلاهما', 48),
(4025, 'fa', 'اورگان', 49),
(4026, 'fa', 'پالائو', 50),
(4027, 'fa', 'پنسیلوانیا', 51),
(4028, 'fa', 'پورتوریکو', 52),
(4029, 'fa', 'رود آیلند', 53),
(4030, 'fa', 'کارولینای جنوبی', 54),
(4031, 'fa', 'داکوتای جنوبی', 55),
(4032, 'fa', 'تنسی', 56),
(4033, 'fa', 'تگزاس', 57),
(4034, 'fa', 'یوتا', 58),
(4035, 'fa', 'ورمونت', 59),
(4036, 'fa', 'جزایر ویرجین', 60),
(4037, 'fa', 'ویرجینیا', 61),
(4038, 'fa', 'واشنگتن', 62),
(4039, 'fa', 'ویرجینیای غربی', 63),
(4040, 'fa', 'ویسکانسین', 64),
(4041, 'fa', 'وایومینگ', 65),
(4042, 'fa', 'آلبرتا', 66),
(4043, 'fa', 'بریتیش کلمبیا', 67),
(4044, 'fa', 'مانیتوبا', 68),
(4045, 'fa', 'نیوفاندلند و لابرادور', 69),
(4046, 'fa', 'نیوبرانزویک', 70),
(4047, 'fa', 'نوا اسکوشیا', 71),
(4048, 'fa', 'سرزمینهای شمال غربی', 72),
(4049, 'fa', 'نوناووت', 73),
(4050, 'fa', 'انتاریو', 74),
(4051, 'fa', 'جزیره پرنس ادوارد', 75),
(4052, 'fa', 'کبک', 76),
(4053, 'fa', 'ساسکاتچوان', 77),
(4054, 'fa', 'قلمرو یوکان', 78),
(4055, 'fa', 'نیدرزاکسن', 79),
(4056, 'fa', 'بادن-وورتمبرگ', 80),
(4057, 'fa', 'بایرن', 81),
(4058, 'fa', 'برلین', 82),
(4059, 'fa', 'براندنبورگ', 83),
(4060, 'fa', 'برمن', 84),
(4061, 'fa', 'هامبور', 85),
(4062, 'fa', 'هسن', 86),
(4063, 'fa', 'مکلنبورگ-وورپومرن', 87),
(4064, 'fa', 'نوردراین-وستفالن', 88),
(4065, 'fa', 'راینلاند-پلاتینات', 89),
(4066, 'fa', 'سارلند', 90),
(4067, 'fa', 'ساچسن', 91),
(4068, 'fa', 'ساچسن-آنهالت', 92),
(4069, 'fa', 'شلسویگ-هولشتاین', 93),
(4070, 'fa', 'تورینگی', 94),
(4071, 'fa', 'وین', 95),
(4072, 'fa', 'اتریش پایین', 96),
(4073, 'fa', 'اتریش فوقانی', 97),
(4074, 'fa', 'سالزبورگ', 98),
(4075, 'fa', 'کارنتا', 99),
(4076, 'fa', 'Steiermar', 100),
(4077, 'fa', 'تیرول', 101),
(4078, 'fa', 'بورگنلن', 102),
(4079, 'fa', 'Vorarlber', 103),
(4080, 'fa', 'آرگ', 104),
(4081, 'fa', '', 105),
(4082, 'fa', 'اپنزلسرهودن', 106),
(4083, 'fa', 'بر', 107),
(4084, 'fa', 'بازل-لندشفت', 108),
(4085, 'fa', 'بازل استاد', 109),
(4086, 'fa', 'فرایبورگ', 110),
(4087, 'fa', 'گنف', 111),
(4088, 'fa', 'گلاروس', 112),
(4089, 'fa', 'Graubünde', 113),
(4090, 'fa', 'ژورا', 114),
(4091, 'fa', 'لوزرن', 115),
(4092, 'fa', 'نوینبور', 116),
(4093, 'fa', 'نیدالد', 117),
(4094, 'fa', 'اوبولدن', 118),
(4095, 'fa', 'سنت گالن', 119),
(4096, 'fa', 'شافهاوز', 120),
(4097, 'fa', 'سولوتور', 121),
(4098, 'fa', 'شووی', 122),
(4099, 'fa', 'تورگاو', 123),
(4100, 'fa', 'تسسی', 124),
(4101, 'fa', 'اوری', 125),
(4102, 'fa', 'وادت', 126),
(4103, 'fa', 'والی', 127),
(4104, 'fa', 'ز', 128),
(4105, 'fa', 'زوریخ', 129),
(4106, 'fa', 'کورونا', 130),
(4107, 'fa', 'آلاوا', 131),
(4108, 'fa', 'آلبوم', 132),
(4109, 'fa', 'آلیکانت', 133),
(4110, 'fa', 'آلمریا', 134),
(4111, 'fa', 'آستوریا', 135),
(4112, 'fa', 'آویلا', 136),
(4113, 'fa', 'باداژوز', 137),
(4114, 'fa', 'ضرب و شتم', 138),
(4115, 'fa', 'بارسلون', 139),
(4116, 'fa', 'بورگو', 140),
(4117, 'fa', 'کاسر', 141),
(4118, 'fa', 'کادی', 142),
(4119, 'fa', 'کانتابریا', 143),
(4120, 'fa', 'کاستلون', 144),
(4121, 'fa', 'سوت', 145),
(4122, 'fa', 'سیوداد واقعی', 146),
(4123, 'fa', 'کوردوب', 147),
(4124, 'fa', 'Cuenc', 148),
(4125, 'fa', 'جیرون', 149),
(4126, 'fa', 'گراناد', 150),
(4127, 'fa', 'گوادالاجار', 151),
(4128, 'fa', 'Guipuzcoa', 152),
(4129, 'fa', 'هولوا', 153),
(4130, 'fa', 'هوسک', 154),
(4131, 'fa', 'جی', 155),
(4132, 'fa', 'لا ریوجا', 156),
(4133, 'fa', 'لاس پالماس', 157),
(4134, 'fa', 'لئو', 158),
(4135, 'fa', 'Lleid', 159),
(4136, 'fa', 'لوگ', 160),
(4137, 'fa', 'مادری', 161),
(4138, 'fa', 'مالاگ', 162),
(4139, 'fa', 'ملیلی', 163),
(4140, 'fa', 'مورسیا', 164),
(4141, 'fa', 'ناوار', 165),
(4142, 'fa', 'اورنس', 166),
(4143, 'fa', 'پالنسی', 167),
(4144, 'fa', 'پونتوودر', 168),
(4145, 'fa', 'سالامانک', 169),
(4146, 'fa', 'سانتا کروز د تنریفه', 170),
(4147, 'fa', 'سوگویا', 171),
(4148, 'fa', 'سوی', 172),
(4149, 'fa', 'سوریا', 173),
(4150, 'fa', 'تاراگونا', 174),
(4151, 'fa', 'ترئو', 175),
(4152, 'fa', 'تولدو', 176),
(4153, 'fa', 'والنسیا', 177),
(4154, 'fa', 'والادولی', 178),
(4155, 'fa', 'ویزکایا', 179),
(4156, 'fa', 'زامور', 180),
(4157, 'fa', 'ساراگوز', 181),
(4158, 'fa', 'عی', 182),
(4159, 'fa', 'آیز', 183),
(4160, 'fa', 'آلی', 184),
(4161, 'fa', 'آلپ-دو-هاوت-پرووانس', 185),
(4162, 'fa', 'هاوتس آلپ', 186),
(4163, 'fa', 'Alpes-Maritime', 187),
(4164, 'fa', 'اردچه', 188),
(4165, 'fa', 'آرد', 189),
(4166, 'fa', 'محاصر', 190),
(4167, 'fa', 'آبه', 191),
(4168, 'fa', 'Aud', 192),
(4169, 'fa', 'آویرون', 193),
(4170, 'fa', 'BOCAS DO Rhône', 194),
(4171, 'fa', 'نوعی عرق', 195),
(4172, 'fa', 'کانتینال', 196),
(4173, 'fa', 'چارنت', 197),
(4174, 'fa', 'چارنت-دریایی', 198),
(4175, 'fa', 'چ', 199),
(4176, 'fa', 'کور', 200),
(4177, 'fa', 'کرس دو ساد', 201),
(4178, 'fa', 'هاوت کورس', 202),
(4179, 'fa', 'کوستا دورکرز', 203),
(4180, 'fa', 'تخت دارمور', 204),
(4181, 'fa', 'درهم', 205),
(4182, 'fa', 'دوردگن', 206),
(4183, 'fa', 'دوب', 207),
(4184, 'fa', 'تعریف اول', 208),
(4185, 'fa', 'یور', 209),
(4186, 'fa', 'Eure-et-Loi', 210),
(4187, 'fa', 'فمینیست', 211),
(4188, 'fa', 'باغ', 212),
(4189, 'fa', 'اوت-گارون', 213),
(4190, 'fa', 'گر', 214),
(4191, 'fa', 'جیروند', 215),
(4192, 'fa', 'هیر', 216),
(4193, 'fa', 'هشدار داده می شود', 217),
(4194, 'fa', 'ایندور', 218),
(4195, 'fa', 'Indre-et-Loir', 219),
(4196, 'fa', 'ایزر', 220),
(4197, 'fa', 'یور', 221),
(4198, 'fa', 'لندز', 222),
(4199, 'fa', 'Loir-et-Che', 223),
(4200, 'fa', 'وام گرفتن', 224),
(4201, 'fa', 'Haute-Loir', 225),
(4202, 'fa', 'Loire-Atlantiqu', 226),
(4203, 'fa', 'لیرت', 227),
(4204, 'fa', 'لوط', 228),
(4205, 'fa', 'لوت و گارون', 229),
(4206, 'fa', 'لوزر', 230),
(4207, 'fa', 'ماین et-Loire', 231),
(4208, 'fa', 'مانچ', 232),
(4209, 'fa', 'مارن', 233),
(4210, 'fa', 'هاوت-مارن', 234),
(4211, 'fa', 'مایین', 235),
(4212, 'fa', 'مورته-et-Moselle', 236),
(4213, 'fa', 'مسخره کردن', 237),
(4214, 'fa', 'موربیان', 238),
(4215, 'fa', 'موزل', 239),
(4216, 'fa', 'Nièvr', 240),
(4217, 'fa', 'نورد', 241),
(4218, 'fa', 'اوی', 242),
(4219, 'fa', 'ارن', 243),
(4220, 'fa', 'پاس-کاله', 244),
(4221, 'fa', 'Puy-de-Dôm', 245),
(4222, 'fa', 'Pyrénées-Atlantiques', 246),
(4223, 'fa', 'Hautes-Pyrénée', 247),
(4224, 'fa', 'Pyrénées-Orientales', 248),
(4225, 'fa', 'بس راین', 249),
(4226, 'fa', 'هاوت-رین', 250),
(4227, 'fa', 'رو', 251),
(4228, 'fa', 'Haute-Saône', 252),
(4229, 'fa', 'Saône-et-Loire', 253),
(4230, 'fa', 'سارته', 254),
(4231, 'fa', 'ساووی', 255),
(4232, 'fa', 'هاو-ساووی', 256),
(4233, 'fa', 'پاری', 257),
(4234, 'fa', 'Seine-Maritime', 258),
(4235, 'fa', 'Seine-et-Marn', 259),
(4236, 'fa', 'ایولینز', 260),
(4237, 'fa', 'Deux-Sèvres', 261),
(4238, 'fa', 'سمی', 262),
(4239, 'fa', 'ضعف', 263),
(4240, 'fa', 'Tarn-et-Garonne', 264),
(4241, 'fa', 'وار', 265),
(4242, 'fa', 'ووکلوز', 266),
(4243, 'fa', 'وندیه', 267),
(4244, 'fa', 'وین', 268),
(4245, 'fa', 'هاوت-وین', 269),
(4246, 'fa', 'رأی دادن', 270),
(4247, 'fa', 'یون', 271),
(4248, 'fa', 'سرزمین-دو-بلفورت', 272),
(4249, 'fa', 'اسون', 273),
(4250, 'fa', 'هاوتز دی سی', 274),
(4251, 'fa', 'Seine-Saint-Deni', 275),
(4252, 'fa', 'والد مارن', 276),
(4253, 'fa', 'Val-d\'Ois', 277),
(4254, 'fa', 'آلبا', 278),
(4255, 'fa', 'آرا', 279),
(4256, 'fa', 'Argeș', 280),
(4257, 'fa', 'باکو', 281),
(4258, 'fa', 'بیهور', 282),
(4259, 'fa', 'بیستریا-نسوود', 283),
(4260, 'fa', 'بوتانی', 284),
(4261, 'fa', 'برازوف', 285),
(4262, 'fa', 'Brăila', 286),
(4263, 'fa', 'București', 287),
(4264, 'fa', 'بوز', 288),
(4265, 'fa', 'کارا- Severin', 289),
(4266, 'fa', 'کالیراسی', 290),
(4267, 'fa', 'كلوژ', 291),
(4268, 'fa', 'کنستانس', 292),
(4269, 'fa', 'کواسنا', 293),
(4270, 'fa', 'Dâmbovița', 294),
(4271, 'fa', 'دال', 295),
(4272, 'fa', 'گالشی', 296),
(4273, 'fa', 'جورجیو', 297),
(4274, 'fa', 'گور', 298),
(4275, 'fa', 'هارگیتا', 299),
(4276, 'fa', 'هوندهار', 300),
(4277, 'fa', 'ایالومیشا', 301),
(4278, 'fa', 'Iași', 302),
(4279, 'fa', 'Ilfo', 303),
(4280, 'fa', 'Maramureș', 304),
(4281, 'fa', 'Mehedinți', 305),
(4282, 'fa', 'Mureș', 306),
(4283, 'fa', 'Neamț', 307),
(4284, 'fa', 'اولت', 308),
(4285, 'fa', 'پرهوا', 309),
(4286, 'fa', 'ستو ماره', 310),
(4287, 'fa', 'سلاج', 311),
(4288, 'fa', 'سیبیو', 312),
(4289, 'fa', 'سوساو', 313),
(4290, 'fa', 'تلورمان', 314),
(4291, 'fa', 'تیمیچ', 315),
(4292, 'fa', 'تولسا', 316),
(4293, 'fa', 'واسلوئی', 317),
(4294, 'fa', 'Vâlcea', 318),
(4295, 'fa', 'ورانسا', 319),
(4296, 'fa', 'لاپی', 320),
(4297, 'fa', 'Pohjois-Pohjanmaa', 321),
(4298, 'fa', 'کائینو', 322),
(4299, 'fa', 'Pohjois-Karjala', 323),
(4300, 'fa', 'Pohjois-Savo', 324),
(4301, 'fa', 'اتل-ساوو', 325),
(4302, 'fa', 'کسکی-پوهانما', 326),
(4303, 'fa', 'Pohjanmaa', 327),
(4304, 'fa', 'پیرکانما', 328),
(4305, 'fa', 'ساتاکونتا', 329),
(4306, 'fa', 'کسکی-پوهانما', 330),
(4307, 'fa', 'کسکی-سوومی', 331),
(4308, 'fa', 'Varsinais-Suomi', 332),
(4309, 'fa', 'اتلی کرجالا', 333),
(4310, 'fa', 'Päijät-HAM', 334),
(4311, 'fa', 'کانتا-هوم', 335),
(4312, 'fa', 'یوسیما', 336),
(4313, 'fa', 'اوسیم', 337),
(4314, 'fa', 'کیمنلاکو', 338),
(4315, 'fa', 'آونوانما', 339),
(4316, 'fa', 'هارژوم', 340),
(4317, 'fa', 'سلا', 341),
(4318, 'fa', 'آیدا-ویروما', 342),
(4319, 'fa', 'Jõgevamaa', 343),
(4320, 'fa', 'جوروماا', 344),
(4321, 'fa', 'لونما', 345),
(4322, 'fa', 'لون-ویروما', 346),
(4323, 'fa', 'پالوماا', 347),
(4324, 'fa', 'پورنوما', 348),
(4325, 'fa', 'Raplama', 349),
(4326, 'fa', 'ساارما', 350),
(4327, 'fa', 'تارتوما', 351),
(4328, 'fa', 'والگام', 352),
(4329, 'fa', 'ویلجاندیم', 353),
(4330, 'fa', 'Võrumaa', 354),
(4331, 'fa', 'داگاوپیل', 355),
(4332, 'fa', 'جلگاو', 356),
(4333, 'fa', 'جکابیل', 357),
(4334, 'fa', 'جرمل', 358),
(4335, 'fa', 'لیپجا', 359),
(4336, 'fa', 'شهرستان لیپاج', 360),
(4337, 'fa', 'روژن', 361),
(4338, 'fa', 'راگ', 362),
(4339, 'fa', 'شهرستان ریگ', 363),
(4340, 'fa', 'والمییرا', 364),
(4341, 'fa', 'Ventspils', 365),
(4342, 'fa', 'آگلوناس نوادا', 366),
(4343, 'fa', 'تازه کاران آیزکرایکلس', 367),
(4344, 'fa', 'تازه واردان', 368),
(4345, 'fa', 'شهرستا', 369),
(4346, 'fa', 'نوازندگان آلوجاس', 370),
(4347, 'fa', 'تازه های آلسونگاس', 371),
(4348, 'fa', 'شهرستان آلوکس', 372),
(4349, 'fa', 'تازه کاران آماتاس', 373),
(4350, 'fa', 'میمون های تازه', 374),
(4351, 'fa', 'نوادا را آویز می کند', 375),
(4352, 'fa', 'شهرستان بابی', 376),
(4353, 'fa', 'Baldones novad', 377),
(4354, 'fa', 'نوین های بالتیناوا', 378),
(4355, 'fa', 'Balvu novad', 379),
(4356, 'fa', 'نوازندگان باسکاس', 380),
(4357, 'fa', 'شهرستان بورین', 381),
(4358, 'fa', 'شهرستان بروچن', 382),
(4359, 'fa', 'بوردنیکو نوآوران', 383),
(4360, 'fa', 'تازه کارنیکاوا', 384),
(4361, 'fa', 'نوازان سزوینس', 385),
(4362, 'fa', 'نوادگان Cibla', 386),
(4363, 'fa', 'شهرستان Cesis', 387),
(4364, 'fa', 'تازه های داگدا', 388),
(4365, 'fa', 'داوگاوپیلز نوادا', 389),
(4366, 'fa', 'دابل نوادی', 390),
(4367, 'fa', 'تازه کارهای دنداگاس', 391),
(4368, 'fa', 'نوباد دوربس', 392),
(4369, 'fa', 'مشغول تازه کارها است', 393),
(4370, 'fa', 'گرکالنس نواد', 394),
(4371, 'fa', 'یا شهرستان گروبی', 395),
(4372, 'fa', 'تازه های گلبنس', 396),
(4373, 'fa', 'Iecavas novads', 397),
(4374, 'fa', 'شهرستان ایسکل', 398),
(4375, 'fa', 'ایالت ایلکست', 399),
(4376, 'fa', 'کنددو د اینچوکالن', 400),
(4377, 'fa', 'نوجواد Jaunjelgavas', 401),
(4378, 'fa', 'تازه های Jaunpiebalgas', 402),
(4379, 'fa', 'شهرستان جونپیلس', 403),
(4380, 'fa', 'شهرستان جگلو', 404),
(4381, 'fa', 'شهرستان جکابیل', 405),
(4382, 'fa', 'شهرستان کنداوا', 406),
(4383, 'fa', 'شهرستان کوکنز', 407),
(4384, 'fa', 'شهرستان کریمولد', 408),
(4385, 'fa', 'شهرستان کرستپیل', 409),
(4386, 'fa', 'شهرستان کراسلاو', 410),
(4387, 'fa', 'کاندادو د کلدیگا', 411),
(4388, 'fa', 'کاندادو د کارساوا', 412),
(4389, 'fa', 'شهرستان لیولوارد', 413),
(4390, 'fa', 'شهرستان لیمباشی', 414),
(4391, 'fa', 'ای ولسوالی لوبون', 415),
(4392, 'fa', 'شهرستان لودزا', 416),
(4393, 'fa', 'شهرستان لیگات', 417),
(4394, 'fa', 'شهرستان لیوانی', 418),
(4395, 'fa', 'شهرستان مادونا', 419),
(4396, 'fa', 'شهرستان مازسال', 420),
(4397, 'fa', 'شهرستان مالپیلس', 421),
(4398, 'fa', 'شهرستان Mārupe', 422),
(4399, 'fa', 'ا کنددو د نوکشنی', 423),
(4400, 'fa', 'کاملاً یک شهرستان', 424),
(4401, 'fa', 'شهرستان نیکا', 425),
(4402, 'fa', 'شهرستان اوگر', 426),
(4403, 'fa', 'شهرستان اولین', 427),
(4404, 'fa', 'شهرستان اوزولنیکی', 428),
(4405, 'fa', 'شهرستان پرلیلی', 429),
(4406, 'fa', 'شهرستان Priekule', 430),
(4407, 'fa', 'Condado de Priekuļi', 431),
(4408, 'fa', 'شهرستان در حال حرکت', 432),
(4409, 'fa', 'شهرستان پاویلوستا', 433),
(4410, 'fa', 'شهرستان Plavinas', 4),
(4411, 'fa', 'شهرستان راونا', 435),
(4412, 'fa', 'شهرستان ریبیشی', 436),
(4413, 'fa', 'شهرستان روجا', 437),
(4414, 'fa', 'شهرستان روپازی', 438),
(4415, 'fa', 'شهرستان روساوا', 439),
(4416, 'fa', 'شهرستان روگی', 440),
(4417, 'fa', 'شهرستان راندل', 441),
(4418, 'fa', 'شهرستان ریزکن', 442),
(4419, 'fa', 'شهرستان روژینا', 443),
(4420, 'fa', 'شهرداری Salacgriva', 444),
(4421, 'fa', 'منطقه جزیره', 445),
(4422, 'fa', 'شهرستان Salaspils', 446),
(4423, 'fa', 'شهرستان سالدوس', 447),
(4424, 'fa', 'شهرستان ساولکرستی', 448),
(4425, 'fa', 'شهرستان سیگولدا', 449),
(4426, 'fa', 'شهرستان Skrunda', 450),
(4427, 'fa', 'شهرستان Skrīveri', 451),
(4428, 'fa', 'شهرستان Smiltene', 452),
(4429, 'fa', 'شهرستان ایستینی', 453),
(4430, 'fa', 'شهرستان استرنشی', 454),
(4431, 'fa', 'منطقه کاشت', 455),
(4432, 'fa', 'شهرستان تالسی', 456),
(4433, 'fa', 'توکومس', 457),
(4434, 'fa', 'شهرستان تورت', 458),
(4435, 'fa', 'یا شهرستان وایودود', 459),
(4436, 'fa', 'شهرستان والکا', 460),
(4437, 'fa', 'شهرستان Valmiera', 461),
(4438, 'fa', 'شهرستان وارکانی', 462),
(4439, 'fa', 'شهرستان Vecpiebalga', 463),
(4440, 'fa', 'شهرستان وکومنیکی', 464),
(4441, 'fa', 'شهرستان ونتسپیل', 465),
(4442, 'fa', 'کنددو د بازدید', 466),
(4443, 'fa', 'شهرستان ویلاکا', 467),
(4444, 'fa', 'شهرستان ویلانی', 468),
(4445, 'fa', 'شهرستان واركاوا', 469),
(4446, 'fa', 'شهرستان زیلوپ', 470),
(4447, 'fa', 'شهرستان آدازی', 471),
(4448, 'fa', 'شهرستان ارگلو', 472),
(4449, 'fa', 'شهرستان کگومس', 473),
(4450, 'fa', 'شهرستان ککاوا', 474),
(4451, 'fa', 'شهرستان Alytus', 475),
(4452, 'fa', 'شهرستان Kaunas', 476),
(4453, 'fa', 'شهرستان کلایپدا', 477),
(4454, 'fa', 'شهرستان ماریجامپولی', 478),
(4455, 'fa', 'شهرستان پانویسیز', 479),
(4456, 'fa', 'شهرستان سیاولیا', 480),
(4457, 'fa', 'شهرستان تاجیج', 481),
(4458, 'fa', 'شهرستان تلشیا', 482),
(4459, 'fa', 'شهرستان اوتنا', 483),
(4460, 'fa', 'شهرستان ویلنیوس', 484),
(4461, 'fa', 'جریب', 485),
(4462, 'fa', 'حالت', 486),
(4463, 'fa', 'آمپá', 487),
(4464, 'fa', 'آمازون', 488),
(4465, 'fa', 'باهی', 489),
(4466, 'fa', 'سارا', 490),
(4467, 'fa', 'روح القدس', 491),
(4468, 'fa', 'برو', 492),
(4469, 'fa', 'مارانهائ', 493),
(4470, 'fa', 'ماتو گروسو', 494),
(4471, 'fa', 'Mato Grosso do Sul', 495),
(4472, 'fa', 'ایالت میناس گرایس', 496),
(4473, 'fa', 'پار', 497),
(4474, 'fa', 'حالت', 498),
(4475, 'fa', 'پارانا', 499),
(4476, 'fa', 'حال', 500),
(4477, 'fa', 'پیازو', 501),
(4478, 'fa', 'ریو دوژانیرو', 502),
(4479, 'fa', 'ریو گراند دو نورته', 503),
(4480, 'fa', 'ریو گراند دو سول', 504),
(4481, 'fa', 'Rondôni', 505),
(4482, 'fa', 'Roraim', 506),
(4483, 'fa', 'سانتا کاتارینا', 507),
(4484, 'fa', 'پ', 508),
(4485, 'fa', 'Sergip', 509),
(4486, 'fa', 'توکانتین', 510),
(4487, 'fa', 'منطقه فدرال', 511),
(4488, 'fa', 'شهرستان زاگرب', 512),
(4489, 'fa', 'Condado de Krapina-Zagorj', 513),
(4490, 'fa', 'شهرستان سیساک-موسلاوینا', 514),
(4491, 'fa', 'شهرستان کارلوواک', 515),
(4492, 'fa', 'شهرداری واراžدین', 516),
(4493, 'fa', 'Condo de Koprivnica-Križevci', 517),
(4494, 'fa', 'محل سکونت د بیلوار-بلوگورا', 518),
(4495, 'fa', 'Condado de Primorje-Gorski kotar', 519),
(4496, 'fa', 'شهرستان لیکا-سنج', 520),
(4497, 'fa', 'Condado de Virovitica-Podravina', 521),
(4498, 'fa', 'شهرستان پوژگا-اسلاونیا', 522),
(4499, 'fa', 'Condado de Brod-Posavina', 523),
(4500, 'fa', 'شهرستان زجر', 524),
(4501, 'fa', 'Condado de Osijek-Baranja', 525),
(4502, 'fa', 'Condo de Sibenik-Knin', 526),
(4503, 'fa', 'Condado de Vukovar-Srijem', 527),
(4504, 'fa', 'شهرستان اسپلیت-Dalmatia', 528),
(4505, 'fa', 'شهرستان ایستیا', 529),
(4506, 'fa', 'Condado de Dubrovnik-Neretva', 530),
(4507, 'fa', 'شهرستان Međimurje', 531),
(4508, 'fa', 'شهر زاگرب', 532),
(4509, 'fa', 'جزایر آندامان و نیکوبار', 533),
(4510, 'fa', 'آندرا پرادش', 534),
(4511, 'fa', 'آروناچال پرادش', 535),
(4512, 'fa', 'آسام', 536),
(4513, 'fa', 'Biha', 537),
(4514, 'fa', 'چاندیگار', 538),
(4515, 'fa', 'چاتیسگار', 539),
(4516, 'fa', 'دادرا و نگار هاولی', 540),
(4517, 'fa', 'دامان و دیو', 541),
(4518, 'fa', 'دهلی', 542),
(4519, 'fa', 'گوا', 543),
(4520, 'fa', 'گجرات', 544),
(4521, 'fa', 'هاریانا', 545),
(4522, 'fa', 'هیماچال پرادش', 546),
(4523, 'fa', 'جامو و کشمیر', 547),
(4524, 'fa', 'جهخند', 548),
(4525, 'fa', 'کارناتاکا', 549),
(4526, 'fa', 'کرال', 550),
(4527, 'fa', 'لاکشادوپ', 551),
(4528, 'fa', 'مادیا پرادش', 552),
(4529, 'fa', 'ماهاراشترا', 553),
(4530, 'fa', 'مانی پور', 554),
(4531, 'fa', 'مگالایا', 555),
(4532, 'fa', 'مزورام', 556),
(4533, 'fa', 'ناگلند', 557),
(4534, 'fa', 'ادیشا', 558),
(4535, 'fa', 'میناکاری', 559),
(4536, 'fa', 'پنجا', 560),
(4537, 'fa', 'راجستان', 561),
(4538, 'fa', 'سیکیم', 562),
(4539, 'fa', 'تامیل نادو', 563),
(4540, 'fa', 'تلنگانا', 564),
(4541, 'fa', 'تریپورا', 565),
(4542, 'fa', 'اوتار پرادش', 566),
(4543, 'fa', 'اوتاراکند', 567),
(4544, 'fa', 'بنگال غرب', 568),
(4545, 'pt_BR', 'Alabama', 1),
(4546, 'pt_BR', 'Alaska', 2),
(4547, 'pt_BR', 'Samoa Americana', 3),
(4548, 'pt_BR', 'Arizona', 4),
(4549, 'pt_BR', 'Arkansas', 5),
(4550, 'pt_BR', 'Forças Armadas da África', 6),
(4551, 'pt_BR', 'Forças Armadas das Américas', 7),
(4552, 'pt_BR', 'Forças Armadas do Canadá', 8),
(4553, 'pt_BR', 'Forças Armadas da Europa', 9),
(4554, 'pt_BR', 'Forças Armadas do Oriente Médio', 10),
(4555, 'pt_BR', 'Forças Armadas do Pacífico', 11),
(4556, 'pt_BR', 'California', 12),
(4557, 'pt_BR', 'Colorado', 13),
(4558, 'pt_BR', 'Connecticut', 14),
(4559, 'pt_BR', 'Delaware', 15),
(4560, 'pt_BR', 'Distrito de Columbia', 16),
(4561, 'pt_BR', 'Estados Federados da Micronésia', 17),
(4562, 'pt_BR', 'Florida', 18),
(4563, 'pt_BR', 'Geórgia', 19),
(4564, 'pt_BR', 'Guam', 20),
(4565, 'pt_BR', 'Havaí', 21),
(4566, 'pt_BR', 'Idaho', 22),
(4567, 'pt_BR', 'Illinois', 23),
(4568, 'pt_BR', 'Indiana', 24),
(4569, 'pt_BR', 'Iowa', 25),
(4570, 'pt_BR', 'Kansas', 26),
(4571, 'pt_BR', 'Kentucky', 27),
(4572, 'pt_BR', 'Louisiana', 28),
(4573, 'pt_BR', 'Maine', 29),
(4574, 'pt_BR', 'Ilhas Marshall', 30),
(4575, 'pt_BR', 'Maryland', 31),
(4576, 'pt_BR', 'Massachusetts', 32),
(4577, 'pt_BR', 'Michigan', 33),
(4578, 'pt_BR', 'Minnesota', 34),
(4579, 'pt_BR', 'Mississippi', 35),
(4580, 'pt_BR', 'Missouri', 36),
(4581, 'pt_BR', 'Montana', 37),
(4582, 'pt_BR', 'Nebraska', 38),
(4583, 'pt_BR', 'Nevada', 39),
(4584, 'pt_BR', 'New Hampshire', 40),
(4585, 'pt_BR', 'Nova Jersey', 41),
(4586, 'pt_BR', 'Novo México', 42),
(4587, 'pt_BR', 'Nova York', 43),
(4588, 'pt_BR', 'Carolina do Norte', 44),
(4589, 'pt_BR', 'Dakota do Norte', 45),
(4590, 'pt_BR', 'Ilhas Marianas do Norte', 46),
(4591, 'pt_BR', 'Ohio', 47),
(4592, 'pt_BR', 'Oklahoma', 48),
(4593, 'pt_BR', 'Oregon', 4),
(4594, 'pt_BR', 'Palau', 50),
(4595, 'pt_BR', 'Pensilvânia', 51),
(4596, 'pt_BR', 'Porto Rico', 52),
(4597, 'pt_BR', 'Rhode Island', 53),
(4598, 'pt_BR', 'Carolina do Sul', 54),
(4599, 'pt_BR', 'Dakota do Sul', 55),
(4600, 'pt_BR', 'Tennessee', 56),
(4601, 'pt_BR', 'Texas', 57),
(4602, 'pt_BR', 'Utah', 58),
(4603, 'pt_BR', 'Vermont', 59),
(4604, 'pt_BR', 'Ilhas Virgens', 60),
(4605, 'pt_BR', 'Virginia', 61),
(4606, 'pt_BR', 'Washington', 62),
(4607, 'pt_BR', 'West Virginia', 63),
(4608, 'pt_BR', 'Wisconsin', 64),
(4609, 'pt_BR', 'Wyoming', 65),
(4610, 'pt_BR', 'Alberta', 66),
(4611, 'pt_BR', 'Colúmbia Britânica', 67),
(4612, 'pt_BR', 'Manitoba', 68),
(4613, 'pt_BR', 'Terra Nova e Labrador', 69),
(4614, 'pt_BR', 'New Brunswick', 70),
(4615, 'pt_BR', 'Nova Escócia', 7),
(4616, 'pt_BR', 'Territórios do Noroeste', 72),
(4617, 'pt_BR', 'Nunavut', 73),
(4618, 'pt_BR', 'Ontario', 74),
(4619, 'pt_BR', 'Ilha do Príncipe Eduardo', 75),
(4620, 'pt_BR', 'Quebec', 76),
(4621, 'pt_BR', 'Saskatchewan', 77),
(4622, 'pt_BR', 'Território yukon', 78),
(4623, 'pt_BR', 'Niedersachsen', 79),
(4624, 'pt_BR', 'Baden-Wurttemberg', 80),
(4625, 'pt_BR', 'Bayern', 81),
(4626, 'pt_BR', 'Berlim', 82),
(4627, 'pt_BR', 'Brandenburg', 83),
(4628, 'pt_BR', 'Bremen', 84),
(4629, 'pt_BR', 'Hamburgo', 85),
(4630, 'pt_BR', 'Hessen', 86),
(4631, 'pt_BR', 'Mecklenburg-Vorpommern', 87),
(4632, 'pt_BR', 'Nordrhein-Westfalen', 88),
(4633, 'pt_BR', 'Renânia-Palatinado', 8),
(4634, 'pt_BR', 'Sarre', 90),
(4635, 'pt_BR', 'Sachsen', 91),
(4636, 'pt_BR', 'Sachsen-Anhalt', 92),
(4637, 'pt_BR', 'Schleswig-Holstein', 93),
(4638, 'pt_BR', 'Turíngia', 94),
(4639, 'pt_BR', 'Viena', 95),
(4640, 'pt_BR', 'Baixa Áustria', 96),
(4641, 'pt_BR', 'Oberösterreich', 97),
(4642, 'pt_BR', 'Salzburg', 98),
(4643, 'pt_BR', 'Caríntia', 99),
(4644, 'pt_BR', 'Steiermark', 100),
(4645, 'pt_BR', 'Tirol', 101),
(4646, 'pt_BR', 'Burgenland', 102),
(4647, 'pt_BR', 'Vorarlberg', 103),
(4648, 'pt_BR', 'Aargau', 104),
(4649, 'pt_BR', 'Appenzell Innerrhoden', 105),
(4650, 'pt_BR', 'Appenzell Ausserrhoden', 106),
(4651, 'pt_BR', 'Bern', 107),
(4652, 'pt_BR', 'Basel-Landschaft', 108),
(4653, 'pt_BR', 'Basel-Stadt', 109),
(4654, 'pt_BR', 'Freiburg', 110),
(4655, 'pt_BR', 'Genf', 111),
(4656, 'pt_BR', 'Glarus', 112),
(4657, 'pt_BR', 'Grisons', 113),
(4658, 'pt_BR', 'Jura', 114),
(4659, 'pt_BR', 'Luzern', 115),
(4660, 'pt_BR', 'Neuenburg', 116),
(4661, 'pt_BR', 'Nidwalden', 117),
(4662, 'pt_BR', 'Obwalden', 118),
(4663, 'pt_BR', 'St. Gallen', 119),
(4664, 'pt_BR', 'Schaffhausen', 120),
(4665, 'pt_BR', 'Solothurn', 121),
(4666, 'pt_BR', 'Schwyz', 122),
(4667, 'pt_BR', 'Thurgau', 123),
(4668, 'pt_BR', 'Tessin', 124),
(4669, 'pt_BR', 'Uri', 125),
(4670, 'pt_BR', 'Waadt', 126),
(4671, 'pt_BR', 'Wallis', 127),
(4672, 'pt_BR', 'Zug', 128),
(4673, 'pt_BR', 'Zurique', 129),
(4674, 'pt_BR', 'Corunha', 130),
(4675, 'pt_BR', 'Álava', 131),
(4676, 'pt_BR', 'Albacete', 132),
(4677, 'pt_BR', 'Alicante', 133),
(4678, 'pt_BR', 'Almeria', 134),
(4679, 'pt_BR', 'Astúrias', 135),
(4680, 'pt_BR', 'Avila', 136),
(4681, 'pt_BR', 'Badajoz', 137),
(4682, 'pt_BR', 'Baleares', 138),
(4683, 'pt_BR', 'Barcelona', 139),
(4684, 'pt_BR', 'Burgos', 140),
(4685, 'pt_BR', 'Caceres', 141),
(4686, 'pt_BR', 'Cadiz', 142),
(4687, 'pt_BR', 'Cantábria', 143),
(4688, 'pt_BR', 'Castellon', 144),
(4689, 'pt_BR', 'Ceuta', 145),
(4690, 'pt_BR', 'Ciudad Real', 146),
(4691, 'pt_BR', 'Cordoba', 147),
(4692, 'pt_BR', 'Cuenca', 148),
(4693, 'pt_BR', 'Girona', 149),
(4694, 'pt_BR', 'Granada', 150),
(4695, 'pt_BR', 'Guadalajara', 151),
(4696, 'pt_BR', 'Guipuzcoa', 152),
(4697, 'pt_BR', 'Huelva', 153),
(4698, 'pt_BR', 'Huesca', 154),
(4699, 'pt_BR', 'Jaen', 155),
(4700, 'pt_BR', 'La Rioja', 156),
(4701, 'pt_BR', 'Las Palmas', 157),
(4702, 'pt_BR', 'Leon', 158),
(4703, 'pt_BR', 'Lleida', 159),
(4704, 'pt_BR', 'Lugo', 160),
(4705, 'pt_BR', 'Madri', 161),
(4706, 'pt_BR', 'Málaga', 162),
(4707, 'pt_BR', 'Melilla', 163),
(4708, 'pt_BR', 'Murcia', 164),
(4709, 'pt_BR', 'Navarra', 165),
(4710, 'pt_BR', 'Ourense', 166),
(4711, 'pt_BR', 'Palencia', 167),
(4712, 'pt_BR', 'Pontevedra', 168),
(4713, 'pt_BR', 'Salamanca', 169),
(4714, 'pt_BR', 'Santa Cruz de Tenerife', 170),
(4715, 'pt_BR', 'Segovia', 171),
(4716, 'pt_BR', 'Sevilla', 172),
(4717, 'pt_BR', 'Soria', 173),
(4718, 'pt_BR', 'Tarragona', 174),
(4719, 'pt_BR', 'Teruel', 175),
(4720, 'pt_BR', 'Toledo', 176),
(4721, 'pt_BR', 'Valencia', 177),
(4722, 'pt_BR', 'Valladolid', 178),
(4723, 'pt_BR', 'Vizcaya', 179),
(4724, 'pt_BR', 'Zamora', 180),
(4725, 'pt_BR', 'Zaragoza', 181),
(4726, 'pt_BR', 'Ain', 182),
(4727, 'pt_BR', 'Aisne', 183),
(4728, 'pt_BR', 'Allier', 184),
(4729, 'pt_BR', 'Alpes da Alta Provença', 185),
(4730, 'pt_BR', 'Altos Alpes', 186),
(4731, 'pt_BR', 'Alpes-Maritimes', 187),
(4732, 'pt_BR', 'Ardèche', 188),
(4733, 'pt_BR', 'Ardennes', 189),
(4734, 'pt_BR', 'Ariege', 190),
(4735, 'pt_BR', 'Aube', 191),
(4736, 'pt_BR', 'Aude', 192),
(4737, 'pt_BR', 'Aveyron', 193),
(4738, 'pt_BR', 'BOCAS DO Rhône', 194),
(4739, 'pt_BR', 'Calvados', 195),
(4740, 'pt_BR', 'Cantal', 196),
(4741, 'pt_BR', 'Charente', 197),
(4742, 'pt_BR', 'Charente-Maritime', 198),
(4743, 'pt_BR', 'Cher', 199),
(4744, 'pt_BR', 'Corrèze', 200),
(4745, 'pt_BR', 'Corse-du-Sud', 201),
(4746, 'pt_BR', 'Alta Córsega', 202),
(4747, 'pt_BR', 'Costa d\'OrCorrèze', 203),
(4748, 'pt_BR', 'Cotes d\'Armor', 204),
(4749, 'pt_BR', 'Creuse', 205),
(4750, 'pt_BR', 'Dordogne', 206),
(4751, 'pt_BR', 'Doubs', 207),
(4752, 'pt_BR', 'DrômeFinistère', 208),
(4753, 'pt_BR', 'Eure', 209),
(4754, 'pt_BR', 'Eure-et-Loir', 210),
(4755, 'pt_BR', 'Finistère', 211),
(4756, 'pt_BR', 'Gard', 212),
(4757, 'pt_BR', 'Haute-Garonne', 213),
(4758, 'pt_BR', 'Gers', 214),
(4759, 'pt_BR', 'Gironde', 215),
(4760, 'pt_BR', 'Hérault', 216),
(4761, 'pt_BR', 'Ille-et-Vilaine', 217),
(4762, 'pt_BR', 'Indre', 218),
(4763, 'pt_BR', 'Indre-et-Loire', 219),
(4764, 'pt_BR', 'Isère', 220),
(4765, 'pt_BR', 'Jura', 221),
(4766, 'pt_BR', 'Landes', 222),
(4767, 'pt_BR', 'Loir-et-Cher', 223),
(4768, 'pt_BR', 'Loire', 224),
(4769, 'pt_BR', 'Haute-Loire', 22),
(4770, 'pt_BR', 'Loire-Atlantique', 226),
(4771, 'pt_BR', 'Loiret', 227),
(4772, 'pt_BR', 'Lot', 228),
(4773, 'pt_BR', 'Lot e Garona', 229),
(4774, 'pt_BR', 'Lozère', 230),
(4775, 'pt_BR', 'Maine-et-Loire', 231),
(4776, 'pt_BR', 'Manche', 232),
(4777, 'pt_BR', 'Marne', 233),
(4778, 'pt_BR', 'Haute-Marne', 234),
(4779, 'pt_BR', 'Mayenne', 235),
(4780, 'pt_BR', 'Meurthe-et-Moselle', 236),
(4781, 'pt_BR', 'Meuse', 237),
(4782, 'pt_BR', 'Morbihan', 238),
(4783, 'pt_BR', 'Moselle', 239),
(4784, 'pt_BR', 'Nièvre', 240),
(4785, 'pt_BR', 'Nord', 241),
(4786, 'pt_BR', 'Oise', 242),
(4787, 'pt_BR', 'Orne', 243),
(4788, 'pt_BR', 'Pas-de-Calais', 244),
(4789, 'pt_BR', 'Puy-de-Dôme', 24),
(4790, 'pt_BR', 'Pirineus Atlânticos', 246),
(4791, 'pt_BR', 'Hautes-Pyrénées', 247),
(4792, 'pt_BR', 'Pirineus Orientais', 248),
(4793, 'pt_BR', 'Bas-Rhin', 249),
(4794, 'pt_BR', 'Alto Reno', 250),
(4795, 'pt_BR', 'Rhône', 251),
(4796, 'pt_BR', 'Haute-Saône', 252),
(4797, 'pt_BR', 'Saône-et-Loire', 253),
(4798, 'pt_BR', 'Sarthe', 25),
(4799, 'pt_BR', 'Savoie', 255),
(4800, 'pt_BR', 'Alta Sabóia', 256),
(4801, 'pt_BR', 'Paris', 257),
(4802, 'pt_BR', 'Seine-Maritime', 258),
(4803, 'pt_BR', 'Seine-et-Marne', 259),
(4804, 'pt_BR', 'Yvelines', 260),
(4805, 'pt_BR', 'Deux-Sèvres', 261),
(4806, 'pt_BR', 'Somme', 262),
(4807, 'pt_BR', 'Tarn', 263),
(4808, 'pt_BR', 'Tarn-et-Garonne', 264),
(4809, 'pt_BR', 'Var', 265),
(4810, 'pt_BR', 'Vaucluse', 266),
(4811, 'pt_BR', 'Compradora', 267),
(4812, 'pt_BR', 'Vienne', 268),
(4813, 'pt_BR', 'Haute-Vienne', 269),
(4814, 'pt_BR', 'Vosges', 270),
(4815, 'pt_BR', 'Yonne', 271),
(4816, 'pt_BR', 'Território de Belfort', 272),
(4817, 'pt_BR', 'Essonne', 273),
(4818, 'pt_BR', 'Altos do Sena', 274),
(4819, 'pt_BR', 'Seine-Saint-Denis', 275),
(4820, 'pt_BR', 'Val-de-Marne', 276),
(4821, 'pt_BR', 'Val-d\'Oise', 277),
(4822, 'pt_BR', 'Alba', 278),
(4823, 'pt_BR', 'Arad', 279),
(4824, 'pt_BR', 'Arges', 280),
(4825, 'pt_BR', 'Bacau', 281),
(4826, 'pt_BR', 'Bihor', 282),
(4827, 'pt_BR', 'Bistrita-Nasaud', 283),
(4828, 'pt_BR', 'Botosani', 284),
(4829, 'pt_BR', 'Brașov', 285),
(4830, 'pt_BR', 'Braila', 286),
(4831, 'pt_BR', 'Bucareste', 287),
(4832, 'pt_BR', 'Buzau', 288),
(4833, 'pt_BR', 'Caras-Severin', 289),
(4834, 'pt_BR', 'Călărași', 290),
(4835, 'pt_BR', 'Cluj', 291),
(4836, 'pt_BR', 'Constanta', 292),
(4837, 'pt_BR', 'Covasna', 29),
(4838, 'pt_BR', 'Dambovita', 294),
(4839, 'pt_BR', 'Dolj', 295),
(4840, 'pt_BR', 'Galati', 296),
(4841, 'pt_BR', 'Giurgiu', 297),
(4842, 'pt_BR', 'Gorj', 298),
(4843, 'pt_BR', 'Harghita', 299),
(4844, 'pt_BR', 'Hunedoara', 300),
(4845, 'pt_BR', 'Ialomita', 301),
(4846, 'pt_BR', 'Iasi', 302),
(4847, 'pt_BR', 'Ilfov', 303),
(4848, 'pt_BR', 'Maramures', 304),
(4849, 'pt_BR', 'Maramures', 305),
(4850, 'pt_BR', 'Mures', 306),
(4851, 'pt_BR', 'alemão', 307),
(4852, 'pt_BR', 'Olt', 308),
(4853, 'pt_BR', 'Prahova', 309),
(4854, 'pt_BR', 'Satu-Mare', 310),
(4855, 'pt_BR', 'Salaj', 311),
(4856, 'pt_BR', 'Sibiu', 312),
(4857, 'pt_BR', 'Suceava', 313),
(4858, 'pt_BR', 'Teleorman', 314),
(4859, 'pt_BR', 'Timis', 315),
(4860, 'pt_BR', 'Tulcea', 316),
(4861, 'pt_BR', 'Vaslui', 317),
(4862, 'pt_BR', 'dale', 318),
(4863, 'pt_BR', 'Vrancea', 319),
(4864, 'pt_BR', 'Lappi', 320),
(4865, 'pt_BR', 'Pohjois-Pohjanmaa', 321),
(4866, 'pt_BR', 'Kainuu', 322),
(4867, 'pt_BR', 'Pohjois-Karjala', 323),
(4868, 'pt_BR', 'Pohjois-Savo', 324),
(4869, 'pt_BR', 'Sul Savo', 325),
(4870, 'pt_BR', 'Ostrobothnia do sul', 326),
(4871, 'pt_BR', 'Pohjanmaa', 327),
(4872, 'pt_BR', 'Pirkanmaa', 328),
(4873, 'pt_BR', 'Satakunta', 329),
(4874, 'pt_BR', 'Keski-Pohjanmaa', 330),
(4875, 'pt_BR', 'Keski-Suomi', 331),
(4876, 'pt_BR', 'Varsinais-Suomi', 332),
(4877, 'pt_BR', 'Carélia do Sul', 333),
(4878, 'pt_BR', 'Päijät-Häme', 334),
(4879, 'pt_BR', 'Kanta-Häme', 335),
(4880, 'pt_BR', 'Uusimaa', 336),
(4881, 'pt_BR', 'Uusimaa', 337),
(4882, 'pt_BR', 'Kymenlaakso', 338),
(4883, 'pt_BR', 'Ahvenanmaa', 339),
(4884, 'pt_BR', 'Harjumaa', 340),
(4885, 'pt_BR', 'Hiiumaa', 341),
(4886, 'pt_BR', 'Ida-Virumaa', 342),
(4887, 'pt_BR', 'Condado de Jõgeva', 343),
(4888, 'pt_BR', 'Condado de Järva', 344),
(4889, 'pt_BR', 'Läänemaa', 345),
(4890, 'pt_BR', 'Condado de Lääne-Viru', 346),
(4891, 'pt_BR', 'Condado de Põlva', 347),
(4892, 'pt_BR', 'Condado de Pärnu', 348),
(4893, 'pt_BR', 'Raplamaa', 349),
(4894, 'pt_BR', 'Saaremaa', 350),
(4895, 'pt_BR', 'Tartumaa', 351),
(4896, 'pt_BR', 'Valgamaa', 352),
(4897, 'pt_BR', 'Viljandimaa', 353),
(4898, 'pt_BR', 'Võrumaa', 354),
(4899, 'pt_BR', 'Daugavpils', 355),
(4900, 'pt_BR', 'Jelgava', 356),
(4901, 'pt_BR', 'Jekabpils', 357),
(4902, 'pt_BR', 'Jurmala', 358),
(4903, 'pt_BR', 'Liepaja', 359),
(4904, 'pt_BR', 'Liepaja County', 360),
(4905, 'pt_BR', 'Rezekne', 361),
(4906, 'pt_BR', 'Riga', 362),
(4907, 'pt_BR', 'Condado de Riga', 363),
(4908, 'pt_BR', 'Valmiera', 364),
(4909, 'pt_BR', 'Ventspils', 365),
(4910, 'pt_BR', 'Aglonas novads', 366),
(4911, 'pt_BR', 'Aizkraukles novads', 367),
(4912, 'pt_BR', 'Aizputes novads', 368),
(4913, 'pt_BR', 'Condado de Akniste', 369),
(4914, 'pt_BR', 'Alojas novads', 370),
(4915, 'pt_BR', 'Alsungas novads', 371),
(4916, 'pt_BR', 'Aluksne County', 372),
(4917, 'pt_BR', 'Amatas novads', 373),
(4918, 'pt_BR', 'Macacos novads', 374),
(4919, 'pt_BR', 'Auces novads', 375),
(4920, 'pt_BR', 'Babītes novads', 376),
(4921, 'pt_BR', 'Baldones novads', 377),
(4922, 'pt_BR', 'Baltinavas novads', 378),
(4923, 'pt_BR', 'Balvu novads', 379),
(4924, 'pt_BR', 'Bauskas novads', 380),
(4925, 'pt_BR', 'Condado de Beverina', 381),
(4926, 'pt_BR', 'Condado de Broceni', 382),
(4927, 'pt_BR', 'Burtnieku novads', 383),
(4928, 'pt_BR', 'Carnikavas novads', 384),
(4929, 'pt_BR', 'Cesvaines novads', 385),
(4930, 'pt_BR', 'Ciblas novads', 386),
(4931, 'pt_BR', 'Cesis county', 387),
(4932, 'pt_BR', 'Dagdas novads', 388),
(4933, 'pt_BR', 'Daugavpils novads', 389),
(4934, 'pt_BR', 'Dobeles novads', 390),
(4935, 'pt_BR', 'Dundagas novads', 391),
(4936, 'pt_BR', 'Durbes novads', 392),
(4937, 'pt_BR', 'Engad novads', 393),
(4938, 'pt_BR', 'Garkalnes novads', 394),
(4939, 'pt_BR', 'O condado de Grobiņa', 395),
(4940, 'pt_BR', 'Gulbenes novads', 396),
(4941, 'pt_BR', 'Iecavas novads', 397),
(4942, 'pt_BR', 'Ikskile county', 398),
(4943, 'pt_BR', 'Ilūkste county', 399),
(4944, 'pt_BR', 'Condado de Inčukalns', 400),
(4945, 'pt_BR', 'Jaunjelgavas novads', 401),
(4946, 'pt_BR', 'Jaunpiebalgas novads', 402),
(4947, 'pt_BR', 'Jaunpils novads', 403),
(4948, 'pt_BR', 'Jelgavas novads', 404),
(4949, 'pt_BR', 'Jekabpils county', 405),
(4950, 'pt_BR', 'Kandavas novads', 406),
(4951, 'pt_BR', 'Kokneses novads', 407),
(4952, 'pt_BR', 'Krimuldas novads', 408),
(4953, 'pt_BR', 'Krustpils novads', 409),
(4954, 'pt_BR', 'Condado de Kraslava', 410),
(4955, 'pt_BR', 'Condado de Kuldīga', 411),
(4956, 'pt_BR', 'Condado de Kārsava', 412),
(4957, 'pt_BR', 'Condado de Lielvarde', 413),
(4958, 'pt_BR', 'Condado de Limbaži', 414),
(4959, 'pt_BR', 'O distrito de Lubāna', 415),
(4960, 'pt_BR', 'Ludzas novads', 416),
(4961, 'pt_BR', 'Ligatne county', 417),
(4962, 'pt_BR', 'Livani county', 418),
(4963, 'pt_BR', 'Madonas novads', 419),
(4964, 'pt_BR', 'Mazsalacas novads', 420),
(4965, 'pt_BR', 'Mālpils county', 421),
(4966, 'pt_BR', 'Mārupe county', 422),
(4967, 'pt_BR', 'O condado de Naukšēni', 423),
(4968, 'pt_BR', 'Neretas novads', 424),
(4969, 'pt_BR', 'Nīca county', 425),
(4970, 'pt_BR', 'Ogres novads', 426),
(4971, 'pt_BR', 'Olaines novads', 427),
(4972, 'pt_BR', 'Ozolnieku novads', 428),
(4973, 'pt_BR', 'Preiļi county', 429),
(4974, 'pt_BR', 'Priekules novads', 430),
(4975, 'pt_BR', 'Condado de Priekuļi', 431),
(4976, 'pt_BR', 'Moving county', 432),
(4977, 'pt_BR', 'Condado de Pavilosta', 433),
(4978, 'pt_BR', 'Condado de Plavinas', 434);
INSERT INTO `country_state_translations` (`id`, `locale`, `default_name`, `country_state_id`) VALUES
(4979, 'pt_BR', 'Raunas novads', 435),
(4980, 'pt_BR', 'Condado de Riebiņi', 436),
(4981, 'pt_BR', 'Rojas novads', 437),
(4982, 'pt_BR', 'Ropazi county', 438),
(4983, 'pt_BR', 'Rucavas novads', 439),
(4984, 'pt_BR', 'Rugāji county', 440),
(4985, 'pt_BR', 'Rundāle county', 441),
(4986, 'pt_BR', 'Rezekne county', 442),
(4987, 'pt_BR', 'Rūjiena county', 443),
(4988, 'pt_BR', 'O município de Salacgriva', 444),
(4989, 'pt_BR', 'Salas novads', 445),
(4990, 'pt_BR', 'Salaspils novads', 446),
(4991, 'pt_BR', 'Saldus novads', 447),
(4992, 'pt_BR', 'Saulkrastu novads', 448),
(4993, 'pt_BR', 'Siguldas novads', 449),
(4994, 'pt_BR', 'Skrundas novads', 450),
(4995, 'pt_BR', 'Skrīveri county', 451),
(4996, 'pt_BR', 'Smiltenes novads', 452),
(4997, 'pt_BR', 'Condado de Stopini', 453),
(4998, 'pt_BR', 'Condado de Strenči', 454),
(4999, 'pt_BR', 'Região de semeadura', 455),
(5000, 'pt_BR', 'Talsu novads', 456),
(5001, 'pt_BR', 'Tukuma novads', 457),
(5002, 'pt_BR', 'Condado de Tērvete', 458),
(5003, 'pt_BR', 'O condado de Vaiņode', 459),
(5004, 'pt_BR', 'Valkas novads', 460),
(5005, 'pt_BR', 'Valmieras novads', 461),
(5006, 'pt_BR', 'Varaklani county', 462),
(5007, 'pt_BR', 'Vecpiebalgas novads', 463),
(5008, 'pt_BR', 'Vecumnieku novads', 464),
(5009, 'pt_BR', 'Ventspils novads', 465),
(5010, 'pt_BR', 'Condado de Viesite', 466),
(5011, 'pt_BR', 'Condado de Vilaka', 467),
(5012, 'pt_BR', 'Vilani county', 468),
(5013, 'pt_BR', 'Condado de Varkava', 469),
(5014, 'pt_BR', 'Zilupes novads', 470),
(5015, 'pt_BR', 'Adazi county', 471),
(5016, 'pt_BR', 'Erglu county', 472),
(5017, 'pt_BR', 'Kegums county', 473),
(5018, 'pt_BR', 'Kekava county', 474),
(5019, 'pt_BR', 'Alytaus Apskritis', 475),
(5020, 'pt_BR', 'Kauno Apskritis', 476),
(5021, 'pt_BR', 'Condado de Klaipeda', 477),
(5022, 'pt_BR', 'Marijampolė county', 478),
(5023, 'pt_BR', 'Panevezys county', 479),
(5024, 'pt_BR', 'Siauliai county', 480),
(5025, 'pt_BR', 'Taurage county', 481),
(5026, 'pt_BR', 'Telšiai county', 482),
(5027, 'pt_BR', 'Utenos Apskritis', 483),
(5028, 'pt_BR', 'Vilniaus Apskritis', 484),
(5029, 'pt_BR', 'Acre', 485),
(5030, 'pt_BR', 'Alagoas', 486),
(5031, 'pt_BR', 'Amapá', 487),
(5032, 'pt_BR', 'Amazonas', 488),
(5033, 'pt_BR', 'Bahia', 489),
(5034, 'pt_BR', 'Ceará', 490),
(5035, 'pt_BR', 'Espírito Santo', 491),
(5036, 'pt_BR', 'Goiás', 492),
(5037, 'pt_BR', 'Maranhão', 493),
(5038, 'pt_BR', 'Mato Grosso', 494),
(5039, 'pt_BR', 'Mato Grosso do Sul', 495),
(5040, 'pt_BR', 'Minas Gerais', 496),
(5041, 'pt_BR', 'Pará', 497),
(5042, 'pt_BR', 'Paraíba', 498),
(5043, 'pt_BR', 'Paraná', 499),
(5044, 'pt_BR', 'Pernambuco', 500),
(5045, 'pt_BR', 'Piauí', 501),
(5046, 'pt_BR', 'Rio de Janeiro', 502),
(5047, 'pt_BR', 'Rio Grande do Norte', 503),
(5048, 'pt_BR', 'Rio Grande do Sul', 504),
(5049, 'pt_BR', 'Rondônia', 505),
(5050, 'pt_BR', 'Roraima', 506),
(5051, 'pt_BR', 'Santa Catarina', 507),
(5052, 'pt_BR', 'São Paulo', 508),
(5053, 'pt_BR', 'Sergipe', 509),
(5054, 'pt_BR', 'Tocantins', 510),
(5055, 'pt_BR', 'Distrito Federal', 511),
(5056, 'pt_BR', 'Condado de Zagreb', 512),
(5057, 'pt_BR', 'Condado de Krapina-Zagorje', 513),
(5058, 'pt_BR', 'Condado de Sisak-Moslavina', 514),
(5059, 'pt_BR', 'Condado de Karlovac', 515),
(5060, 'pt_BR', 'Concelho de Varaždin', 516),
(5061, 'pt_BR', 'Condado de Koprivnica-Križevci', 517),
(5062, 'pt_BR', 'Condado de Bjelovar-Bilogora', 518),
(5063, 'pt_BR', 'Condado de Primorje-Gorski kotar', 519),
(5064, 'pt_BR', 'Condado de Lika-Senj', 520),
(5065, 'pt_BR', 'Condado de Virovitica-Podravina', 521),
(5066, 'pt_BR', 'Condado de Požega-Slavonia', 522),
(5067, 'pt_BR', 'Condado de Brod-Posavina', 523),
(5068, 'pt_BR', 'Condado de Zadar', 524),
(5069, 'pt_BR', 'Condado de Osijek-Baranja', 525),
(5070, 'pt_BR', 'Condado de Šibenik-Knin', 526),
(5071, 'pt_BR', 'Condado de Vukovar-Srijem', 527),
(5072, 'pt_BR', 'Condado de Split-Dalmácia', 528),
(5073, 'pt_BR', 'Condado de Ístria', 529),
(5074, 'pt_BR', 'Condado de Dubrovnik-Neretva', 530),
(5075, 'pt_BR', 'Međimurska županija', 531),
(5076, 'pt_BR', 'Grad Zagreb', 532),
(5077, 'pt_BR', 'Ilhas Andaman e Nicobar', 533),
(5078, 'pt_BR', 'Andhra Pradesh', 534),
(5079, 'pt_BR', 'Arunachal Pradesh', 535),
(5080, 'pt_BR', 'Assam', 536),
(5081, 'pt_BR', 'Bihar', 537),
(5082, 'pt_BR', 'Chandigarh', 538),
(5083, 'pt_BR', 'Chhattisgarh', 539),
(5084, 'pt_BR', 'Dadra e Nagar Haveli', 540),
(5085, 'pt_BR', 'Daman e Diu', 541),
(5086, 'pt_BR', 'Delhi', 542),
(5087, 'pt_BR', 'Goa', 543),
(5088, 'pt_BR', 'Gujarat', 544),
(5089, 'pt_BR', 'Haryana', 545),
(5090, 'pt_BR', 'Himachal Pradesh', 546),
(5091, 'pt_BR', 'Jammu e Caxemira', 547),
(5092, 'pt_BR', 'Jharkhand', 548),
(5093, 'pt_BR', 'Karnataka', 549),
(5094, 'pt_BR', 'Kerala', 550),
(5095, 'pt_BR', 'Lakshadweep', 551),
(5096, 'pt_BR', 'Madhya Pradesh', 552),
(5097, 'pt_BR', 'Maharashtra', 553),
(5098, 'pt_BR', 'Manipur', 554),
(5099, 'pt_BR', 'Meghalaya', 555),
(5100, 'pt_BR', 'Mizoram', 556),
(5101, 'pt_BR', 'Nagaland', 557),
(5102, 'pt_BR', 'Odisha', 558),
(5103, 'pt_BR', 'Puducherry', 559),
(5104, 'pt_BR', 'Punjab', 560),
(5105, 'pt_BR', 'Rajasthan', 561),
(5106, 'pt_BR', 'Sikkim', 562),
(5107, 'pt_BR', 'Tamil Nadu', 563),
(5108, 'pt_BR', 'Telangana', 564),
(5109, 'pt_BR', 'Tripura', 565),
(5110, 'pt_BR', 'Uttar Pradesh', 566),
(5111, 'pt_BR', 'Uttarakhand', 567),
(5112, 'pt_BR', 'Bengala Ocidental', 568);

-- --------------------------------------------------------

--
-- Table structure for table `country_translations`
--

CREATE TABLE `country_translations` (
  `id` int(10) UNSIGNED NOT NULL,
  `locale` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `country_translations`
--

INSERT INTO `country_translations` (`id`, `locale`, `name`, `country_id`) VALUES
(1531, 'ar', 'أفغانستان', 1),
(1532, 'ar', 'جزر آلاند', 2),
(1533, 'ar', 'ألبانيا', 3),
(1534, 'ar', 'الجزائر', 4),
(1535, 'ar', 'ساموا الأمريكية', 5),
(1536, 'ar', 'أندورا', 6),
(1537, 'ar', 'أنغولا', 7),
(1538, 'ar', 'أنغيلا', 8),
(1539, 'ar', 'القارة القطبية الجنوبية', 9),
(1540, 'ar', 'أنتيغوا وبربودا', 10),
(1541, 'ar', 'الأرجنتين', 11),
(1542, 'ar', 'أرمينيا', 12),
(1543, 'ar', 'أروبا', 13),
(1544, 'ar', 'جزيرة الصعود', 14),
(1545, 'ar', 'أستراليا', 15),
(1546, 'ar', 'النمسا', 16),
(1547, 'ar', 'أذربيجان', 17),
(1548, 'ar', 'الباهاما', 18),
(1549, 'ar', 'البحرين', 19),
(1550, 'ar', 'بنغلاديش', 20),
(1551, 'ar', 'بربادوس', 21),
(1552, 'ar', 'روسيا البيضاء', 22),
(1553, 'ar', 'بلجيكا', 23),
(1554, 'ar', 'بليز', 24),
(1555, 'ar', 'بنين', 25),
(1556, 'ar', 'برمودا', 26),
(1557, 'ar', 'بوتان', 27),
(1558, 'ar', 'بوليفيا', 28),
(1559, 'ar', 'البوسنة والهرسك', 29),
(1560, 'ar', 'بوتسوانا', 30),
(1561, 'ar', 'البرازيل', 31),
(1562, 'ar', 'إقليم المحيط البريطاني الهندي', 32),
(1563, 'ar', 'جزر فيرجن البريطانية', 33),
(1564, 'ar', 'بروناي', 34),
(1565, 'ar', 'بلغاريا', 35),
(1566, 'ar', 'بوركينا فاسو', 36),
(1567, 'ar', 'بوروندي', 37),
(1568, 'ar', 'كمبوديا', 38),
(1569, 'ar', 'الكاميرون', 39),
(1570, 'ar', 'كندا', 40),
(1571, 'ar', 'جزر الكناري', 41),
(1572, 'ar', 'الرأس الأخضر', 42),
(1573, 'ar', 'الكاريبي هولندا', 43),
(1574, 'ar', 'جزر كايمان', 44),
(1575, 'ar', 'جمهورية افريقيا الوسطى', 45),
(1576, 'ar', 'سبتة ومليلية', 46),
(1577, 'ar', 'تشاد', 47),
(1578, 'ar', 'تشيلي', 48),
(1579, 'ar', 'الصين', 49),
(1580, 'ar', 'جزيرة الكريسماس', 50),
(1581, 'ar', 'جزر كوكوس (كيلينغ)', 51),
(1582, 'ar', 'كولومبيا', 52),
(1583, 'ar', 'جزر القمر', 53),
(1584, 'ar', 'الكونغو - برازافيل', 54),
(1585, 'ar', 'الكونغو - كينشاسا', 55),
(1586, 'ar', 'جزر كوك', 56),
(1587, 'ar', 'كوستاريكا', 57),
(1588, 'ar', 'ساحل العاج', 58),
(1589, 'ar', 'كرواتيا', 59),
(1590, 'ar', 'كوبا', 60),
(1591, 'ar', 'كوراساو', 61),
(1592, 'ar', 'قبرص', 62),
(1593, 'ar', 'التشيك', 63),
(1594, 'ar', 'الدنمارك', 64),
(1595, 'ar', 'دييغو غارسيا', 65),
(1596, 'ar', 'جيبوتي', 66),
(1597, 'ar', 'دومينيكا', 67),
(1598, 'ar', 'جمهورية الدومنيكان', 68),
(1599, 'ar', 'الإكوادور', 69),
(1600, 'ar', 'مصر', 70),
(1601, 'ar', 'السلفادور', 71),
(1602, 'ar', 'غينيا الإستوائية', 72),
(1603, 'ar', 'إريتريا', 73),
(1604, 'ar', 'استونيا', 74),
(1605, 'ar', 'أثيوبيا', 75),
(1606, 'ar', 'منطقة اليورو', 76),
(1607, 'ar', 'جزر فوكلاند', 77),
(1608, 'ar', 'جزر فاروس', 78),
(1609, 'ar', 'فيجي', 79),
(1610, 'ar', 'فنلندا', 80),
(1611, 'ar', 'فرنسا', 81),
(1612, 'ar', 'غيانا الفرنسية', 82),
(1613, 'ar', 'بولينيزيا الفرنسية', 83),
(1614, 'ar', 'المناطق الجنوبية لفرنسا', 84),
(1615, 'ar', 'الغابون', 85),
(1616, 'ar', 'غامبيا', 86),
(1617, 'ar', 'جورجيا', 87),
(1618, 'ar', 'ألمانيا', 88),
(1619, 'ar', 'غانا', 89),
(1620, 'ar', 'جبل طارق', 90),
(1621, 'ar', 'اليونان', 91),
(1622, 'ar', 'الأرض الخضراء', 92),
(1623, 'ar', 'غرينادا', 93),
(1624, 'ar', 'جوادلوب', 94),
(1625, 'ar', 'غوام', 95),
(1626, 'ar', 'غواتيمالا', 96),
(1627, 'ar', 'غيرنسي', 97),
(1628, 'ar', 'غينيا', 98),
(1629, 'ar', 'غينيا بيساو', 99),
(1630, 'ar', 'غيانا', 100),
(1631, 'ar', 'هايتي', 101),
(1632, 'ar', 'هندوراس', 102),
(1633, 'ar', 'هونج كونج SAR الصين', 103),
(1634, 'ar', 'هنغاريا', 104),
(1635, 'ar', 'أيسلندا', 105),
(1636, 'ar', 'الهند', 106),
(1637, 'ar', 'إندونيسيا', 107),
(1638, 'ar', 'إيران', 108),
(1639, 'ar', 'العراق', 109),
(1640, 'ar', 'أيرلندا', 110),
(1641, 'ar', 'جزيرة آيل أوف مان', 111),
(1642, 'ar', 'إسرائيل', 112),
(1643, 'ar', 'إيطاليا', 113),
(1644, 'ar', 'جامايكا', 114),
(1645, 'ar', 'اليابان', 115),
(1646, 'ar', 'جيرسي', 116),
(1647, 'ar', 'الأردن', 117),
(1648, 'ar', 'كازاخستان', 118),
(1649, 'ar', 'كينيا', 119),
(1650, 'ar', 'كيريباس', 120),
(1651, 'ar', 'كوسوفو', 121),
(1652, 'ar', 'الكويت', 122),
(1653, 'ar', 'قرغيزستان', 123),
(1654, 'ar', 'لاوس', 124),
(1655, 'ar', 'لاتفيا', 125),
(1656, 'ar', 'لبنان', 126),
(1657, 'ar', 'ليسوتو', 127),
(1658, 'ar', 'ليبيريا', 128),
(1659, 'ar', 'ليبيا', 129),
(1660, 'ar', 'ليختنشتاين', 130),
(1661, 'ar', 'ليتوانيا', 131),
(1662, 'ar', 'لوكسمبورغ', 132),
(1663, 'ar', 'ماكاو SAR الصين', 133),
(1664, 'ar', 'مقدونيا', 134),
(1665, 'ar', 'مدغشقر', 135),
(1666, 'ar', 'مالاوي', 136),
(1667, 'ar', 'ماليزيا', 137),
(1668, 'ar', 'جزر المالديف', 138),
(1669, 'ar', 'مالي', 139),
(1670, 'ar', 'مالطا', 140),
(1671, 'ar', 'جزر مارشال', 141),
(1672, 'ar', 'مارتينيك', 142),
(1673, 'ar', 'موريتانيا', 143),
(1674, 'ar', 'موريشيوس', 144),
(1675, 'ar', 'ضائع', 145),
(1676, 'ar', 'المكسيك', 146),
(1677, 'ar', 'ميكرونيزيا', 147),
(1678, 'ar', 'مولدوفا', 148),
(1679, 'ar', 'موناكو', 149),
(1680, 'ar', 'منغوليا', 150),
(1681, 'ar', 'الجبل الأسود', 151),
(1682, 'ar', 'مونتسيرات', 152),
(1683, 'ar', 'المغرب', 153),
(1684, 'ar', 'موزمبيق', 154),
(1685, 'ar', 'ميانمار (بورما)', 155),
(1686, 'ar', 'ناميبيا', 156),
(1687, 'ar', 'ناورو', 157),
(1688, 'ar', 'نيبال', 158),
(1689, 'ar', 'نيبال', 159),
(1690, 'ar', 'كاليدونيا الجديدة', 160),
(1691, 'ar', 'نيوزيلاندا', 161),
(1692, 'ar', 'نيكاراغوا', 162),
(1693, 'ar', 'النيجر', 163),
(1694, 'ar', 'نيجيريا', 164),
(1695, 'ar', 'نيوي', 165),
(1696, 'ar', 'جزيرة نورفولك', 166),
(1697, 'ar', 'كوريا الشماليه', 167),
(1698, 'ar', 'جزر مريانا الشمالية', 168),
(1699, 'ar', 'النرويج', 169),
(1700, 'ar', 'سلطنة عمان', 170),
(1701, 'ar', 'باكستان', 171),
(1702, 'ar', 'بالاو', 172),
(1703, 'ar', 'الاراضي الفلسطينية', 173),
(1704, 'ar', 'بناما', 174),
(1705, 'ar', 'بابوا غينيا الجديدة', 175),
(1706, 'ar', 'باراغواي', 176),
(1707, 'ar', 'بيرو', 177),
(1708, 'ar', 'الفلبين', 178),
(1709, 'ar', 'جزر بيتكيرن', 179),
(1710, 'ar', 'بولندا', 180),
(1711, 'ar', 'البرتغال', 181),
(1712, 'ar', 'بورتوريكو', 182),
(1713, 'ar', 'دولة قطر', 183),
(1714, 'ar', 'جمع شمل', 184),
(1715, 'ar', 'رومانيا', 185),
(1716, 'ar', 'روسيا', 186),
(1717, 'ar', 'رواندا', 187),
(1718, 'ar', 'ساموا', 188),
(1719, 'ar', 'سان مارينو', 189),
(1720, 'ar', 'سانت كيتس ونيفيس', 190),
(1721, 'ar', 'المملكة العربية السعودية', 191),
(1722, 'ar', 'السنغال', 192),
(1723, 'ar', 'صربيا', 193),
(1724, 'ar', 'سيشيل', 194),
(1725, 'ar', 'سيراليون', 195),
(1726, 'ar', 'سنغافورة', 196),
(1727, 'ar', 'سينت مارتن', 197),
(1728, 'ar', 'سلوفاكيا', 198),
(1729, 'ar', 'سلوفينيا', 199),
(1730, 'ar', 'جزر سليمان', 200),
(1731, 'ar', 'الصومال', 201),
(1732, 'ar', 'جنوب أفريقيا', 202),
(1733, 'ar', 'جورجيا الجنوبية وجزر ساندويتش الجنوبية', 203),
(1734, 'ar', 'كوريا الجنوبية', 204),
(1735, 'ar', 'جنوب السودان', 205),
(1736, 'ar', 'إسبانيا', 206),
(1737, 'ar', 'سيريلانكا', 207),
(1738, 'ar', 'سانت بارتيليمي', 208),
(1739, 'ar', 'سانت هيلانة', 209),
(1740, 'ar', 'سانت كيتس ونيفيس', 210),
(1741, 'ar', 'شارع لوسيا', 211),
(1742, 'ar', 'سانت مارتن', 212),
(1743, 'ar', 'سانت بيير وميكلون', 213),
(1744, 'ar', 'سانت فنسنت وجزر غرينادين', 214),
(1745, 'ar', 'السودان', 215),
(1746, 'ar', 'سورينام', 216),
(1747, 'ar', 'سفالبارد وجان ماين', 217),
(1748, 'ar', 'سوازيلاند', 218),
(1749, 'ar', 'السويد', 219),
(1750, 'ar', 'سويسرا', 220),
(1751, 'ar', 'سوريا', 221),
(1752, 'ar', 'تايوان', 222),
(1753, 'ar', 'طاجيكستان', 223),
(1754, 'ar', 'تنزانيا', 224),
(1755, 'ar', 'تايلاند', 225),
(1756, 'ar', 'تيمور', 226),
(1757, 'ar', 'توجو', 227),
(1758, 'ar', 'توكيلاو', 228),
(1759, 'ar', 'تونغا', 229),
(1760, 'ar', 'ترينيداد وتوباغو', 230),
(1761, 'ar', 'تريستان دا كونها', 231),
(1762, 'ar', 'تونس', 232),
(1763, 'ar', 'ديك رومي', 233),
(1764, 'ar', 'تركمانستان', 234),
(1765, 'ar', 'جزر تركس وكايكوس', 235),
(1766, 'ar', 'توفالو', 236),
(1767, 'ar', 'جزر الولايات المتحدة البعيدة', 237),
(1768, 'ar', 'جزر فيرجن الأمريكية', 238),
(1769, 'ar', 'أوغندا', 239),
(1770, 'ar', 'أوكرانيا', 240),
(1771, 'ar', 'الإمارات العربية المتحدة', 241),
(1772, 'ar', 'المملكة المتحدة', 242),
(1773, 'ar', 'الأمم المتحدة', 243),
(1774, 'ar', 'الولايات المتحدة الأمريكية', 244),
(1775, 'ar', 'أوروغواي', 245),
(1776, 'ar', 'أوزبكستان', 246),
(1777, 'ar', 'فانواتو', 247),
(1778, 'ar', 'مدينة الفاتيكان', 248),
(1779, 'ar', 'فنزويلا', 249),
(1780, 'ar', 'فيتنام', 250),
(1781, 'ar', 'واليس وفوتونا', 251),
(1782, 'ar', 'الصحراء الغربية', 252),
(1783, 'ar', 'اليمن', 253),
(1784, 'ar', 'زامبيا', 254),
(1785, 'ar', 'زيمبابوي', 255),
(1786, 'fa', 'افغانستان', 1),
(1787, 'fa', 'جزایر الند', 2),
(1788, 'fa', 'آلبانی', 3),
(1789, 'fa', 'الجزایر', 4),
(1790, 'fa', 'ساموآ آمریکایی', 5),
(1791, 'fa', 'آندورا', 6),
(1792, 'fa', 'آنگولا', 7),
(1793, 'fa', 'آنگولا', 8),
(1794, 'fa', 'جنوبگان', 9),
(1795, 'fa', 'آنتیگوا و باربودا', 10),
(1796, 'fa', 'آرژانتین', 11),
(1797, 'fa', 'ارمنستان', 12),
(1798, 'fa', 'آروبا', 13),
(1799, 'fa', 'جزیره صعود', 14),
(1800, 'fa', 'استرالیا', 15),
(1801, 'fa', 'اتریش', 16),
(1802, 'fa', 'آذربایجان', 17),
(1803, 'fa', 'باهاما', 18),
(1804, 'fa', 'بحرین', 19),
(1805, 'fa', 'بنگلادش', 20),
(1806, 'fa', 'باربادوس', 21),
(1807, 'fa', 'بلاروس', 22),
(1808, 'fa', 'بلژیک', 23),
(1809, 'fa', 'بلژیک', 24),
(1810, 'fa', 'بنین', 25),
(1811, 'fa', 'برمودا', 26),
(1812, 'fa', 'بوتان', 27),
(1813, 'fa', 'بولیوی', 28),
(1814, 'fa', 'بوسنی و هرزگوین', 29),
(1815, 'fa', 'بوتسوانا', 30),
(1816, 'fa', 'برزیل', 31),
(1817, 'fa', 'قلمرو اقیانوس هند انگلیس', 32),
(1818, 'fa', 'جزایر ویرجین انگلیس', 33),
(1819, 'fa', 'برونئی', 34),
(1820, 'fa', 'بلغارستان', 35),
(1821, 'fa', 'بورکینا فاسو', 36),
(1822, 'fa', 'بوروندی', 37),
(1823, 'fa', 'کامبوج', 38),
(1824, 'fa', 'کامرون', 39),
(1825, 'fa', 'کانادا', 40),
(1826, 'fa', 'جزایر قناری', 41),
(1827, 'fa', 'کیپ ورد', 42),
(1828, 'fa', 'کارائیب هلند', 43),
(1829, 'fa', 'Cayman Islands', 44),
(1830, 'fa', 'جمهوری آفریقای مرکزی', 45),
(1831, 'fa', 'سوتا و ملیلا', 46),
(1832, 'fa', 'چاد', 47),
(1833, 'fa', 'شیلی', 48),
(1834, 'fa', 'چین', 49),
(1835, 'fa', 'جزیره کریسمس', 50),
(1836, 'fa', 'جزایر کوکو (Keeling)', 51),
(1837, 'fa', 'کلمبیا', 52),
(1838, 'fa', 'کومور', 53),
(1839, 'fa', 'کنگو - برزاویل', 54),
(1840, 'fa', 'کنگو - کینشاسا', 55),
(1841, 'fa', 'جزایر کوک', 56),
(1842, 'fa', 'کاستاریکا', 57),
(1843, 'fa', 'ساحل عاج', 58),
(1844, 'fa', 'کرواسی', 59),
(1845, 'fa', 'کوبا', 60),
(1846, 'fa', 'کوراسائو', 61),
(1847, 'fa', 'قبرس', 62),
(1848, 'fa', 'چک', 63),
(1849, 'fa', 'دانمارک', 64),
(1850, 'fa', 'دیگو گارسیا', 65),
(1851, 'fa', 'جیبوتی', 66),
(1852, 'fa', 'دومینیکا', 67),
(1853, 'fa', 'جمهوری دومینیکن', 68),
(1854, 'fa', 'اکوادور', 69),
(1855, 'fa', 'مصر', 70),
(1856, 'fa', 'السالوادور', 71),
(1857, 'fa', 'گینه استوایی', 72),
(1858, 'fa', 'اریتره', 73),
(1859, 'fa', 'استونی', 74),
(1860, 'fa', 'اتیوپی', 75),
(1861, 'fa', 'منطقه یورو', 76),
(1862, 'fa', 'جزایر فالکلند', 77),
(1863, 'fa', 'جزایر فارو', 78),
(1864, 'fa', 'فیجی', 79),
(1865, 'fa', 'فنلاند', 80),
(1866, 'fa', 'فرانسه', 81),
(1867, 'fa', 'گویان فرانسه', 82),
(1868, 'fa', 'پلی‌نزی فرانسه', 83),
(1869, 'fa', 'سرزمین های جنوبی فرانسه', 84),
(1870, 'fa', 'گابن', 85),
(1871, 'fa', 'گامبیا', 86),
(1872, 'fa', 'جورجیا', 87),
(1873, 'fa', 'آلمان', 88),
(1874, 'fa', 'غنا', 89),
(1875, 'fa', 'جبل الطارق', 90),
(1876, 'fa', 'یونان', 91),
(1877, 'fa', 'گرینلند', 92),
(1878, 'fa', 'گرنادا', 93),
(1879, 'fa', 'گوادلوپ', 94),
(1880, 'fa', 'گوام', 95),
(1881, 'fa', 'گواتمالا', 96),
(1882, 'fa', 'گورنسی', 97),
(1883, 'fa', 'گینه', 98),
(1884, 'fa', 'گینه بیسائو', 99),
(1885, 'fa', 'گویان', 100),
(1886, 'fa', 'هائیتی', 101),
(1887, 'fa', 'هندوراس', 102),
(1888, 'fa', 'هنگ کنگ SAR چین', 103),
(1889, 'fa', 'مجارستان', 104),
(1890, 'fa', 'ایسلند', 105),
(1891, 'fa', 'هند', 106),
(1892, 'fa', 'اندونزی', 107),
(1893, 'fa', 'ایران', 108),
(1894, 'fa', 'عراق', 109),
(1895, 'fa', 'ایرلند', 110),
(1896, 'fa', 'جزیره من', 111),
(1897, 'fa', 'اسرائيل', 112),
(1898, 'fa', 'ایتالیا', 113),
(1899, 'fa', 'جامائیکا', 114),
(1900, 'fa', 'ژاپن', 115),
(1901, 'fa', 'پیراهن ورزشی', 116),
(1902, 'fa', 'اردن', 117),
(1903, 'fa', 'قزاقستان', 118),
(1904, 'fa', 'کنیا', 119),
(1905, 'fa', 'کیریباتی', 120),
(1906, 'fa', 'کوزوو', 121),
(1907, 'fa', 'کویت', 122),
(1908, 'fa', 'قرقیزستان', 123),
(1909, 'fa', 'لائوس', 124),
(1910, 'fa', 'لتونی', 125),
(1911, 'fa', 'لبنان', 126),
(1912, 'fa', 'لسوتو', 127),
(1913, 'fa', 'لیبریا', 128),
(1914, 'fa', 'لیبی', 129),
(1915, 'fa', 'لیختن اشتاین', 130),
(1916, 'fa', 'لیتوانی', 131),
(1917, 'fa', 'لوکزامبورگ', 132),
(1918, 'fa', 'ماکائو SAR چین', 133),
(1919, 'fa', 'مقدونیه', 134),
(1920, 'fa', 'ماداگاسکار', 135),
(1921, 'fa', 'مالاوی', 136),
(1922, 'fa', 'مالزی', 137),
(1923, 'fa', 'مالدیو', 138),
(1924, 'fa', 'مالی', 139),
(1925, 'fa', 'مالت', 140),
(1926, 'fa', 'جزایر مارشال', 141),
(1927, 'fa', 'مارتینیک', 142),
(1928, 'fa', 'موریتانی', 143),
(1929, 'fa', 'موریس', 144),
(1930, 'fa', 'گمشده', 145),
(1931, 'fa', 'مکزیک', 146),
(1932, 'fa', 'میکرونزی', 147),
(1933, 'fa', 'مولداوی', 148),
(1934, 'fa', 'موناکو', 149),
(1935, 'fa', 'مغولستان', 150),
(1936, 'fa', 'مونته نگرو', 151),
(1937, 'fa', 'مونتسرات', 152),
(1938, 'fa', 'مراکش', 153),
(1939, 'fa', 'موزامبیک', 154),
(1940, 'fa', 'میانمار (برمه)', 155),
(1941, 'fa', 'ناميبيا', 156),
(1942, 'fa', 'نائورو', 157),
(1943, 'fa', 'نپال', 158),
(1944, 'fa', 'هلند', 159),
(1945, 'fa', 'کالدونیای جدید', 160),
(1946, 'fa', 'نیوزلند', 161),
(1947, 'fa', 'نیکاراگوئه', 162),
(1948, 'fa', 'نیجر', 163),
(1949, 'fa', 'نیجریه', 164),
(1950, 'fa', 'نیو', 165),
(1951, 'fa', 'جزیره نورفولک', 166),
(1952, 'fa', 'کره شمالی', 167),
(1953, 'fa', 'جزایر ماریانای شمالی', 168),
(1954, 'fa', 'نروژ', 169),
(1955, 'fa', 'عمان', 170),
(1956, 'fa', 'پاکستان', 171),
(1957, 'fa', 'پالائو', 172),
(1958, 'fa', 'سرزمین های فلسطینی', 173),
(1959, 'fa', 'پاناما', 174),
(1960, 'fa', 'پاپوا گینه نو', 175),
(1961, 'fa', 'پاراگوئه', 176),
(1962, 'fa', 'پرو', 177),
(1963, 'fa', 'فیلیپین', 178),
(1964, 'fa', 'جزایر پیکریرن', 179),
(1965, 'fa', 'لهستان', 180),
(1966, 'fa', 'کشور پرتغال', 181),
(1967, 'fa', 'پورتوریکو', 182),
(1968, 'fa', 'قطر', 183),
(1969, 'fa', 'تجدید دیدار', 184),
(1970, 'fa', 'رومانی', 185),
(1971, 'fa', 'روسیه', 186),
(1972, 'fa', 'رواندا', 187),
(1973, 'fa', 'ساموآ', 188),
(1974, 'fa', 'سان مارینو', 189),
(1975, 'fa', 'سنت کیتس و نوویس', 190),
(1976, 'fa', 'عربستان سعودی', 191),
(1977, 'fa', 'سنگال', 192),
(1978, 'fa', 'صربستان', 193),
(1979, 'fa', 'سیشل', 194),
(1980, 'fa', 'سیرالئون', 195),
(1981, 'fa', 'سنگاپور', 196),
(1982, 'fa', 'سینت ماارتن', 197),
(1983, 'fa', 'اسلواکی', 198),
(1984, 'fa', 'اسلوونی', 199),
(1985, 'fa', 'جزایر سلیمان', 200),
(1986, 'fa', 'سومالی', 201),
(1987, 'fa', 'آفریقای جنوبی', 202),
(1988, 'fa', 'جزایر جورجیا جنوبی و جزایر ساندویچ جنوبی', 203),
(1989, 'fa', 'کره جنوبی', 204),
(1990, 'fa', 'سودان جنوبی', 205),
(1991, 'fa', 'اسپانیا', 206),
(1992, 'fa', 'سری لانکا', 207),
(1993, 'fa', 'سنت بارتلی', 208),
(1994, 'fa', 'سنت هلنا', 209),
(1995, 'fa', 'سنت کیتز و نوویس', 210),
(1996, 'fa', 'سنت لوسیا', 211),
(1997, 'fa', 'سنت مارتین', 212),
(1998, 'fa', 'سنت پیر و میکلون', 213),
(1999, 'fa', 'سنت وینسنت و گرنادینها', 214),
(2000, 'fa', 'سودان', 215),
(2001, 'fa', 'سورینام', 216),
(2002, 'fa', 'اسوالبارد و جان ماین', 217),
(2003, 'fa', 'سوازیلند', 218),
(2004, 'fa', 'سوئد', 219),
(2005, 'fa', 'سوئیس', 220),
(2006, 'fa', 'سوریه', 221),
(2007, 'fa', 'تایوان', 222),
(2008, 'fa', 'تاجیکستان', 223),
(2009, 'fa', 'تانزانیا', 224),
(2010, 'fa', 'تایلند', 225),
(2011, 'fa', 'تیمور-لست', 226),
(2012, 'fa', 'رفتن', 227),
(2013, 'fa', 'توکلو', 228),
(2014, 'fa', 'تونگا', 229),
(2015, 'fa', 'ترینیداد و توباگو', 230),
(2016, 'fa', 'تریستان دا کانونا', 231),
(2017, 'fa', 'تونس', 232),
(2018, 'fa', 'بوقلمون', 233),
(2019, 'fa', 'ترکمنستان', 234),
(2020, 'fa', 'جزایر تورکس و کایکوس', 235),
(2021, 'fa', 'تووالو', 236),
(2022, 'fa', 'جزایر دور افتاده ایالات متحده آمریکا', 237),
(2023, 'fa', 'جزایر ویرجین ایالات متحده', 238),
(2024, 'fa', 'اوگاندا', 239),
(2025, 'fa', 'اوکراین', 240),
(2026, 'fa', 'امارات متحده عربی', 241),
(2027, 'fa', 'انگلستان', 242),
(2028, 'fa', 'سازمان ملل', 243),
(2029, 'fa', 'ایالات متحده', 244),
(2030, 'fa', 'اروگوئه', 245),
(2031, 'fa', 'ازبکستان', 246),
(2032, 'fa', 'وانواتو', 247),
(2033, 'fa', 'شهر واتیکان', 248),
(2034, 'fa', 'ونزوئلا', 249),
(2035, 'fa', 'ویتنام', 250),
(2036, 'fa', 'والیس و فوتونا', 251),
(2037, 'fa', 'صحرای غربی', 252),
(2038, 'fa', 'یمن', 253),
(2039, 'fa', 'زامبیا', 254),
(2040, 'fa', 'زیمبابوه', 255),
(2041, 'pt_BR', 'Afeganistão', 1),
(2042, 'pt_BR', 'Ilhas Åland', 2),
(2043, 'pt_BR', 'Albânia', 3),
(2044, 'pt_BR', 'Argélia', 4),
(2045, 'pt_BR', 'Samoa Americana', 5),
(2046, 'pt_BR', 'Andorra', 6),
(2047, 'pt_BR', 'Angola', 7),
(2048, 'pt_BR', 'Angola', 8),
(2049, 'pt_BR', 'Antártico', 9),
(2050, 'pt_BR', 'Antígua e Barbuda', 10),
(2051, 'pt_BR', 'Argentina', 11),
(2052, 'pt_BR', 'Armênia', 12),
(2053, 'pt_BR', 'Aruba', 13),
(2054, 'pt_BR', 'Ilha de escalada', 14),
(2055, 'pt_BR', 'Austrália', 15),
(2056, 'pt_BR', 'Áustria', 16),
(2057, 'pt_BR', 'Azerbaijão', 17),
(2058, 'pt_BR', 'Bahamas', 18),
(2059, 'pt_BR', 'Bahrain', 19),
(2060, 'pt_BR', 'Bangladesh', 20),
(2061, 'pt_BR', 'Barbados', 21),
(2062, 'pt_BR', 'Bielorrússia', 22),
(2063, 'pt_BR', 'Bélgica', 23),
(2064, 'pt_BR', 'Bélgica', 24),
(2065, 'pt_BR', 'Benin', 25),
(2066, 'pt_BR', 'Bermuda', 26),
(2067, 'pt_BR', 'Butão', 27),
(2068, 'pt_BR', 'Bolívia', 28),
(2069, 'pt_BR', 'Bósnia e Herzegovina', 29),
(2070, 'pt_BR', 'Botsuana', 30),
(2071, 'pt_BR', 'Brasil', 31),
(2072, 'pt_BR', 'Território Britânico do Oceano Índico', 32),
(2073, 'pt_BR', 'Ilhas Virgens Britânicas', 33),
(2074, 'pt_BR', 'Brunei', 34),
(2075, 'pt_BR', 'Bulgária', 35),
(2076, 'pt_BR', 'Burkina Faso', 36),
(2077, 'pt_BR', 'Burundi', 37),
(2078, 'pt_BR', 'Camboja', 38),
(2079, 'pt_BR', 'Camarões', 39),
(2080, 'pt_BR', 'Canadá', 40),
(2081, 'pt_BR', 'Ilhas Canárias', 41),
(2082, 'pt_BR', 'Cabo Verde', 42),
(2083, 'pt_BR', 'Holanda do Caribe', 43),
(2084, 'pt_BR', 'Ilhas Cayman', 44),
(2085, 'pt_BR', 'República Centro-Africana', 45),
(2086, 'pt_BR', 'Ceuta e Melilla', 46),
(2087, 'pt_BR', 'Chade', 47),
(2088, 'pt_BR', 'Chile', 48),
(2089, 'pt_BR', 'China', 49),
(2090, 'pt_BR', 'Ilha Christmas', 50),
(2091, 'pt_BR', 'Ilhas Cocos (Keeling)', 51),
(2092, 'pt_BR', 'Colômbia', 52),
(2093, 'pt_BR', 'Comores', 53),
(2094, 'pt_BR', 'Congo - Brazzaville', 54),
(2095, 'pt_BR', 'Congo - Kinshasa', 55),
(2096, 'pt_BR', 'Ilhas Cook', 56),
(2097, 'pt_BR', 'Costa Rica', 57),
(2098, 'pt_BR', 'Costa do Marfim', 58),
(2099, 'pt_BR', 'Croácia', 59),
(2100, 'pt_BR', 'Cuba', 60),
(2101, 'pt_BR', 'Curaçao', 61),
(2102, 'pt_BR', 'Chipre', 62),
(2103, 'pt_BR', 'Czechia', 63),
(2104, 'pt_BR', 'Dinamarca', 64),
(2105, 'pt_BR', 'Diego Garcia', 65),
(2106, 'pt_BR', 'Djibuti', 66),
(2107, 'pt_BR', 'Dominica', 67),
(2108, 'pt_BR', 'República Dominicana', 68),
(2109, 'pt_BR', 'Equador', 69),
(2110, 'pt_BR', 'Egito', 70),
(2111, 'pt_BR', 'El Salvador', 71),
(2112, 'pt_BR', 'Guiné Equatorial', 72),
(2113, 'pt_BR', 'Eritreia', 73),
(2114, 'pt_BR', 'Estônia', 74),
(2115, 'pt_BR', 'Etiópia', 75),
(2116, 'pt_BR', 'Zona Euro', 76),
(2117, 'pt_BR', 'Ilhas Malvinas', 77),
(2118, 'pt_BR', 'Ilhas Faroe', 78),
(2119, 'pt_BR', 'Fiji', 79),
(2120, 'pt_BR', 'Finlândia', 80),
(2121, 'pt_BR', 'França', 81),
(2122, 'pt_BR', 'Guiana Francesa', 82),
(2123, 'pt_BR', 'Polinésia Francesa', 83),
(2124, 'pt_BR', 'Territórios Franceses do Sul', 84),
(2125, 'pt_BR', 'Gabão', 85),
(2126, 'pt_BR', 'Gâmbia', 86),
(2127, 'pt_BR', 'Geórgia', 87),
(2128, 'pt_BR', 'Alemanha', 88),
(2129, 'pt_BR', 'Gana', 89),
(2130, 'pt_BR', 'Gibraltar', 90),
(2131, 'pt_BR', 'Grécia', 91),
(2132, 'pt_BR', 'Gronelândia', 92),
(2133, 'pt_BR', 'Granada', 93),
(2134, 'pt_BR', 'Guadalupe', 94),
(2135, 'pt_BR', 'Guam', 95),
(2136, 'pt_BR', 'Guatemala', 96),
(2137, 'pt_BR', 'Guernsey', 97),
(2138, 'pt_BR', 'Guiné', 98),
(2139, 'pt_BR', 'Guiné-Bissau', 99),
(2140, 'pt_BR', 'Guiana', 100),
(2141, 'pt_BR', 'Haiti', 101),
(2142, 'pt_BR', 'Honduras', 102),
(2143, 'pt_BR', 'Região Administrativa Especial de Hong Kong, China', 103),
(2144, 'pt_BR', 'Hungria', 104),
(2145, 'pt_BR', 'Islândia', 105),
(2146, 'pt_BR', 'Índia', 106),
(2147, 'pt_BR', 'Indonésia', 107),
(2148, 'pt_BR', 'Irã', 108),
(2149, 'pt_BR', 'Iraque', 109),
(2150, 'pt_BR', 'Irlanda', 110),
(2151, 'pt_BR', 'Ilha de Man', 111),
(2152, 'pt_BR', 'Israel', 112),
(2153, 'pt_BR', 'Itália', 113),
(2154, 'pt_BR', 'Jamaica', 114),
(2155, 'pt_BR', 'Japão', 115),
(2156, 'pt_BR', 'Jersey', 116),
(2157, 'pt_BR', 'Jordânia', 117),
(2158, 'pt_BR', 'Cazaquistão', 118),
(2159, 'pt_BR', 'Quênia', 119),
(2160, 'pt_BR', 'Quiribati', 120),
(2161, 'pt_BR', 'Kosovo', 121),
(2162, 'pt_BR', 'Kuwait', 122),
(2163, 'pt_BR', 'Quirguistão', 123),
(2164, 'pt_BR', 'Laos', 124),
(2165, 'pt_BR', 'Letônia', 125),
(2166, 'pt_BR', 'Líbano', 126),
(2167, 'pt_BR', 'Lesoto', 127),
(2168, 'pt_BR', 'Libéria', 128),
(2169, 'pt_BR', 'Líbia', 129),
(2170, 'pt_BR', 'Liechtenstein', 130),
(2171, 'pt_BR', 'Lituânia', 131),
(2172, 'pt_BR', 'Luxemburgo', 132),
(2173, 'pt_BR', 'Macau SAR China', 133),
(2174, 'pt_BR', 'Macedônia', 134),
(2175, 'pt_BR', 'Madagascar', 135),
(2176, 'pt_BR', 'Malawi', 136),
(2177, 'pt_BR', 'Malásia', 137),
(2178, 'pt_BR', 'Maldivas', 138),
(2179, 'pt_BR', 'Mali', 139),
(2180, 'pt_BR', 'Malta', 140),
(2181, 'pt_BR', 'Ilhas Marshall', 141),
(2182, 'pt_BR', 'Martinica', 142),
(2183, 'pt_BR', 'Mauritânia', 143),
(2184, 'pt_BR', 'Maurício', 144),
(2185, 'pt_BR', 'Maiote', 145),
(2186, 'pt_BR', 'México', 146),
(2187, 'pt_BR', 'Micronésia', 147),
(2188, 'pt_BR', 'Moldávia', 148),
(2189, 'pt_BR', 'Mônaco', 149),
(2190, 'pt_BR', 'Mongólia', 150),
(2191, 'pt_BR', 'Montenegro', 151),
(2192, 'pt_BR', 'Montserrat', 152),
(2193, 'pt_BR', 'Marrocos', 153),
(2194, 'pt_BR', 'Moçambique', 154),
(2195, 'pt_BR', 'Mianmar (Birmânia)', 155),
(2196, 'pt_BR', 'Namíbia', 156),
(2197, 'pt_BR', 'Nauru', 157),
(2198, 'pt_BR', 'Nepal', 158),
(2199, 'pt_BR', 'Holanda', 159),
(2200, 'pt_BR', 'Nova Caledônia', 160),
(2201, 'pt_BR', 'Nova Zelândia', 161),
(2202, 'pt_BR', 'Nicarágua', 162),
(2203, 'pt_BR', 'Níger', 163),
(2204, 'pt_BR', 'Nigéria', 164),
(2205, 'pt_BR', 'Niue', 165),
(2206, 'pt_BR', 'Ilha Norfolk', 166),
(2207, 'pt_BR', 'Coréia do Norte', 167),
(2208, 'pt_BR', 'Ilhas Marianas do Norte', 168),
(2209, 'pt_BR', 'Noruega', 169),
(2210, 'pt_BR', 'Omã', 170),
(2211, 'pt_BR', 'Paquistão', 171),
(2212, 'pt_BR', 'Palau', 172),
(2213, 'pt_BR', 'Territórios Palestinos', 173),
(2214, 'pt_BR', 'Panamá', 174),
(2215, 'pt_BR', 'Papua Nova Guiné', 175),
(2216, 'pt_BR', 'Paraguai', 176),
(2217, 'pt_BR', 'Peru', 177),
(2218, 'pt_BR', 'Filipinas', 178),
(2219, 'pt_BR', 'Ilhas Pitcairn', 179),
(2220, 'pt_BR', 'Polônia', 180),
(2221, 'pt_BR', 'Portugal', 181),
(2222, 'pt_BR', 'Porto Rico', 182),
(2223, 'pt_BR', 'Catar', 183),
(2224, 'pt_BR', 'Reunião', 184),
(2225, 'pt_BR', 'Romênia', 185),
(2226, 'pt_BR', 'Rússia', 186),
(2227, 'pt_BR', 'Ruanda', 187),
(2228, 'pt_BR', 'Samoa', 188),
(2229, 'pt_BR', 'São Marinho', 189),
(2230, 'pt_BR', 'São Cristóvão e Nevis', 190),
(2231, 'pt_BR', 'Arábia Saudita', 191),
(2232, 'pt_BR', 'Senegal', 192),
(2233, 'pt_BR', 'Sérvia', 193),
(2234, 'pt_BR', 'Seychelles', 194),
(2235, 'pt_BR', 'Serra Leoa', 195),
(2236, 'pt_BR', 'Cingapura', 196),
(2237, 'pt_BR', 'São Martinho', 197),
(2238, 'pt_BR', 'Eslováquia', 198),
(2239, 'pt_BR', 'Eslovênia', 199),
(2240, 'pt_BR', 'Ilhas Salomão', 200),
(2241, 'pt_BR', 'Somália', 201),
(2242, 'pt_BR', 'África do Sul', 202),
(2243, 'pt_BR', 'Ilhas Geórgia do Sul e Sandwich do Sul', 203),
(2244, 'pt_BR', 'Coréia do Sul', 204),
(2245, 'pt_BR', 'Sudão do Sul', 205),
(2246, 'pt_BR', 'Espanha', 206),
(2247, 'pt_BR', 'Sri Lanka', 207),
(2248, 'pt_BR', 'São Bartolomeu', 208),
(2249, 'pt_BR', 'Santa Helena', 209),
(2250, 'pt_BR', 'São Cristóvão e Nevis', 210),
(2251, 'pt_BR', 'Santa Lúcia', 211),
(2252, 'pt_BR', 'São Martinho', 212),
(2253, 'pt_BR', 'São Pedro e Miquelon', 213),
(2254, 'pt_BR', 'São Vicente e Granadinas', 214),
(2255, 'pt_BR', 'Sudão', 215),
(2256, 'pt_BR', 'Suriname', 216),
(2257, 'pt_BR', 'Svalbard e Jan Mayen', 217),
(2258, 'pt_BR', 'Suazilândia', 218),
(2259, 'pt_BR', 'Suécia', 219),
(2260, 'pt_BR', 'Suíça', 220),
(2261, 'pt_BR', 'Síria', 221),
(2262, 'pt_BR', 'Taiwan', 222),
(2263, 'pt_BR', 'Tajiquistão', 223),
(2264, 'pt_BR', 'Tanzânia', 224),
(2265, 'pt_BR', 'Tailândia', 225),
(2266, 'pt_BR', 'Timor-Leste', 226),
(2267, 'pt_BR', 'Togo', 227),
(2268, 'pt_BR', 'Tokelau', 228),
(2269, 'pt_BR', 'Tonga', 229),
(2270, 'pt_BR', 'Trinidad e Tobago', 230),
(2271, 'pt_BR', 'Tristan da Cunha', 231),
(2272, 'pt_BR', 'Tunísia', 232),
(2273, 'pt_BR', 'Turquia', 233),
(2274, 'pt_BR', 'Turquemenistão', 234),
(2275, 'pt_BR', 'Ilhas Turks e Caicos', 235),
(2276, 'pt_BR', 'Tuvalu', 236),
(2277, 'pt_BR', 'Ilhas periféricas dos EUA', 237),
(2278, 'pt_BR', 'Ilhas Virgens dos EUA', 238),
(2279, 'pt_BR', 'Uganda', 239),
(2280, 'pt_BR', 'Ucrânia', 240),
(2281, 'pt_BR', 'Emirados Árabes Unidos', 241),
(2282, 'pt_BR', 'Reino Unido', 242),
(2283, 'pt_BR', 'Nações Unidas', 243),
(2284, 'pt_BR', 'Estados Unidos', 244),
(2285, 'pt_BR', 'Uruguai', 245),
(2286, 'pt_BR', 'Uzbequistão', 246),
(2287, 'pt_BR', 'Vanuatu', 247),
(2288, 'pt_BR', 'Cidade do Vaticano', 248),
(2289, 'pt_BR', 'Venezuela', 249),
(2290, 'pt_BR', 'Vietnã', 250),
(2291, 'pt_BR', 'Wallis e Futuna', 251),
(2292, 'pt_BR', 'Saara Ocidental', 252),
(2293, 'pt_BR', 'Iêmen', 253),
(2294, 'pt_BR', 'Zâmbia', 254),
(2295, 'pt_BR', 'Zimbábue', 255);

-- --------------------------------------------------------

--
-- Table structure for table `currencies`
--

CREATE TABLE `currencies` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `symbol` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `currencies`
--

INSERT INTO `currencies` (`id`, `code`, `name`, `created_at`, `updated_at`, `symbol`) VALUES
(1, 'USD', 'US Dollar', NULL, NULL, '$'),
(2, 'EUR', 'Euro', NULL, NULL, '€'),
(3, 'BNG', 'Taka', '2020-07-20 09:28:32', '2020-07-20 09:28:32', '৳');

-- --------------------------------------------------------

--
-- Table structure for table `currency_exchange_rates`
--

CREATE TABLE `currency_exchange_rates` (
  `id` int(10) UNSIGNED NOT NULL,
  `rate` decimal(24,12) NOT NULL,
  `target_currency` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` int(10) UNSIGNED NOT NULL,
  `first_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `gender` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `api_token` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_group_id` int(10) UNSIGNED DEFAULT NULL,
  `subscribed_to_news_letter` tinyint(1) NOT NULL DEFAULT 0,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `is_verified` tinyint(1) NOT NULL DEFAULT 0,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `customer_groups`
--

CREATE TABLE `customer_groups` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_user_defined` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `customer_groups`
--

INSERT INTO `customer_groups` (`id`, `name`, `is_user_defined`, `created_at`, `updated_at`, `code`) VALUES
(1, 'Guest', 0, NULL, NULL, 'guest'),
(2, 'General', 0, NULL, NULL, 'general'),
(3, 'Wholesale', 0, NULL, NULL, 'wholesale');

-- --------------------------------------------------------

--
-- Table structure for table `customer_password_resets`
--

CREATE TABLE `customer_password_resets` (
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `downloadable_link_purchased`
--

CREATE TABLE `downloadable_link_purchased` (
  `id` int(10) UNSIGNED NOT NULL,
  `product_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `url` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `download_bought` int(11) NOT NULL DEFAULT 0,
  `download_used` int(11) NOT NULL DEFAULT 0,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `order_item_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `inventory_sources`
--

CREATE TABLE `inventory_sources` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contact_email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contact_number` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contact_fax` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `street` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `postcode` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `priority` int(11) NOT NULL DEFAULT 0,
  `latitude` decimal(10,5) DEFAULT NULL,
  `longitude` decimal(10,5) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `inventory_sources`
--

INSERT INTO `inventory_sources` (`id`, `code`, `name`, `description`, `contact_name`, `contact_email`, `contact_number`, `contact_fax`, `country`, `state`, `city`, `street`, `postcode`, `priority`, `latitude`, `longitude`, `status`, `created_at`, `updated_at`) VALUES
(1, 'default', 'Default', NULL, 'Detroit Warehouse', 'warehouse@example.com', '1234567899', NULL, 'US', 'MI', 'Detroit', '12th Street', '48127', 0, NULL, NULL, 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `invoices`
--

CREATE TABLE `invoices` (
  `id` int(10) UNSIGNED NOT NULL,
  `increment_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_sent` tinyint(1) NOT NULL DEFAULT 0,
  `total_qty` int(11) DEFAULT NULL,
  `base_currency_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `channel_currency_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_currency_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sub_total` decimal(12,4) DEFAULT 0.0000,
  `base_sub_total` decimal(12,4) DEFAULT 0.0000,
  `grand_total` decimal(12,4) DEFAULT 0.0000,
  `base_grand_total` decimal(12,4) DEFAULT 0.0000,
  `shipping_amount` decimal(12,4) DEFAULT 0.0000,
  `base_shipping_amount` decimal(12,4) DEFAULT 0.0000,
  `tax_amount` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount` decimal(12,4) DEFAULT 0.0000,
  `discount_amount` decimal(12,4) DEFAULT 0.0000,
  `base_discount_amount` decimal(12,4) DEFAULT 0.0000,
  `order_id` int(10) UNSIGNED DEFAULT NULL,
  `order_address_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `transaction_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `invoice_items`
--

CREATE TABLE `invoice_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sku` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `total` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_total` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `tax_amount` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount` decimal(12,4) DEFAULT 0.0000,
  `product_id` int(10) UNSIGNED DEFAULT NULL,
  `product_type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_item_id` int(10) UNSIGNED DEFAULT NULL,
  `invoice_id` int(10) UNSIGNED DEFAULT NULL,
  `parent_id` int(10) UNSIGNED DEFAULT NULL,
  `additional` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`additional`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `discount_percent` decimal(12,4) DEFAULT 0.0000,
  `discount_amount` decimal(12,4) DEFAULT 0.0000,
  `base_discount_amount` decimal(12,4) DEFAULT 0.0000
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `locales`
--

CREATE TABLE `locales` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `direction` enum('ltr','rtl') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ltr',
  `locale_image` text COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `locales`
--

INSERT INTO `locales` (`id`, `code`, `name`, `created_at`, `updated_at`, `direction`, `locale_image`) VALUES
(1, 'en', 'English', NULL, NULL, 'ltr', NULL),
(2, 'fr', 'French', NULL, NULL, 'ltr', NULL),
(3, 'nl', 'Dutch', NULL, NULL, 'ltr', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_admin_password_resets_table', 1),
(3, '2014_10_12_100000_create_password_resets_table', 1),
(4, '2018_06_12_111907_create_admins_table', 1),
(5, '2018_06_13_055341_create_roles_table', 1),
(6, '2018_07_05_130148_create_attributes_table', 1),
(7, '2018_07_05_132854_create_attribute_translations_table', 1),
(8, '2018_07_05_135150_create_attribute_families_table', 1),
(9, '2018_07_05_135152_create_attribute_groups_table', 1),
(10, '2018_07_05_140832_create_attribute_options_table', 1),
(11, '2018_07_05_140856_create_attribute_option_translations_table', 1),
(12, '2018_07_05_142820_create_categories_table', 1),
(13, '2018_07_10_055143_create_locales_table', 1),
(14, '2018_07_20_054426_create_countries_table', 1),
(15, '2018_07_20_054502_create_currencies_table', 1),
(16, '2018_07_20_054542_create_currency_exchange_rates_table', 1),
(17, '2018_07_20_064849_create_channels_table', 1),
(18, '2018_07_21_142836_create_category_translations_table', 1),
(19, '2018_07_23_110040_create_inventory_sources_table', 1),
(20, '2018_07_24_082635_create_customer_groups_table', 1),
(21, '2018_07_24_082930_create_customers_table', 1),
(22, '2018_07_24_083025_create_customer_addresses_table', 1),
(23, '2018_07_27_065727_create_products_table', 1),
(24, '2018_07_27_070011_create_product_attribute_values_table', 1),
(25, '2018_07_27_092623_create_product_reviews_table', 1),
(26, '2018_07_27_113941_create_product_images_table', 1),
(27, '2018_07_27_113956_create_product_inventories_table', 1),
(28, '2018_08_03_114203_create_sliders_table', 1),
(29, '2018_08_30_064755_create_tax_categories_table', 1),
(30, '2018_08_30_065042_create_tax_rates_table', 1),
(31, '2018_08_30_065840_create_tax_mappings_table', 1),
(32, '2018_09_05_150444_create_cart_table', 1),
(33, '2018_09_05_150915_create_cart_items_table', 1),
(34, '2018_09_11_064045_customer_password_resets', 1),
(35, '2018_09_19_092845_create_cart_address', 1),
(36, '2018_09_19_093453_create_cart_payment', 1),
(37, '2018_09_19_093508_create_cart_shipping_rates_table', 1),
(38, '2018_09_20_060658_create_core_config_table', 1),
(39, '2018_09_27_113154_create_orders_table', 1),
(40, '2018_09_27_113207_create_order_items_table', 1),
(41, '2018_09_27_113405_create_order_address_table', 1),
(42, '2018_09_27_115022_create_shipments_table', 1),
(43, '2018_09_27_115029_create_shipment_items_table', 1),
(44, '2018_09_27_115135_create_invoices_table', 1),
(45, '2018_09_27_115144_create_invoice_items_table', 1),
(46, '2018_10_01_095504_create_order_payment_table', 1),
(47, '2018_10_03_025230_create_wishlist_table', 1),
(48, '2018_10_12_101803_create_country_translations_table', 1),
(49, '2018_10_12_101913_create_country_states_table', 1),
(50, '2018_10_12_101923_create_country_state_translations_table', 1),
(51, '2018_11_15_153257_alter_order_table', 1),
(52, '2018_11_15_163729_alter_invoice_table', 1),
(53, '2018_11_16_173504_create_subscribers_list_table', 1),
(54, '2018_11_17_165758_add_is_verified_column_in_customers_table', 1),
(55, '2018_11_21_144411_create_cart_item_inventories_table', 1),
(56, '2018_11_26_110500_change_gender_column_in_customers_table', 1),
(57, '2018_11_27_174449_change_content_column_in_sliders_table', 1),
(58, '2018_12_05_132625_drop_foreign_key_core_config_table', 1),
(59, '2018_12_05_132629_alter_core_config_table', 1),
(60, '2018_12_06_185202_create_product_flat_table', 1),
(61, '2018_12_21_101307_alter_channels_table', 1),
(62, '2018_12_24_123812_create_channel_inventory_sources_table', 1),
(63, '2018_12_24_184402_alter_shipments_table', 1),
(64, '2018_12_26_165327_create_product_ordered_inventories_table', 1),
(65, '2018_12_31_161114_alter_channels_category_table', 1),
(66, '2019_01_11_122452_add_vendor_id_column_in_product_inventories_table', 1),
(67, '2019_01_25_124522_add_updated_at_column_in_product_flat_table', 1),
(68, '2019_01_29_123053_add_min_price_and_max_price_column_in_product_flat_table', 1),
(69, '2019_01_31_164117_update_value_column_type_to_text_in_core_config_table', 1),
(70, '2019_02_21_145238_alter_product_reviews_table', 1),
(71, '2019_02_21_152709_add_swatch_type_column_in_attributes_table', 1),
(72, '2019_02_21_153035_alter_customer_id_in_product_reviews_table', 1),
(73, '2019_02_21_153851_add_swatch_value_columns_in_attribute_options_table', 1),
(74, '2019_03_15_123337_add_display_mode_column_in_categories_table', 1),
(75, '2019_03_28_103658_add_notes_column_in_customers_table', 1),
(76, '2019_04_24_155820_alter_product_flat_table', 1),
(77, '2019_05_13_024320_remove_tables', 1),
(78, '2019_05_13_024321_create_cart_rules_table', 1),
(79, '2019_05_13_024322_create_cart_rule_channels_table', 1),
(80, '2019_05_13_024323_create_cart_rule_customer_groups_table', 1),
(81, '2019_05_13_024324_create_cart_rule_translations_table', 1),
(82, '2019_05_13_024325_create_cart_rule_customers_table', 1),
(83, '2019_05_13_024326_create_cart_rule_coupons_table', 1),
(84, '2019_05_13_024327_create_cart_rule_coupon_usage_table', 1),
(85, '2019_05_22_165833_update_zipcode_column_type_to_varchar_in_cart_address_table', 1),
(86, '2019_05_23_113407_add_remaining_column_in_product_flat_table', 1),
(87, '2019_05_23_155520_add_discount_columns_in_invoice_items_table', 1),
(88, '2019_05_23_184029_rename_discount_columns_in_cart_table', 1),
(89, '2019_06_04_114009_add_phone_column_in_customers_table', 1),
(90, '2019_06_06_195905_update_custom_price_to_nullable_in_cart_items', 1),
(91, '2019_06_15_183412_add_code_column_in_customer_groups_table', 1),
(92, '2019_06_17_180258_create_product_downloadable_samples_table', 1),
(93, '2019_06_17_180314_create_product_downloadable_sample_translations_table', 1),
(94, '2019_06_17_180325_create_product_downloadable_links_table', 1),
(95, '2019_06_17_180346_create_product_downloadable_link_translations_table', 1),
(96, '2019_06_19_162817_remove_unique_in_phone_column_in_customers_table', 1),
(97, '2019_06_21_130512_update_weight_column_deafult_value_in_cart_items_table', 1),
(98, '2019_06_21_202249_create_downloadable_link_purchased_table', 1),
(99, '2019_07_02_180307_create_booking_products_table', 1),
(100, '2019_07_05_114157_add_symbol_column_in_currencies_table', 1),
(101, '2019_07_05_154415_create_booking_product_default_slots_table', 1),
(102, '2019_07_05_154429_create_booking_product_appointment_slots_table', 1),
(103, '2019_07_05_154440_create_booking_product_event_tickets_table', 1),
(104, '2019_07_05_154451_create_booking_product_rental_slots_table', 1),
(105, '2019_07_05_154502_create_booking_product_table_slots_table', 1),
(106, '2019_07_11_151210_add_locale_id_in_category_translations', 1),
(107, '2019_07_23_033128_alter_locales_table', 1),
(108, '2019_07_23_174708_create_velocity_contents_table', 1),
(109, '2019_07_23_175212_create_velocity_contents_translations_table', 1),
(110, '2019_07_29_142734_add_use_in_flat_column_in_attributes_table', 1),
(111, '2019_07_30_153530_create_cms_pages_table', 1),
(112, '2019_07_31_143339_create_category_filterable_attributes_table', 1),
(113, '2019_08_02_105320_create_product_grouped_products_table', 1),
(114, '2019_08_12_184925_add_additional_cloumn_in_wishlist_table', 1),
(115, '2019_08_20_170510_create_product_bundle_options_table', 1),
(116, '2019_08_20_170520_create_product_bundle_option_translations_table', 1),
(117, '2019_08_20_170528_create_product_bundle_option_products_table', 1),
(118, '2019_08_21_123707_add_seo_column_in_channels_table', 1),
(119, '2019_09_11_184511_create_refunds_table', 1),
(120, '2019_09_11_184519_create_refund_items_table', 1),
(121, '2019_09_26_163950_remove_channel_id_from_customers_table', 1),
(122, '2019_10_03_105451_change_rate_column_in_currency_exchange_rates_table', 1),
(123, '2019_10_21_105136_order_brands', 1),
(124, '2019_10_24_173358_change_postcode_column_type_in_order_address_table', 1),
(125, '2019_10_24_173437_change_postcode_column_type_in_cart_address_table', 1),
(126, '2019_10_24_173507_change_postcode_column_type_in_customer_addresses_table', 1),
(127, '2019_11_21_194541_add_column_url_path_to_category_translations', 1),
(128, '2019_11_21_194608_add_stored_function_to_get_url_path_of_category', 1),
(129, '2019_11_21_194627_add_trigger_to_category_translations', 1),
(130, '2019_11_21_194648_add_url_path_to_existing_category_translations', 1),
(131, '2019_11_21_194703_add_trigger_to_categories', 1),
(132, '2019_11_25_171136_add_applied_cart_rule_ids_column_in_cart_table', 1),
(133, '2019_11_25_171208_add_applied_cart_rule_ids_column_in_cart_items_table', 1),
(134, '2019_11_30_124437_add_applied_cart_rule_ids_column_in_orders_table', 1),
(135, '2019_11_30_165644_add_discount_columns_in_cart_shipping_rates_table', 1),
(136, '2019_12_03_175253_create_remove_catalog_rule_tables', 1),
(137, '2019_12_03_184613_create_catalog_rules_table', 1),
(138, '2019_12_03_184651_create_catalog_rule_channels_table', 1),
(139, '2019_12_03_184732_create_catalog_rule_customer_groups_table', 1),
(140, '2019_12_06_101110_create_catalog_rule_products_table', 1),
(141, '2019_12_06_110507_create_catalog_rule_product_prices_table', 1),
(142, '2019_12_30_155256_create_velocity_meta_data', 1),
(143, '2020_01_02_201029_add_api_token_columns', 1),
(144, '2020_01_06_173505_alter_trigger_category_translations', 1),
(145, '2020_01_06_173524_alter_stored_function_url_path_category', 1),
(146, '2020_01_06_195305_alter_trigger_on_categories', 1),
(147, '2020_01_09_154851_add_shipping_discount_columns_in_orders_table', 1),
(148, '2020_01_09_202815_add_inventory_source_name_column_in_shipments_table', 1),
(149, '2020_01_10_122226_update_velocity_meta_data', 1),
(150, '2020_01_10_151902_customer_address_improvements', 1),
(151, '2020_01_13_131431_alter_float_value_column_type_in_product_attribute_values_table', 1),
(152, '2020_01_13_155803_add_velocity_locale_icon', 1),
(153, '2020_01_13_192149_add_category_velocity_meta_data', 1),
(154, '2020_01_14_191854_create_cms_page_translations_table', 1),
(155, '2020_01_14_192206_remove_columns_from_cms_pages_table', 1),
(156, '2020_01_15_130209_create_cms_page_channels_table', 1),
(157, '2020_01_15_145637_add_product_policy', 1),
(158, '2020_01_15_152121_add_banner_link', 1),
(159, '2020_01_28_102422_add_new_column_and_rename_name_column_in_customer_addresses_table', 1),
(160, '2020_01_29_124748_alter_name_column_in_country_state_translations_table', 1),
(161, '2020_02_18_165639_create_bookings_table', 1),
(162, '2020_02_21_121201_create_booking_product_event_ticket_translations_table', 1),
(163, '2020_02_24_190025_add_is_comparable_column_in_attributes_table', 1),
(164, '2020_02_25_181902_propagate_company_name', 1),
(165, '2020_02_26_163908_change_column_type_in_cart_rules_table', 1),
(166, '2020_02_28_105104_fix_order_columns', 1),
(167, '2020_02_28_111958_create_customer_compare_products_table', 1),
(168, '2020_03_23_201431_alter_booking_products_table', 1),
(169, '2020_04_13_224524_add_locale_in_sliders_table', 1),
(170, '2020_04_16_130351_remove_channel_from_tax_category', 1),
(171, '2020_04_16_185147_add_table_addresses', 1);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(10) UNSIGNED NOT NULL,
  `increment_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `channel_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_guest` tinyint(1) DEFAULT NULL,
  `customer_email` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_first_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_last_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_company_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `customer_vat_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipping_method` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipping_title` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipping_description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `coupon_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_gift` tinyint(1) NOT NULL DEFAULT 0,
  `total_item_count` int(11) DEFAULT NULL,
  `total_qty_ordered` int(11) DEFAULT NULL,
  `base_currency_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `channel_currency_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_currency_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `grand_total` decimal(12,4) DEFAULT 0.0000,
  `base_grand_total` decimal(12,4) DEFAULT 0.0000,
  `grand_total_invoiced` decimal(12,4) DEFAULT 0.0000,
  `base_grand_total_invoiced` decimal(12,4) DEFAULT 0.0000,
  `grand_total_refunded` decimal(12,4) DEFAULT 0.0000,
  `base_grand_total_refunded` decimal(12,4) DEFAULT 0.0000,
  `sub_total` decimal(12,4) DEFAULT 0.0000,
  `base_sub_total` decimal(12,4) DEFAULT 0.0000,
  `sub_total_invoiced` decimal(12,4) DEFAULT 0.0000,
  `base_sub_total_invoiced` decimal(12,4) DEFAULT 0.0000,
  `sub_total_refunded` decimal(12,4) DEFAULT 0.0000,
  `base_sub_total_refunded` decimal(12,4) DEFAULT 0.0000,
  `discount_percent` decimal(12,4) DEFAULT 0.0000,
  `discount_amount` decimal(12,4) DEFAULT 0.0000,
  `base_discount_amount` decimal(12,4) DEFAULT 0.0000,
  `discount_invoiced` decimal(12,4) DEFAULT 0.0000,
  `base_discount_invoiced` decimal(12,4) DEFAULT 0.0000,
  `discount_refunded` decimal(12,4) DEFAULT 0.0000,
  `base_discount_refunded` decimal(12,4) DEFAULT 0.0000,
  `tax_amount` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount` decimal(12,4) DEFAULT 0.0000,
  `tax_amount_invoiced` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount_invoiced` decimal(12,4) DEFAULT 0.0000,
  `tax_amount_refunded` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount_refunded` decimal(12,4) DEFAULT 0.0000,
  `shipping_amount` decimal(12,4) DEFAULT 0.0000,
  `base_shipping_amount` decimal(12,4) DEFAULT 0.0000,
  `shipping_invoiced` decimal(12,4) DEFAULT 0.0000,
  `base_shipping_invoiced` decimal(12,4) DEFAULT 0.0000,
  `shipping_refunded` decimal(12,4) DEFAULT 0.0000,
  `base_shipping_refunded` decimal(12,4) DEFAULT 0.0000,
  `customer_id` int(10) UNSIGNED DEFAULT NULL,
  `customer_type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `channel_id` int(10) UNSIGNED DEFAULT NULL,
  `channel_type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `cart_id` int(11) DEFAULT NULL,
  `applied_cart_rule_ids` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shipping_discount_amount` decimal(12,4) DEFAULT 0.0000,
  `base_shipping_discount_amount` decimal(12,4) DEFAULT 0.0000
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `order_brands`
--

CREATE TABLE `order_brands` (
  `id` int(10) UNSIGNED NOT NULL,
  `order_id` int(10) UNSIGNED DEFAULT NULL,
  `order_item_id` int(10) UNSIGNED DEFAULT NULL,
  `product_id` int(10) UNSIGNED DEFAULT NULL,
  `brand` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `sku` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `coupon_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `weight` decimal(12,4) DEFAULT 0.0000,
  `total_weight` decimal(12,4) DEFAULT 0.0000,
  `qty_ordered` int(11) DEFAULT 0,
  `qty_shipped` int(11) DEFAULT 0,
  `qty_invoiced` int(11) DEFAULT 0,
  `qty_canceled` int(11) DEFAULT 0,
  `qty_refunded` int(11) DEFAULT 0,
  `price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `total` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_total` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `total_invoiced` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_total_invoiced` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `amount_refunded` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_amount_refunded` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `discount_percent` decimal(12,4) DEFAULT 0.0000,
  `discount_amount` decimal(12,4) DEFAULT 0.0000,
  `base_discount_amount` decimal(12,4) DEFAULT 0.0000,
  `discount_invoiced` decimal(12,4) DEFAULT 0.0000,
  `base_discount_invoiced` decimal(12,4) DEFAULT 0.0000,
  `discount_refunded` decimal(12,4) DEFAULT 0.0000,
  `base_discount_refunded` decimal(12,4) DEFAULT 0.0000,
  `tax_percent` decimal(12,4) DEFAULT 0.0000,
  `tax_amount` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount` decimal(12,4) DEFAULT 0.0000,
  `tax_amount_invoiced` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount_invoiced` decimal(12,4) DEFAULT 0.0000,
  `tax_amount_refunded` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount_refunded` decimal(12,4) DEFAULT 0.0000,
  `product_id` int(10) UNSIGNED DEFAULT NULL,
  `product_type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_id` int(10) UNSIGNED DEFAULT NULL,
  `parent_id` int(10) UNSIGNED DEFAULT NULL,
  `additional` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`additional`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `order_payment`
--

CREATE TABLE `order_payment` (
  `id` int(10) UNSIGNED NOT NULL,
  `method` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `method_title` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(10) UNSIGNED NOT NULL,
  `sku` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `parent_id` int(10) UNSIGNED DEFAULT NULL,
  `attribute_family_id` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_attribute_values`
--

CREATE TABLE `product_attribute_values` (
  `id` int(10) UNSIGNED NOT NULL,
  `locale` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `channel` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `text_value` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `boolean_value` tinyint(1) DEFAULT NULL,
  `integer_value` int(11) DEFAULT NULL,
  `float_value` decimal(12,4) DEFAULT NULL,
  `datetime_value` datetime DEFAULT NULL,
  `date_value` date DEFAULT NULL,
  `json_value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`json_value`)),
  `product_id` int(10) UNSIGNED NOT NULL,
  `attribute_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_bundle_options`
--

CREATE TABLE `product_bundle_options` (
  `id` int(10) UNSIGNED NOT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_required` tinyint(1) NOT NULL DEFAULT 1,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `product_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_bundle_option_products`
--

CREATE TABLE `product_bundle_option_products` (
  `id` int(10) UNSIGNED NOT NULL,
  `qty` int(11) NOT NULL DEFAULT 0,
  `is_user_defined` tinyint(1) NOT NULL DEFAULT 1,
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `product_bundle_option_id` int(10) UNSIGNED NOT NULL,
  `product_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_bundle_option_translations`
--

CREATE TABLE `product_bundle_option_translations` (
  `id` int(10) UNSIGNED NOT NULL,
  `locale` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `product_bundle_option_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_categories`
--

CREATE TABLE `product_categories` (
  `product_id` int(10) UNSIGNED NOT NULL,
  `category_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_cross_sells`
--

CREATE TABLE `product_cross_sells` (
  `parent_id` int(10) UNSIGNED NOT NULL,
  `child_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_downloadable_links`
--

CREATE TABLE `product_downloadable_links` (
  `id` int(10) UNSIGNED NOT NULL,
  `url` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `sample_url` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sample_file` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sample_file_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sample_type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `downloads` int(11) NOT NULL DEFAULT 0,
  `sort_order` int(11) DEFAULT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_downloadable_link_translations`
--

CREATE TABLE `product_downloadable_link_translations` (
  `id` int(10) UNSIGNED NOT NULL,
  `locale` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `product_downloadable_link_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_downloadable_samples`
--

CREATE TABLE `product_downloadable_samples` (
  `id` int(10) UNSIGNED NOT NULL,
  `url` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_downloadable_sample_translations`
--

CREATE TABLE `product_downloadable_sample_translations` (
  `id` int(10) UNSIGNED NOT NULL,
  `locale` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `product_downloadable_sample_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_flat`
--

CREATE TABLE `product_flat` (
  `id` int(10) UNSIGNED NOT NULL,
  `sku` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `url_key` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `new` tinyint(1) DEFAULT NULL,
  `featured` tinyint(1) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `thumbnail` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` decimal(12,4) DEFAULT NULL,
  `cost` decimal(12,4) DEFAULT NULL,
  `special_price` decimal(12,4) DEFAULT NULL,
  `special_price_from` date DEFAULT NULL,
  `special_price_to` date DEFAULT NULL,
  `weight` decimal(12,4) DEFAULT NULL,
  `color` int(11) DEFAULT NULL,
  `color_label` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `size_label` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `locale` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `channel` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `parent_id` int(10) UNSIGNED DEFAULT NULL,
  `visible_individually` tinyint(1) DEFAULT NULL,
  `min_price` decimal(12,4) DEFAULT NULL,
  `max_price` decimal(12,4) DEFAULT NULL,
  `short_description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_title` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_keywords` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `width` decimal(12,4) DEFAULT NULL,
  `height` decimal(12,4) DEFAULT NULL,
  `depth` decimal(12,4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_grouped_products`
--

CREATE TABLE `product_grouped_products` (
  `id` int(10) UNSIGNED NOT NULL,
  `qty` int(11) NOT NULL DEFAULT 0,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `product_id` int(10) UNSIGNED NOT NULL,
  `associated_product_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_images`
--

CREATE TABLE `product_images` (
  `id` int(10) UNSIGNED NOT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `path` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `product_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_inventories`
--

CREATE TABLE `product_inventories` (
  `id` int(10) UNSIGNED NOT NULL,
  `qty` int(11) NOT NULL DEFAULT 0,
  `product_id` int(10) UNSIGNED NOT NULL,
  `inventory_source_id` int(10) UNSIGNED NOT NULL,
  `vendor_id` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_ordered_inventories`
--

CREATE TABLE `product_ordered_inventories` (
  `id` int(10) UNSIGNED NOT NULL,
  `qty` int(11) NOT NULL DEFAULT 0,
  `product_id` int(10) UNSIGNED NOT NULL,
  `channel_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_relations`
--

CREATE TABLE `product_relations` (
  `parent_id` int(10) UNSIGNED NOT NULL,
  `child_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_reviews`
--

CREATE TABLE `product_reviews` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rating` int(11) NOT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_super_attributes`
--

CREATE TABLE `product_super_attributes` (
  `product_id` int(10) UNSIGNED NOT NULL,
  `attribute_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `product_up_sells`
--

CREATE TABLE `product_up_sells` (
  `parent_id` int(10) UNSIGNED NOT NULL,
  `child_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `refunds`
--

CREATE TABLE `refunds` (
  `id` int(10) UNSIGNED NOT NULL,
  `increment_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_sent` tinyint(1) NOT NULL DEFAULT 0,
  `total_qty` int(11) DEFAULT NULL,
  `base_currency_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `channel_currency_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_currency_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `adjustment_refund` decimal(12,4) DEFAULT 0.0000,
  `base_adjustment_refund` decimal(12,4) DEFAULT 0.0000,
  `adjustment_fee` decimal(12,4) DEFAULT 0.0000,
  `base_adjustment_fee` decimal(12,4) DEFAULT 0.0000,
  `sub_total` decimal(12,4) DEFAULT 0.0000,
  `base_sub_total` decimal(12,4) DEFAULT 0.0000,
  `grand_total` decimal(12,4) DEFAULT 0.0000,
  `base_grand_total` decimal(12,4) DEFAULT 0.0000,
  `shipping_amount` decimal(12,4) DEFAULT 0.0000,
  `base_shipping_amount` decimal(12,4) DEFAULT 0.0000,
  `tax_amount` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount` decimal(12,4) DEFAULT 0.0000,
  `discount_percent` decimal(12,4) DEFAULT 0.0000,
  `discount_amount` decimal(12,4) DEFAULT 0.0000,
  `base_discount_amount` decimal(12,4) DEFAULT 0.0000,
  `order_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `refund_items`
--

CREATE TABLE `refund_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sku` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_price` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `total` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `base_total` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `tax_amount` decimal(12,4) DEFAULT 0.0000,
  `base_tax_amount` decimal(12,4) DEFAULT 0.0000,
  `discount_percent` decimal(12,4) DEFAULT 0.0000,
  `discount_amount` decimal(12,4) DEFAULT 0.0000,
  `base_discount_amount` decimal(12,4) DEFAULT 0.0000,
  `product_id` int(10) UNSIGNED DEFAULT NULL,
  `product_type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_item_id` int(10) UNSIGNED DEFAULT NULL,
  `refund_id` int(10) UNSIGNED DEFAULT NULL,
  `parent_id` int(10) UNSIGNED DEFAULT NULL,
  `additional` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`additional`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `permission_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `permissions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`permissions`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `description`, `permission_type`, `permissions`, `created_at`, `updated_at`) VALUES
(1, 'Administrator', 'Administrator rolem', 'all', NULL, NULL, NULL),
(2, 'Shop keeper ', 'Can edit catalog', 'custom', '[\"catalog\",\"catalog.products\",\"catalog.products.create\",\"catalog.products.edit\",\"catalog.products.delete\",\"catalog.categories\",\"catalog.categories.create\",\"catalog.categories.edit\",\"catalog.categories.delete\",\"catalog.attributes\",\"catalog.attributes.create\",\"catalog.attributes.edit\",\"catalog.attributes.delete\",\"catalog.families\",\"catalog.families.create\",\"catalog.families.edit\",\"catalog.families.delete\"]', '2020-07-20 09:31:21', '2020-07-20 09:31:21');

-- --------------------------------------------------------

--
-- Table structure for table `shipments`
--

CREATE TABLE `shipments` (
  `id` int(10) UNSIGNED NOT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_qty` int(11) DEFAULT NULL,
  `total_weight` int(11) DEFAULT NULL,
  `carrier_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `carrier_title` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `track_number` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_sent` tinyint(1) NOT NULL DEFAULT 0,
  `customer_id` int(10) UNSIGNED DEFAULT NULL,
  `customer_type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_id` int(10) UNSIGNED NOT NULL,
  `order_address_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `inventory_source_id` int(10) UNSIGNED DEFAULT NULL,
  `inventory_source_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `shipment_items`
--

CREATE TABLE `shipment_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sku` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `weight` int(11) DEFAULT NULL,
  `price` decimal(12,4) DEFAULT 0.0000,
  `base_price` decimal(12,4) DEFAULT 0.0000,
  `total` decimal(12,4) DEFAULT 0.0000,
  `base_total` decimal(12,4) DEFAULT 0.0000,
  `product_id` int(10) UNSIGNED DEFAULT NULL,
  `product_type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_item_id` int(10) UNSIGNED DEFAULT NULL,
  `shipment_id` int(10) UNSIGNED NOT NULL,
  `additional` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`additional`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `sliders`
--

CREATE TABLE `sliders` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `path` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `channel_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `slider_path` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `locale` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `subscribers_list`
--

CREATE TABLE `subscribers_list` (
  `id` int(10) UNSIGNED NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_subscribed` tinyint(1) NOT NULL DEFAULT 0,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `channel_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `tax_categories`
--

CREATE TABLE `tax_categories` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `tax_categories_tax_rates`
--

CREATE TABLE `tax_categories_tax_rates` (
  `id` int(10) UNSIGNED NOT NULL,
  `tax_category_id` int(10) UNSIGNED NOT NULL,
  `tax_rate_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `tax_rates`
--

CREATE TABLE `tax_rates` (
  `id` int(10) UNSIGNED NOT NULL,
  `identifier` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_zip` tinyint(1) NOT NULL DEFAULT 0,
  `zip_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zip_from` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zip_to` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tax_rate` decimal(12,4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `velocity_contents`
--

CREATE TABLE `velocity_contents` (
  `id` int(10) UNSIGNED NOT NULL,
  `content_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `position` int(10) UNSIGNED DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `velocity_contents_translations`
--

CREATE TABLE `velocity_contents_translations` (
  `id` int(10) UNSIGNED NOT NULL,
  `content_id` int(10) UNSIGNED DEFAULT NULL,
  `title` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `custom_title` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `custom_heading` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `page_link` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `link_target` tinyint(1) NOT NULL DEFAULT 0,
  `catalog_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `products` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `locale` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `velocity_customer_compare_products`
--

CREATE TABLE `velocity_customer_compare_products` (
  `id` int(10) UNSIGNED NOT NULL,
  `product_flat_id` int(10) UNSIGNED NOT NULL,
  `customer_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `velocity_meta_data`
--

CREATE TABLE `velocity_meta_data` (
  `id` int(10) UNSIGNED NOT NULL,
  `home_page_content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `footer_left_content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `footer_middle_content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `slider` tinyint(1) NOT NULL DEFAULT 0,
  `advertisement` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`advertisement`)),
  `sidebar_category_count` int(11) NOT NULL DEFAULT 9,
  `featured_product_count` int(11) NOT NULL DEFAULT 10,
  `new_products_count` int(11) NOT NULL DEFAULT 10,
  `subscription_bar_content` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `product_view_images` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`product_view_images`)),
  `product_policy` text COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `velocity_meta_data`
--

INSERT INTO `velocity_meta_data` (`id`, `home_page_content`, `footer_left_content`, `footer_middle_content`, `slider`, `advertisement`, `sidebar_category_count`, `featured_product_count`, `new_products_count`, `subscription_bar_content`, `created_at`, `updated_at`, `product_view_images`, `product_policy`) VALUES
(1, '<p>@include(\'shop::home.advertisements.advertisement-four\')@include(\'shop::home.featured-products\') @include(\'shop::home.product-policy\') @include(\'shop::home.advertisements.advertisement-three\') @include(\'shop::home.new-products\') @include(\'shop::home.advertisements.advertisement-two\')</p>', '<p>We love to craft softwares and solve the real world problems with the binaries. We are highly committed to our goals. We invest our resources to create world class easy to use softwares and applications for the enterprise business with the top notch, on the edge technology expertise.</p>', '<div class=\"col-lg-6 col-md-12 col-sm-12 no-padding\"><ul type=\"none\"><li><a href=\"https://webkul.com/about-us/company-profile/\">About Us</a></li><li><a href=\"https://webkul.com/about-us/company-profile/\">Customer Service</a></li><li><a href=\"https://webkul.com/about-us/company-profile/\">What&rsquo;s New</a></li><li><a href=\"https://webkul.com/about-us/company-profile/\">Contact Us </a></li></ul></div><div class=\"col-lg-6 col-md-12 col-sm-12 no-padding\"><ul type=\"none\"><li><a href=\"https://webkul.com/about-us/company-profile/\"> Order and Returns </a></li><li><a href=\"https://webkul.com/about-us/company-profile/\"> Payment Policy </a></li><li><a href=\"https://webkul.com/about-us/company-profile/\"> Shipping Policy</a></li><li><a href=\"https://webkul.com/about-us/company-profile/\"> Privacy and Cookies Policy </a></li></ul></div>', 1, NULL, 9, 10, 10, '<div class=\"social-icons col-lg-6\"><a href=\"https://webkul.com\" target=\"_blank\" class=\"unset\" rel=\"noopener noreferrer\"><i class=\"fs24 within-circle rango-facebook\" title=\"facebook\"></i> </a> <a href=\"https://webkul.com\" target=\"_blank\" class=\"unset\" rel=\"noopener noreferrer\"><i class=\"fs24 within-circle rango-twitter\" title=\"twitter\"></i> </a> <a href=\"https://webkul.com\" target=\"_blank\" class=\"unset\" rel=\"noopener noreferrer\"><i class=\"fs24 within-circle rango-linked-in\" title=\"linkedin\"></i> </a> <a href=\"https://webkul.com\" target=\"_blank\" class=\"unset\" rel=\"noopener noreferrer\"><i class=\"fs24 within-circle rango-pintrest\" title=\"Pinterest\"></i> </a> <a href=\"https://webkul.com\" target=\"_blank\" class=\"unset\" rel=\"noopener noreferrer\"><i class=\"fs24 within-circle rango-youtube\" title=\"Youtube\"></i> </a> <a href=\"https://webkul.com\" target=\"_blank\" class=\"unset\" rel=\"noopener noreferrer\"><i class=\"fs24 within-circle rango-instagram\" title=\"instagram\"></i></a></div>', NULL, NULL, NULL, '<div class=\"row col-12 remove-padding-margin\"><div class=\"col-lg-4 col-sm-12 product-policy-wrapper\"><div class=\"card\"><div class=\"policy\"><div class=\"left\"><i class=\"rango-van-ship fs40\"></i></div> <div class=\"right\"><span class=\"font-setting fs20\">Free Shipping on Order $20 or More</span></div></div></div></div> <div class=\"col-lg-4 col-sm-12 product-policy-wrapper\"><div class=\"card\"><div class=\"policy\"><div class=\"left\"><i class=\"rango-exchnage fs40\"></i></div> <div class=\"right\"><span class=\"font-setting fs20\">Product Replace &amp; Return Available </span></div></div></div></div> <div class=\"col-lg-4 col-sm-12 product-policy-wrapper\"><div class=\"card\"><div class=\"policy\"><div class=\"left\"><i class=\"rango-exchnage fs40\"></i></div> <div class=\"right\"><span class=\"font-setting fs20\">Product Exchange and EMI Available </span></div></div></div></div></div>');

-- --------------------------------------------------------

--
-- Table structure for table `wishlist`
--

CREATE TABLE `wishlist` (
  `id` int(10) UNSIGNED NOT NULL,
  `channel_id` int(10) UNSIGNED NOT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `customer_id` int(10) UNSIGNED NOT NULL,
  `item_options` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`item_options`)),
  `moved_to_cart` date DEFAULT NULL,
  `shared` tinyint(1) DEFAULT NULL,
  `time_of_moving` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `additional` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`additional`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `addresses`
--
ALTER TABLE `addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `addresses_customer_id_foreign` (`customer_id`),
  ADD KEY `addresses_cart_id_foreign` (`cart_id`),
  ADD KEY `addresses_order_id_foreign` (`order_id`);

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `admins_email_unique` (`email`),
  ADD UNIQUE KEY `admins_api_token_unique` (`api_token`);

--
-- Indexes for table `admin_password_resets`
--
ALTER TABLE `admin_password_resets`
  ADD KEY `admin_password_resets_email_index` (`email`);

--
-- Indexes for table `attributes`
--
ALTER TABLE `attributes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `attributes_code_unique` (`code`);

--
-- Indexes for table `attribute_families`
--
ALTER TABLE `attribute_families`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `attribute_groups`
--
ALTER TABLE `attribute_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `attribute_groups_attribute_family_id_name_unique` (`attribute_family_id`,`name`);

--
-- Indexes for table `attribute_group_mappings`
--
ALTER TABLE `attribute_group_mappings`
  ADD PRIMARY KEY (`attribute_id`,`attribute_group_id`),
  ADD KEY `attribute_group_mappings_attribute_group_id_foreign` (`attribute_group_id`);

--
-- Indexes for table `attribute_options`
--
ALTER TABLE `attribute_options`
  ADD PRIMARY KEY (`id`),
  ADD KEY `attribute_options_attribute_id_foreign` (`attribute_id`);

--
-- Indexes for table `attribute_option_translations`
--
ALTER TABLE `attribute_option_translations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `attribute_option_translations_attribute_option_id_locale_unique` (`attribute_option_id`,`locale`);

--
-- Indexes for table `attribute_translations`
--
ALTER TABLE `attribute_translations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `attribute_translations_attribute_id_locale_unique` (`attribute_id`,`locale`);

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bookings_order_id_foreign` (`order_id`),
  ADD KEY `bookings_product_id_foreign` (`product_id`);

--
-- Indexes for table `booking_products`
--
ALTER TABLE `booking_products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `booking_products_product_id_foreign` (`product_id`);

--
-- Indexes for table `booking_product_appointment_slots`
--
ALTER TABLE `booking_product_appointment_slots`
  ADD PRIMARY KEY (`id`),
  ADD KEY `booking_product_appointment_slots_booking_product_id_foreign` (`booking_product_id`);

--
-- Indexes for table `booking_product_default_slots`
--
ALTER TABLE `booking_product_default_slots`
  ADD PRIMARY KEY (`id`),
  ADD KEY `booking_product_default_slots_booking_product_id_foreign` (`booking_product_id`);

--
-- Indexes for table `booking_product_event_tickets`
--
ALTER TABLE `booking_product_event_tickets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `booking_product_event_tickets_booking_product_id_foreign` (`booking_product_id`);

--
-- Indexes for table `booking_product_event_ticket_translations`
--
ALTER TABLE `booking_product_event_ticket_translations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `booking_product_event_ticket_translations_locale_unique` (`booking_product_event_ticket_id`,`locale`);

--
-- Indexes for table `booking_product_rental_slots`
--
ALTER TABLE `booking_product_rental_slots`
  ADD PRIMARY KEY (`id`),
  ADD KEY `booking_product_rental_slots_booking_product_id_foreign` (`booking_product_id`);

--
-- Indexes for table `booking_product_table_slots`
--
ALTER TABLE `booking_product_table_slots`
  ADD PRIMARY KEY (`id`),
  ADD KEY `booking_product_table_slots_booking_product_id_foreign` (`booking_product_id`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart_customer_id_foreign` (`customer_id`),
  ADD KEY `cart_channel_id_foreign` (`channel_id`);

--
-- Indexes for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart_items_product_id_foreign` (`product_id`),
  ADD KEY `cart_items_cart_id_foreign` (`cart_id`),
  ADD KEY `cart_items_tax_category_id_foreign` (`tax_category_id`),
  ADD KEY `cart_items_parent_id_foreign` (`parent_id`);

--
-- Indexes for table `cart_item_inventories`
--
ALTER TABLE `cart_item_inventories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cart_payment`
--
ALTER TABLE `cart_payment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart_payment_cart_id_foreign` (`cart_id`);

--
-- Indexes for table `cart_rules`
--
ALTER TABLE `cart_rules`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cart_rule_channels`
--
ALTER TABLE `cart_rule_channels`
  ADD PRIMARY KEY (`cart_rule_id`,`channel_id`),
  ADD KEY `cart_rule_channels_channel_id_foreign` (`channel_id`);

--
-- Indexes for table `cart_rule_coupons`
--
ALTER TABLE `cart_rule_coupons`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart_rule_coupons_cart_rule_id_foreign` (`cart_rule_id`);

--
-- Indexes for table `cart_rule_coupon_usage`
--
ALTER TABLE `cart_rule_coupon_usage`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart_rule_coupon_usage_cart_rule_coupon_id_foreign` (`cart_rule_coupon_id`),
  ADD KEY `cart_rule_coupon_usage_customer_id_foreign` (`customer_id`);

--
-- Indexes for table `cart_rule_customers`
--
ALTER TABLE `cart_rule_customers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart_rule_customers_cart_rule_id_foreign` (`cart_rule_id`),
  ADD KEY `cart_rule_customers_customer_id_foreign` (`customer_id`);

--
-- Indexes for table `cart_rule_customer_groups`
--
ALTER TABLE `cart_rule_customer_groups`
  ADD PRIMARY KEY (`cart_rule_id`,`customer_group_id`),
  ADD KEY `cart_rule_customer_groups_customer_group_id_foreign` (`customer_group_id`);

--
-- Indexes for table `cart_rule_translations`
--
ALTER TABLE `cart_rule_translations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cart_rule_translations_cart_rule_id_locale_unique` (`cart_rule_id`,`locale`);

--
-- Indexes for table `cart_shipping_rates`
--
ALTER TABLE `cart_shipping_rates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cart_shipping_rates_cart_address_id_foreign` (`cart_address_id`);

--
-- Indexes for table `catalog_rules`
--
ALTER TABLE `catalog_rules`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `catalog_rule_channels`
--
ALTER TABLE `catalog_rule_channels`
  ADD PRIMARY KEY (`catalog_rule_id`,`channel_id`),
  ADD KEY `catalog_rule_channels_channel_id_foreign` (`channel_id`);

--
-- Indexes for table `catalog_rule_customer_groups`
--
ALTER TABLE `catalog_rule_customer_groups`
  ADD PRIMARY KEY (`catalog_rule_id`,`customer_group_id`),
  ADD KEY `catalog_rule_customer_groups_customer_group_id_foreign` (`customer_group_id`);

--
-- Indexes for table `catalog_rule_products`
--
ALTER TABLE `catalog_rule_products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `catalog_rule_products_product_id_foreign` (`product_id`),
  ADD KEY `catalog_rule_products_customer_group_id_foreign` (`customer_group_id`),
  ADD KEY `catalog_rule_products_catalog_rule_id_foreign` (`catalog_rule_id`),
  ADD KEY `catalog_rule_products_channel_id_foreign` (`channel_id`);

--
-- Indexes for table `catalog_rule_product_prices`
--
ALTER TABLE `catalog_rule_product_prices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `catalog_rule_product_prices_product_id_foreign` (`product_id`),
  ADD KEY `catalog_rule_product_prices_customer_group_id_foreign` (`customer_group_id`),
  ADD KEY `catalog_rule_product_prices_catalog_rule_id_foreign` (`catalog_rule_id`),
  ADD KEY `catalog_rule_product_prices_channel_id_foreign` (`channel_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categories__lft__rgt_parent_id_index` (`_lft`,`_rgt`,`parent_id`);

--
-- Indexes for table `category_filterable_attributes`
--
ALTER TABLE `category_filterable_attributes`
  ADD KEY `category_filterable_attributes_category_id_foreign` (`category_id`),
  ADD KEY `category_filterable_attributes_attribute_id_foreign` (`attribute_id`);

--
-- Indexes for table `category_translations`
--
ALTER TABLE `category_translations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `category_translations_category_id_slug_locale_unique` (`category_id`,`slug`,`locale`),
  ADD KEY `category_translations_locale_id_foreign` (`locale_id`);

--
-- Indexes for table `channels`
--
ALTER TABLE `channels`
  ADD PRIMARY KEY (`id`),
  ADD KEY `channels_default_locale_id_foreign` (`default_locale_id`),
  ADD KEY `channels_base_currency_id_foreign` (`base_currency_id`),
  ADD KEY `channels_root_category_id_foreign` (`root_category_id`);

--
-- Indexes for table `channel_currencies`
--
ALTER TABLE `channel_currencies`
  ADD PRIMARY KEY (`channel_id`,`currency_id`),
  ADD KEY `channel_currencies_currency_id_foreign` (`currency_id`);

--
-- Indexes for table `channel_inventory_sources`
--
ALTER TABLE `channel_inventory_sources`
  ADD UNIQUE KEY `channel_inventory_sources_channel_id_inventory_source_id_unique` (`channel_id`,`inventory_source_id`),
  ADD KEY `channel_inventory_sources_inventory_source_id_foreign` (`inventory_source_id`);

--
-- Indexes for table `channel_locales`
--
ALTER TABLE `channel_locales`
  ADD PRIMARY KEY (`channel_id`,`locale_id`),
  ADD KEY `channel_locales_locale_id_foreign` (`locale_id`);

--
-- Indexes for table `cms_pages`
--
ALTER TABLE `cms_pages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cms_page_channels`
--
ALTER TABLE `cms_page_channels`
  ADD UNIQUE KEY `cms_page_channels_cms_page_id_channel_id_unique` (`cms_page_id`,`channel_id`),
  ADD KEY `cms_page_channels_channel_id_foreign` (`channel_id`);

--
-- Indexes for table `cms_page_translations`
--
ALTER TABLE `cms_page_translations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cms_page_translations_cms_page_id_url_key_locale_unique` (`cms_page_id`,`url_key`,`locale`);

--
-- Indexes for table `core_config`
--
ALTER TABLE `core_config`
  ADD PRIMARY KEY (`id`),
  ADD KEY `core_config_channel_id_foreign` (`channel_code`);

--
-- Indexes for table `countries`
--
ALTER TABLE `countries`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `country_states`
--
ALTER TABLE `country_states`
  ADD PRIMARY KEY (`id`),
  ADD KEY `country_states_country_id_foreign` (`country_id`);

--
-- Indexes for table `country_state_translations`
--
ALTER TABLE `country_state_translations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `country_state_translations_country_state_id_foreign` (`country_state_id`);

--
-- Indexes for table `country_translations`
--
ALTER TABLE `country_translations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `country_translations_country_id_foreign` (`country_id`);

--
-- Indexes for table `currencies`
--
ALTER TABLE `currencies`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `currency_exchange_rates`
--
ALTER TABLE `currency_exchange_rates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `currency_exchange_rates_target_currency_unique` (`target_currency`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `customers_email_unique` (`email`),
  ADD UNIQUE KEY `customers_api_token_unique` (`api_token`),
  ADD KEY `customers_customer_group_id_foreign` (`customer_group_id`);

--
-- Indexes for table `customer_groups`
--
ALTER TABLE `customer_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `customer_groups_code_unique` (`code`);

--
-- Indexes for table `customer_password_resets`
--
ALTER TABLE `customer_password_resets`
  ADD KEY `customer_password_resets_email_index` (`email`);

--
-- Indexes for table `downloadable_link_purchased`
--
ALTER TABLE `downloadable_link_purchased`
  ADD PRIMARY KEY (`id`),
  ADD KEY `downloadable_link_purchased_customer_id_foreign` (`customer_id`),
  ADD KEY `downloadable_link_purchased_order_id_foreign` (`order_id`),
  ADD KEY `downloadable_link_purchased_order_item_id_foreign` (`order_item_id`);

--
-- Indexes for table `inventory_sources`
--
ALTER TABLE `inventory_sources`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `inventory_sources_code_unique` (`code`);

--
-- Indexes for table `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `invoices_order_id_foreign` (`order_id`),
  ADD KEY `invoices_order_address_id_foreign` (`order_address_id`);

--
-- Indexes for table `invoice_items`
--
ALTER TABLE `invoice_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `invoice_items_invoice_id_foreign` (`invoice_id`),
  ADD KEY `invoice_items_parent_id_foreign` (`parent_id`);

--
-- Indexes for table `locales`
--
ALTER TABLE `locales`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `locales_code_unique` (`code`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `orders_customer_id_foreign` (`customer_id`),
  ADD KEY `orders_channel_id_foreign` (`channel_id`);

--
-- Indexes for table `order_brands`
--
ALTER TABLE `order_brands`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_brands_order_id_foreign` (`order_id`),
  ADD KEY `order_brands_order_item_id_foreign` (`order_item_id`),
  ADD KEY `order_brands_product_id_foreign` (`product_id`),
  ADD KEY `order_brands_brand_foreign` (`brand`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_items_order_id_foreign` (`order_id`),
  ADD KEY `order_items_parent_id_foreign` (`parent_id`);

--
-- Indexes for table `order_payment`
--
ALTER TABLE `order_payment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_payment_order_id_foreign` (`order_id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `products_sku_unique` (`sku`),
  ADD KEY `products_attribute_family_id_foreign` (`attribute_family_id`),
  ADD KEY `products_parent_id_foreign` (`parent_id`);

--
-- Indexes for table `product_attribute_values`
--
ALTER TABLE `product_attribute_values`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `chanel_locale_attribute_value_index_unique` (`channel`,`locale`,`attribute_id`,`product_id`),
  ADD KEY `product_attribute_values_product_id_foreign` (`product_id`),
  ADD KEY `product_attribute_values_attribute_id_foreign` (`attribute_id`);

--
-- Indexes for table `product_bundle_options`
--
ALTER TABLE `product_bundle_options`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_bundle_options_product_id_foreign` (`product_id`);

--
-- Indexes for table `product_bundle_option_products`
--
ALTER TABLE `product_bundle_option_products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_bundle_option_products_product_bundle_option_id_foreign` (`product_bundle_option_id`),
  ADD KEY `product_bundle_option_products_product_id_foreign` (`product_id`);

--
-- Indexes for table `product_bundle_option_translations`
--
ALTER TABLE `product_bundle_option_translations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `product_bundle_option_translations_option_id_locale_unique` (`product_bundle_option_id`,`locale`);

--
-- Indexes for table `product_categories`
--
ALTER TABLE `product_categories`
  ADD KEY `product_categories_product_id_foreign` (`product_id`),
  ADD KEY `product_categories_category_id_foreign` (`category_id`);

--
-- Indexes for table `product_cross_sells`
--
ALTER TABLE `product_cross_sells`
  ADD KEY `product_cross_sells_parent_id_foreign` (`parent_id`),
  ADD KEY `product_cross_sells_child_id_foreign` (`child_id`);

--
-- Indexes for table `product_downloadable_links`
--
ALTER TABLE `product_downloadable_links`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_downloadable_links_product_id_foreign` (`product_id`);

--
-- Indexes for table `product_downloadable_link_translations`
--
ALTER TABLE `product_downloadable_link_translations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `link_translations_link_id_foreign` (`product_downloadable_link_id`);

--
-- Indexes for table `product_downloadable_samples`
--
ALTER TABLE `product_downloadable_samples`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_downloadable_samples_product_id_foreign` (`product_id`);

--
-- Indexes for table `product_downloadable_sample_translations`
--
ALTER TABLE `product_downloadable_sample_translations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sample_translations_sample_id_foreign` (`product_downloadable_sample_id`);

--
-- Indexes for table `product_flat`
--
ALTER TABLE `product_flat`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `product_flat_unique_index` (`product_id`,`channel`,`locale`),
  ADD KEY `product_flat_parent_id_foreign` (`parent_id`);

--
-- Indexes for table `product_grouped_products`
--
ALTER TABLE `product_grouped_products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_grouped_products_product_id_foreign` (`product_id`),
  ADD KEY `product_grouped_products_associated_product_id_foreign` (`associated_product_id`);

--
-- Indexes for table `product_images`
--
ALTER TABLE `product_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_images_product_id_foreign` (`product_id`);

--
-- Indexes for table `product_inventories`
--
ALTER TABLE `product_inventories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `product_source_vendor_index_unique` (`product_id`,`inventory_source_id`,`vendor_id`),
  ADD KEY `product_inventories_inventory_source_id_foreign` (`inventory_source_id`);

--
-- Indexes for table `product_ordered_inventories`
--
ALTER TABLE `product_ordered_inventories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `product_ordered_inventories_product_id_channel_id_unique` (`product_id`,`channel_id`),
  ADD KEY `product_ordered_inventories_channel_id_foreign` (`channel_id`);

--
-- Indexes for table `product_relations`
--
ALTER TABLE `product_relations`
  ADD KEY `product_relations_parent_id_foreign` (`parent_id`),
  ADD KEY `product_relations_child_id_foreign` (`child_id`);

--
-- Indexes for table `product_reviews`
--
ALTER TABLE `product_reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_reviews_product_id_foreign` (`product_id`),
  ADD KEY `product_reviews_customer_id_foreign` (`customer_id`);

--
-- Indexes for table `product_super_attributes`
--
ALTER TABLE `product_super_attributes`
  ADD KEY `product_super_attributes_product_id_foreign` (`product_id`),
  ADD KEY `product_super_attributes_attribute_id_foreign` (`attribute_id`);

--
-- Indexes for table `product_up_sells`
--
ALTER TABLE `product_up_sells`
  ADD KEY `product_up_sells_parent_id_foreign` (`parent_id`),
  ADD KEY `product_up_sells_child_id_foreign` (`child_id`);

--
-- Indexes for table `refunds`
--
ALTER TABLE `refunds`
  ADD PRIMARY KEY (`id`),
  ADD KEY `refunds_order_id_foreign` (`order_id`);

--
-- Indexes for table `refund_items`
--
ALTER TABLE `refund_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `refund_items_order_item_id_foreign` (`order_item_id`),
  ADD KEY `refund_items_refund_id_foreign` (`refund_id`),
  ADD KEY `refund_items_parent_id_foreign` (`parent_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `shipments`
--
ALTER TABLE `shipments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `shipments_order_id_foreign` (`order_id`),
  ADD KEY `shipments_inventory_source_id_foreign` (`inventory_source_id`),
  ADD KEY `shipments_order_address_id_foreign` (`order_address_id`);

--
-- Indexes for table `shipment_items`
--
ALTER TABLE `shipment_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `shipment_items_shipment_id_foreign` (`shipment_id`);

--
-- Indexes for table `sliders`
--
ALTER TABLE `sliders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sliders_channel_id_foreign` (`channel_id`);

--
-- Indexes for table `subscribers_list`
--
ALTER TABLE `subscribers_list`
  ADD PRIMARY KEY (`id`),
  ADD KEY `subscribers_list_channel_id_foreign` (`channel_id`);

--
-- Indexes for table `tax_categories`
--
ALTER TABLE `tax_categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tax_categories_code_unique` (`code`),
  ADD UNIQUE KEY `tax_categories_name_unique` (`name`);

--
-- Indexes for table `tax_categories_tax_rates`
--
ALTER TABLE `tax_categories_tax_rates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tax_map_index_unique` (`tax_category_id`,`tax_rate_id`),
  ADD KEY `tax_categories_tax_rates_tax_rate_id_foreign` (`tax_rate_id`);

--
-- Indexes for table `tax_rates`
--
ALTER TABLE `tax_rates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tax_rates_identifier_unique` (`identifier`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- Indexes for table `velocity_contents`
--
ALTER TABLE `velocity_contents`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `velocity_contents_translations`
--
ALTER TABLE `velocity_contents_translations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `velocity_contents_translations_content_id_foreign` (`content_id`);

--
-- Indexes for table `velocity_customer_compare_products`
--
ALTER TABLE `velocity_customer_compare_products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `velocity_customer_compare_products_product_flat_id_foreign` (`product_flat_id`),
  ADD KEY `velocity_customer_compare_products_customer_id_foreign` (`customer_id`);

--
-- Indexes for table `velocity_meta_data`
--
ALTER TABLE `velocity_meta_data`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `wishlist`
--
ALTER TABLE `wishlist`
  ADD PRIMARY KEY (`id`),
  ADD KEY `wishlist_channel_id_foreign` (`channel_id`),
  ADD KEY `wishlist_product_id_foreign` (`product_id`),
  ADD KEY `wishlist_customer_id_foreign` (`customer_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `addresses`
--
ALTER TABLE `addresses`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `attributes`
--
ALTER TABLE `attributes`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `attribute_families`
--
ALTER TABLE `attribute_families`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `attribute_groups`
--
ALTER TABLE `attribute_groups`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `attribute_options`
--
ALTER TABLE `attribute_options`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `attribute_option_translations`
--
ALTER TABLE `attribute_option_translations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `attribute_translations`
--
ALTER TABLE `attribute_translations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `booking_products`
--
ALTER TABLE `booking_products`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `booking_product_appointment_slots`
--
ALTER TABLE `booking_product_appointment_slots`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `booking_product_default_slots`
--
ALTER TABLE `booking_product_default_slots`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `booking_product_event_tickets`
--
ALTER TABLE `booking_product_event_tickets`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `booking_product_event_ticket_translations`
--
ALTER TABLE `booking_product_event_ticket_translations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `booking_product_rental_slots`
--
ALTER TABLE `booking_product_rental_slots`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `booking_product_table_slots`
--
ALTER TABLE `booking_product_table_slots`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cart_items`
--
ALTER TABLE `cart_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cart_item_inventories`
--
ALTER TABLE `cart_item_inventories`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cart_payment`
--
ALTER TABLE `cart_payment`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cart_rules`
--
ALTER TABLE `cart_rules`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cart_rule_coupons`
--
ALTER TABLE `cart_rule_coupons`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cart_rule_coupon_usage`
--
ALTER TABLE `cart_rule_coupon_usage`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cart_rule_customers`
--
ALTER TABLE `cart_rule_customers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cart_rule_translations`
--
ALTER TABLE `cart_rule_translations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cart_shipping_rates`
--
ALTER TABLE `cart_shipping_rates`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `catalog_rules`
--
ALTER TABLE `catalog_rules`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `catalog_rule_products`
--
ALTER TABLE `catalog_rule_products`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `catalog_rule_product_prices`
--
ALTER TABLE `catalog_rule_product_prices`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `category_translations`
--
ALTER TABLE `category_translations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `channels`
--
ALTER TABLE `channels`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `cms_pages`
--
ALTER TABLE `cms_pages`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `cms_page_translations`
--
ALTER TABLE `cms_page_translations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `core_config`
--
ALTER TABLE `core_config`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `countries`
--
ALTER TABLE `countries`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=256;

--
-- AUTO_INCREMENT for table `country_states`
--
ALTER TABLE `country_states`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=569;

--
-- AUTO_INCREMENT for table `country_state_translations`
--
ALTER TABLE `country_state_translations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5113;

--
-- AUTO_INCREMENT for table `country_translations`
--
ALTER TABLE `country_translations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2296;

--
-- AUTO_INCREMENT for table `currencies`
--
ALTER TABLE `currencies`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `currency_exchange_rates`
--
ALTER TABLE `currency_exchange_rates`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `customer_groups`
--
ALTER TABLE `customer_groups`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `downloadable_link_purchased`
--
ALTER TABLE `downloadable_link_purchased`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inventory_sources`
--
ALTER TABLE `inventory_sources`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `invoices`
--
ALTER TABLE `invoices`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `invoice_items`
--
ALTER TABLE `invoice_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `locales`
--
ALTER TABLE `locales`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=172;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_brands`
--
ALTER TABLE `order_brands`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_payment`
--
ALTER TABLE `order_payment`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_attribute_values`
--
ALTER TABLE `product_attribute_values`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_bundle_options`
--
ALTER TABLE `product_bundle_options`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_bundle_option_products`
--
ALTER TABLE `product_bundle_option_products`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_bundle_option_translations`
--
ALTER TABLE `product_bundle_option_translations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_downloadable_links`
--
ALTER TABLE `product_downloadable_links`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_downloadable_link_translations`
--
ALTER TABLE `product_downloadable_link_translations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_downloadable_samples`
--
ALTER TABLE `product_downloadable_samples`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_downloadable_sample_translations`
--
ALTER TABLE `product_downloadable_sample_translations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_flat`
--
ALTER TABLE `product_flat`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_grouped_products`
--
ALTER TABLE `product_grouped_products`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_images`
--
ALTER TABLE `product_images`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_inventories`
--
ALTER TABLE `product_inventories`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_ordered_inventories`
--
ALTER TABLE `product_ordered_inventories`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_reviews`
--
ALTER TABLE `product_reviews`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `refunds`
--
ALTER TABLE `refunds`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `refund_items`
--
ALTER TABLE `refund_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `shipments`
--
ALTER TABLE `shipments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shipment_items`
--
ALTER TABLE `shipment_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sliders`
--
ALTER TABLE `sliders`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `subscribers_list`
--
ALTER TABLE `subscribers_list`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tax_categories`
--
ALTER TABLE `tax_categories`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tax_categories_tax_rates`
--
ALTER TABLE `tax_categories_tax_rates`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tax_rates`
--
ALTER TABLE `tax_rates`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `velocity_contents`
--
ALTER TABLE `velocity_contents`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `velocity_contents_translations`
--
ALTER TABLE `velocity_contents_translations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `velocity_customer_compare_products`
--
ALTER TABLE `velocity_customer_compare_products`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `velocity_meta_data`
--
ALTER TABLE `velocity_meta_data`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `wishlist`
--
ALTER TABLE `wishlist`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `addresses`
--
ALTER TABLE `addresses`
  ADD CONSTRAINT `addresses_cart_id_foreign` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `addresses_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `addresses_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `attribute_groups`
--
ALTER TABLE `attribute_groups`
  ADD CONSTRAINT `attribute_groups_attribute_family_id_foreign` FOREIGN KEY (`attribute_family_id`) REFERENCES `attribute_families` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `attribute_group_mappings`
--
ALTER TABLE `attribute_group_mappings`
  ADD CONSTRAINT `attribute_group_mappings_attribute_group_id_foreign` FOREIGN KEY (`attribute_group_id`) REFERENCES `attribute_groups` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `attribute_group_mappings_attribute_id_foreign` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `attribute_options`
--
ALTER TABLE `attribute_options`
  ADD CONSTRAINT `attribute_options_attribute_id_foreign` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `attribute_option_translations`
--
ALTER TABLE `attribute_option_translations`
  ADD CONSTRAINT `attribute_option_translations_attribute_option_id_foreign` FOREIGN KEY (`attribute_option_id`) REFERENCES `attribute_options` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `attribute_translations`
--
ALTER TABLE `attribute_translations`
  ADD CONSTRAINT `attribute_translations_attribute_id_foreign` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `bookings_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `bookings_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `booking_products`
--
ALTER TABLE `booking_products`
  ADD CONSTRAINT `booking_products_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `booking_product_appointment_slots`
--
ALTER TABLE `booking_product_appointment_slots`
  ADD CONSTRAINT `booking_product_appointment_slots_booking_product_id_foreign` FOREIGN KEY (`booking_product_id`) REFERENCES `booking_products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `booking_product_default_slots`
--
ALTER TABLE `booking_product_default_slots`
  ADD CONSTRAINT `booking_product_default_slots_booking_product_id_foreign` FOREIGN KEY (`booking_product_id`) REFERENCES `booking_products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `booking_product_event_tickets`
--
ALTER TABLE `booking_product_event_tickets`
  ADD CONSTRAINT `booking_product_event_tickets_booking_product_id_foreign` FOREIGN KEY (`booking_product_id`) REFERENCES `booking_products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `booking_product_event_ticket_translations`
--
ALTER TABLE `booking_product_event_ticket_translations`
  ADD CONSTRAINT `booking_product_event_ticket_translations_locale_foreign` FOREIGN KEY (`booking_product_event_ticket_id`) REFERENCES `booking_product_event_tickets` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `booking_product_rental_slots`
--
ALTER TABLE `booking_product_rental_slots`
  ADD CONSTRAINT `booking_product_rental_slots_booking_product_id_foreign` FOREIGN KEY (`booking_product_id`) REFERENCES `booking_products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `booking_product_table_slots`
--
ALTER TABLE `booking_product_table_slots`
  ADD CONSTRAINT `booking_product_table_slots_booking_product_id_foreign` FOREIGN KEY (`booking_product_id`) REFERENCES `booking_products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD CONSTRAINT `cart_items_cart_id_foreign` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_items_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `cart_items` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_items_tax_category_id_foreign` FOREIGN KEY (`tax_category_id`) REFERENCES `tax_categories` (`id`);

--
-- Constraints for table `cart_payment`
--
ALTER TABLE `cart_payment`
  ADD CONSTRAINT `cart_payment_cart_id_foreign` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cart_rule_channels`
--
ALTER TABLE `cart_rule_channels`
  ADD CONSTRAINT `cart_rule_channels_cart_rule_id_foreign` FOREIGN KEY (`cart_rule_id`) REFERENCES `cart_rules` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_rule_channels_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cart_rule_coupons`
--
ALTER TABLE `cart_rule_coupons`
  ADD CONSTRAINT `cart_rule_coupons_cart_rule_id_foreign` FOREIGN KEY (`cart_rule_id`) REFERENCES `cart_rules` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cart_rule_coupon_usage`
--
ALTER TABLE `cart_rule_coupon_usage`
  ADD CONSTRAINT `cart_rule_coupon_usage_cart_rule_coupon_id_foreign` FOREIGN KEY (`cart_rule_coupon_id`) REFERENCES `cart_rule_coupons` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_rule_coupon_usage_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cart_rule_customers`
--
ALTER TABLE `cart_rule_customers`
  ADD CONSTRAINT `cart_rule_customers_cart_rule_id_foreign` FOREIGN KEY (`cart_rule_id`) REFERENCES `cart_rules` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_rule_customers_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cart_rule_customer_groups`
--
ALTER TABLE `cart_rule_customer_groups`
  ADD CONSTRAINT `cart_rule_customer_groups_cart_rule_id_foreign` FOREIGN KEY (`cart_rule_id`) REFERENCES `cart_rules` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_rule_customer_groups_customer_group_id_foreign` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_groups` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cart_rule_translations`
--
ALTER TABLE `cart_rule_translations`
  ADD CONSTRAINT `cart_rule_translations_cart_rule_id_foreign` FOREIGN KEY (`cart_rule_id`) REFERENCES `cart_rules` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cart_shipping_rates`
--
ALTER TABLE `cart_shipping_rates`
  ADD CONSTRAINT `cart_shipping_rates_cart_address_id_foreign` FOREIGN KEY (`cart_address_id`) REFERENCES `addresses` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `catalog_rule_channels`
--
ALTER TABLE `catalog_rule_channels`
  ADD CONSTRAINT `catalog_rule_channels_catalog_rule_id_foreign` FOREIGN KEY (`catalog_rule_id`) REFERENCES `catalog_rules` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `catalog_rule_channels_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `catalog_rule_customer_groups`
--
ALTER TABLE `catalog_rule_customer_groups`
  ADD CONSTRAINT `catalog_rule_customer_groups_catalog_rule_id_foreign` FOREIGN KEY (`catalog_rule_id`) REFERENCES `catalog_rules` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `catalog_rule_customer_groups_customer_group_id_foreign` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_groups` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `catalog_rule_products`
--
ALTER TABLE `catalog_rule_products`
  ADD CONSTRAINT `catalog_rule_products_catalog_rule_id_foreign` FOREIGN KEY (`catalog_rule_id`) REFERENCES `catalog_rules` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `catalog_rule_products_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `catalog_rule_products_customer_group_id_foreign` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_groups` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `catalog_rule_products_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `catalog_rule_product_prices`
--
ALTER TABLE `catalog_rule_product_prices`
  ADD CONSTRAINT `catalog_rule_product_prices_catalog_rule_id_foreign` FOREIGN KEY (`catalog_rule_id`) REFERENCES `catalog_rules` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `catalog_rule_product_prices_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `catalog_rule_product_prices_customer_group_id_foreign` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_groups` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `catalog_rule_product_prices_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `category_filterable_attributes`
--
ALTER TABLE `category_filterable_attributes`
  ADD CONSTRAINT `category_filterable_attributes_attribute_id_foreign` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `category_filterable_attributes_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `category_translations`
--
ALTER TABLE `category_translations`
  ADD CONSTRAINT `category_translations_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `category_translations_locale_id_foreign` FOREIGN KEY (`locale_id`) REFERENCES `locales` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `channels`
--
ALTER TABLE `channels`
  ADD CONSTRAINT `channels_base_currency_id_foreign` FOREIGN KEY (`base_currency_id`) REFERENCES `currencies` (`id`),
  ADD CONSTRAINT `channels_default_locale_id_foreign` FOREIGN KEY (`default_locale_id`) REFERENCES `locales` (`id`),
  ADD CONSTRAINT `channels_root_category_id_foreign` FOREIGN KEY (`root_category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `channel_currencies`
--
ALTER TABLE `channel_currencies`
  ADD CONSTRAINT `channel_currencies_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `channel_currencies_currency_id_foreign` FOREIGN KEY (`currency_id`) REFERENCES `currencies` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `channel_inventory_sources`
--
ALTER TABLE `channel_inventory_sources`
  ADD CONSTRAINT `channel_inventory_sources_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `channel_inventory_sources_inventory_source_id_foreign` FOREIGN KEY (`inventory_source_id`) REFERENCES `inventory_sources` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `channel_locales`
--
ALTER TABLE `channel_locales`
  ADD CONSTRAINT `channel_locales_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `channel_locales_locale_id_foreign` FOREIGN KEY (`locale_id`) REFERENCES `locales` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cms_page_channels`
--
ALTER TABLE `cms_page_channels`
  ADD CONSTRAINT `cms_page_channels_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cms_page_channels_cms_page_id_foreign` FOREIGN KEY (`cms_page_id`) REFERENCES `cms_pages` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cms_page_translations`
--
ALTER TABLE `cms_page_translations`
  ADD CONSTRAINT `cms_page_translations_cms_page_id_foreign` FOREIGN KEY (`cms_page_id`) REFERENCES `cms_pages` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `country_states`
--
ALTER TABLE `country_states`
  ADD CONSTRAINT `country_states_country_id_foreign` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `country_state_translations`
--
ALTER TABLE `country_state_translations`
  ADD CONSTRAINT `country_state_translations_country_state_id_foreign` FOREIGN KEY (`country_state_id`) REFERENCES `country_states` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `country_translations`
--
ALTER TABLE `country_translations`
  ADD CONSTRAINT `country_translations_country_id_foreign` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `currency_exchange_rates`
--
ALTER TABLE `currency_exchange_rates`
  ADD CONSTRAINT `currency_exchange_rates_target_currency_foreign` FOREIGN KEY (`target_currency`) REFERENCES `currencies` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `customers`
--
ALTER TABLE `customers`
  ADD CONSTRAINT `customers_customer_group_id_foreign` FOREIGN KEY (`customer_group_id`) REFERENCES `customer_groups` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `downloadable_link_purchased`
--
ALTER TABLE `downloadable_link_purchased`
  ADD CONSTRAINT `downloadable_link_purchased_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `downloadable_link_purchased_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `downloadable_link_purchased_order_item_id_foreign` FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `invoices`
--
ALTER TABLE `invoices`
  ADD CONSTRAINT `invoices_order_address_id_foreign` FOREIGN KEY (`order_address_id`) REFERENCES `addresses` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `invoices_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `invoice_items`
--
ALTER TABLE `invoice_items`
  ADD CONSTRAINT `invoice_items_invoice_id_foreign` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `invoice_items_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `invoice_items` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `orders_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `order_brands`
--
ALTER TABLE `order_brands`
  ADD CONSTRAINT `order_brands_brand_foreign` FOREIGN KEY (`brand`) REFERENCES `attribute_options` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_brands_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_brands_order_item_id_foreign` FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_brands_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `order_items` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_payment`
--
ALTER TABLE `order_payment`
  ADD CONSTRAINT `order_payment_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_attribute_family_id_foreign` FOREIGN KEY (`attribute_family_id`) REFERENCES `attribute_families` (`id`),
  ADD CONSTRAINT `products_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_attribute_values`
--
ALTER TABLE `product_attribute_values`
  ADD CONSTRAINT `product_attribute_values_attribute_id_foreign` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_attribute_values_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_bundle_options`
--
ALTER TABLE `product_bundle_options`
  ADD CONSTRAINT `product_bundle_options_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_bundle_option_products`
--
ALTER TABLE `product_bundle_option_products`
  ADD CONSTRAINT `product_bundle_option_products_product_bundle_option_id_foreign` FOREIGN KEY (`product_bundle_option_id`) REFERENCES `product_bundle_options` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_bundle_option_products_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_bundle_option_translations`
--
ALTER TABLE `product_bundle_option_translations`
  ADD CONSTRAINT `product_bundle_option_translations_option_id_foreign` FOREIGN KEY (`product_bundle_option_id`) REFERENCES `product_bundle_options` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_categories`
--
ALTER TABLE `product_categories`
  ADD CONSTRAINT `product_categories_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_categories_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_cross_sells`
--
ALTER TABLE `product_cross_sells`
  ADD CONSTRAINT `product_cross_sells_child_id_foreign` FOREIGN KEY (`child_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_cross_sells_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_downloadable_links`
--
ALTER TABLE `product_downloadable_links`
  ADD CONSTRAINT `product_downloadable_links_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_downloadable_link_translations`
--
ALTER TABLE `product_downloadable_link_translations`
  ADD CONSTRAINT `link_translations_link_id_foreign` FOREIGN KEY (`product_downloadable_link_id`) REFERENCES `product_downloadable_links` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_downloadable_samples`
--
ALTER TABLE `product_downloadable_samples`
  ADD CONSTRAINT `product_downloadable_samples_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_downloadable_sample_translations`
--
ALTER TABLE `product_downloadable_sample_translations`
  ADD CONSTRAINT `sample_translations_sample_id_foreign` FOREIGN KEY (`product_downloadable_sample_id`) REFERENCES `product_downloadable_samples` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_flat`
--
ALTER TABLE `product_flat`
  ADD CONSTRAINT `product_flat_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `product_flat` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_flat_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_grouped_products`
--
ALTER TABLE `product_grouped_products`
  ADD CONSTRAINT `product_grouped_products_associated_product_id_foreign` FOREIGN KEY (`associated_product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_grouped_products_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_images`
--
ALTER TABLE `product_images`
  ADD CONSTRAINT `product_images_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_inventories`
--
ALTER TABLE `product_inventories`
  ADD CONSTRAINT `product_inventories_inventory_source_id_foreign` FOREIGN KEY (`inventory_source_id`) REFERENCES `inventory_sources` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_inventories_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_ordered_inventories`
--
ALTER TABLE `product_ordered_inventories`
  ADD CONSTRAINT `product_ordered_inventories_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_ordered_inventories_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_relations`
--
ALTER TABLE `product_relations`
  ADD CONSTRAINT `product_relations_child_id_foreign` FOREIGN KEY (`child_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_relations_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_reviews`
--
ALTER TABLE `product_reviews`
  ADD CONSTRAINT `product_reviews_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_super_attributes`
--
ALTER TABLE `product_super_attributes`
  ADD CONSTRAINT `product_super_attributes_attribute_id_foreign` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`),
  ADD CONSTRAINT `product_super_attributes_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_up_sells`
--
ALTER TABLE `product_up_sells`
  ADD CONSTRAINT `product_up_sells_child_id_foreign` FOREIGN KEY (`child_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_up_sells_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `refunds`
--
ALTER TABLE `refunds`
  ADD CONSTRAINT `refunds_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `refund_items`
--
ALTER TABLE `refund_items`
  ADD CONSTRAINT `refund_items_order_item_id_foreign` FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `refund_items_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `refund_items` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `refund_items_refund_id_foreign` FOREIGN KEY (`refund_id`) REFERENCES `refunds` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `shipments`
--
ALTER TABLE `shipments`
  ADD CONSTRAINT `shipments_inventory_source_id_foreign` FOREIGN KEY (`inventory_source_id`) REFERENCES `inventory_sources` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `shipments_order_address_id_foreign` FOREIGN KEY (`order_address_id`) REFERENCES `addresses` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `shipments_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `shipment_items`
--
ALTER TABLE `shipment_items`
  ADD CONSTRAINT `shipment_items_shipment_id_foreign` FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `sliders`
--
ALTER TABLE `sliders`
  ADD CONSTRAINT `sliders_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `subscribers_list`
--
ALTER TABLE `subscribers_list`
  ADD CONSTRAINT `subscribers_list_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `tax_categories_tax_rates`
--
ALTER TABLE `tax_categories_tax_rates`
  ADD CONSTRAINT `tax_categories_tax_rates_tax_category_id_foreign` FOREIGN KEY (`tax_category_id`) REFERENCES `tax_categories` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tax_categories_tax_rates_tax_rate_id_foreign` FOREIGN KEY (`tax_rate_id`) REFERENCES `tax_rates` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `velocity_contents_translations`
--
ALTER TABLE `velocity_contents_translations`
  ADD CONSTRAINT `velocity_contents_translations_content_id_foreign` FOREIGN KEY (`content_id`) REFERENCES `velocity_contents` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `velocity_customer_compare_products`
--
ALTER TABLE `velocity_customer_compare_products`
  ADD CONSTRAINT `velocity_customer_compare_products_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `velocity_customer_compare_products_product_flat_id_foreign` FOREIGN KEY (`product_flat_id`) REFERENCES `product_flat` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `wishlist`
--
ALTER TABLE `wishlist`
  ADD CONSTRAINT `wishlist_channel_id_foreign` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `wishlist_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `wishlist_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
