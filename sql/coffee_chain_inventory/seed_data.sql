BEGIN TRANSACTION;

INSERT INTO coffee_shops (shop_id, shop_name, city, state, neighborhood_profile, foot_traffic_score) VALUES
    (1, 'Downtown Flagship', 'Washington', 'DC', 'Central business district with heavy commuter volume', 92),
    (2, 'Georgetown Waterfront', 'Washington', 'DC', 'Upscale shopping corridor with tourist foot traffic', 84),
    (3, 'Arlington Commons', 'Arlington', 'VA', 'Mixed-use neighborhood with residential density', 76);

INSERT INTO suppliers (supplier_id, supplier_name, lead_time_days, reliability_score, contact_email, contact_phone) VALUES
    (1, 'Capital Roasters Cooperative', 3, 0.96, 'orders@capitalroasters.com', '202-555-0101'),
    (2, 'District Bottling Works', 5, 0.90, 'supply@districtbottling.com', '202-555-0145'),
    (3, 'Morning Bakery Collective', 2, 0.94, 'bakery@morningcollective.com', '202-555-0198'),
    (4, 'Green Bites Kitchen', 4, 0.92, 'hello@greenbiteskitchen.com', '703-555-0152');

INSERT INTO products (product_id, product_name, category, unit, default_supplier_id, reorder_point, target_stock_level, standard_cost, suggested_retail_price) VALUES
    (1, 'Capital City Espresso Beans (12oz bag)', 'Coffee', 'bag', 1, 30, 60, 6.50, 14.00),
    (2, 'Georgetown House Blend (12oz bag)', 'Coffee', 'bag', 1, 35, 60, 5.80, 13.00),
    (3, 'District Cold Brew 4-Pack', 'Beverage', '4-pack', 2, 25, 45, 8.75, 19.00),
    (4, 'Almond Croissant (individually wrapped)', 'Bakery', 'each', 3, 60, 90, 2.10, 4.75),
    (5, 'Vegan Breakfast Sandwich', 'Food', 'each', 4, 40, 70, 2.85, 6.50);

INSERT INTO inventory_levels (shop_id, product_id, quantity_on_hand, last_updated) VALUES
    (1, 1, 18, '2024-03-24'),
    (1, 2, 34, '2024-03-24'),
    (1, 3, 14, '2024-03-24'),
    (1, 4, 54, '2024-03-24'),
    (1, 5, 28, '2024-03-24'),
    (2, 1, 44, '2024-03-24'),
    (2, 2, 28, '2024-03-24'),
    (2, 3, 20, '2024-03-24'),
    (2, 4, 62, '2024-03-24'),
    (2, 5, 40, '2024-03-24'),
    (3, 1, 30, '2024-03-24'),
    (3, 2, 36, '2024-03-24'),
    (3, 3, 26, '2024-03-24'),
    (3, 4, 58, '2024-03-24'),
    (3, 5, 22, '2024-03-24');

