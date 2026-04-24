-- constraints.sql
USE exam_seating;

-- 1. Unique roll_no for students
ALTER TABLE students
ADD CONSTRAINT unique_roll_no UNIQUE (roll_no);

-- Basic unique checks that make sense to prevent fundamental data issues
ALTER TABLE courses
ADD CONSTRAINT unique_course_code UNIQUE (course_code);

ALTER TABLE rooms
ADD CONSTRAINT unique_room_number UNIQUE (room_number);

-- 2. Unique (exam_id, seat_id) - Prevent duplicate seat assignment in same exam
ALTER TABLE allocations
ADD CONSTRAINT unique_exam_seat UNIQUE (exam_id, seat_id);

-- 3. Unique (exam_id, student_id) - Prevent duplicate student allocation in same exam
ALTER TABLE allocations
ADD CONSTRAINT unique_exam_student UNIQUE (exam_id, student_id);

-- 4. Room capacity must be greater than 0
ALTER TABLE rooms
ADD CONSTRAINT check_capacity_positive CHECK (capacity > 0);

-- 5. Valid row/column seat numbers (must be greater than 0)
ALTER TABLE seats
ADD CONSTRAINT check_row_positive CHECK (row_num > 0),
ADD CONSTRAINT check_col_positive CHECK (col_num > 0);

-- Prevent seating in the same exact row/col of the same room twice in the 'seats' master table
ALTER TABLE seats
ADD CONSTRAINT unique_room_row_col UNIQUE (room_id, row_num, col_num);
