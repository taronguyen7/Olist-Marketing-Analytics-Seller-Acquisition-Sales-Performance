# CORE BUSINESS QUESTIONS FOR THIS PROJECT ANALYTICS 
#1 Which marketing channels convert the most leads into sellers? 
	#Question 1: We found that organic search generates the most closed deals (271),
    #while paid search has a slightly higher conversion rate (12.30% versus 11.80%). 
	#Unknown and blank origins have higher rates, but they aren't identifiable channels.
    
#2 Which channels generate the most sales value?
	# Organic search generated the most attributable sales value (204,509.79).
	# Paid search ranked second (151,444.15), followed by social (43,394.20).
	# Unknown sources generated 209,651.37 but cannot be attributed to a specific channel.
	# Results include only matched sellers with delivered order activity so a gap will show.
    
#3 Which marketing channels should Olist prioritize based on our findings?


CREATE DATABASE olist_marketing;
USE olist_marketing;

SHOW CREATE TABLE olist_marketing.marketing_qualified_leads;

ALTER TABLE marketing_qualified_leads
MODIFY COLUMN first_contact_date TEXT;

SELECT
    first_contact_date,
    STR_TO_DATE(first_contact_date, '%m/%d/%Y') AS converted_date
FROM marketing_qualified_leads
LIMIT 10;

SELECT COUNT(*) AS invalid_dates
FROM marketing_qualified_leads
WHERE STR_TO_DATE(first_contact_date, '%m/%d/%Y') IS NULL;

ALTER TABLE marketing_qualified_leads
ADD COLUMN contact_date_clean DATE;

UPDATE marketing_qualified_leads
SET contact_date_clean =
    STR_TO_DATE(first_contact_date, '%m/%d/%Y');

SELECT
    COUNT(*) AS total_records,
    COUNT(contact_date_clean) AS cleaned_dates,
    COUNT(*) - COUNT(contact_date_clean) AS missing_dates
FROM marketing_qualified_leads;

SELECT
    first_contact_date,
    contact_date_clean
FROM marketing_qualified_leads
LIMIT 10;

SELECT
    COUNT(*) AS total_records,
    COUNT(won_date_clean) AS cleaned_dates,
    COUNT(*) - COUNT(won_date_clean) AS missing_dates
FROM olist_closed_deals_dataset;


SELECT *
FROM olist_closed_deals_dataset
LIMIT 10;

-- OLIST CLOSED DEALS DATA CLEANING ABOVE
-- Imported 842 records from the closed deals dataset.
-- Inspected the table structure and identified won_date as TEXT.
-- Used STR_TO_DATE() to convert the original dates into DATETIME format.
-- Checked for invalid dates and confirmed there were none.
-- Created a new column, won_date_clean, to preserve the original data.
-- Populated the new column with the converted dates.
-- Verified that all 842 records were successfully converted with 0 missing dates.

SELECT
    mql_id,
    COUNT(*) AS occurrences
FROM olist_closed_deals_dataset
GROUP BY mql_id
HAVING COUNT(*) > 1;

SELECT
    COUNT(*) AS missing_mql_ids
FROM olist_closed_deals_dataset
WHERE mql_id IS NULL
   OR TRIM(mql_id) = '';


SELECT
    COUNT(*) AS unmatched_deals
FROM olist_closed_deals_dataset AS cd
LEFT JOIN marketing_qualified_leads AS mql
    ON cd.mql_id = mql.mql_id
WHERE mql.mql_id IS NULL;

SELECT
    COUNT(*) AS total_leads,
    COUNT(DISTINCT mql_id) AS unique_leads
FROM marketing_qualified_leads;


SELECT *
FROM olist_closed_deals_dataset;

SELECT *
FROM olist_sellers_dataset;

# Check for unmatched seller IDs between closed deals and sellers.
# Found 462 unmatched records out of 842 closed deals.
# These records cannot currently be linked to the sellers dataset.
# This check helps identify potential gaps before analyzing sales revenue.
SELECT COUNT(*)
FROM olist_closed_deals_dataset AS olc
LEFT JOIN olist_sellers_dataset AS ols
ON olc.seller_id = ols.seller_id
WHERE ols.seller_id IS NULL;

SELECT COUNT(*)
FROM olist_closed_deals_dataset
WHERE seller_id IS NULL OR seller_id = '';

