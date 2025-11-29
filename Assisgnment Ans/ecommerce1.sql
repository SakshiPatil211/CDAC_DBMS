CREATE TABLE IF NOT EXISTS products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(50),
  price DECIMAL(12,2),
  stock INT,
  discount_pct INT DEFAULT NULL -- optional column to store assigned discount %
);

CREATE TABLE IF NOT EXISTS orders (
  order_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT,
  product_id INT,
  qty INT,
  total_price DECIMAL(12,2),
  order_date DATE DEFAULT (CURDATE()),
  cashback_amt DECIMAL(10,2) DEFAULT 0
);

DELIMITER $$
CREATE PROCEDURE place_order_ecom(
  IN p_customer_id INT,
  IN p_product_id INT,
  IN p_qty INT
)
BEGIN
  DECLARE v_stock INT;
  DECLARE v_price DECIMAL(12,2);
  DECLARE v_total DECIMAL(12,2);
  DECLARE v_gst DECIMAL(12,2);
  DECLARE v_discount_pct INT;
  DECLARE v_cashback DECIMAL(10,2);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Order placement failed and rolled back';
  END;

  START TRANSACTION;

  SELECT stock, price, discount_pct INTO v_stock, v_price, v_discount_pct
  FROM products
  WHERE product_id = p_product_id
  FOR UPDATE;

  IF v_stock IS NULL THEN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product does not exist';
  END IF;

  IF v_stock < p_qty THEN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient stock';
  END IF;

  -- Compute price considering discount (if discount_pct NULL => no discount)
  IF v_discount_pct IS NOT NULL THEN
    SET v_price = v_price * (1 - v_discount_pct/100.0);
  END IF;

  SET v_total = v_price * p_qty;
  SET v_gst = ROUND(v_total * 0.18,2);
  SET v_total = ROUND(v_total + v_gst,2);

  -- Deduct stock
  UPDATE products SET stock = stock - p_qty WHERE product_id = p_product_id;

  -- Random cashback 0..100 rupees
  SET v_cashback = FLOOR(RAND() * 101);

  -- Insert order
  INSERT INTO orders(customer_id, product_id, qty, total_price, cashback_amt)
  VALUES (p_customer_id, p_product_id, p_qty, v_total, v_cashback);

  COMMIT;
END$$
DELIMITER ;
