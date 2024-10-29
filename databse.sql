create database ojek_online;

create table Address (
  id serial primary key,
  street varchar(250),
  city varchar(200),
  province varchar(200)
);

create type CustomerStatus as enum (
  'active',
  'non active'
);

create table Customer (
  id serial primary key,
  name varchar(250),
  address_id int references Address(id),
  status CustomerStatus not null
);

create table Driver (
  id serial primary key,
  name varchar(250),
  address_id int references Address(id)
);

create table Orders (
  id serial primary key,
  customer_id int references Customer(id),
  driver_id int references Driver(id),
  order_date date not null,
  price int
);

INSERT INTO Address (street, city, province) VALUES
('Jl. Raya No.1', 'Jakarta', 'DKI Jakarta'),
('Jl. Merdeka No.5', 'Bandung', 'Jawa Barat'),
('Jl. Pahlawan No.7', 'Surabaya', 'Jawa Timur');

INSERT INTO Customer (name, address_id, status) VALUES
('Jefri', 1, 'active'),
('Agistar', 2, 'non_aktif'),
('Putra', 3, 'active');

INSERT INTO Driver (name, address_id) VALUES
('Budi Santoso', 1),
('Siti Aminah', 2),
('Doni Prabowo', 3);

INSERT INTO Orders (customer_id, driver_id, order_date, price) VALUES
(1, 1, '2024-10-01', 50000),
(2, 2, '2024-10-15', 75000),
(1, 3, '2024-10-20', 60000);

// menampilkan total order setiap bulan
SELECT 
    DATE_TRUNC('month', order_date) AS month,
    SUM(price) AS total_price
FROM 
    Orders
GROUP BY 
    month
ORDER BY 
    month;

//melihat customer yangsering order setiap bulan dan tampilkan namanya
SELECT 
    C.name AS customer_name,
    DATE_TRUNC('month', O.order_date) AS month,
    COUNT(O.id) AS total_orders
FROM 
    Orders O
JOIN 
    Customer C ON O.customer_id = C.id
GROUP BY 
    C.name, month
ORDER BY 
    month, total_orders DESC;

//melihat daerah mana saja yang banyak orderan nya
  SELECT 
      A.street, A.city, A.province,
      COUNT(O.id) AS total_orders
  FROM 
      Orders O
  JOIN 
      Customer C ON O.customer_id = C.id
  JOIN 
      Address A ON C.address_id = A.id
  GROUP BY 
    A.street, A.city, A.province
  ORDER BY 
      total_orders DESC;

//melihat pukul berapa saja order yang ramai dan sepi
SELECT 
    EXTRACT(HOUR FROM order_date) AS order_hour,
    COUNT(id) AS total_orders
FROM 
    Orders
GROUP BY 
    order_hour
ORDER BY 
    total_orders DESC;

//update jam nya atau date
UPDATE Orders
SET order_date = order_date + INTERVAL '1 hour'
WHERE customer_id = 1; 

//melihat customer yang active dan non active
SELECT 
    name, 
    status 
FROM 
    Customer
WHERE 
    status IN ('active', 'non active');

//melihat driver yang rajin mengambil order setiap bulan diambil dari tahun dan bulan nya
SELECT 
    d.name AS driver_name,
    COUNT(o.id) AS total_orders
FROM 
    Driver d
JOIN 
    Orders o ON d.id = o.driver_id
WHERE 
    EXTRACT(YEAR FROM o.order_date) = 2024 AND 
    EXTRACT(MONTH FROM o.order_date) = 10
GROUP BY 
    d.id
ORDER BY 
    total_orders DESC;


//menampilkan nama driver beserta rincian bulan dan tahun
SELECT 
    d.name AS driver_name,
    EXTRACT(YEAR FROM o.order_date) AS order_year,
    EXTRACT(MONTH FROM o.order_date) AS order_month,
    COUNT(o.id) AS total_orders
FROM 
    Driver d
JOIN 
    Orders o ON d.id = o.driver_id
GROUP BY 
    d.id, order_year, order_month
ORDER BY 
    order_year, order_month, total_orders DESC;
