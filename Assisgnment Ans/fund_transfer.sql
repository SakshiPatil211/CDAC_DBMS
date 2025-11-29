CREATE TABLE IF NOT EXISTS accounts (
  acc_no INT PRIMARY KEY,
  cust_name VARCHAR(50),
  balance DECIMAL(15,2) DEFAULT 0
);

CREATE TABLE IF NOT EXISTS transaction_history (
  txn_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  from_acc INT,
  to_acc INT,
  amount DECIMAL(15,2),
  txn_date DATE DEFAULT (CURDATE())
);

DELIMITER $$
CREATE PROCEDURE transfer_funds(
  IN p_from_acc INT,
  IN p_to_acc INT,
  IN p_amount DECIMAL(15,2)
)
BEGIN
  DECLARE v_from_bal DECIMAL(15,2);
  DECLARE v_to_exists INT;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    -- On any SQL error rollback
    ROLLBACK;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transfer failed and rolled back';
  END;

  START TRANSACTION;

  -- Check balances and existence
  SELECT balance INTO v_from_bal FROM accounts WHERE acc_no = p_from_acc FOR UPDATE;
  IF v_from_bal IS NULL THEN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'From account does not exist';
  END IF;

  SELECT COUNT(*) INTO v_to_exists FROM accounts WHERE acc_no = p_to_acc;
  IF v_to_exists = 0 THEN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'To account does not exist';
  END IF;

  IF v_from_bal < p_amount THEN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient balance';
  END IF;

  -- Deduct and credit
  UPDATE accounts SET balance = balance - p_amount WHERE acc_no = p_from_acc;
  UPDATE accounts SET balance = balance + p_amount WHERE acc_no = p_to_acc;

  -- Insert log
  INSERT INTO transaction_history(from_acc,to_acc,amount)
  VALUES(p_from_acc, p_to_acc, p_amount);

  COMMIT;
END$$
DELIMITER ;
