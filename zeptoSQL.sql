Create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC (8,2),
discountPercentage NUMERIC(5,2),
availableQuantity INTEGER,
discountedsellingPrice NUMERIC(8,2),
weightinGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

-- Data exploration 

-- Count rows 
SELECT COUNT(*) FROM zepto;

--sample data
SELECT * FROM zepto
LIMIT 10;

--Null Values
SELECT * FROM zepto
WHERE name IS NULL
OR
mrp IS NULL
OR 
discountpercentage IS NULL
OR
availablequantity IS NULL
OR
weightingms IS NULL
OR 
outofstock IS NULL
OR
quantity IS NULL;
-- diffrent product categories 
SELECT DISTINCT category 
FROM zepto
ORDER BY category;
-- products in stock and out of stocks count
SELECT outOfStock, count(sku_id)
FROM zepto
GROUP By outofstock;

--Product name presentin table mutiple times 
SELECT name, COUNT(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING COUNT (sku_id)>1
ORDER By COUNT (sku_id) DESC;

--data cleaning 
-- product price with zeor =0

SELECT * FROM zepto
where mrp=0 OR discountedSellingPrice=0;

DELETE FROM zepto
WHERE mrp=0;

--conver Paise to rupess
UPDATE zepto 
SET mrp=mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0
-- find the top 10 best value product based on discount percentage
SELECT name, mrp,discountpercentage
FROM zepto
ORDER BY discountpercentage DESC
LIMIT 10;

--For each product name, find the maximum discount
SELECT 
    name, 
    MAX(discountpercentage) AS max_discount
FROM zepto
GROUP BY name
ORDER BY max_discount DESC;
--products with high mrp but out of stock
SELECT name, Max(mrp)as maximum_value
FROM zepto
WHERE outofstock = TRUE AND mrp>350
GROUP BY name
ORDER BY maximum_value DESC
LIMIT 10;

-- estimted revenue for each catogory 
SELECT SUM(mrp) as total_revenue, category 
FROM zepto
GROUP BY category
ORDER by total_revenue DESC
limit 14;

-- product where mrp is greater than 500 and discoutn is less than 10%
SELECT DISTINCT name,mrp, discountPercentage
FROM zepto
WHERE mrp>500 AND discountPercentage<10
ORDER BY mrp DESC, discountPercentage DESC;

SELECT * from zepto;
-- to check number of columns exsist in database
SELECT *
FROM information_schema.columns
WHERE table_name = 'zepto';

-- identify th top 5 categories offering the highest avargae discount percentage

SELECT category,
ROUND(AVG(discountpercentage),2) as avg_discount
FROM zepto
GROUP BY category 
order by avg_discount DESC
LIMIT 5;

-- price per gms for prodcuts above 100 g and srot by best value;
SELECT DISTINCT name, weightingms, discountedsellingprice,
ROUND(discountedsellingprice/weightingms,2) as price_per_gram
FROM zepto
WHERE weightingms>=100
ORDER by price_per_gram DESC;
--
SELECT * FROM zepto;
-- group the products into categories like low, medium, bulk based on weight 
SELECT DISTINCT name,Category, weightingms,
CASE WHEN weightingms <1000 THEN 'low'
WHEN weightingms <5000 THEN 'Medium'
ELSE 'Bulk'
END as Weight_category
FROM zepto
WHERE weightingms BETWEEN 2000 AND 4000;

-- totoal inventory weight per cateogry 
SELECT category,
SUM(weightingms*availablequantity) as total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight DESC;
UPDATE zepto
SET weightingms = weightingms / 1000.0;
SELECT * FROM zepto;