# Validate closed deals against the sellers dataset.
# 380 of 842 closed deals match seller records.
# 462 closed deals have no matching seller record.
# Confirmed the same mismatch exists in the original CSV files.
# Retain all closed deals for marketing conversion analysis.
SELECT olc.seller_id
FROM olist_closed_deals_dataset AS olc
LEFT JOIN olist_sellers_dataset AS ols
ON olc.seller_id = ols.seller_id
WHERE ols.seller_id IS NULL
LIMIT 10;


SELECT *
FROM olist_order_items_dataset
LIMIT 20;
# Step 4.6: Verify seller matches across datasets.
# All 380 matched closed-deal sellers appear in both
# the Sellers and Order Items datasets.
# The remaining 462 appear in neither dataset.
# Verified using the original CSV files.
# Keep all 842 closed deals for conversion analysis.
# Revenue attribution is limited to matched sellers.
SELECT COUNT(DISTINCT oli.seller_id)
FROM olist_closed_deals_dataset AS olc
LEFT JOIN olist_order_items_dataset AS oli
ON olc.seller_id = oli.seller_id;

# Step 5: Check for missing order IDs
# Identifies orders with NULL or empty order IDs.
# Missing IDs could prevent orders from matching order items.
SELECT COUNT(*) AS missing_order_ids
FROM olist_orders_dataset
WHERE order_id IS NULL
   OR TRIM(order_id) = '';

# Step 5: Examine order statuses
# Identify how many orders were delivered, canceled,
# or have other statuses before calculating sales revenue.
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY total_orders DESC;

# Step 5: Check for order items without matching orders
# Ensures order items can be connected to order statuses.
SELECT COUNT(*) AS unmatched_order_items
FROM olist_order_items_dataset AS oli
LEFT JOIN olist_orders_dataset AS olo
ON oli.order_id = olo.order_id
WHERE olo.order_id IS NULL;

# Step 5: Inspect order purchase dates
# Determine the date format before converting TEXT to DATETIME.
SELECT order_purchase_timestamp
FROM olist_orders_dataset
LIMIT 10;

# Step 5: Test order purchase date conversion
# Convert TEXT dates to DATETIME for time-based sales analysis.
SELECT
    order_purchase_timestamp,
    STR_TO_DATE(order_purchase_timestamp, '%m/%d/%Y %H:%i') AS converted_date
FROM olist_orders_dataset
LIMIT 10;

# Check for invalid or missing order purchase dates
# Before converting the column to DATETIME.
SELECT COUNT(*) AS invalid_dates
FROM olist_orders_dataset
WHERE STR_TO_DATE(
    order_purchase_timestamp,
    '%m/%d/%Y %H:%i'
) IS NULL;

# Create a cleaned purchase date column.
# Preserve the original date values for reference.
ALTER TABLE olist_orders_dataset
ADD COLUMN order_purchase_date_clean DATETIME;

# Populate the cleaned purchase date column.
# Convert TEXT values into DATETIME format.
UPDATE olist_orders_dataset
SET order_purchase_date_clean =
    STR_TO_DATE(order_purchase_timestamp, '%m/%d/%Y %H:%i');

# Verify that all order purchase dates were cleaned.
# Check for missing values after conversion.
SELECT
    COUNT(*) AS total_orders,
    COUNT(order_purchase_date_clean) AS cleaned_dates,
    COUNT(*) - COUNT(order_purchase_date_clean) AS missing_dates
FROM olist_orders_dataset;


# Step 6.1: Marketing Lead Acquisition by Channel
# Identify which marketing channels generate the most qualified leads.
# This establishes a baseline for comparing channel performance.
SELECT origin, COUNT(*) AS total_leads
FROM marketing_qualified_leads
GROUP BY origin
ORDER BY total_leads DESC;
#ABOVE
# Step 6.1: Marketing Lead Acquisition - Key Findings
# 1. Organic search generated the most qualified leads (2,296 or 28.70%).
# 2. Paid search ranked second with 1,586 leads (19.83%).
# 3. Social media ranked third with 1,350 leads (16.88%).
# 4. Unknown and blank sources accounted for 1,159 leads (14.49%), indicating a potential marketing attribution issue.
# 5. Lead volume alone does not determine channel effectiveness.
# Conversion rates and seller sales value must be analyzed before making marketing investment recommendations.

