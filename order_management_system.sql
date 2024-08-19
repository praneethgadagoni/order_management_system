create database order_management_system;
use order_management_system;

CREATE TABLE IF NOT EXISTS  customer(
customer_id int primary key auto_increment,
first_name varchar(50),
last_name varchar(50),
email varchar(200) unique NOT NULL,
phone int NOT NULL,
address text NOT NULL
);

INSERT INTO customer(customer_id,first_name,last_name,email,phone,address)
VALUES (1,"praneeth","goud","praneeth@gmail.com",100,"siddipet");
INSERT INTO customer(customer_id,first_name,last_name,email,phone,address)
VALUES (2,"vivek","goud","vivek@gmail.com",101,"warangal");
INSERT INTO customer(customer_id,first_name,last_name,email,phone,address)
VALUES (3,"sai","reddy","sai@gmail.com",102,"pargi");
INSERT INTO customer(customer_id,first_name,last_name,email,phone,address)
VALUES (4,"faiz","ali","faiz@gmail.com",103,"karimnagar");
INSERT INTO customer(customer_id,first_name,last_name,email,phone,address)
VALUES (5,"tharun","patel","tharun@gmail.com",104,"bombay");
INSERT INTO customer(customer_id,first_name,last_name,email,phone,address)
VALUES (6,"rakesh","varma","rakesh@gmail.com",105,"goa");
INSERT INTO customer(customer_id,first_name,last_name,email,phone,address)
VALUES (7,"naveen","rao","vivek@gmail.com",106,"kerala");
INSERT INTO customer(customer_id,first_name,last_name,email,phone,address)
VALUES (8,"tilu","bro","tilu@gmail.com",107,"gujarat");

select *  from customer;

CREATE TABLE IF NOT EXISTS  orders(
order_id int primary key auto_increment,
customer_id int ,
order_date timestamp DEFAULT CURRENT_TIMESTAMP ,
order_status varchar(100),
total_amount int NOT NULL
);

INSERT INTO orders(order_id,customer_id,order_date,order_status,total_amount)
VALUES (90,1,'2024-08-10',"delivered",10000);
INSERT INTO orders(order_id,customer_id,order_date,order_status,total_amount)
VALUES (91,2,'2024-08-11',"not deliver",20000);
INSERT INTO orders(order_id,customer_id,order_date,order_status,total_amount)
VALUES (92,3,'2024-08-12',"dispatch",30000);
INSERT INTO orders(order_id,customer_id,order_date,order_status,total_amount)
VALUES (93,4,'2024-08-13',"delivered",40000);
INSERT INTO orders(order_id,customer_id,order_date,order_status,total_amount)
VALUES (94,5,'2024-08-14',"not deliver",50000);

select * from orders;

CREATE TABLE IF NOT EXISTS  order_items(
order_item_id int NOT NULL,
order_id int,
product_name varchar(50) NOT NULL,
quantity int,
price int
);

INSERT INTO order_items(order_item_id,order_id,product_name,quantity,price)
VALUES (11,90,"phone",1,32000);
INSERT INTO order_items(order_item_id,order_id,product_name,quantity,price)
VALUES (22,91,"watch",4,10000);
INSERT INTO order_items(order_item_id,order_id,product_name,quantity,price)
VALUES (33,92,"tab",2,12000);
INSERT INTO order_items(order_item_id,order_id,product_name,quantity,price)
VALUES (44,93,"tv",1,25000);
INSERT INTO order_items(order_item_id,order_id,product_name,quantity,price)
VALUES (55,94,"shoes",2,2000);

select * from order_items;

CREATE TABLE IF NOT EXISTS  products(
product_id int,
product_name varchar(100),
category_id int,
price int,
stock_quantity int
);

INSERT INTO products(product_id,product_name,category_id,price,stock_quantity)
VALUES (123,"oneplus",1,25000,2);
INSERT INTO products(product_id,product_name,category_id,price,stock_quantity)
VALUES (124,"apple",2,75000,1);
INSERT INTO products(product_id,product_name,category_id,price,stock_quantity)
VALUES (125,"redmi",3,15000,1);
INSERT INTO products(product_id,product_name,category_id,price,stock_quantity)
VALUES (126,"samsung",4,90000,3);
INSERT INTO products(product_id,product_name,category_id,price,stock_quantity)
VALUES (127,"nokia",5,5000,1);

select * from products;

CREATE TABLE IF NOT EXISTS  product_categories(
 foreign key (category_id) references products(category_id),
 category_name varchar(100)
);

INSERT INTO product_categories(category_id,category_name)
VALUES (1,"electonics");
INSERT INTO product_categories(category_id,category_name)
VALUES (2,"accessory");
INSERT INTO product_categories(category_id,category_name)
VALUES (3,"hardware");
INSERT INTO product_categories(category_id,category_name)
VALUES (4,"clothing");
INSERT INTO product_categories(category_id,category_name)
VALUES (5,"household");


CREATE TABLE IF NOT EXISTS  product_reviews(
review_id int,
product_id int,
customer_id int,
rating int,
review_text varchar(100),
review_date date
);

