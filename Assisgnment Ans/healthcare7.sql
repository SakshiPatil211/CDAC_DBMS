DELIMITER $$
CREATE FUNCTION net_payable_with_tax(p_patient_id INT, tax_rate DECIMAL(5,2))
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
  DECLARE v_total DECIMAL(12,2);
  DECLARE v_ins_cov DECIMAL(12,2);
  DECLARE v_payable DECIMAL(12,2);
  SET v_total = total_treatment_cost(p_patient_id);
  SET v_ins_cov = insurance_coverage(p_patient_id);
  SET v_payable = v_total - v_ins_cov;
  SET v_payable = v_payable + ROUND(v_payable * (tax_rate/100.0),2);
  RETURN ROUND(v_payable,2);
END$$
DELIMITER ;