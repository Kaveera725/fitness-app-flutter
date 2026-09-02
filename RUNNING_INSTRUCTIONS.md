# 🏋️ FitPulse Fitness App - Setup & Running Instructions

This guide provides step-by-step instructions to set up, configure, and run the **FitPulse Fitness Application** (PostgreSQL Database, FastAPI Backend, and Flutter Frontend).

---

## 📋 Prerequisites

Before starting, ensure you have the following installed on your machine:
- **Flutter SDK** (v3.0 or higher) - [Flutter Installation Guide](https://docs.flutter.dev/get-started/install)
- **Python** (v3.10 or higher) - [Python Download](https://www.python.org/downloads/)
- **PostgreSQL** (v14 or higher) - [PostgreSQL Download](https://www.postgresql.org/download/)
- **Chrome** (for web testing) or **Android Studio / Emulator** (for mobile testing)

---

## 🗄️ 1. Database Setup (PostgreSQL)

1. Make sure your PostgreSQL server is running on `localhost:5432`.
2. Open **pgAdmin** or **psql** command line.
3. Run the following SQL commands to create the user and database:

```sql
-- Create User
CREATE USER fitness_user WITH PASSWORD 'my_strong_password';

-- Create Database
CREATE DATABASE fitness_db OWNER fitness_user;

-- Grant Privileges
GRANT ALL PRIVILEGES ON DATABASE fitness_db TO fitness_user;
\c fitness_db
GRANT ALL ON SCHEMA public TO fitness_user;
```

---


## 🚀 2. Backend Setup (FastAPI)

1. Open a terminal and navigate to the `backend` directory:
   ```bash
   cd backend
   ```

2. Create and activate a Python virtual environment:
   - **Windows (PowerShell):**
     ```powershell
     python -m venv ..\.venv
     ..\.venv\Scripts\Activate.ps1
     ```
   - **macOS / Linux:**
     ```bash
     python3 -m venv ../.venv
     source ../.venv/bin/activate
     ```

3. Install required Python packages:
   ```bash
   pip install fastapi uvicorn sqlalchemy psycopg2-binary bcrypt pydantic[email]
   ```

4. Start the FastAPI backend server:
   ```bash
   uvicorn main:app --reload --host 127.0.0.1 --port 8000
   ```

5. Verify the backend:
   - **API Root / Health:** Open [http://127.0.0.1:8000/health](http://127.0.0.1:8000/health) in your browser.
   - **Interactive Swagger Docs:** Open [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs) to view and test all endpoints.

---

## 📱 3. Frontend Setup (Flutter)

1. Open a new terminal in the project root directory:
   ```bash
   cd c:\Users\anush\OneDrive\Desktop\flutter\fitness
   ```

2. Get all Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application on your desired platform:
   - **Run on Chrome (Web):**
     ```bash
     flutter run -d chrome
     ```
   - **Run on Windows Desktop:**
     ```bash
     flutter run -d windows
     ```
   - **Run on Android Emulator:**
     ```bash
     flutter run -d android
     ```

---

## 👥 4. Default Accounts & User Roles

| Role | Email | Password | Permissions & Features |
| :--- | :--- | :--- | :--- |
| 👑 **Admin** | `admin@gmail.com` | `admin123` | Full access, Admin Control Center, View and change roles of all registered users |
| 🏋️ **Coach** | *Select during Sign Up* | *Your password* | Coach Workspace, Trainee Routines & workout management |
| ⭐ **Premium** | *Select during Sign Up / Upgrade in Profile* | *Your password* | Unlimited workout access, premium badges |
| 🏃 **Member** | *Default on Sign Up* | *Your password* | Standard fitness workouts, one-click upgrade to Premium |

---

## 🌐 5. Network & Platform Configuration

The frontend automatically detects your platform via `lib/services/api_service.dart`:
- **Web & Desktop:** Connects to `http://127.0.0.1:8000`
- **Android Emulator:** Automatically routes to `http://10.0.2.2:8000` (host machine bridge)

---

## 🧪 6. Running Tests

To run automated test suites:
```bash
# Run Flutter tests
flutter test
```