-- Weekly sales volumes for March 2024 (each row represents a Sunday week ending).
INSERT INTO sales (shop_id, product_id, sale_date, units_sold, unit_price) VALUES
    (1, 1, '2024-03-03', 68, 14.00),
    (1, 2, '2024-03-03', 55, 13.00),
    (1, 3, '2024-03-03', 34, 19.00),
    (1, 4, '2024-03-03', 110, 4.75),
    (1, 5, '2024-03-03', 70, 6.50),
    (1, 1, '2024-03-10', 72, 14.00),
    (1, 2, '2024-03-10', 58, 13.00),
    (1, 3, '2024-03-10', 36, 19.00),
    (1, 4, '2024-03-10', 118, 4.75),
    (1, 5, '2024-03-10', 75, 6.50),
    (1, 1, '2024-03-17', 70, 14.00),
    (1, 2, '2024-03-17', 60, 13.00),
    (1, 3, '2024-03-17', 38, 19.00),
    (1, 4, '2024-03-17', 125, 4.75),
    (1, 5, '2024-03-17', 74, 6.50),
    (1, 1, '2024-03-24', 78, 14.00),
    (1, 2, '2024-03-24', 63, 13.00),
    (1, 3, '2024-03-24', 40, 19.00),
    (1, 4, '2024-03-24', 130, 4.75),
    (1, 5, '2024-03-24', 80, 6.50),
    (2, 1, '2024-03-03', 50, 14.25),
    (2, 2, '2024-03-03', 44, 13.25),
    (2, 3, '2024-03-03', 28, 19.50),
    (2, 4, '2024-03-03', 90, 4.85),
    (2, 5, '2024-03-03', 62, 6.75),
    (2, 1, '2024-03-10', 52, 14.25),
    (2, 2, '2024-03-10', 47, 13.25),
    (2, 3, '2024-03-10', 30, 19.50),
    (2, 4, '2024-03-10', 95, 4.85),
    (2, 5, '2024-03-10', 64, 6.75),
    (2, 1, '2024-03-17', 54, 14.25),
    (2, 2, '2024-03-17', 45, 13.25),
    (2, 3, '2024-03-17', 32, 19.50),
    (2, 4, '2024-03-17', 100, 4.85),
    (2, 5, '2024-03-17', 66, 6.75),
    (2, 1, '2024-03-24', 58, 14.25),
    (2, 2, '2024-03-24', 50, 13.25),
    (2, 3, '2024-03-24', 35, 19.50),
    (2, 4, '2024-03-24', 103, 4.85),
    (2, 5, '2024-03-24', 70, 6.75),
    (3, 1, '2024-03-03', 40, 13.75),
    (3, 2, '2024-03-03', 36, 12.75),
    (3, 3, '2024-03-03', 22, 18.75),
    (3, 4, '2024-03-03', 80, 4.65),
    (3, 5, '2024-03-03', 50, 6.40),
    (3, 1, '2024-03-10', 42, 13.75),
    (3, 2, '2024-03-10', 35, 12.75),
    (3, 3, '2024-03-10', 24, 18.75),
    (3, 4, '2024-03-10', 82, 4.65),
    (3, 5, '2024-03-10', 52, 6.40),
    (3, 1, '2024-03-17', 41, 13.75),
    (3, 2, '2024-03-17', 38, 12.75),
    (3, 3, '2024-03-17', 25, 18.75),
    (3, 4, '2024-03-17', 85, 4.65),
    (3, 5, '2024-03-17', 51, 6.40),
    (3, 1, '2024-03-24', 45, 13.75),
    (3, 2, '2024-03-24', 40, 12.75),
    (3, 3, '2024-03-24', 27, 18.75),
    (3, 4, '2024-03-24', 88, 4.65),
    (3, 5, '2024-03-24', 54, 6.40);

INSERT INTO purchase_orders (po_id, shop_id, supplier_id, order_date, expected_delivery_date, status) VALUES
    (1, 1, 1, '2024-03-20', '2024-03-25', 'Pending'),
    (2, 1, 3, '2024-03-18', '2024-03-21', 'Received'),
    (3, 2, 1, '2024-03-15', '2024-03-19', 'Received'),
    (4, 2, 2, '2024-03-22', '2024-03-29', 'Pending'),
    (5, 3, 4, '2024-03-17', '2024-03-26', 'Pending'),
    (6, 3, 3, '2024-03-10', '2024-03-14', 'Received');

INSERT INTO purchase_order_items (po_item_id, po_id, product_id, quantity_ordered, unit_cost) VALUES
    (1, 1, 1, 30, 6.40),
    (2, 1, 2, 20, 5.70),
    (3, 2, 4, 40, 2.05),
    (4, 3, 1, 40, 6.35),
    (5, 3, 2, 40, 5.75),
    (6, 4, 3, 30, 8.60),
    (7, 5, 5, 40, 2.80),
    (8, 6, 4, 50, 2.00);

COMMIT;
