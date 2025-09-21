PRAGMA foreign_keys = ON;

-- Drop tables in reverse dependency order to make the script idempotent.
DROP TABLE IF EXISTS purchase_order_items;
DROP TABLE IF EXISTS purchase_orders;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS inventory_levels;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS coffee_shops;

-- Master data for the three retail locations in the coffee shop collective.
CREATE TABLE coffee_shops (
    shop_id              INTEGER PRIMARY KEY,
    shop_name            TEXT    NOT NULL,
    city                 TEXT    NOT NULL,
    state                TEXT    NOT NULL,
    neighborhood_profile TEXT,
    foot_traffic_score   INTEGER CHECK (foot_traffic_score BETWEEN 1 AND 100)
);

-- Supplier directory with lead time and contact info.
CREATE TABLE suppliers (
    supplier_id       INTEGER PRIMARY KEY,
    supplier_name     TEXT    NOT NULL,
    lead_time_days    INTEGER NOT NULL CHECK (lead_time_days > 0),
    reliability_score REAL    CHECK (reliability_score BETWEEN 0 AND 1),
    contact_email     TEXT,
    contact_phone     TEXT
);

-- Packaged products sold in the cafés with reorder policies.
CREATE TABLE products (
    product_id            INTEGER PRIMARY KEY,
    product_name          TEXT    NOT NULL,
    category              TEXT    NOT NULL,
    unit                  TEXT    NOT NULL,
    default_supplier_id   INTEGER NOT NULL,
    reorder_point         INTEGER NOT NULL CHECK (reorder_point >= 0),
    target_stock_level    INTEGER NOT NULL CHECK (target_stock_level >= reorder_point),
    standard_cost         REAL    NOT NULL CHECK (standard_cost >= 0),
    suggested_retail_price REAL   NOT NULL CHECK (suggested_retail_price >= 0),
    FOREIGN KEY (default_supplier_id) REFERENCES suppliers (supplier_id)
);

-- Snapshot of on-hand inventory by shop and product.
CREATE TABLE inventory_levels (
    shop_id          INTEGER NOT NULL,
    product_id       INTEGER NOT NULL,
    quantity_on_hand INTEGER NOT NULL CHECK (quantity_on_hand >= 0),
    last_updated     TEXT    NOT NULL,
    PRIMARY KEY (shop_id, product_id),
    FOREIGN KEY (shop_id) REFERENCES coffee_shops (shop_id),
    FOREIGN KEY (product_id) REFERENCES products (product_id)
);

-- Weekly sales volumes and realized pricing.
CREATE TABLE sales (
    sale_id     INTEGER PRIMARY KEY,
    shop_id     INTEGER NOT NULL,
    product_id  INTEGER NOT NULL,
    sale_date   TEXT    NOT NULL,
    units_sold  INTEGER NOT NULL CHECK (units_sold >= 0),
    unit_price  REAL    NOT NULL CHECK (unit_price >= 0),
    FOREIGN KEY (shop_id) REFERENCES coffee_shops (shop_id),
    FOREIGN KEY (product_id) REFERENCES products (product_id)
);

-- Purchase order headers.
CREATE TABLE purchase_orders (
    po_id                   INTEGER PRIMARY KEY,
    shop_id                 INTEGER NOT NULL,
    supplier_id             INTEGER NOT NULL,
    order_date              TEXT    NOT NULL,
    expected_delivery_date  TEXT,
    status                  TEXT    NOT NULL DEFAULT 'Pending'
                              CHECK (status IN ('Pending', 'Received', 'Canceled')),
    FOREIGN KEY (shop_id) REFERENCES coffee_shops (shop_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers (supplier_id)
);

-- Line items for each purchase order.
CREATE TABLE purchase_order_items (
    po_item_id       INTEGER PRIMARY KEY,
    po_id            INTEGER NOT NULL,
    product_id       INTEGER NOT NULL,
    quantity_ordered INTEGER NOT NULL CHECK (quantity_ordered > 0),
    unit_cost        REAL    NOT NULL CHECK (unit_cost >= 0),
    FOREIGN KEY (po_id) REFERENCES purchase_orders (po_id),
    FOREIGN KEY (product_id) REFERENCES products (product_id)
);

-- Helpful indexes for analytical workloads.
CREATE INDEX idx_sales_shop_product_date ON sales (shop_id, product_id, sale_date);
CREATE INDEX idx_inventory_product ON inventory_levels (product_id);
CREATE INDEX idx_po_status ON purchase_orders (status);
