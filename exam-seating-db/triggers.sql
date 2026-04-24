-- triggers.sql
USE exam_seating;

DELIMITER $$

-- Trigger to prevent invigilator double-booking
CREATE TRIGGER before_invigilation_insert
BEFORE INSERT ON invigilation_duty
FOR EACH ROW
BEGIN
    DECLARE v_clash_count INT;
    DECLARE v_exam_date DATE;
    DECLARE v_start_time TIME;
    DECLARE v_end_time TIME;

    -- Fetch the target exam date and timings
    SELECT exam_date, start_time, end_time INTO v_exam_date, v_start_time, v_end_time
    FROM exams WHERE exam_id = NEW.exam_id;

    -- Check for time overlaps for the same invigilator
    SELECT COUNT(*) INTO v_clash_count
    FROM invigilation_duty idty
    JOIN exams e ON idty.exam_id = e.exam_id
    WHERE idty.invigilator_id = NEW.invigilator_id
      AND e.exam_date = v_exam_date
      AND (
          (v_start_time >= e.start_time AND v_start_time < e.end_time) OR
          (v_end_time > e.start_time AND v_end_time <= e.end_time) OR
          (v_start_time <= e.start_time AND v_end_time >= e.end_time)
      );

    IF v_clash_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Invigilator is already assigned to a clashing exam on this date and time.';
    END IF;
END$$

-- Trigger to prevent duplicate seat assignments, duplicated student allocations, and room overbooking
CREATE TRIGGER before_allocation_insert
BEFORE INSERT ON allocations
FOR EACH ROW
BEGIN
    DECLARE v_room_id INT;
    DECLARE v_capacity INT;
    DECLARE v_allocated_count INT;
    DECLARE v_duplicate_seat INT;
    DECLARE v_duplicate_student INT;

    -- 1. Check for Duplicate Seat Assignment
    SELECT COUNT(*) INTO v_duplicate_seat
    FROM allocations
    WHERE exam_id = NEW.exam_id AND seat_id = NEW.seat_id;

    IF v_duplicate_seat > 0 THEN
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Error: This seat is already allocated for this exam.';
    END IF;

    -- 2. Check for Duplicate Student Allocation
    SELECT COUNT(*) INTO v_duplicate_student
    FROM allocations
    WHERE exam_id = NEW.exam_id AND student_id = NEW.student_id;

    IF v_duplicate_student > 0 THEN
         SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Error: This student has already been allocated in this exam.';
    END IF;

    -- 3. Check for Room Overbooking
    SELECT room_id INTO v_room_id FROM seats WHERE seat_id = NEW.seat_id;
    SELECT capacity INTO v_capacity FROM rooms WHERE room_id = v_room_id;

    SELECT COUNT(*) INTO v_allocated_count
    FROM allocations a
    JOIN seats s ON a.seat_id = s.seat_id
    WHERE a.exam_id = NEW.exam_id AND s.room_id = v_room_id;

    IF v_allocated_count >= v_capacity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Room overbooking prevented. Maximum room capacity reached for this exam.';
    END IF;

END$$

DELIMITER ;
