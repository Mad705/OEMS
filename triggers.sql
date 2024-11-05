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

DELIMITER ;
