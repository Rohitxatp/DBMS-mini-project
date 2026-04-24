-- sample_data.sql
USE exam_seating;

-- Insert Students
INSERT INTO students (roll_no, first_name, last_name, email) VALUES
('CS2023001', 'Alice', 'Smith', 'alice@example.com'),
('CS2023002', 'Bob', 'Johnson', 'bob@example.com'),
('CS2023003', 'Charlie', 'Brown', 'charlie@example.com'),
('CS2023004', 'Diana', 'Prince', 'diana@example.com'),
('CS2023005', 'Evan', 'Wright', 'evan@example.com');

-- Insert Courses
INSERT INTO courses (course_code, course_name, department) VALUES
('CS101', 'Intro to Programming', 'Computer Science'),
('MATH101', 'Calculus I', 'Mathematics'),
('CS102', 'Data Structures', 'Computer Science');

-- Insert Exams
-- Note: CS101 and CS102 intentionally have colliding times to test the clash query
INSERT INTO exams (course_id, exam_date, start_time, end_time) VALUES
(1, '2026-05-10', '09:00:00', '12:00:00'), -- Exam 1: CS101 
(2, '2026-05-11', '14:00:00', '17:00:00'), -- Exam 2: MATH101
(3, '2026-05-10', '09:00:00', '12:00:00'); -- Exam 3: CS102 (Clashes with Exam 1)

-- Insert Rooms
INSERT INTO rooms (room_number, building, capacity) VALUES
('101A', 'Science Block', 4),
('102B', 'Science Block', 30);

-- Insert Seats for Room 1 '101A' (Capacity 4 -> 2x2 grid)
INSERT INTO seats (room_id, row_num, col_num) VALUES
(1, 1, 1),
(1, 1, 2),
(1, 2, 1),
(1, 2, 2);

-- Insert Seats for Room 2 '102B' (Let's insert 4 just to demonstrate)
INSERT INTO seats (room_id, row_num, col_num) VALUES
(2, 1, 1),
(2, 1, 2),
(2, 2, 1),
(2, 2, 2);

-- Insert Registrations
-- Student 2 is registered for CS101 and CS102 which clash in schedule
INSERT INTO registrations (student_id, course_id, registration_date) VALUES
(1, 1, '2026-01-15'), 
(2, 1, '2026-01-15'), 
(3, 1, '2026-01-16'), 
(4, 1, '2026-01-17'),
(1, 2, '2026-01-15'), 
(5, 2, '2026-01-15'),
(2, 3, '2026-01-15');

-- Insert Allocations for Exam 1 (CS101)
-- Only allocate 3 seats to leave one vacant for our queries test
INSERT INTO allocations (exam_id, student_id, seat_id) VALUES
(1, 1, 1),
(1, 2, 2),
(1, 3, 3);

-- Insert Invigilators
INSERT INTO invigilators (employee_id, first_name, last_name, department) VALUES
('EMP001', 'Dr. John', 'Doe', 'Computer Science'),
('EMP002', 'Prof. Mary', 'Jane', 'Mathematics');

-- Insert Invigilation Duty
INSERT INTO invigilation_duty (exam_id, room_id, invigilator_id) VALUES
(1, 1, 1),
(2, 2, 2);
