-- Seed amenities (runs automatically on startup)
INSERT INTO amenities (amenity_name) VALUES
  ('WiFi'),
  ('AC'),
  ('Food'),
  ('Parking'),
  ('Laundry'),
  ('Gym'),
  ('Power Backup'),
  ('Water Purifier')
ON CONFLICT (amenity_name) DO NOTHING;
