from pydantic import BaseModel, EmailStr
from typing import Optional

class UserCreate(BaseModel):
    name: Optional[str] = None
    email: EmailStr
    password: str
    role: Optional[str] = "user"

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class UserResponse(BaseModel):
    id: int
    name: Optional[str] = None
    email: EmailStr
    role: str = "user"

    class Config:
        from_attributes = True

class LoginResponse(BaseModel):
    message: str
    user_id: int
    email: EmailStr
    name: Optional[str] = None
    role: str = "user"

class UserRoleUpdate(BaseModel):
    role: str

