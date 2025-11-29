CREATE TABLE IF NOT EXISTS product_catalog (
  product_id INT PRIMARY KEY,
  category VARCHAR(30),
  price DECIMAL(12,2)
);

CREATE TABLE IF NOT EXISTS discount_history (
  hist_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  category VARCHAR(30),
  percent INT,
  updated_on DATE DEFAULT (CURDATE())
);

DELIMITER $$
CREATE PROCEDURE apply_discount(IN p_category VARCHAR(30), IN p_percent INT)
BEGIN
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Apply discount failed';
  END;

  START TRANSACTION;
  -- Apply discount: decrease price by p_percent percent
  UPDATE product_catalog
  SET price = ROUND(price * (1 - p_percent/100.0),2)
  WHERE category = p_category;

  INSERT INTO discount_history(category, percent) VALUES(p_category, p_percent);

  COMMIT;
END$$
DELIMITER ;