SELECT *
FROM marketing_qualified_leads
LIMIT 10;

SELECT *
FROM olist_closed_deals_dataset
LIMIT 10;

# CALCULATING CONVERSION RATE KPI #1
SELECT ROUND(COUNT(ol.mql_id) / COUNT(ml.mql_id) * 100,2) AS conversion_rate
FROM marketing_qualified_leads AS ml
LEFT JOIN olist_closed_deals_dataset AS ol
ON ml.mql_id = ol.mql_id;

# KPI #2: Conversion Rate by Marketing Channel
# Joined Marketing Leads and Closed Deals using mql_id.
# Calculated and ranked conversion rates for each channel.
# Compared results against the overall conversion rate of 10.53%.
SELECT mql.origin, COUNT(mql.mql_id), COUNT(olc.mql_id), ROUND(COUNT(olc.mql_id) / COUNT(mql.mql_id) * 100, 2) AS conversion_rate
FROM marketing_qualified_leads AS mql
LEFT JOIN olist_closed_deals_dataset AS olc
ON mql.mql_id = olc.mql_id
GROUP BY mql.origin
ORDER BY conversion_rate DESC;

SELECT *
FROM olist_order_items_dataset
LIMIT 10;

SELECT *
FROM olist_orders_dataset
LIMIT 10;

# Step 6.3: Calculate total delivered merchandise sales value.
# Joined Orders and Order Items, filtering for delivered orders.
# Total sales value: 13,221,498.11 (excluding freight).
SELECT ROUND(SUM(oli.price), 2)
FROM olist_order_items_dataset AS oli
INNER JOIN olist_orders_dataset AS olo
ON oli.order_id = olo.order_id
WHERE olo.order_status = 'delivered';


# KPI #3: Delivered Sales Value by Marketing Channel
# Joined four datasets to connect marketing channels to seller sales.
# Calculated delivered merchandise sales value for each channel.
# Total attributed sales value: 664,857.00.
# Only 380 of 842 closed-deal sellers had matching order activity.
SELECT mql.origin, ROUND(SUM(
	CASE
	WHEN olo.order_status = 'delivered' THEN oli.price
	ELSE 0
	END), 2) AS delivered_sales_value
FROM marketing_qualified_leads AS mql
LEFT JOIN olist_closed_deals_dataset AS olc
    ON mql.mql_id = olc.mql_id
LEFT JOIN olist_order_items_dataset AS oli
    ON olc.seller_id = oli.seller_id
LEFT JOIN olist_orders_dataset AS olo
    ON oli.order_id = olo.order_id
    GROUP BY mql.origin
    ORDER BY delivered_sales_value DESC;



# KPI #4: Average Delivered Sales Value per Seller by Marketing Channel
# Calculated total delivered sales value and unique active sellers per channel.
# Divided sales value by seller count to compare average seller performance.
# Organic search averaged 1,842.43, compared with paid search at 1,514.44.
# Other ranked highest but had only 2 sellers, making the result less reliable.
SELECT mql.origin, ROUND(SUM(
	CASE
	WHEN olo.order_status = 'delivered' THEN oli.price
	ELSE 0
	END), 2) AS delivered_sales_value, 
    COUNT(DISTINCT 
	CASE 
	WHEN olo.order_status = 'delivered' THEN oli.seller_id
	ELSE NULL
	END) AS sellers_with_delivered_sales,
ROUND(SUM(
	CASE
	WHEN olo.order_status = 'delivered' THEN oli.price
	ELSE 0
	END) /
    NULLIF(COUNT(DISTINCT 
	CASE 
	WHEN olo.order_status = 'delivered' THEN oli.seller_id
	ELSE NULL
	END), 0) , 2) AS avg_sales_per_seller
FROM marketing_qualified_leads AS mql
LEFT JOIN olist_closed_deals_dataset AS olc
ON mql.mql_id = olc.mql_id
LEFT JOIN olist_order_items_dataset AS oli
ON olc.seller_id = oli.seller_id
LEFT JOIN olist_orders_dataset AS olo
ON oli.order_id = olo.order_id
GROUP BY mql.origin
ORDER BY avg_sales_per_seller DESC;

GRANT SELECT ON olist_marketing.*
TO 'powerbi_user'@'localhost';

SHOW GRANTS FOR 'powerbi_user'@'localhost';






















