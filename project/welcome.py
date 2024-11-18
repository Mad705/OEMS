import streamlit as st
from student_dashboard import student_view_all_exams

def welcome_page():
    # Display the logo in the top right corner using Streamlit's columns
    col1, col2 = st.columns([6, 2])
    with col1:
           st.markdown("""
        <style>
            .title {
                font-size: 2em;
                font-weight: bold;
                text-align: right;
                color: #333;
                background: linear-gradient(90deg, #5ef7d4, #5ef7d4);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2);
                margin-top: 0;
            }
        </style>
        <h3 class="title">ONLINE EXAMINATION MANAGEMENT SYSTEM</h3>
    """, unsafe_allow_html=True)
    with col2:
        # Display your logo in the top right column
        st.image("123.png", use_container_width=True)  # Replace "123.png" with your logo file path

    # Sidebar button for login
    if st.sidebar.button("LOGIN"):
        st.session_state.page = "user_login"
        st.rerun()
    if st.sidebar.button("ABOUT US"):
        st.session_state.page = "user_login"
        st.rerun()

    # Tile-style display for functionalities
    st.markdown("""
    <style>
        .tile {
            background-color: #309adb;
            padding: 8px;
            margin-bottom: 10px;
            border-radius: 100px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
            font-size: 1.5em;
            font-weight: bold ;
            color:  black;
            width: 100%;
            display: block;
            border: 3px solid #309adb;  /* Border color */
        }
        .tile:hover {
            background-color: white;
            box-shadow: 0px 6px 12px rgba(0, 0, 0, 0.2);
        }
    </style>
    """, unsafe_allow_html=True)

    # Display each feature as a full-width tile in a single column
    tiles = [
        "Create and Schedule Exams",
        "Build and Manage Question Bank",
        "Reuse and Organize Questions",
        "Take Exams Easily Online",
        "View Comprehensive Results",
        "Detailed Performance Analysis"
    ]
    
    for tile in tiles:
        st.markdown(f"<div class='tile'>{tile}</div>", unsafe_allow_html=True)
    st.write("Login to get started")


