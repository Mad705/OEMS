import streamlit as st
from datetime import datetime
from streamlit_calendar import calendar
from utils import get_exam_date, get_all_exams_1,pre_register,your_exams,register_to_exam,write_exam,untaken_exams,student_answers,unreg_exams,change_password,results_fetch,update_results
import time 

# Funtion to register for exams

def registration_exam():
    st.subheader("Register for exams")
    student_id= st.session_state.get("student_id", None)
    exams = pre_register(student_id)
    today_date = datetime.today().date()
    upcoming_exams = [(exam_id, course, type, duration, date) for exam_id, course, type, duration, date in exams if date >= today_date]

    if not upcoming_exams:
        st.error("No upcoming exams found.")
        return


    
    col1, col2 = st.columns(2)
    
    for i, (exam_id, course, exam_type, duration, date) in enumerate(upcoming_exams):
        with col1 if i % 2 == 0 else col2:
            # Display each exam in a card-style layout
            st.markdown(f"""
            <div style="padding: 15px; background-color: #262730; border-radius: 10px; margin-bottom: 15px; 
                        box-shadow: 0px 4px 8px rgba(255, 255, 255, 0.1); color: #FAFAFA;">
                <h3 style="color: #5ef7d4; text-align: center;">{course.capitalize()} - {exam_type}</h3>
                <p style="text-align: center;"><strong>Date: </strong>{date.strftime('%Y-%m-%d')}</p>
                <p style="text-align: center;"><strong>Duration: </strong>{duration} mins</p>
            </div>
            """, unsafe_allow_html=True)

            # Button functionality placed directly below each styled container
            if st.button(f"Register for {course}", key=f"register_{exam_id}"):
                register_to_exam(student_id,exam_id)
                st.success(f"Registration for {course} successful")
                st.session_state.active_view = "View All Exams"
                st.rerun()


def delete_exams():
    st.subheader("Unregister for exams")
    student_id= st.session_state.get("student_id", None)
    exams=untaken_exams(student_id)
    for i, (exam_id, course, exam_type, duration, date) in enumerate(exams):
            # Display each exam in a card-style layout
            st.markdown(f"""
            <div style="padding: 15px; background-color: #262730; border-radius: 10px; margin-bottom: 15px; 
                        box-shadow: 0px 4px 8px rgba(255, 255, 255, 0.1); color: #FAFAFA;">
                <h3 style="color: #5ef7d4; text-align: center;">{course.capitalize()} - {exam_type}</h3>
                <p style="text-align: center;"><strong>Date: </strong>{date.strftime('%Y-%m-%d')}</p>
                <p style="text-align: center;"><strong>Duration: </strong>{duration} mins</p>
            </div>
            """, unsafe_allow_html=True)

            # Button functionality placed directly below each styled container
            if st.button(f"Unregister for {course}", key=f"register_{exam_id}"):
                unreg_exams(student_id,exam_id)
                st.success(f"Exam deletion for {course} successful")
                st.session_state.active_view = "View All Exams"
                st.rerun()




# Function to view all exams in calendar format
def student_view_all_exams():
    st.subheader("Your Exams")
    st.write("Here is a list of your  exams, both upcoming and completed.")
    student_id= st.session_state.get("student_id", None)
    exams = your_exams(student_id)

    

    events = []  # Will hold all events to show in the calendar

    # Loop through the exams and create events
    for exam in exams:
        event = {
            "title": f"{exam[1]}", 
            "start": exam[4].strftime("%Y-%m-%d"), #.isoformat(),
            "tooltip": f"Duration: {exam[3]}"
            #"end": datetime.strptime(details["date"], "%Y-%m-%d").isoformat(),
            
        }
        events.append(event)


    # Render the calendar
    if events:
        calendar(events=events)
    else:
        st.write("No exams scheduled.")
    for exam in exams:
        if st.button(exam[1]):
            # Display full details for the selected exam
            st.write(f"*Subject*: {exam[1]}")
            st.write(f"*Date*: {exam[4].strftime("%Y-%m-%d")}")
            st.write(f"*Duration*: {exam[3]}")
            # st.write(f"*Status*: {details['status']}")

def display_exam_form(exam_id):
    # Fetch the questions for the given exam
    questions = write_exam(exam_id)
    
    # Use a form to collect responses for the entire exam
    with st.form(key=f"exam_form_{exam_id}"):
        st.header("Exam")
        
        # Create a dictionary to store user responses
        responses = {}
        unanswered_questions = []  # Track unanswered questions

        # Loop through each question and display it with options
        for question in questions:
            st.markdown(f"**{question['question_body'].capitalize()}**")
            options = {
                "A": question['opt_A'],
                "B": question['opt_B'],
                "C": question['opt_C'],
                "D": question['opt_D']
            }
            # Display options as radio buttons
            user_choice = st.radio(
                label="Choose an option",
                options=list(options.keys()),
                format_func=lambda x: f"{x}. {options[x]}",
                key=f"question_{question['question_id']},",
                index=None 
            )
            responses[question['question_id']] = user_choice  # Save user's response
            
            # Check if a response is not selected
            if user_choice == None: 
                unanswered_questions.append(question['question_id'])

        # Submit button to end the exam
        submit = st.form_submit_button("Submit Exam")

        # When the form is submitted
        if submit:
            if unanswered_questions:
                # Show a warning if there are unanswered questions
                st.warning(f"Please answer the following questions: {', '.join(map(str, unanswered_questions))}")
            else:
                st.success("Your exam has been submitted successfully!")
                #st.write("Responses:", responses)
                for q_id in responses:
                    student_id = st.session_state.get("student_id", None)
                    student_answers(student_id,exam_id,q_id,responses[q_id])
                st.session_state.active_view="View All Exams"
                st.session_state["exam_in_progress"]=None

                time.sleep(2)
                st.rerun()
                # Further processing like grading can be done with the `responses` dictionary

