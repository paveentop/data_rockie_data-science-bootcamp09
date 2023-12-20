-- Table  1 customers
CREATE TABLE customers (
 customer_id int unique,
 customer_name varchar(200),
 customer_address varchar(200),
 customer_phone varchar(200)
);
INSERT INTO customers
VALUES 
    (1,'John', '123 Phetburi', '099-099-1991'), 
    (2,'Topson', '456 Silom', '097-089-2929'),
    (3,'Tom', '789 Silom', '088-000-7412'),
    (4,'Best', '11 Sri Ayuttaya', '088-000-7412');

--Table 2 pizza_menu
CREATE TABLE pizza_menu (
 pizza_id int unique,
 pizza_name varchar(200),
 pizza_size varchar(200),
 pizza_price DECIMAL(50)
);
INSERT INTO pizza_menu 
VALUES 
   (1,'Pepperoni Pizza', 'Small', 80), 
   (2,'Pepperoni Pizza', 'Medium', 110), 
   (3,'Pepperoni Pizza', 'Large', 150),
   (4,'Cheese Pizza', 'Small', 90), 
   (5,'Cheese Pizza', 'Medium', 120), 
   (6,'Cheese Pizza', 'Large', 160);

--Table 3 orders
CREATE TABLE orders (
  order_id int unique,
  customer_id int,
  pizza_id int,
  toppings_id int,
  quantity int,
  total_price decimal(50)
);

INSERT INTO orders 
VALUES 
  (1,1, 1, 1, 1, 85),
  (2,1, 2, 2, 1, 117),
  (3,2, 4, 3, 1, 92),
  (4,2, 5, 4, 1, 127),
  (5,3, 1, 1, 2, 170),
  (6,3, 2, 2, 2, 234),
  (7,4, 4, 3, 3, 276),
  (8,4, 5, 4, 3, 381),
  (9,5, 1, 1, 4, 340),
  (10,5, 2, 2, 4, 468),
  (11,6, 4, 3, 5, 460),
  (12,6, 5, 4, 5, 615),
  (13,4, 6, 3, 6, 1000);

--Table 4 toppings
CREATE TABLE toppings (
 topping_id int unique,
 topping_name varchar(200),
 topping_price DECIMAL(50)
);
INSERT INTO toppings 
VALUES 
   (1,'Pepperoni', 5), 
   (2,'Mushrooms', 7), 
   (3,'Onions', 2), 
   (4,'Green Peppers', 1);

.mode box
--aggregate functions find the count of customers ?
SELECT sum(total_price)          AS sum_price,
       ROUND(avg(total_price),2) AS avg_price,
       min(total_price)          AS min_price,
       max(total_price)          AS max_price
FROM orders;

--ลูกค้าคนไหนสั่งซื้อพิซซ่ามากที่สุด?
SELECT  customer_name AS name,
        pizza_name,
        quantity ,
        pizza_size,
        total_price
FROM orders
  INNER JOIN customers ON orders.customer_id = customers.customer_id
  INNER JOIN pizza_menu ON orders.pizza_id = pizza_menu.pizza_id 
ORDER BY total_price DESC ;

--ยอดขายแต่ละเมนู?
SELECT  pizza_name, 
        sum(total_price) AS sum_price
FROM orders
  INNER JOIN  pizza_menu ON orders.pizza_id = pizza_menu.pizza_id
GROUP BY pizza_name;

--ยอดขายแต่ละเมนูแต่ละขนาด?
SELECT pizza_name,
       pizza_size,
       COALESCE((SELECT SUM(total_price) FROM orders WHERE orders.pizza_id = pizza_menu.pizza_id), 0) AS sum_price
FROM pizza_menu
ORDER BY sum_price DESC;

-- ท็อปปิ้งยอดนิยม
WITH popular_topping AS 
  (SELECT topping_name, COUNT(*) AS total_orders
  FROM orders
  INNER JOIN toppings
  ON orders.toppings_id = toppings.topping_id
  GROUP BY topping_name
  ORDER BY total_orders DESC
  LIMIT 3
)

SELECT topping_name AS popular_topping FROM popular_topping;

