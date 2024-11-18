import streamlit as st
from utils import authenticate_user
import time

def user_login():
    st.title("User Login")
    user_type = st.pills("Select Your Role", ["student", "examiner"])
    user_id = st.text_input("User ID")
    password = st.text_input("Password", type="password")
    if st.sidebar.button("HOME"):
        st.session_state.page = "welcome"
        st.rerun()
    if st.sidebar.button("NEW USER"):
        st.session_state.page = "new_user"
        st.rerun()
    if st.button("Login"):
        if user_type=="student":
          
            if authenticate_user(user_id, password,user_type):
                st.success("Logged in successfully!")
                st.session_state.student_id =user_id
                time.sleep(1)  # Wait for 2 seconds
                st.session_state.page = "student_dashboard"  # Set session state to the student dashboard page
                st.rerun()
            else:
                st.error("Invalid username or password")
        else :
            if authenticate_user(user_id, password,user_type):
                st.success("Logged in successfully!")
                st.session_state.examiner_id =user_id
                # Redirect to examiner dashboard or page after successful login
                time.sleep(1)  # Wait for 2 seconds
                st.session_state.page = "examiner_dashboard"  # Set session state to the student dashboard page
                st.rerun()
            else:
                st.error("Invalid username or password")

