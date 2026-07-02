# LearnSphere — Full-Stack E-Learning Platform

A production-grade, Byju's-inspired learning platform built for **students** and **homemakers** to master new skills through expert-led courses.

## Tech Stack

| Layer      | Technology              |
|------------|-------------------------|
| Frontend   | React 19 + Vite 6       |
| Backend    | Node.js + Express 4     |
| Database   | MySQL 8 (mysql2)        |
| Auth       | JWT + bcryptjs          |
| Security   | Helmet, CORS, Rate Limiting |

## Project Structure

```
learnsphere/
├── backend/
│   ├── config/db.js            ← MySQL connection pool
│   ├── controllers/            ← Business logic (auth, courses, enrollments, users, categories)
│   ├── middleware/              ← JWT auth, error handler
│   ├── routes/                  ← Express route definitions
│   ├── utils/helpers.js         ← Password hashing, token utils
│   ├── server.js                ← Express app entry point
│   └── .env                     ← Environment variables
├── frontend/
│   ├── src/
│   │   ├── api/axios.js         ← Axios instance with JWT interceptors
│   │   ├── context/AuthContext.jsx ← Auth state management
│   │   ├── components/          ← Navbar, Footer, CourseCard, ProtectedRoute
│   │   ├── pages/               ← Landing, Login, Register, Courses, CourseDetail,
│   │   │                          Dashboard, Profile, AdminPanel
│   │   ├── App.jsx              ← React Router setup
│   │   └── index.css            ← Design system (dark theme)
│   └── vite.config.js           ← API proxy config
├── mysql.sql                    ← Database schema + seed data
└── package.json                 ← Root workspace scripts
```

## Setup

### 1. Database
```bash
mysql -u root -p < mysql.sql
```

### 2. Backend
```bash
cd backend
npm install
# Edit .env if your MySQL password is different
npm run dev          # runs on http://localhost:3001
```

### 3. Frontend
```bash
cd frontend
npm install
npm run dev          # runs on http://localhost:5173
```

## Demo Accounts

| Role       | Email                      | Password     |
|------------|----------------------------|--------------|
| Admin      | admin@learnsphere.com      | password123  |
| Instructor | lakshmi@learnsphere.com    | password123  |
| Student    | rahul@learnsphere.com      | password123  |

## API Endpoints

| Method | Endpoint                       | Auth     | Description            |
|--------|--------------------------------|----------|------------------------|
| POST   | /api/auth/register             | —        | Register new user      |
| POST   | /api/auth/login                | —        | Login, returns JWT     |
| GET    | /api/auth/me                   | ✓        | Current user profile   |
| GET    | /api/categories                | —        | List categories        |
| GET    | /api/courses                   | —        | List courses (filters) |
| GET    | /api/courses/:id               | —        | Course detail + lessons|
| POST   | /api/courses                   | Instructor | Create course        |
| PUT    | /api/courses/:id               | Instructor | Update course        |
| DELETE | /api/courses/:id               | Instructor | Delete course        |
| POST   | /api/enrollments               | Student  | Enroll in course       |
| GET    | /api/enrollments/my            | Student  | My enrollments         |
| PATCH  | /api/enrollments/:id/progress  | Student  | Update progress        |
| POST   | /api/reviews                   | Student  | Submit course review   |
| GET    | /api/users                     | Admin    | List all users         |
| GET    | /api/users/stats               | Admin    | Dashboard statistics   |

## Features

- 🎨 Premium dark theme with glassmorphism UI
- 🔐 JWT authentication with role-based access (Student, Instructor, Admin)
- 📚 Course catalog with search, category filters, and sorting
- 📊 Student dashboard with progress tracking
- 🛡️ Admin panel with stats, user & course management
- ⭐ Course reviews and ratings
- 📱 Fully responsive design
- 🚀 Production-ready architecture (connection pooling, error handling, security headers)