def take_exam():


    # Check if there's an exam currently in progress
    if "exam_in_progress" in st.session_state and st.session_state["exam_in_progress"]:
        # Call display_exam_form to show questions for the active exam
        display_exam_form(st.session_state["exam_in_progress"])
        return  # Exit the function to avoid showing other exams while in progress
    st.subheader("Take Exam")
    st.divider()
    # Fetch the list of exams
    student_id = st.session_state.get("student_id", None)
    exams = untaken_exams(student_id)
    today_date = datetime.today().date()
    upcoming_exams = [(exam_id, course, type, duration, date) for exam_id, course, type, duration, date in exams if date >= today_date]

    if not upcoming_exams:
        st.error("No exams found.")
        return

    # Display each upcoming exam with a "Take Exam" button
    for exam_id, title, type, duration, dat in upcoming_exams:
        with st.container():
            st.markdown(f"<h3 style='color:#5ef7d4;'>{title.capitalize()}</h3>", unsafe_allow_html=True)
            st.write(f"Exam ID : {exam_id}")
            st.write(f"Type : {type}")
            st.write(f"Duration : {duration}")

            # Check if today is the exam date
            today = datetime.today().date()
            exam_date = get_exam_date(exam_id)

            if exam_date:
                st.write(f"Scheduled Date: {exam_date.strftime('%Y-%m-%d')}")
            else:
                st.write("Scheduled Date: Not set")

            # Button to start the exam
            if st.button(f"Take Exam", key=exam_id):
                if exam_date and today == exam_date:
                    st.success("You are allowed to take the exam today!")
                    st.session_state["exam_in_progress"] = exam_id  # Set flag for the current exam
                    st.rerun()  # Refresh to show the exam form instead of exam list
                elif exam_date and exam_date > today:
                    st.error("You can only take this exam on the scheduled date.")
                    st.info(f"The exam is scheduled for: {exam_date.strftime('%Y-%m-%d')}")
        st.divider()



# Function to view results (stub for now)
def student_view_results():
    st.subheader("View Exam Results")
    student_id = st.session_state.get("student_id", None)
    results=results_fetch(student_id)
    results_table = []
    for result in results:
        update_results(result["result_id"])

        results_table.append({
            "Result ID": result["result_id"],
            "Course": result["course"].capitalize(),  # Capitalizing course name
            "Marks": f"{result['marks_attained']}/{result['total_marks']}",
            "Grade": result["grade"],
            "Date": result["date"],
        })
    
    # Display results in a table
    st.table(results_table)

def reset_password():
    with st.form(key="reset"):
        st.subheader("Reset password")
        old_password=st.text_input("Enter Your Old Password")
        new_password=st.text_input("Enter Your New Password")
        change_pass= st.form_submit_button(label="Change password")

        if change_pass:
            if old_password and new_password:
                student_id= st.session_state.get("student_id", None)
                res=change_password(student_id,"student",new_password,old_password)
                if res=="Password changed succesfully":
                    st.success("Password changed successfully , You can login now ")
                    time.sleep(1)
                    st.session_state.page = "welcome"
                    st.rerun()
                else :
                    st.warning(res)
            else :
                st.error("Please fill in all fields.")
                







# Main student dashboard function
def student_dashboard():
    st.title("Student Dashboard")
    st.sidebar.subheader("Dashboard Options")
    if "active_view" not in st.session_state:
        st.session_state.active_view = "View All Exams"

    # Navigation options in the sidebar
    # option = st.sidebar.button("Choose an Option", ["Take Exam", "View All Exams", "View Results"])
    
    # Create buttons for each option

    if st.sidebar.button("Logout"):
        st.session_state.page="welcome"
    if st.sidebar.button("Reset password"):
        st.session_state.active_view = "reset"
    if st.sidebar.button("Your exams"):
        st.session_state.active_view = "View All Exams"
    if st.sidebar.button("Exam Registration"):
        st.session_state.active_view = "Exam Registration"
    if st.sidebar.button("Delete Exams"):
        st.session_state.active_view = "delete exams"
    if st.sidebar.button("Take Exam"):
        st.session_state.active_view = "Take Exam"
    if st.sidebar.button("View Results"):
        st.session_state.active_view = "View Results"


    # Show the corresponding section based on the button click
    if st.session_state.active_view == "View All Exams":
        student_view_all_exams()   
    elif st.session_state.active_view == "Take Exam":
        take_exam()
    elif st.session_state.active_view == "reset":
        reset_password()

    elif st.session_state.active_view == "View Results":
        student_view_results()
    elif st.session_state.active_view == "Exam Registration":
        registration_exam()
    elif st.session_state.active_view == "delete exams":
        delete_exams()
    
    


