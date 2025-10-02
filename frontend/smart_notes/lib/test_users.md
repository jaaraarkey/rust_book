# 🧪 Test Users for Smart Notes

The app includes predefined test users for development and testing purposes.

## 📋 Available Test Users

### User 1: John Doe
- **Email**: `john@example.com`
- **Password**: `password123`
- **Full Name**: John Doe
- **User ID**: user-001
- **Created**: January 15, 2024

### User 2: Jane Smith
- **Email**: `jane@example.com`
- **Password**: `secret456`
- **Full Name**: Jane Smith
- **User ID**: user-002
- **Created**: February 20, 2024

### User 3: Admin User
- **Email**: `admin@smartnotes.com`
- **Password**: `admin123`
- **Full Name**: Admin User
- **User ID**: user-003
- **Created**: January 1, 2024

### User 4: Alice Johnson
- **Email**: `alice@test.com`
- **Password**: `test123`
- **Full Name**: Alice Johnson
- **User ID**: user-004
- **Created**: March 10, 2024

## 🔧 How to Test

### Method 1: Use Predefined Test Users
1. Open the app in your browser
2. Use any of the email/password combinations above
3. **Exact password required** - wrong password will show "Invalid email or password"

### Method 2: Use Any Other Credentials
- Any other email/password combination will work (both fields must be non-empty)
- Will create a temporary user with the provided email

## 🎯 Testing Scenarios

### Authentication Flow
```
✅ Valid test user login → Success with correct user data
❌ Wrong password for test user → "Invalid email or password"
✅ New email/password → Success with temporary user
✅ Empty fields → Form validation error
```

### User Persistence
- Test users maintain consistent IDs and data across sessions
- Temporary users get new IDs each login
- All users can access the full app functionality

### Development vs Production
- **Development Mode**: Uses mock authentication with predefined users
- **Production Mode**: Would connect to actual Rust GraphQL backend
- Switch by enabling/disabling the mock authentication logic in `auth_service.dart`

## 🚀 Quick Test Commands

Open app and try:
1. `john@example.com` / `password123` ← Predefined user
2. `admin@smartnotes.com` / `admin123` ← Admin user
3. `test@myemail.com` / `anypassword` ← Temporary user
4. `alice@test.com` / `wrongpassword` ← Should fail
