CREATE DATABASE Training_Institute

USE Training_Institute

CREATE TABLE Trainee (
trainee_id INT PRIMARY KEY IDENTITY (1,1),
fullname NVARCHAR(100),
gender CHAR(1) CHECK(gender IN ('M', 'F')),
background NVARCHAR(100),
email VARCHAR(100)
)

CREATE TABLE Trainer(
trainer_id INT PRIMARY KEY IDENTITY (1,1),
fullname NVARCHAR(100),
specialty NVARCHAR(100),
phone NVARCHAR(20),
email VARCHAR(100)
)

CREATE TABLE Course(
course_id INT PRIMARY KEY IDENTITY (1,1),
title NVARCHAR(100),
category NVARCHAR(100),
level NVARCHAR(50),
duration_hrs DECIMAL(4,1),
)

CREATE TABLE Schedule (
schedule_id INT PRIMARY KEY IDENTITY (1,1),
course_id INT FOREIGN KEY REFERENCES Course(course_id),
trainer_id INT FOREIGN KEY REFERENCES Trainer(trainer_id),
start_date DATE,
end_date DATE,
time_slot NVARCHAR(50)
)

CREATE TABLE Enrollment (
enrollment_id INT PRIMARY KEY IDENTITY (1,1),
trainee_id INT FOREIGN KEY REFERENCES Trainee(trainee_id),
course_id INT FOREIGN KEY REFERENCES Course(course_id),
enrollment_date DATE
)

INSERT INTO Trainee (fullname, gender, background, email) VALUES
('Aisha Al-Harthy', 'F', 'Engineering', 'aisha@example.com'),
('Sultan Al-Farsi', 'M', 'Business', 'sultan@example.com'),
('Mariam Al-Saadi', 'F', 'Marketing', 'mariam@example.com'),
('Omar Al-Balushi', 'M', 'Computer Science', 'omar@example.com'),
('Fatma Al-Hinai', 'F', 'Data Science', 'fatma@example.com');

INSERT INTO Trainer (fullname, specialty, phone, email) VALUES
('Khalid Al-Maawali', 'Databases', '96891234567', 'khalid@example.com'),
('Noura Al-Kindi', 'Web Development', '96892345678', 'noura@example.com'),
('Salim Al-Harthy', 'Data Science', '96893456789', 'salim@example.com');

INSERT INTO Course (title, category, level, duration_hrs) VALUES
('Database Fundamentals', 'Databases', 'Beginner', 20),
('Web Development Basics', 'Web', 'Beginner', 30),
('Data Science Introduction', 'Data Science', 'Intermediate', 25),
('Advanced SQL Queries', 'Databases', 'Advanced', 15);

INSERT INTO Schedule (course_id, trainer_id, start_date, end_date, time_slot) VALUES
(1, 1, '2025-07-01', '2025-07-10', 'Morning'),
(2, 2, '2025-07-05', '2025-07-20', 'Evening'),
(3, 3, '2025-07-10', '2025-07-25', 'Weekend'),
(4, 1, '2025-07-15', '2025-07-22', 'Morning');

INSERT INTO Enrollment (trainee_id, course_id, enrollment_date) VALUES
(1, 1, '2025-06-01'),
(2, 1, '2025-06-02'),
(3, 2, '2025-06-03'),
(4, 3, '2025-06-04'),
(5, 3, '2025-06-05'),
(1, 4, '2025-06-06');

-- QUERY CHALLENGE --
--Trainee Perspective----------------------------------------------------------------------------------
-- 1. Show all available courses (title, level, category)  --
SELECT title, level, category
FROM Course

-- 2. View beginner-level Data Science courses --
SELECT title, level, category
FROM Course
WHERE level = 'Beginner' AND category = 'Data Science'

-- 3. Show courses this trainee is enrolled in (I assumed TraineeID = 1 is logged in) --
SELECT title, trainee_id
FROM Course C, Enrollment E
WHERE C.course_id =  E.course_id AND E.trainee_id = 1

