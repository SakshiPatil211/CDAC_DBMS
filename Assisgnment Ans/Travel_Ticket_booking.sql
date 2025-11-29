CREATE TABLE IF NOT EXISTS trains (
  train_id INT PRIMARY KEY,
  train_name VARCHAR(50),
  total_seats INT,
  booked_seats INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS tickets (
  ticket_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  passenger_name VARCHAR(50),
  train_id INT,
  seat_no INT,
  booking_date DATE DEFAULT (CURDATE()),
  status VARCHAR(20) DEFAULT 'CONFIRMED'
);

CREATE TABLE IF NOT EXISTS waiting_list (
  wait_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  passenger_name VARCHAR(50),
  train_id INT,
  request_date DATE DEFAULT (CURDATE())
);

DELIMITER $$
CREATE PROCEDURE book_ticket(IN p_passenger VARCHAR(50), IN p_train_id INT)
BEGIN
  DECLARE v_total INT;
  DECLARE v_booked INT;
  DECLARE v_next_seat INT;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Booking failed';
  END;

  START TRANSACTION;

  SELECT total_seats, booked_seats INTO v_total, v_booked
  FROM trains
  WHERE train_id = p_train_id
  FOR UPDATE;

  IF v_total IS NULL THEN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Train not found';
  END IF;

  IF v_booked < v_total THEN
    SET v_next_seat = v_booked + 1;
    INSERT INTO tickets(passenger_name, train_id, seat_no, status)
    VALUES(p_passenger, p_train_id, v_next_seat, 'CONFIRMED');
    UPDATE trains SET booked_seats = booked_seats + 1 WHERE train_id = p_train_id;
  ELSE
    -- Put on waiting list
    INSERT INTO waiting_list(passenger_name, train_id) VALUES(p_passenger, p_train_id);
  END IF;

  COMMIT;
END$$
DELIMITER ;
