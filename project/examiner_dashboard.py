import streamlit as st
import time
from utils import add_question, add_exam, get_all_questions, add_question_to_exam, get_all_exams, view_all_exams,change_password,total_students,total_questions

def examiner_dashboard():
    st.title("Examiner Dashboard")

    # Set the default view_exams state to True only if it's the first load
    # Check and set default states for the session
    if "view_exams" not in st.session_state:
        st.session_state.view_exams = False
    if "show_question_form" not in st.session_state:
        st.session_state.show_question_form = False
    if "show_exam_form" not in st.session_state:
        st.session_state.show_exam_form = False
    if "show_add_to_exam_form" not in st.session_state:
        st.session_state.show_add_to_exam_form = False    
    if "reset" not in st.session_state:
        st.session_state.reset = False

    # Set view_exams to True only if all other flags are False
    if not st.session_state.show_question_form and not st.session_state.show_exam_form and not st.session_state.show_add_to_exam_form and not st.session_state.reset:
        st.session_state.view_exams = True

    # Sidebar buttons
    if st.sidebar.button("Logout"):
        st.session_state.page = "welcome"
        st.session_state.view_exams = False
        st.session_state.show_question_form = False
        st.session_state.show_exam_form = False
        st.session_state.show_add_to_exam_form = False
        st.session_state.reset = False
        st.rerun()
    if st.sidebar.button("Reset Password"):
        st.session_state.reset = True
        st.session_state.view_exams = False
        st.session_state.show_question_form = False
        st.session_state.show_exam_form = False
        st.session_state.show_add_to_exam_form = False
        st.rerun()
    
    if st.sidebar.button("All Exams"):
        st.session_state.view_exams = True
        st.session_state.show_add_to_exam_form = False
        st.session_state.show_exam_form = False
        st.session_state.show_question_form = False
        st.session_state.reset = False
        st.rerun()

    if st.sidebar.button("Add Question"):
        st.session_state.show_question_form = True
        st.session_state.view_exams = False
        st.session_state.show_add_to_exam_form = False
        st.session_state.show_exam_form = False
        st.session_state.reset = False
        st.rerun()

    if st.sidebar.button("Create Exam"):
        st.session_state.show_exam_form = True
        st.session_state.view_exams = False
        st.session_state.show_question_form = False
        st.session_state.show_add_to_exam_form = False
        st.session_state.reset = False
        st.rerun()

    if st.sidebar.button("Add Questions to Exam"):
        st.session_state.show_add_to_exam_form = True
        st.session_state.view_exams = False
        st.session_state.show_question_form = False
        st.session_state.show_exam_form = False
        st.session_state.reset = False
        st.rerun()

    # Display Exams list first if view_exams is True
    if st.session_state.view_exams:
        all_exams = view_all_exams()
        st.markdown("### All Exams")
        st.write("---")
        col1, col2 = st.columns(2)
        
        for i, exam in enumerate(all_exams):
            exam_result = total_students(exam['exam_id'])
            texams = list(exam_result.values())[0] 
            exam_q = total_questions(exam['exam_id'])
            tq = list(exam_q.values())[0] 
            with col1 if i % 2 == 0 else col2:
                st.markdown(f"""
                <div style="padding: 15px; background-color: #262730; border-radius: 10px; margin-bottom: 15px; 
                            box-shadow: 0px 4px 8px rgba(255, 255, 255, 0.1); color: #FAFAFA;">
                    <h3 style="color: #5ef7d4; text-align: center;">{exam['course'].capitalize()}  ({exam['type']}) </h3>
                    <p style="text-align: center;"><strong>Date :   </strong> {exam['date']}</p>
                    <p style="text-align: center;"><strong>Total Questions :   </strong> {tq}</p>
                    <p style="text-align: center;"><strong>Duration :   </strong> {exam['duration']} mins</p>
                    <p style="text-align: center;"><strong>Total Marks :   </strong> {exam['total_marks']}</p>
                    <p style="text-align: center;"><strong>Examiner ID :   </strong> {exam['examiner_id']}</p>
                    <p style="text-align: center;"><strong>Total students :   </strong> {texams}</p>
                </div>
                """, unsafe_allow_html=True)

    if st.session_state.reset:
        with st.form(key="reset_password"):
            st.subheader("Reset password")
            old_password=st.text_input("Enter Your Old Password")
            new_password=st.text_input("Enter Your New Password")
            change_pass= st.form_submit_button(label="Change password")

            if change_pass:
                if old_password and new_password:
                    student_id= st.session_state.get("examiner_id", None)
                    res=change_password(student_id,"examiner",new_password,old_password)
                    if res=="Password changed succesfully":
                        st.success("Password changed successfully , You can login now ")
                        time.sleep(1)
                        st.session_state.page = "welcome"
                        st.rerun()
                    else :
                        st.warning(res)
                else :
                    st.error("Please fill in all fields.")

    # Display forms conditionally, ensuring they appear only when their respective states are True
    if st.session_state.show_question_form:
        with st.form(key="question_form"):
            st.subheader("Add Question")
            body = st.text_area("Question body")
            opt_a = st.text_area("Option - A")
            opt_b = st.text_area("Option - B")
            opt_c = st.text_area("Option - C")
            opt_d = st.text_area("Option - D")
            ans = st.text_area("Correct option")
            examiner_id = st.session_state.get("examiner_id", None)
            mark = st.number_input("Marks", value=1, step=1)

            submit_question = st.form_submit_button(label="Submit")

            if submit_question:
                if body and opt_a and opt_b and opt_c and opt_d and ans and examiner_id is not None and mark:
                    add_question(body, opt_a, opt_b, opt_c, opt_d, ans, examiner_id, mark)
                    st.success("Question submitted successfully!")
                    time.sleep(2)
                    st.session_state.show_question_form = False
                    st.session_state.view_exams = True
                    st.rerun()
                else:
                    st.error("Please fill in all fields before submitting.")

    if st.session_state.show_add_to_exam_form:
        with st.form(key="add_to_exam_form"):
            st.subheader("Add Questions to Exam")
            exam_list = get_all_exams()
            course_exam = {e['course']: e['exam_id'] for e in exam_list}

            courses = st.selectbox("Select Exam ID to Add Questions", options=course_exam.keys())
            exam_id = course_exam[courses]
            
            questions = get_all_questions(exam_id)
            question_options = {q['question_body']: q['question_id'] for q in questions}
            selected_questions = st.multiselect("Select Questions to Add", options=question_options.keys())
            selected_question_ids = [question_options[q] for q in selected_questions]

            submit_add_questions = st.form_submit_button(label="Add to Exam")

        if submit_add_questions:
            if exam_id and selected_question_ids:
                # Add selected questions to the exam
                for q_id in selected_question_ids:
                    add_question_to_exam(exam_id, int(q_id))
                st.success(f"Questions added to Exam {courses} successfully!")
                time.sleep(2)
                
                # Hide the add-to-exam form and show the view exams list
                st.session_state.show_add_to_exam_form = False
                st.session_state.view_exams = True
                st.rerun()  # Refresh the page to reflect the changes
            else:
                # If no questions are selected, show an error and keep the form visible
                st.error("Please select an exam ID and at least one question.")



    if st.session_state.show_exam_form:
        with st.form(key="exam_form"):
            st.subheader("Create Exam")
            exam_id = st.text_input("Exam ID")
            exam_type = st.radio("Exam Type", options=["ISA", "ESA"], horizontal=True)
            exam_date = st.date_input("Exam Date")
            duration = st.number_input("Duration (minutes)", min_value=1, step=1)
            course_name = st.text_input("Course Name")

            submit_exam = st.form_submit_button(label="Create Exam")
            examiner_id = st.session_state.get("examiner_id", None)
            if submit_exam:
                if exam_id and exam_type and exam_date and duration and course_name:
                    result = add_exam(exam_id, exam_type, exam_date, duration, course_name, examiner_id)
                    if result == "Exam created successfully.":
                        st.success("Exam created successfully")
                        time.sleep(2)
                        st.session_state.show_exam_form = False
                        st.session_state.view_exams = True
                        st.rerun()
                    else:
                        st.warning(result)
                else:
                    st.error("Please fill in all fields before submitting.")
