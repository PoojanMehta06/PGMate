-- ============================================================
-- PG Mate - Database Schema
-- MySQL 8.x Required
-- ============================================================

CREATE DATABASE IF NOT EXISTS sy_project_pgmate
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE sy_project_pgmate;

-- ============================================================
-- Users (PG Owners & Tenants)
-- ============================================================
CREATE TABLE users (
  user_id       INT           NOT NULL AUTO_INCREMENT,
  full_name     VARCHAR(255)  DEFAULT NULL,
  email         VARCHAR(255)  DEFAULT NULL UNIQUE,
  password_hash VARCHAR(255)  DEFAULT NULL,
  role          VARCHAR(255)  DEFAULT NULL,
  PRIMARY KEY (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- PGs (Paying Guest properties)
-- ============================================================
CREATE TABLE pgs (
  pg_id          INT           NOT NULL AUTO_INCREMENT,
  owner_id       INT           DEFAULT NULL,
  pg_name        VARCHAR(255)  DEFAULT NULL,
  address        TEXT          DEFAULT NULL,
  city           VARCHAR(255)  DEFAULT NULL,
  pg_type        VARCHAR(255)  DEFAULT NULL COMMENT 'Boys / Girls / Co-ed',
  contact_phone  VARCHAR(255)  DEFAULT NULL,
  contact_email  VARCHAR(255)  DEFAULT NULL,
  description    TEXT          DEFAULT NULL,
  rules          TEXT          DEFAULT NULL,
  room_type      VARCHAR(255)  DEFAULT NULL COMMENT 'Single / Double / Triple',
  rent           INT           DEFAULT NULL,
  image          LONGTEXT      DEFAULT NULL COMMENT 'Base64-encoded image',
  PRIMARY KEY (pg_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- Amenities (e.g. WiFi, AC, Food)
-- ============================================================
CREATE TABLE amenities (
  amenity_id   INT           NOT NULL AUTO_INCREMENT,
  amenity_name VARCHAR(255)  DEFAULT NULL,
  PRIMARY KEY (amenity_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- PG <-> Amenity join table
-- ============================================================
CREATE TABLE pg_amenities (
  pg_id      INT  NOT NULL,
  amenity_id INT  NOT NULL,
  PRIMARY KEY (pg_id, amenity_id),
  CONSTRAINT fk_pg_amenities_pg       FOREIGN KEY (pg_id)      REFERENCES pgs (pg_id)       ON DELETE CASCADE,
  CONSTRAINT fk_pg_amenities_amenity  FOREIGN KEY (amenity_id) REFERENCES amenities (amenity_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- Rooms (belong to a PG)
-- ============================================================
CREATE TABLE rooms (
  room_id        INT            NOT NULL AUTO_INCREMENT,
  pg_id          INT            NOT NULL,
  room_number    VARCHAR(255)   NOT NULL,
  rent_per_month DECIMAL(10,2)  NOT NULL,
  status         VARCHAR(255)   NOT NULL DEFAULT 'Available' COMMENT 'Available / Occupied / Maintenance',
  PRIMARY KEY (room_id),
  CONSTRAINT fk_rooms_pg FOREIGN KEY (pg_id) REFERENCES pgs (pg_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- Booking requests
-- ============================================================
CREATE TABLE bookings (
  booking_id   INT           NOT NULL AUTO_INCREMENT,
  pg_id        INT           DEFAULT NULL,
  tenant_id    INT           DEFAULT NULL,
  owner_id     INT           DEFAULT NULL,
  status       VARCHAR(255)  DEFAULT 'Pending' COMMENT 'Pending / Approved / Rejected',
  request_date DATETIME(6)   DEFAULT NULL,
  PRIMARY KEY (booking_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- Tenancies (active / inactive rental agreements)
-- ============================================================
CREATE TABLE tenancies (
  tenancy_id    INT           NOT NULL AUTO_INCREMENT,
  tenant_id     INT           DEFAULT NULL,
  pg_id         INT           DEFAULT NULL,
  room_id       INT           NOT NULL,
  move_in_date  DATE          DEFAULT NULL,
  move_out_date DATE          DEFAULT NULL,
  status        VARCHAR(255)  DEFAULT 'Active' COMMENT 'Active / Inactive',
  PRIMARY KEY (tenancy_id),
  CONSTRAINT fk_tenancies_room FOREIGN KEY (room_id) REFERENCES rooms (room_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- Payments (rent payments)
-- ============================================================
CREATE TABLE payments (
  payment_id        INT            NOT NULL AUTO_INCREMENT,
  tenancy_id        INT            DEFAULT NULL,
  amount            DECIMAL(10,2)  DEFAULT NULL,
  payment_date      DATETIME(6)    DEFAULT NULL,
  payment_for_month VARCHAR(255)   DEFAULT NULL COMMENT 'e.g. 2025-06',
  status            VARCHAR(255)   DEFAULT NULL COMMENT 'Success / Failed / Pending',
  PRIMARY KEY (payment_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- Feedback (tenant reviews for PG)
-- ============================================================
CREATE TABLE feedbacks (
  feedback_id  INT           NOT NULL AUTO_INCREMENT,
  pg_id        INT           DEFAULT NULL,
  tenant_id    INT           DEFAULT NULL,
  owner_id     INT           DEFAULT NULL,
  rating       INT           DEFAULT NULL COMMENT '1-5',
  comment      TEXT          DEFAULT NULL,
  created_at   DATETIME(6)   DEFAULT NULL,
  PRIMARY KEY (feedback_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- Rent Notifications (reminders sent by owner)
-- ============================================================
CREATE TABLE rent_notifications (
  notification_id INT           NOT NULL AUTO_INCREMENT,
  owner_id        INT           DEFAULT NULL,
  tenant_id       INT           DEFAULT NULL,
  pg_id           INT           DEFAULT NULL,
  message         VARCHAR(255)  DEFAULT NULL,
  status          VARCHAR(255)  DEFAULT 'Sent' COMMENT 'Sent / Read',
  created_at      DATETIME(6)   DEFAULT NULL,
  PRIMARY KEY (notification_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- Seed: Default Amenities
-- ============================================================
INSERT INTO amenities (amenity_name) VALUES
  ('WiFi'),
  ('AC'),
  ('Food'),
  ('Parking'),
  ('Laundry'),
  ('Gym'),
  ('Power Backup'),
  ('Water Purifier');