INSERT INTO product_reviews(review_id,product_id,customer_id,rating,review_text,review_date)
VALUES (001,123,1,4,"super",'2024-05-25');
INSERT INTO product_reviews(review_id,product_id,customer_id,rating,review_text,review_date)
VALUES (002,124,2,2,"average",'2024-05-26');
INSERT INTO product_reviews(review_id,product_id,customer_id,rating,review_text,review_date)
VALUES (003,125,3,1,"poor",'2024-05-27');
INSERT INTO product_reviews(review_id,product_id,customer_id,rating,review_text,review_date)
VALUES (004,126,4,5,"execellent",'2024-05-28');
INSERT INTO product_reviews(review_id,product_id,customer_id,rating,review_text,review_date)
VALUES (005,127,5,5,"very good",'2024-05-29');

select * from product_reviews;


-- 1. Write a query to find the top 3 products with the highest average rating in the last 6 months
-- Use a CTE to calculate the average rating for each product.

with products_cte as(
select product_reviews.product_id,
products.product_name,
AVG(product_reviews.rating) as average_rating
from
product_reviews
join
products on products.product_id=product_reviews.product_id
where
product_reviews.review_date between '2024-05-25' and '2024-05-29'
group by 
product_reviews.product_id,products.product_name
)
select
product_name,
average_rating
from
products_cte
order by
average_rating desc
limit 3;

--  3 3. Create a trigger that decreases the stock quantity of a product when an order item is added.
-- Assume the order_items table has a foreign key constraint to the products table.

delimiter //
CREATE TRIGGER order_item_insert
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    update products
    set stock_quantity= stock_quantity-new.quantity
    where product_name = NEW.product_name;
END //

-- 4. Write a query using a CTE to find the top 5 customers by total spending in the last 6 months.
-- Provide their total spending and the number of orders they placed.

WITH customer_spending AS (
    SELECT
        customer.customer_id,
        customer.first_name,
        customer.last_name,
        SUM(orders.total_amount) AS total_spending,
        COUNT(orders.order_id) AS num_orders
    FROM
        customer
    JOIN
        orders ON customer.customer_id = orders.customer_id
    WHERE
        orders.order_date BETWEEN '2024-08-10' AND '2024-08-14'
    GROUP BY
        customer.customer_id,
        customer.first_name,
        customer.last_name
)

SELECT 
    first_name,
    last_name,
    total_spending,
    num_orders
FROM
    customer_spending
ORDER BY
    total_spending DESC
LIMIT 5;

-- 5. Write a query to find the average rating for each product and 
-- list the products with a rating greater than the average rating of all products.

WITH ProductAverage AS (
    SELECT
        p.product_id,
        p.product_name,
        AVG(pr.rating) AS avg_rating
    FROM
        products as p
    LEFT JOIN
        product_reviews pr ON p.product_id = pr.product_id
    GROUP BY
        p.product_id, p.product_name
),
OverallAverage AS (
    SELECT
        AVG(avg_rating) AS overall_avg_rating
    FROM
        ProductAverage
)
SELECT
    pa.product_name,
    pa.avg_rating
FROM
    ProductAverage pa
JOIN
    OverallAverage oa
ON
    pa.avg_rating > oa.overall_avg_rating;
    
   -- 7. Write a query to rank products based on their total sales volume over the past year. For each product, display the product name, total quantity sold, and its rank.
   -- The rank should be calculated such that the product with the highest total quantity sold receives the rank of 1.
  
  WITH TotalSales AS (
    SELECT 
        oi.product_name,
        SUM(oi.quantity) AS total_quantity_sold
    FROM 
        order_items oi
    JOIN 
        orders o ON oi.order_id = o.order_id
    WHERE 
        o.order_date BETWEEN '2024-08-10' AND '2024-08-14'
       
    GROUP BY 
        oi.product_name
),
RankedProducts AS (
    SELECT 
        product_name,
        total_quantity_sold,
        RANK() OVER (ORDER BY total_quantity_sold DESC) AS rank_products
    FROM 
        TotalSales
)
SELECT 
    product_name,
    total_quantity_sold,
    rank_products
FROM 
    RankedProducts
ORDER BY 
    rank_products;
    
    -- 8. Write a query to find the top 3 products based on the highest average order value, where the average order value is calculated as the total value of orders containing that product divided by the number of distinct orders containing it. 
     -- Display the product names, the average order value, and their rank.
     
   WITH OrderTotals AS (
    SELECT
        oi.product_name,
        SUM(oi.quantity * oi.price) AS total_order_value,
        COUNT(DISTINCT oi.order_id) AS order_count
    FROM order_items as oi
    JOIN orders as o ON oi.order_id = o.order_id
    GROUP BY oi.product_name
),
AverageOrderValue AS (
    SELECT
        product_name,
        total_order_value / order_count AS avg_order_value
    FROM OrderTotals
)
SELECT
    product_name,
    avg_order_value,
    RANK() OVER (ORDER BY avg_order_value DESC) AS rank_product
FROM AverageOrderValue
ORDER BY rank_product
LIMIT 3;

    
    


