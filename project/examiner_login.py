import streamlit as st
from utils import authenticate_user
import time
def examiner_login():
    st.title("Examiner Login")
    examiner_id = st.text_input("Examiner ID")
    password = st.text_input("Password", type="password")
    
    if st.button("Login"):
        if authenticate_user(examiner_id, password,"examiner"):
            st.success("Logged in successfully!")
            st.session_state.examiner_id = examiner_id
            # Redirect to examiner dashboard or page after successful login
            time.sleep(2)  # Wait for 2 seconds
            st.session_state.page = "examiner_dashboard"  # Set session state to the student dashboard page
            st.rerun()
        else:
            st.error("Invalid username or password")
    # Go back to welcome page
    if st.button("Back to Welcome"):
        st.session_state.page = "welcome"
        st.rerun()
