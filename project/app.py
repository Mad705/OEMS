import streamlit as st
from welcome import welcome_page
from user_login import user_login
from student_dashboard import student_dashboard
from examiner_dashboard import examiner_dashboard
from register import register

def main():
    # Initialize session state for page if not already set
    if 'page' not in st.session_state:
        st.session_state.page = "welcome"

    # Conditional rendering based on the selected page
    if st.session_state.page == "welcome":
        welcome_page()
    elif st.session_state.page == "user_login":
        user_login()
 
    elif st.session_state.page == "student_dashboard":
        student_dashboard()
    elif st.session_state.page == "new_user":
        register()
    elif st.session_state.page == "examiner_dashboard":
        examiner_dashboard()

if __name__ == "__main__":
    main()
