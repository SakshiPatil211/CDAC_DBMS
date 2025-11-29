CREATE TABLE IF NOT EXISTS employees (
  emp_id INT PRIMARY KEY,
  name VARCHAR(50),
  basic DECIMAL(12,2),
  allowance DECIMAL(12,2),
  deduction DECIMAL(12,2)
);

CREATE TABLE IF NOT EXISTS payroll_history (
  payroll_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  emp_id INT,
  net_salary DECIMAL(12,2),
  payroll_date DATE DEFAULT (CURDATE())
);

DELIMITER $$
CREATE PROCEDURE process_salary(IN p_emp_id INT)
BEGIN
  DECLARE v_basic DECIMAL(12,2);
  DECLARE v_allow DECIMAL(12,2);
  DECLARE v_ded DECIMAL(12,2);
  DECLARE v_net DECIMAL(12,2);

  SELECT basic, allowance, deduction INTO v_basic, v_allow, v_ded
  FROM employees
  WHERE emp_id = p_emp_id;

  IF v_basic IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee not found';
  END IF;

  SET v_net = v_basic + COALESCE(v_allow,0) - COALESCE(v_ded,0);
  INSERT INTO payroll_history(emp_id, net_salary) VALUES(p_emp_id, ROUND(v_net,2));
END$$
DELIMITER ;
