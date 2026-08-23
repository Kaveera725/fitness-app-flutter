# 🏋️ FitPulse Fitness Application

A full-stack fitness tracking application built with **Flutter**, **FastAPI**, and **PostgreSQL**.

## 📖 Running Instructions
For complete setup, database initialization, and execution instructions, please see:
👉 **[RUNNING_INSTRUCTIONS.md](file:///c:/Users/anush/OneDrive/Desktop/flutter/fitness/RUNNING_INSTRUCTIONS.md)**

## 🚀 Quick Run Summary

### 1. Database
Ensure PostgreSQL is running with database `fitness_db` and user `fitness_user`.

### 2. Backend (FastAPI)
```bash
cd backend
..\.venv\Scripts\Activate.ps1
uvicorn main:app --reload --host 127.0.0.1 --port 8000
```
- API Documentation: `http://127.0.0.1:8000/docs`

### 3. Frontend (Flutter)
```bash
flutter pub get
flutter run -d chrome
```

### 🔑 Pre-Configured Admin Account
- **Email:** `admin@gmail.com`
- **Password:** `admin123`
- **Role:** Admin