-- 4. View the schedule (start_date, time_slot) for the trainee's enrolled courses (Assumed traineeid =1)
SELECT S.course_id, start_date, time_slot
FROM Schedule S, Enrollment E
WHERE S.course_id = E.course_id AND trainee_id = 1 

-- 5. Count how many courses the trainee is enrolled in (Assumed traineeid =1) --
SELECT COUNT(trainee_id) AS enrolled_courses_count
FROM Enrollment
WHERE trainee_id = 1

-- 6. Show course titles, trainer names, and time slots the trainee is attending  (Assumed traineeid =1) --
SELECT title, T.fullname AS TrainerName, time_slot
FROM Course C, Schedule S, Trainer T, Enrollment E
WHERE E.trainee_id = 1 AND E.course_id = C.course_id AND S.course_id = E.course_id AND S.trainer_id = T.trainer_id

-------------------------------------------------------------------------------------------------------
-- Trainer Perspective --------------------------------------------------------------------------------
-- 1. List all courses the trainer is assigned to (Assumed trainer id = 1) -- 
SELECT title, trainer_id
FROM Schedule S, Course C
WHERE S.course_id = C.course_id AND trainer_id = 1

-- 2. Show upcoming sessions (with dates and time slots)  (Assumed trainer id = 1) -- 
SELECT title, start_date, end_date, time_slot
FROM Schedule, Course
WHERE Schedule.course_id = Course.course_id AND trainer_id = 1

-- 3. See how many trainees are enrolled in each of your courses (Assumed trainer id = 1) --
SELECT COUNT(trainee_id) AS No_trainees_enrolled
FROM Schedule S , Enrollment E
WHERE E.course_id = S.course_id AND trainer_id = 1

-- 4. List names and emails of trainees in each of your courses (Assumed trainer id = 1) --
SELECT DISTINCT T.fullname, T.email
FROM Enrollment E, Trainee T, Schedule S
WHERE E.trainee_id = T.trainee_id AND E.course_id = S.course_id AND trainer_id =1

-- 5. Show the trainer's contact info and assigned courses (Assumed trainer id = 1) --
SELECT title, email, phone
FROM Schedule S, Trainer T, Course C
WHERE S.trainer_id = 1 AND S.trainer_id = T.trainer_id AND S.course_id = C.course_id

-- 6. Count the number of courses the trainer teaches (Assumed trainer id = 1) --
SELECT COUNT(course_id) AS courses_count
FROM Schedule
WHERE trainer_id = 1

-------------------------------------------------------------------------------------------------------
-- Admin Perspective ----------------------------------------------------------------------------------
-- 1. Add a new course (INSERT statement) --
INSERT INTO Course (title, category, level, duration_hrs) VALUES
('Data Analysis with Python', 'Data Science', 'Advanced', 20);

-- 2. Create a new schedule for a trainer --
INSERT INTO Schedule (course_id, trainer_id, start_date, end_date, time_slot) VALUES
(9, 3, '2025-07-25','2025-08-15','Morning');

-- 3.  View all trainee enrollments with course title and schedule info --
SELECT trainee_id, title, trainer_id, start_date, end_date, time_slot
FROM Enrollment E, Course C, Schedule S

-- 4. Show how many courses each trainer is assigned to --
SELECT trainer_id, COUNT(course_id) AS No_Courses_Assigned
FROM Schedule
GROUP BY trainer_id

-- 5. Retrieve trainee names and emails for those enrolled in the course titled "Data Basics". --
SELECT fullname, email
FROM Enrollment E, Trainee T, Course C
WHERE E.trainee_id = T.trainee_id AND E.course_id = C.course_id AND title = 'Data Science Introduction'

-- 6. Identify the course with the highest number of enrollments --
SELECT  TOP 1 COUNT(enrollment_id) AS No_of_Enrollments, course_id
FROM Enrollment
GROUP BY course_id
ORDER BY No_of_Enrollments DESC

-- 7. Display all schedules sorted by start date --
SELECT * 
FROM Schedule
ORDER BY start_date ASC
------------------------------------------ DONE ! -----------------------------------------------------