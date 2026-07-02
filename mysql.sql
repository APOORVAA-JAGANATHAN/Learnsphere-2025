-- ================================================================
-- LearnSphere — Production Database Schema
-- ================================================================

DROP DATABASE IF EXISTS learnsphere;
CREATE DATABASE learnsphere CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE learnsphere;

-- ── USERS ─────────────────────────────────────────────────────
CREATE TABLE users (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(100)  NOT NULL,
  email       VARCHAR(150)  NOT NULL UNIQUE,
  password    VARCHAR(255)  NOT NULL,
  role        ENUM('student','instructor','admin') NOT NULL DEFAULT 'student',
  avatar_url  VARCHAR(500)  DEFAULT NULL,
  bio         TEXT          DEFAULT NULL,
  created_at  TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
  updated_at  TIMESTAMP     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_users_email (email),
  INDEX idx_users_role  (role)
) ENGINE=InnoDB;

-- ── CATEGORIES ────────────────────────────────────────────────
CREATE TABLE categories (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(100)  NOT NULL UNIQUE,
  icon        VARCHAR(50)   DEFAULT '📚',
  description VARCHAR(255)  DEFAULT NULL,
  created_at  TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ── COURSES ───────────────────────────────────────────────────
CREATE TABLE courses (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  title           VARCHAR(200)   NOT NULL,
  description     TEXT           NOT NULL,
  thumbnail_url   VARCHAR(500)   DEFAULT NULL,
  instructor_id   INT            NOT NULL,
  category_id     INT            NOT NULL,
  level           ENUM('beginner','intermediate','advanced') NOT NULL DEFAULT 'beginner',
  price           DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
  duration_hours  INT            DEFAULT 0,
  is_published    BOOLEAN        DEFAULT FALSE,
  created_at      TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
  updated_at      TIMESTAMP      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (instructor_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (category_id)   REFERENCES categories(id) ON DELETE RESTRICT,
  INDEX idx_courses_category    (category_id),
  INDEX idx_courses_instructor  (instructor_id),
  INDEX idx_courses_published   (is_published)
) ENGINE=InnoDB;

-- ── LESSONS ───────────────────────────────────────────────────
CREATE TABLE lessons (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  course_id     INT            NOT NULL,
  title         VARCHAR(200)   NOT NULL,
  content       TEXT           DEFAULT NULL,
  video_url     VARCHAR(500)   DEFAULT NULL,
  duration_min  INT            DEFAULT 0,
  sort_order    INT            NOT NULL DEFAULT 0,
  created_at    TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  INDEX idx_lessons_course (course_id)
) ENGINE=InnoDB;

-- ── ENROLLMENTS ───────────────────────────────────────────────
CREATE TABLE enrollments (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  student_id    INT            NOT NULL,
  course_id     INT            NOT NULL,
  progress      INT            NOT NULL DEFAULT 0,
  status        ENUM('enrolled','in_progress','completed') NOT NULL DEFAULT 'enrolled',
  enrolled_at   TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
  completed_at  TIMESTAMP      NULL DEFAULT NULL,
  FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (course_id)  REFERENCES courses(id) ON DELETE CASCADE,
  UNIQUE KEY uq_enrollment (student_id, course_id),
  INDEX idx_enroll_student (student_id),
  INDEX idx_enroll_course  (course_id)
) ENGINE=InnoDB;

-- ── REVIEWS ───────────────────────────────────────────────────
CREATE TABLE reviews (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  student_id  INT       NOT NULL,
  course_id   INT       NOT NULL,
  rating      TINYINT   NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment     TEXT      DEFAULT NULL,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (course_id)  REFERENCES courses(id) ON DELETE CASCADE,
  UNIQUE KEY uq_review (student_id, course_id)
) ENGINE=InnoDB;

-- ── DAILY STATS ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS daily_stats (
  id                INT AUTO_INCREMENT PRIMARY KEY,
  stats_date        DATE NOT NULL UNIQUE,
  total_students    INT NOT NULL DEFAULT 0,
  total_instructors INT NOT NULL DEFAULT 0,
  total_enrolled    INT NOT NULL DEFAULT 0,
  total_in_progress INT NOT NULL DEFAULT 0,
  total_completed   INT NOT NULL DEFAULT 0,
  daily_revenue     DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  active_sessions   INT NOT NULL DEFAULT 0,
  created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_stats_date (stats_date)
) ENGINE=InnoDB;


-- ================================================================
-- SEED DATA
-- ================================================================

-- Categories (Follow User Request exactly)
INSERT INTO categories (name, icon, description) VALUES
('Project Training', '💻', 'Mobile Apps, Cloud, Cybersecurity, Game Dev, UI/UX, Data Analytics'),
('Government Exams / Career Advancement', '🏛️', 'Banking, RRB, TET, Defence, Police, State PSC, TOEFL, IELTS'),
('Skill Development / Growth', '📈', 'Public Speaking, Leadership, Entrepreneurship, Digital Marketing'),
('Wellness, Hobbies & Languages', '🧘', 'Yoga, Photography, Languages, Finance, Global Certifications');

-- Users  (password = bcrypt hash of "password123")
INSERT INTO users (name, email, password, role, bio) VALUES
('Admin User',     'admin@learnsphere.com',  '$2a$10$rJWSzBLVcJGqA7rQFg4/..G/cGpM2uTM0byFxDrBq9HwmrgtGB3ze', 'admin',      'Platform administrator'),
('Lakshmi Devi',   'lakshmi@learnsphere.com', '$2a$10$rJWSzBLVcJGqA7rQFg4/..G/cGpM2uTM0byFxDrBq9HwmrgtGB3ze', 'instructor', 'Full-stack web developer with 10+ years of experience'),
('Meena Kumari',   'meena@learnsphere.com',   '$2a$10$rJWSzBLVcJGqA7rQFg4/..G/cGpM2uTM0byFxDrBq9HwmrgtGB3ze', 'instructor', 'AI researcher and data science expert'),
('Anitha Rao',     'anitha@learnsphere.com',  '$2a$10$rJWSzBLVcJGqA7rQFg4/..G/cGpM2uTM0byFxDrBq9HwmrgtGB3ze', 'instructor', 'IoT specialist and embedded systems engineer'),
('Divya Sharma',   'divya@learnsphere.com',   '$2a$10$rJWSzBLVcJGqA7rQFg4/..G/cGpM2uTM0byFxDrBq9HwmrgtGB3ze', 'instructor', 'Communication coach and motivational speaker'),
('Radha Iyer',     'radha@learnsphere.com',   '$2a$10$rJWSzBLVcJGqA7rQFg4/..G/cGpM2uTM0byFxDrBq9HwmrgtGB3ze', 'instructor', 'UPSC topper and civil services mentor'),
('Rahul Kumar',    'rahul@learnsphere.com',   '$2a$10$rJWSzBLVcJGqA7rQFg4/..G/cGpM2uTM0byFxDrBq9HwmrgtGB3ze', 'student',    'Engineering student passionate about web development'),
('Priya Nair',     'priya@learnsphere.com',   '$2a$10$rJWSzBLVcJGqA7rQFg4/..G/cGpM2uTM0byFxDrBq9HwmrgtGB3ze', 'student',    'Homemaker exploring AI and data science'),
('Arun Prakash',   'arun@learnsphere.com',    '$2a$10$rJWSzBLVcJGqA7rQFg4/..G/cGpM2uTM0byFxDrBq9HwmrgtGB3ze', 'student',    'College student preparing for competitive exams');

-- Courses
INSERT INTO courses (title, description, thumbnail_url, instructor_id, category_id, level, price, duration_hours, is_published) VALUES
('Mobile App Development Projects (Android / iOS)', 'Build real-world apps with Flutter and React Native.', NULL, 2, 1, 'intermediate', 2999.00, 48, TRUE),
('Cloud Computing Projects (AWS, Azure, GCP)', 'Master cloud architecture and deploy scalable applications.', NULL, 3, 1, 'advanced', 3499.00, 56, TRUE),
('Cybersecurity Projects & Ethical Hacking', 'Learn penetration testing and secure application development.', NULL, 4, 1, 'advanced', 3999.00, 60, TRUE),
('Robotics & Automation Projects', 'Build robotic systems and automate tasks using Python and IoT.', NULL, 4, 1, 'intermediate', 1999.00, 32, TRUE),
('Game Development Projects (Unity, Unreal Engine)', 'Create 3D games from scratch using Unity and C#.', NULL, 2, 1, 'beginner', 2499.00, 40, TRUE),
('UI/UX Design Projects', 'Design intuitive interfaces using Figma and Adobe XD.', NULL, 5, 1, 'beginner', 1499.00, 20, TRUE),
('Data Analytics & Visualization Projects', 'Master Tableau, PowerBI, Pandas, and SQL for analytics.', NULL, 3, 1, 'intermediate', 1999.00, 36, TRUE),
('Open Source Contribution / GitHub Projects', 'Learn Git, GitHub, and how to contribute to major open source projects.', NULL, 2, 1, 'beginner', 999.00, 15, TRUE),

('Banking Exams (IBPS, SBI PO, Clerk)', 'Comprehensive prep for all major Indian banking exams.', NULL, 6, 2, 'advanced', 1999.00, 80, TRUE),
('Railway Recruitment Board (RRB) Exams', 'Targeted preparation for Indian Railways recruitment.', NULL, 6, 2, 'intermediate', 1499.00, 60, TRUE),
('Teaching Exams (TET, CTET)', 'Prepare for state and central teacher eligibility tests.', NULL, 5, 2, 'intermediate', 1499.00, 45, TRUE),
('Defence Exams (NDA, CDS, AFCAT)', 'Physical and academic preparation strategies for defence services.', NULL, 6, 2, 'advanced', 2499.00, 90, TRUE),
('Police / State Civil Services', 'Syllabus coverage for state-level police and civil exams.', NULL, 6, 2, 'advanced', 2999.00, 100, TRUE),
('Foreign Language Exams (TOEFL, IELTS, JLPT)', 'Master English and Japanese for studying and working abroad.', NULL, 5, 2, 'intermediate', 1999.00, 40, TRUE),

('Public Speaking & Presentation Skills', 'Overcome stage fear and deliver powerful presentations.', NULL, 5, 3, 'beginner', 999.00, 16, TRUE),
('Leadership & Team Management Training', 'Learn to lead, inspire, and manage highly effective teams.', NULL, 6, 3, 'intermediate', 1499.00, 24, TRUE),
('Entrepreneurship / Startup Guidance', 'From idea validation to fundraising: comprehensive startup guide.', NULL, 2, 3, 'advanced', 2999.00, 40, TRUE),
('Creative Writing & Blogging Skills', 'Turn your thoughts into engaging stories and profitable blogs.', NULL, 5, 3, 'beginner', 799.00, 15, TRUE),
('Digital Marketing (SEO, Social Media, Content Creation)', 'Master modern marketing across Google, Meta, and written content.', NULL, 3, 3, 'intermediate', 1999.00, 30, TRUE),
('Graphic Design / Video Editing Skills', 'Learn Premiere Pro, After Effects, and Photoshop.', NULL, 5, 3, 'intermediate', 1499.00, 25, TRUE),
('AI & Machine Learning Certifications', 'Get certified in modern AI development and ML engineering.', NULL, 3, 3, 'advanced', 3999.00, 60, TRUE),
('Time Management & Productivity Workshops', 'Achieve more in less time using proven productivity systems.', NULL, 6, 3, 'beginner', 499.00, 10, TRUE),

('Lifestyle & Wellness – Yoga, Meditation', 'Holistic approaches to physical and mental well-being.', NULL, 5, 4, 'beginner', 899.00, 20, TRUE),
('Hobbies & Arts – Photography, Music, Dance', 'Find your creative outlet and learn from expert artists.', NULL, 2, 4, 'beginner', 999.00, 30, TRUE),
('Language Learning – Spanish, French, German', 'Become a polyglot with these immersive language courses.', NULL, 5, 4, 'beginner', 1999.00, 50, TRUE),
('Financial Literacy – Stock Market, Finance', 'Take control of your wealth, investments, and financial future.', NULL, 3, 4, 'intermediate', 1499.00, 35, TRUE),
('Global Certifications – Google, MS, AWS, Cisco', 'Guided preparation for the most recognized IT certifications.', NULL, 4, 4, 'advanced', 2999.00, 45, TRUE);

-- Lessons for "Complete Web Development Bootcamp" (course_id = 1)
INSERT INTO lessons (course_id, title, content, video_url, duration_min, sort_order) VALUES
(1, 'Introduction to Web Development', 'Overview of how the web works, browsers, servers, and the request-response cycle.', NULL, 30, 1),
(1, 'HTML Fundamentals',               'Learn semantic HTML5 elements, forms, tables, and accessibility best practices.', NULL, 45, 2),
(1, 'CSS Layouts & Flexbox',           'Master modern layouts with Flexbox and CSS Grid. Build responsive designs.', NULL, 60, 3),
(1, 'JavaScript Essentials',           'Variables, functions, DOM manipulation, events, and ES6+ features.', NULL, 90, 4),
(1, 'React.js Basics',                 'Components, JSX, props, state, and building your first React application.', NULL, 75, 5),
(1, 'Node.js & Express',               'Server-side JavaScript, REST APIs, middleware, routing, and error handling.', NULL, 60, 6),
(1, 'MySQL Database Integration',      'Relational databases, SQL queries, joins, and connecting Express to MySQL.', NULL, 60, 7),
(1, 'Full-Stack Project',              'Build a complete full-stack application from scratch with deployment.', NULL, 120, 8);

-- Lessons for "AI & Machine Learning" (course_id = 2)
INSERT INTO lessons (course_id, title, content, video_url, duration_min, sort_order) VALUES
(2, 'Python for Data Science',     'Python basics, data types, control flow, and working with libraries.', NULL, 60, 1),
(2, 'NumPy & Pandas Deep Dive',    'Array manipulation, DataFrames, data cleaning, and transformations.', NULL, 75, 2),
(2, 'Data Visualization',          'Matplotlib, Seaborn, and creating compelling data visualizations.', NULL, 45, 3),
(2, 'Introduction to ML',          'Supervised vs unsupervised learning, model training, and evaluation metrics.', NULL, 60, 4),
(2, 'Building Neural Networks',    'TensorFlow basics, building and training deep learning models.', NULL, 90, 5),
(2, 'Deploying ML Models',         'Model serving with Flask, Docker containerization, and cloud deployment.', NULL, 60, 6);

-- Lessons for "Public Speaking" (course_id = 4)
INSERT INTO lessons (course_id, title, content, video_url, duration_min, sort_order) VALUES
(4, 'Overcoming Stage Fear',       'Techniques to manage anxiety and build confidence for public speaking.', NULL, 30, 1),
(4, 'Body Language Mastery',       'Non-verbal communication, eye contact, gestures, and posture.', NULL, 40, 2),
(4, 'Structuring Your Speech',     'Introduction, body, conclusion — frameworks for impactful speeches.', NULL, 35, 3),
(4, 'Storytelling Techniques',     'Use narratives to engage your audience and make your points memorable.', NULL, 45, 4),
(4, 'Handling Q&A Sessions',       'Stay composed, think on your feet, and handle tough questions gracefully.', NULL, 30, 5);

-- Enrollments
INSERT INTO enrollments (student_id, course_id, progress, status) VALUES
(7, 1, 62, 'in_progress'),
(7, 4, 100, 'completed'),
(8, 2, 33, 'in_progress'),
(8, 6, 0,  'enrolled'),
(9, 5, 15, 'in_progress'),
(9, 4, 80, 'in_progress');

-- Reviews
INSERT INTO reviews (student_id, course_id, rating, comment) VALUES
(7, 1, 5, 'Excellent course! Lakshmi explains complex topics so clearly. Already built my first full-stack app.'),
(7, 4, 4, 'Great tips on public speaking. Helped me present my college project with confidence.'),
(8, 2, 5, 'Meena is an amazing instructor. The hands-on projects really helped me understand ML concepts.'),
(9, 5, 4, 'Very comprehensive UPSC preparation guide. The mock tests are incredibly helpful.'),
(9, 4, 5, 'Divya is an inspiring speaker. This course completely changed how I communicate.');

SELECT 'LearnSphere database created successfully!' AS status;