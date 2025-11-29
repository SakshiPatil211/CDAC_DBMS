CREATE TABLE IF NOT EXISTS student_academic (
  student_id INT PRIMARY KEY,
  course_id INT,
  semester INT,
  marks INT
);

DELIMITER $$
CREATE PROCEDURE promote_students(IN p_course_id INT)
BEGIN
  UPDATE student_academic
  SET semester = semester + 1
  WHERE course_id = p_course_id AND marks >= 50;
END$$
DELIMITER ;

