CREATE TABLE IF NOT EXISTS shop_products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(50),
  stock INT
);

CREATE TABLE IF NOT EXISTS shop_orders (
  order_id INT PRIMARY KEY,
  product_id INT,
  qty INT,
  status VARCHAR(20) DEFAULT 'PLACED'
);

CREATE TABLE IF NOT EXISTS order_log (
  log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  order_id INT,
  action VARCHAR(50),
  log_date DATE DEFAULT (CURDATE())
);

