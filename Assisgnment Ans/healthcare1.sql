CREATE TABLE IF NOT EXISTS patients (
  patient_id INT PRIMARY KEY,
  name VARCHAR(50),
  insurance VARCHAR(3) CHECK (insurance IN ('YES','NO')) DEFAULT 'NO'
);

CREATE TABLE IF NOT EXISTS treatment (
  treatment_id INT PRIMARY KEY,
  patient_id INT,
  doctor_fee DECIMAL(10,2),
  medicine_fee DECIMAL(10,2)
);

-- 3.1 total_treatment_cost
DELIMITER $$
CREATE FUNCTION total_treatment_cost(p_patient_id INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
  DECLARE v_total DECIMAL(12,2);
  SELECT COALESCE(SUM(doctor_fee + medicine_fee),0) INTO v_total
  FROM treatment
  WHERE patient_id = p_patient_id;
  RETURN v_total;
END$$
DELIMITER ;
