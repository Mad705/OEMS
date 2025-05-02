import mysql.connector
from mysql.connector import Error

def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="enter your password here ",
        database="oems"
    )
def get_db_connection_student():
    return mysql.connector.connect(
        host="localhost",
        user="student1",
        password="student1",
        database="oems"
    )
def get_db_connection_examiner():
    return mysql.connector.connect(
        host="localhost",
        user="examiner1",
        password="examiner1",
        database="oems"
    )
def get_exam_date(exam_id):
    conn = get_db_connection()
    if conn is None:
        print("Failed to get a connection in get_exam_date.")
        return None

    try:
        cursor = conn.cursor()
        query = "SELECT date FROM exam WHERE exam_id = %s"
        cursor.execute(query, (exam_id,))
        result = cursor.fetchone()
        
        if result:
            return result[0]  # Directly return the datetime.date object
        else:
            return None
    except Error as e:
        print("Error while fetching exam date:", e)
        return None
    finally:
        cursor.close()
        conn.close()  # Return the connection to the pool
def authenticate_user(username, password, user_type):


    table = "student" if user_type == "student" else "examiner"
    if table=="student":
        conn = get_db_connection_student()
        cursor = conn.cursor(dictionary=True)
    else :
        conn = get_db_connection_examiner()
        cursor = conn.cursor(dictionary=True)       
    id = "student_id" if user_type == "student" else "examiner_id"
    query = f"SELECT * FROM {table} WHERE {id} = %s AND password = %s"
    cursor.execute(query, (username, password))
    user = cursor.fetchone()
    cursor.close()
    conn.close()
    return user is not None

def new_user(username, password, user_type, email, name):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    table = "student" if user_type == "student" else "examiner"
    id_column = "student_id" if user_type == "student" else "examiner_id"
    
    # Check if the user already exists
    check_query = f"SELECT * FROM {table} WHERE {id_column} = %s"
    cursor.execute(check_query, (username,))
    user_exists = cursor.fetchone()
    
    if user_exists:
        cursor.close()
        conn.close()
        return "User already exists."
    
    # Insert new user if they do not exist
    insert_query = f"INSERT INTO {table}  VALUES (%s, %s, %s, %s)"
    cursor.execute(insert_query, (username, name, email, password))
    conn.commit()
    
    cursor.close()
    conn.close()
    return "User created successfully."

def add_question(q_body, opt_a, opt_b, opt_c, opt_d, answer, examiner_id, marks):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    insert_query = """
    INSERT INTO question (question_body, opt_A, opt_B, opt_C, opt_D, answer, examiner_id, mark)
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
    """
    # Pass values as a tuple to avoid syntax issues
    cursor.execute(insert_query, (q_body, opt_a, opt_b, opt_c, opt_d, answer, examiner_id, marks))
    conn.commit()
    cursor.close()
    conn.close()
    return "Question created successfully."
