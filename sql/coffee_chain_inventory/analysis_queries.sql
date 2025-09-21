.headers on
.mode column
.width 22 40 17 14 24 26 19 15 18

.print '1) Inventory risk versus supplier lead time'
.print '-------------------------------------------------------------'
WITH avg_sales AS (
    SELECT
        shop_id,
        product_id,
        AVG(units_sold) AS avg_weekly_units
    FROM sales
    GROUP BY shop_id, product_id
),
pending AS (
    SELECT
        po.shop_id,
        poi.product_id,
        SUM(CASE WHEN po.status = 'Pending' THEN poi.quantity_ordered ELSE 0 END) AS incoming_units,
        MIN(CASE WHEN po.status = 'Pending' THEN po.expected_delivery_date END) AS next_delivery_date
    FROM purchase_orders po
    JOIN purchase_order_items poi ON poi.po_id = po.po_id
    GROUP BY po.shop_id, poi.product_id
)
SELECT
    cs.shop_name AS shop,
    p.product_name AS product,
    il.quantity_on_hand,
    p.reorder_point,
    ROUND((il.quantity_on_hand * 7.0) / avg_sales.avg_weekly_units, 1) AS current_days_of_supply,
    ROUND(((il.quantity_on_hand + COALESCE(pending.incoming_units, 0)) * 7.0) / avg_sales.avg_weekly_units, 1) AS projected_days_with_pending,
    s.lead_time_days AS supplier_lead_days,
    COALESCE(pending.incoming_units, 0) AS incoming_units,
    pending.next_delivery_date
FROM inventory_levels il
JOIN coffee_shops cs ON cs.shop_id = il.shop_id
JOIN products p ON p.product_id = il.product_id
JOIN suppliers s ON s.supplier_id = p.default_supplier_id
JOIN avg_sales ON avg_sales.shop_id = il.shop_id AND avg_sales.product_id = il.product_id
LEFT JOIN pending ON pending.shop_id = il.shop_id AND pending.product_id = il.product_id
WHERE (il.quantity_on_hand * 7.0) / avg_sales.avg_weekly_units < s.lead_time_days
ORDER BY current_days_of_supply ASC;

.print ''
.print '2) Top revenue drivers by shop'
.print '-------------------------------------------------------------'
WITH revenue AS (
    SELECT
        cs.shop_name,
        p.product_name,
        SUM(s.units_sold * s.unit_price) AS total_revenue
    FROM sales s
    JOIN coffee_shops cs ON cs.shop_id = s.shop_id
    JOIN products p ON p.product_id = s.product_id
    GROUP BY cs.shop_name, p.product_name
),
ranked AS (
    SELECT
        shop_name,
        product_name,
        total_revenue,
        ROW_NUMBER() OVER (PARTITION BY shop_name ORDER BY total_revenue DESC) AS revenue_rank
    FROM revenue
)
SELECT
    shop_name,
    product_name,
    ROUND(total_revenue, 2) AS total_revenue
FROM ranked
WHERE revenue_rank <= 3
ORDER BY shop_name, revenue_rank;

.print ''
.print '3) Supplier revenue concentration by shop'
.print '-------------------------------------------------------------'
WITH supplier_revenue AS (
    SELECT
        cs.shop_name,
        s.supplier_name,
        SUM(sa.units_sold * sa.unit_price) AS revenue
    FROM sales sa
    JOIN products p ON p.product_id = sa.product_id
    JOIN suppliers s ON s.supplier_id = p.default_supplier_id
    JOIN coffee_shops cs ON cs.shop_id = sa.shop_id
    GROUP BY cs.shop_name, s.supplier_name
),
shop_totals AS (
    SELECT
        shop_name,
        SUM(revenue) AS total_revenue
    FROM supplier_revenue
    GROUP BY shop_name
)
SELECT
    sr.shop_name,
    sr.supplier_name,
    ROUND(sr.revenue, 2) AS revenue_contribution,
    ROUND((sr.revenue / st.total_revenue) * 100.0, 1) AS revenue_share_pct
FROM supplier_revenue sr
JOIN shop_totals st ON st.shop_name = sr.shop_name
ORDER BY sr.shop_name, sr.revenue DESC;
