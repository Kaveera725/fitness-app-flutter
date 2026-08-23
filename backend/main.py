from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from sqlalchemy import text
from typing import List
import bcrypt

import models
import schemas
from database import engine, get_db

# Create all tables in the database and ensure role column exists
models.Base.metadata.create_all(bind=engine)
try:
    with engine.connect() as conn:
        conn.execute(text("ALTER TABLE users ADD COLUMN IF NOT EXISTS role VARCHAR(50) DEFAULT 'user';"))
        conn.commit()
except Exception as e:
    print(f"Migration note: {e}")

app = FastAPI(title="FitPulse Fitness API")

# Enable CORS for Flutter web, mobile, and desktop clients
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

def get_password_hash(password: str) -> str:
    salt = bcrypt.gensalt()
    return bcrypt.hashpw(password.encode("utf-8"), salt).decode("utf-8")

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return bcrypt.checkpw(plain_password.encode("utf-8"), hashed_password.encode("utf-8"))

@app.get("/")
def read_root(db: Session = Depends(get_db)):
    return {
        "status": "online",
        "message": "Database connected and FitPulse API is running successfully!"
    }

@app.get("/health")
def health_check(db: Session = Depends(get_db)):
    return {"status": "healthy", "database": "connected"}

@app.post("/signup", response_model=schemas.UserResponse, status_code=status.HTTP_201_CREATED)
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    db_user = db.query(models.User).filter(models.User.email == user.email).first()
    if db_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered"
        )
    
    hashed_password = get_password_hash(user.password)
    user_role = (user.role or "user").lower().strip()
    if user_role not in ["user", "coach", "admin", "premium"]:
        user_role = "user"

    new_user = models.User(
        name=user.name,
        email=user.email,
        hashed_password=hashed_password,
        role=user_role
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user

@app.post("/login", response_model=schemas.LoginResponse)
def login(user: schemas.UserLogin, db: Session = Depends(get_db)):
    db_user = db.query(models.User).filter(models.User.email == user.email).first()
    if not db_user or not verify_password(user.password, db_user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password"
        )
    return {
        "message": "Login successful",
        "user_id": db_user.id,
        "email": db_user.email,
        "name": db_user.name,
        "role": db_user.role or "user"
    }

@app.get("/users", response_model=List[schemas.UserResponse])
def get_all_users(db: Session = Depends(get_db)):
    users = db.query(models.User).all()
    return users

@app.patch("/users/{user_id}/role", response_model=schemas.UserResponse)
def update_user_role(user_id: int, role_data: schemas.UserRoleUpdate, db: Session = Depends(get_db)):
    db_user = db.query(models.User).filter(models.User.id == user_id).first()
    if not db_user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    
    new_role = role_data.role.lower().strip()
    if new_role not in ["user", "coach", "admin", "premium"]:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Invalid role specified")
    
    db_user.role = new_role
    db.commit()
    db.refresh(db_user)
    return db_user

@app.post("/upgrade-premium", response_model=schemas.UserResponse)
def upgrade_premium(data: dict, db: Session = Depends(get_db)):
    user_id = data.get("user_id")
    if not user_id:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="user_id is required")
    db_user = db.query(models.User).filter(models.User.id == user_id).first()
    if not db_user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    
    db_user.role = "premium"
    db.commit()
    db.refresh(db_user)
    return db_user

