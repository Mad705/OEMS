CREATE TABLE student (
    student_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    PRIMARY KEY (student_id)
);

CREATE TABLE examiner (
    examiner_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    PRIMARY KEY (examiner_id)
);
CREATE TABLE exam (
    exam_id INT NOT NULL,
    type ENUM('ISA', 'ESA') NOT NULL,
    date DATE NOT NULL,
    duration INT NOT NULL,
    course VARCHAR(100) NOT NULL,
    total_marks INT DEFAULT 0,
    examiner_id INT NOT NULL,
    PRIMARY KEY (exam_id),
    FOREIGN KEY (examiner_id) REFERENCES examiner (examiner_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
CREATE TABLE question (
    question_id INT NOT NULL AUTO_INCREMENT,
    question_body TEXT NOT NULL,
    opt_A TEXT NOT NULL,
    opt_B TEXT NOT NULL,
    opt_C TEXT NOT NULL,
    opt_D TEXT NOT NULL,
    answer CHAR(1) NOT NULL,
    examiner_id INT NOT NULL,
    mark INT NOT NULL,
    PRIMARY KEY (question_id),
    FOREIGN KEY (examiner_id) REFERENCES examiner (examiner_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
CREATE TABLE student_exam (
    student_id INT NOT NULL,
    exam_id INT NOT NULL,
    PRIMARY KEY (student_id, exam_id),
    FOREIGN KEY (student_id) REFERENCES student (student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (exam_id) REFERENCES exam (exam_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
CREATE TABLE exam_question (
    exam_id INT NOT NULL,
    question_id INT NOT NULL,
    PRIMARY KEY (exam_id, question_id),
    FOREIGN KEY (exam_id) REFERENCES exam (exam_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (question_id) REFERENCES question (question_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
CREATE TABLE attempted_answers (
    answer_id INT NOT NULL AUTO_INCREMENT,
    student_id INT NOT NULL,
    exam_id INT NOT NULL,
    question_id INT NOT NULL,
    student_answer CHAR(1) NOT NULL,
    marks_awarded INT DEFAULT 0,
    PRIMARY KEY (answer_id),
    FOREIGN KEY (student_id) REFERENCES student (student_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (exam_id) REFERENCES exam (exam_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (question_id) REFERENCES question (question_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
CREATE TABLE result (
    result_id INT NOT NULL AUTO_INCREMENT,
    student_id INT,
    exam_id INT,
    marks_attained INT,
    grade CHAR(1),
    PRIMARY KEY (result_id),
    FOREIGN KEY (student_id) REFERENCES student (student_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    FOREIGN KEY (exam_id) REFERENCES exam (exam_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

DELIMITER //
CREATE TRIGGER set_marks_awarded
BEFORE INSERT ON attempted_answers
FOR EACH ROW
BEGIN
    DECLARE correct_answer CHAR(1);
    DECLARE question_mark INT;

    -- Retrieve the correct answer and mark for the question
    SELECT answer, mark INTO correct_answer, question_mark
    FROM question
    WHERE question_id = NEW.question_id;

    -- Check if the student's answer matches the correct answer
    IF NEW.student_answer = correct_answer THEN
        SET NEW.marks_awarded = question_mark;
    ELSE
        SET NEW.marks_awarded = 0;  -- Set to 0 if the answer is incorrect
    END IF;
END//
DELIMITER //

CREATE TRIGGER update_total_marks_after_insert
AFTER INSERT ON exam_question
FOR EACH ROW
BEGIN
    DECLARE question_mark INT;

    -- Get the mark for the question being added
    SELECT mark INTO question_mark 
    FROM question 
    WHERE question_id = NEW.question_id;

    -- Update the total_marks in the exam table
    UPDATE exam
    SET total_marks = total_marks + question_mark
    WHERE exam_id = NEW.exam_id;
END;
//

DELIMITER ;
DELIMITER //

CREATE TRIGGER update_total_marks_after_delete
AFTER DELETE ON exam_question
FOR EACH ROW
BEGIN
    DECLARE question_mark INT;

    -- Get the mark for the question being deleted
    SELECT mark INTO question_mark 
    FROM question 
    WHERE question_id = OLD.question_id;

    -- Update the total_marks in the exam table
    UPDATE exam
    SET total_marks = total_marks - question_mark
    WHERE exam_id = OLD.exam_id;
END;
//

DELIMITER ;


DELIMITER ;
DELIMITER //

CREATE TRIGGER update_result_after_attempt
AFTER INSERT ON attempted_answers
FOR EACH ROW
BEGIN
    DECLARE total_marks INT;
    DECLARE current_marks INT;
    DECLARE percentage DECIMAL(5, 2);
    DECLARE calculated_grade CHAR(1);

    -- Get the total marks for the exam
    SELECT total_marks INTO total_marks
    FROM exam
    WHERE exam_id = NEW.exam_id;

    -- Check if there's already a result entry for this student and exam
    IF EXISTS (SELECT 1 FROM result WHERE student_id = NEW.student_id AND exam_id = NEW.exam_id) THEN
        -- Update existing result entry: add the new marks_awarded to current marks_attained
        UPDATE result
        SET marks_attained = marks_attained + NEW.marks_awarded
        WHERE student_id = NEW.student_id AND exam_id = NEW.exam_id;

        -- Get the updated marks_attained for grade calculation
        SELECT marks_attained INTO current_marks
        FROM result
        WHERE student_id = NEW.student_id AND exam_id = NEW.exam_id;

    ELSE
        -- Insert a new result entry if it doesn’t exist
        INSERT INTO result (student_id, exam_id, marks_attained)
        VALUES (NEW.student_id, NEW.exam_id, NEW.marks_awarded);

        -- Set current_marks to marks_awarded for grade calculation
        SET current_marks = NEW.marks_awarded;
    END IF;

    -- Calculate percentage and determine grade
    SET percentage = current_marks / total_marks;

    IF percentage >= 0.9 THEN
        SET calculated_grade = 'S';
    ELSEIF percentage >= 0.8 THEN
        SET calculated_grade = 'A';
    ELSEIF percentage >= 0.7 THEN
        SET calculated_grade = 'B';
    ELSEIF percentage >= 0.6 THEN
        SET calculated_grade = 'C';
    ELSEIF percentage >= 0.5 THEN
        SET calculated_grade = 'D';
    ELSEIF percentage >= 0.4 THEN
        SET calculated_grade = 'E';
    ELSE
        SET calculated_grade = 'F';
    END IF;

    -- Update the grade in the result table
    UPDATE result
    SET grade = calculated_grade
    WHERE student_id = NEW.student_id AND exam_id = NEW.exam_id;

END //

DELIMITER ;
DELIMITER //
CREATE FUNCTION GetTotalQuestions(p_exam_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE question_count INT;

    SELECT COUNT(*) INTO question_count
    FROM exam_question
    WHERE exam_id = p_exam_id;

    RETURN question_count;
END //
DELIMITER ;
DELIMITER //
CREATE FUNCTION GetTotalStudentsInExam(p_exam_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_students INT;

    SELECT COUNT(*) INTO total_students
    FROM student_exam
    WHERE exam_id = p_exam_id;

    RETURN total_students;
END //
DELIMITER ;
DELIMITER //
CREATE FUNCTION GetTotalExamsOfStudent(student_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_exams INT;

    SELECT COUNT(*) INTO total_exams
    FROM student_exam
    WHERE student_id = student_id;

    RETURN total_exams;
END //
DELIMITER ;
DELIMITER //
CREATE PROCEDURE GetCoursesByGrade(IN student_id INT, IN grade CHAR(1))
BEGIN
    SELECT e.course
    FROM exam e
    JOIN result r ON e.exam_id = r.exam_id
    WHERE r.student_id = student_id
    AND r.grade = grade;
END //
DELIMITER ;
DELIMITER //
CREATE PROCEDURE GetCourse_grade_marks(IN student_id INT)
BEGIN
    SELECT e.course
    FROM exam e
    JOIN result r ON e.exam_id = r.exam_id
    WHERE r.student_id = student_id
    AND r.grade = grade;
END //
DELIMITER ;
 
 delimiter //
 create procedure incorrect_answers_by_exam(in student_id INT , in exam_id INT)
     begin 
     select a.question_id from attempted_answers a where a.student_id =student_id and a.exam_id = exam_id
     and marks_awarded = 0;
    end //
delimiter ;
DELIMITER //

CREATE PROCEDURE GetPendingExams(IN student_id INT)
BEGIN
    SELECT e.exam_id, e.course, e.type, e.duration, e.date
    FROM exam e
    WHERE EXISTS (
        SELECT 1
        FROM student_exam se
        WHERE se.student_id = student_id AND se.exam_id = e.exam_id
    )
    AND NOT EXISTS (
        SELECT 1
        FROM result r
        WHERE r.student_id = student_id AND r.exam_id = e.exam_id
    );
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE GetUnassignedQuestions(IN exam_id INT)
BEGIN
    SELECT q.question_id, q.question_body
    FROM question q
    WHERE NOT EXISTS (
        SELECT 1
        FROM exam_question eq
        WHERE eq.exam_id = exam_id AND eq.question_id = q.question_id
    );
END //

DELIMITER ;


