import streamlit as st
from utils import authenticate_user
import time

def student_login():
    st.title("Student Login")
    
    student_id = st.text_input("Student ID")
    password = st.text_input("Password", type="password")
   
    if st.button("Login"):
        if authenticate_user(student_id, password,"student"):
            st.success("Logged in successfully!")
            time.sleep(2)  # Wait for 2 seconds
            st.session_state.page = "student_dashboard"  # Set session state to the student dashboard page
            st.rerun()
        else:
            st.error("Invalid username or password")


    # Go back to welcome page
    if st.button("Back to Welcome"):
        st.session_state.page = "welcome"
        st.rerun()
        

