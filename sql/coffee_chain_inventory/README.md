# Coffee Chain Inventory Analytics Database

## Business context
A regional coffee shop collective wants to prevent stockouts of its top products while avoiding excess inventory that ties up cash. The chain runs three retail cafés that sell packaged goods (coffee beans, bottled beverages, and fresh bakery items). Leadership asked for a lightweight analytics database that consolidates sales, inventory, and purchasing activity so store managers can make proactive replenishment decisions and quantify how dependent each location is on key suppliers.

## Schema overview
The database is implemented for SQLite and contains the following entities:

| Table | Description |
| --- | --- |
| `coffee_shops` | Master list of retail locations and their market characteristics. |
| `suppliers` | Vendors providing packaged goods, including their lead times and contact information. |
| `products` | Packaged products that the shops sell, with reorder policies and default suppliers. |
| `inventory_levels` | Snapshot of on-hand inventory by shop and product. |
| `sales` | Historical weekly sales volumes and realized unit prices by shop and product. |
| `purchase_orders` | Purchase orders created by each shop, including expected arrival dates and fulfillment status. |
| `purchase_order_items` | Line items for each purchase order. |

The schema emphasizes the relationship between demand (sales), supply (purchase orders), and service level expectations (supplier lead time and reorder points).

## Files in this directory
- `schema.sql` – DDL statements to drop and recreate the database tables with foreign keys enforced.
- `seed_data.sql` – Sample data that represents four weeks of March 2024 activity for three shops and five top products.
- `analysis_queries.sql` – Reusable analytical queries that answer the business questions described below.

## Business questions addressed
1. **Which shop and product combinations are at the highest risk of stocking out before the next replenishment?** The first query calculates each location’s projected days of supply versus the supplier’s lead time, factoring in any open purchase orders.
2. **What are the top revenue drivers for each shop?** The second query ranks products by total revenue so managers can prioritize merchandising and marketing resources.
3. **How concentrated is each shop’s revenue by supplier?** The third query aggregates revenue by the default supplier to highlight single points of failure in the supply chain.

## How to use the database
1. Create a fresh SQLite database and apply the schema:
   ```bash
   sqlite3 coffee_chain.db < schema.sql
   ```
2. Populate the tables with the provided March 2024 scenario data:
   ```bash
   sqlite3 coffee_chain.db < seed_data.sql
   ```
3. Run the analytical queries individually or execute the whole script to review all insights:
   ```bash
   sqlite3 coffee_chain.db < analysis_queries.sql
   ```

Each query in `analysis_queries.sql` prints descriptive headers and is heavily commented so you can adapt the logic to real-world data.

## Extending the solution
To evolve this scenario into a production-ready analytics mart, consider connecting your point-of-sale system and procurement platform to feed the tables, scheduling the queries to run daily, and exporting their results into dashboards or alerting workflows.
