import streamlit as st
from utils import new_user
import time

def register():
    st.title("User Registration")

    # Form fields
    user_type = st.pills("Select Your Role", ["student", "examiner"])
    username = st.text_input("User ID (e.g., Student ID or Examiner ID)")
    name = st.text_input("Name")
    email = st.text_input("Email")
    password = st.text_input("Password", type="password")

    if st.button("Register"):
        if username and name and email and password:
            result = new_user(username, password, user_type, email, name)
            if result == "User created successfully.":
                st.success("User created successfully , You can login now ")
                time.sleep(1)
                st.session_state.page = "welcome"
                st.rerun()


            else:
                st.warning(result)
        else:
            st.error("Please fill in all fields.")
    if st.sidebar.button("HOME"):
        st.session_state.page = "welcome"
        st.rerun()