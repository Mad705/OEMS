# OEMS - Online Examination Management System

A database-backed web application to manage online examinations, built using Python, Streamlit, and MySQL. The system allows students and examiners to interact with features like exam creation, question banks, exam participation, and result viewing.

---

## 🚀 Features

### 👨‍🏫 Examiner:
- Secure login for examiners
- Add questions to the **question bank**
- Create new **exams**
- Add specific questions to individual exams
- View all exams

### 👨‍🎓 Student:
- Secure student login
- View all available exams
- Attempt exams
- View exam results

---

## 🛠️ Tech Stack

- **Frontend:** Streamlit
- **Backend:** Python
- **Database:** MySQL

---

## 📦 Installation & Setup

### 1. Clone the Repository

```bash
git clone https://github.com/Mad705/OEMS.git
cd OEMS
```

### 2. Set Up Python Environment

Make sure Python 3.8+ is installed.

```bash
pip install -r requirements.txt
```

> If `requirements.txt` is missing, install dependencies manually:
```bash
pip install streamlit mysql-connector-python
```

### 3. Set Up MySQL Database

- Import the `schema.sql` file into your MySQL database (if available).
- Update your MySQL username and password in the `db.py` file:

```python
# db.py
mydb = mysql.connector.connect(
    host="localhost",
    user="your_mysql_username",        # <-- change this
    password="your_mysql_password",    # <-- change this
    database="your_database_name"
)
```

Make sure the required database and tables are created before starting the app.

---

## ▶️ Run the Application

Launch the application with the following command:

```bash
streamlit run app.py
```

This will open the OEMS web interface in your default browser.

---

## 📸 Screenshots

_Add screenshots of:_
- Examiner dashboard
- Question bank interface
- Exam participation view
- Results page

---

## 🤝 Contributing

Contributions are welcome! If you'd like to improve or extend this project, feel free to fork the repo and submit a pull request.

---

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

---

## 📬 Contact

For queries, bugs, or suggestions, open an issue on the GitHub repository:  
[https://github.com/Mad705/OEMS/issues](https://github.com/Mad705/OEMS/issues)
