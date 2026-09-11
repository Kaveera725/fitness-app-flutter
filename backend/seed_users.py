"""
Seed script to create or update development users: Coach, Premium Member, and Member.
Can be executed with:
python seed_users.py
"""

import bcrypt
import models
from database import SessionLocal, engine

# Ensure tables exist
models.Base.metadata.create_all(bind=engine)

def get_password_hash(password: str) -> str:
    salt = bcrypt.gensalt()
    return bcrypt.hashpw(password.encode("utf-8"), salt).decode("utf-8")

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return bcrypt.checkpw(plain_password.encode("utf-8"), hashed_password.encode("utf-8"))

DEV_USERS = [
    {
        "name": "Coach",
        "email": "coach@gmail.com",
        "password": "coach123",
        "role": "coach"
    },
    {
        "name": "Premium Member",
        "email": "premium@gmail.com",
        "password": "premium123",
        "role": "premium"
    },
    {
        "name": "Member",
        "email": "member@gmail.com",
        "password": "member123",
        "role": "user"
    }
]

def seed_users():
    db = SessionLocal()
    print("Seeding development users into database...")
    try:
        for user_info in DEV_USERS:
            email = user_info["email"]
            name = user_info["name"]
            password = user_info["password"]
            role = user_info["role"]
            
            existing = db.query(models.User).filter(models.User.email == email).first()
            hashed_pwd = get_password_hash(password)
            
            if existing:
                existing.name = name
                existing.hashed_password = hashed_pwd
                existing.role = role
                print(f"[UPDATED] {name} ({email}) -> Role: {role}")
            else:
                new_user = models.User(
                    name=name,
                    email=email,
                    hashed_password=hashed_pwd,
                    role=role
                )
                db.add(new_user)
                print(f"[CREATED] {name} ({email}) -> Role: {role}")
        
        db.commit()
        print("\nAll development users successfully saved in database!")
        
        # Verify logins
        print("\nVerifying credentials:")
        for user_info in DEV_USERS:
            db_user = db.query(models.User).filter(models.User.email == user_info["email"]).first()
            is_valid = verify_password(user_info["password"], db_user.hashed_password)
            print(f"- {user_info['name']}: email={db_user.email}, role={db_user.role}, password_valid={is_valid}")
            
    except Exception as e:
        db.rollback()
        print(f"Error seeding users: {e}")
        raise
    finally:
        db.close()

if __name__ == "__main__":
    seed_users()
