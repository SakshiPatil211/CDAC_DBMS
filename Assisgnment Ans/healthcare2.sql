DELIMITER $$
CREATE FUNCTION insurance_coverage(p_patient_id INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
  DECLARE v_total DECIMAL(12,2);
  DECLARE v_ins VARCHAR(3);
  SELECT insurance INTO v_ins FROM patients WHERE patient_id = p_patient_id;
  SELECT total_treatment_cost(p_patient_id) INTO v_total;

  IF v_ins = 'YES' THEN
    RETURN ROUND(v_total * 0.20,2);
  ELSE
    RETURN 0;
  END IF;
END$$
DELIMITER ;