def get_all_questions(exam_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    query="""
    call getunassignedquestions(%s);
"""
    cursor.execute(query,(exam_id,))
    questions=cursor.fetchall()
    cursor.close()
    conn.close()
    return questions
def get_all_exams():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    query="select exam_id,course from exam"
    cursor.execute(query)
    exams_list=cursor.fetchall()
    cursor.close()
    conn.close()
    return exams_list
def get_all_exams_1():
    conn = get_db_connection()
    if conn is None:
        print("Failed to get a connection in get_all_exams.")
        return []
    
    try:
        cursor = conn.cursor()
        query = "SELECT exam_id, course, type, duration,date FROM exam"
        cursor.execute(query)
        exams = cursor.fetchall()
        return exams
    except Error as e:
        print("Error while fetching exams:", e)
        return []
    finally:
        cursor.close()
        conn.close()  # Return the connection to the pool

def view_all_exams():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    query="select * from exam"
    cursor.execute(query)
    exams_list=cursor.fetchall()
    cursor.close()
    conn.close()
    return exams_list
def add_question_to_exam(exam_id,question_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    query = "insert into exam_question values(%d, %d)" % (exam_id, question_id)
    cursor.execute(query)
    conn.commit()
    cursor.close()
    conn.close()
    return "success"

def add_exam(exam_id,exam_type,date,duration,course,examiner_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    table="exam"
    check_query = f"SELECT * FROM {table} WHERE exam_id = %s"
    cursor.execute(check_query, (exam_id,))
    exam_exists = cursor.fetchone()
    
    if exam_exists:
        cursor.close()
        conn.close()
        return "exam already exists."
    insert_query = f"INSERT INTO {table} (exam_id,type,date,duration,course,examiner_id) VALUES (%s, %s, %s, %s, %s, %s)"
    cursor.execute(insert_query, (exam_id, exam_type, date, duration,course,examiner_id))
    conn.commit()
    
    cursor.close()
    conn.close()
    return "Exam created successfully."
def pre_register(student_id):
    conn = get_db_connection()
    if conn is None:
        print("Failed to get a connection in get_all_exams.")
        return []
    
    try:
        cursor = conn.cursor()
        query = """
            SELECT e.exam_id, e.course, e.type, e.duration, e.date
            FROM exam e
            WHERE NOT EXISTS (
                SELECT 1
                FROM student_exam se
                WHERE se.student_id = %s AND se.exam_id = e.exam_id
            )
        """        
        cursor.execute(query, (student_id,))  # Ensure student_id is passed as a tuple
        exams = cursor.fetchall()
        return exams
    except Error as e:
        print("Error while fetching exams:", e)
        return []
    finally:
        cursor.close()
        conn.close()  # Ensure connection is closed
def your_exams(student_id):
    conn = get_db_connection()
    if conn is None:
        print("Failed to get a connection in get_all_exams.")
        return []
    
    try:
        cursor = conn.cursor()
        query = """
            SELECT e.exam_id, e.course, e.type, e.duration, e.date
            FROM exam e
            WHERE EXISTS (
                SELECT 1
                FROM student_exam se
                WHERE se.student_id = %s AND se.exam_id = e.exam_id
            )
        """        
        cursor.execute(query, (student_id,))  # Ensure student_id is passed as a tuple
        exams = cursor.fetchall()
        return exams
    except Error as e:
        print("Error while fetching exams:", e)
        return []
    finally:
        cursor.close()
        conn.close()  # Ensure connection is closed

def register_to_exam(student_id,exam_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    table="student_exam"
    insert_query = f"INSERT INTO {table} VALUES (%s, %s)"
    cursor.execute(insert_query, (student_id,exam_id,))
    conn.commit()
    
    cursor.close()
    conn.close()
    return "You have registered successfully."
def write_exam(exam_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    query=f"select * from question q join exam_question eq on eq.question_id = q.question_id where eq.exam_id = {exam_id}"
    cursor.execute(query)
    q_list=cursor.fetchall()
    cursor.close()
    conn.close()
    return q_list

def untaken_exams(student_id):
    conn = get_db_connection()
    if conn is None:
        print("Failed to get a connection in get_all_exams.")
        return []
    
    try:
        cursor = conn.cursor()
        query = """
    call getpendingexams(%s)
        """        
        cursor.execute(query, (student_id,))  # Ensure student_id is passed as a tuple
        exams = cursor.fetchall()
        return exams
    except Error as e:
        print("Error while fetching exams:", e)
        return []
    finally:
        cursor.close()
        conn.close()  # Ensure connection is closed

def student_answers(student_id,exam_id,questions_id,student_answer):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    table="attempted_answers"
    insert_query = f"INSERT INTO {table} (student_id,exam_id,question_id,student_answer) VALUES (%s, %s, %s, %s)"
    cursor.execute(insert_query, (student_id,exam_id,questions_id,student_answer,))
    conn.commit()
    
    cursor.close()
    conn.close()
    return "You have registered successfully."

def unreg_exams(student_id,exam_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    table="student_exam"
    delete_query = f"delete from {table} where student_id = %s and exam_id = %s"
    cursor.execute(delete_query, (student_id,exam_id,))
    conn.commit()
    
    cursor.close()
    conn.close()
    return "You have Unregistered successfully."
def change_password(user_id,user_type,new_password,old_password):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    table="student" if user_type=="student" else "examiner"
    id = "student_id" if user_type == "student" else "examiner_id"
    check_query=f"select * from {table} where {id} = %s and password = %s"
    cursor.execute(check_query,(user_id,old_password,))
    usr=cursor.fetchone()
    if usr:
        update_query=f"update {table} set password=%s  where {id}=%s "
        cursor.execute(update_query,(new_password,user_id,))
        conn.commit()
        cursor.close()
        conn.close()
        return "Password changed succesfully"
    else :
        return "Old password incorrect"


def results_fetch(student_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    query="select * from result r join exam e on r.exam_id = e.exam_id where r.student_id=%s"
    cursor.execute(query,(student_id,))
    results= cursor.fetchall()
    return results

def update_results(result_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    try:
        # Step 1: Get the total marks and marks attained for the given result_id
        cursor.execute("""
            SELECT e.total_marks, r.marks_attained
            FROM result r
            JOIN exam e ON r.exam_id = e.exam_id
            WHERE r.result_id = %s
        """, (result_id,))
        
        result = cursor.fetchone()
        
        if result:
            total_marks = result['total_marks']
            marks_attained = result['marks_attained']
            
            # Step 2: Calculate the percentage
            percentage = (marks_attained / total_marks) * 100
            
            # Step 3: Determine the grade based on the percentage
            if percentage >= 90:
                grade = 'S'
            elif percentage >= 80:
                grade = 'A'
            elif percentage >= 70:
                grade = 'B'
            elif percentage >= 60:
                grade = 'C'
            elif percentage >= 50:
                grade = 'D'
            elif percentage >= 40:
                grade = 'E'
            else:
                grade = 'F'
            
            # Step 4: Update the grade in the result table
            cursor.execute("""
                UPDATE result
                SET grade = %s
                WHERE result_id = %s
            """, (grade, result_id))
            
            # Commit the transaction
            conn.commit()
            print(f"Result updated: Grade '{grade}' assigned based on {percentage:.2f}%")
        
        else:
            print(f"No result found for result_id: {result_id}")
    
    except mysql.connector.Error as err:
        print(f"Error: {err}")
    
    finally:
        cursor.close()
        conn.close()
    
def total_students(exam_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    query="select GetTotalStudentsInExam(%s)"
    cursor.execute(query,(exam_id,))
    texams=cursor.fetchone()
    return texams

def total_questions(exam_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    query="select GetTotalQuestions(%s)"
    cursor.execute(query,(exam_id,))
    texams=cursor.fetchone()
    return texams


    

