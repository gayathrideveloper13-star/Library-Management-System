-- =====================================================
--  DC Library Management System - Complete Database
--  Run this whole file in MySQL (MySQL Workbench / CLI)
-- =====================================================

CREATE DATABASE IF NOT EXISTS dc_library1;
USE dc_library1;

-- -----------------------------------------------------
-- Table: users (admins + normal users in same table)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    id       INT AUTO_INCREMENT PRIMARY KEY,
    name     VARCHAR(100) NOT NULL,
    email    VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    role     VARCHAR(20) DEFAULT 'user'       -- 'admin' or 'user'
);

-- -----------------------------------------------------
-- Table: books (with image_url)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS books (
    id        INT AUTO_INCREMENT PRIMARY KEY,
    title     VARCHAR(200) NOT NULL,
    author    VARCHAR(100),
    price     DECIMAL(10,2) NOT NULL,
    quantity  INT DEFAULT 0,
    image_url VARCHAR(500)
);

-- -----------------------------------------------------
-- Table: cart (user's shopping cart)
-- ON DELETE CASCADE => deleting a book also removes
-- it from every user's cart automatically
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS cart (
    id       INT AUTO_INCREMENT PRIMARY KEY,
    user_id  INT NOT NULL,
    book_id  INT NOT NULL,
    quantity INT DEFAULT 1,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Table: orders (purchase history)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS orders (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT NOT NULL,
    book_id    INT NOT NULL,
    quantity   INT DEFAULT 1,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id)
);

-- =====================================================
--  SAMPLE / SEED DATA
-- =====================================================

-- Admin users (stored in users table with role = 'admin')
-- Login: admin@gmail.com / admin123  OR  naveen@gmail.com / Naveen@123
INSERT INTO users (name, email, password, role) VALUES
('Admin', 'admin@gmail.com', 'admin123', 'admin'),
('Naveen', 'naveen@gmail.com', 'Naveen@123', 'admin');

-- Sample normal user (login: john@gmail.com / john123)
INSERT INTO users (name, email, password, role) VALUES
('John Doe', 'john@gmail.com', 'john123', 'user');

-- Technical & Motivational Books Catalog
INSERT INTO books (title, author, price, quantity, image_url) VALUES
(
    'Java Programming',
    'John Doe',
    500.00,
    9,
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTt7MC2BfVnW_YRk3okt3iux3wa70VGSDEa-KibpNu9HQ&s=10'
),
(
    'Data Structures',
    'Narasimha',
    650.00,
    7,
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6bDrVsCSgO6Enl7toh4dU1Z_lP1xw1n0QaDNpmzU2EQ&s=10'
),
(
    'MySQL',
    'Adam Aspin',
    400.00,
    0,
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQdtNflbFucTmx4m3gFUGO_R4IzhqfwMBJrvMxuAiCkg&s=10'
),
(
    'Clean Code',
    'Robert C. Martin',
    720.00,
    8,
    'https://covers.openlibrary.org/b/isbn/9780132350884-L.jpg'
),
(
    'Atomic Habits',
    'James Clear',
    499.00,
    14,
    'https://covers.openlibrary.org/b/isbn/9780735211292-L.jpg'
),
(
    'The 7 Habits of Highly Effective People',
    'Stephen R. Covey',
    549.00,
    10,
    'https://covers.openlibrary.org/b/isbn/9780743269513-L.jpg'
),
(
    'Think and Grow Rich',
    'Napoleon Hill',
    349.00,
    12,
    'https://covers.openlibrary.org/b/isbn/9781585424337-L.jpg'
),
(
    'Mindset: The New Psychology of Success',
    'Carol S. Dweck',
    429.00,
    8,
    'https://covers.openlibrary.org/b/isbn/9780345472328-L.jpg'
),
(
    'Can''t Hurt Me: Master Your Mind',
    'David Goggins',
    599.00,
    6,
    'https://covers.openlibrary.org/b/isbn/9781544512280-L.jpg'
),
(
    'Deep Work: Rules for Focused Success',
    'Cal Newport',
    450.00,
    9,
    'https://covers.openlibrary.org/b/isbn/9781455586691-L.jpg'
),
(
    'The Power of Now',
    'Eckhart Tolle',
    399.00,
    11,
    'https://covers.openlibrary.org/b/isbn/9781577314806-L.jpg'
),
(
    'The Alchemist',
    'Paulo Coelho',
    299.00,
    15,
    'https://covers.openlibrary.org/b/isbn/9780062315007-L.jpg'
);

-- Sample cart entries for John Doe
INSERT INTO cart (user_id, book_id, quantity)
SELECT u.id, b.id, 1 FROM users u, books b
WHERE u.email = 'john@gmail.com' AND b.title = 'Java Programming';

INSERT INTO cart (user_id, book_id, quantity)
SELECT u.id, b.id, 1 FROM users u, books b
WHERE u.email = 'john@gmail.com' AND b.title = 'Atomic Habits';

-- Sample past order for John Doe (powers Personalized AI Recommendations)
INSERT INTO orders (user_id, book_id, quantity)
SELECT u.id, b.id, 1 FROM users u, books b
WHERE u.email = 'john@gmail.com' AND b.title = 'Clean Code';

-- =====================================================
--  QUICK VERIFICATION QUERIES (optional, run to test)
-- =====================================================
-- SELECT * FROM users;
-- SELECT * FROM books;
-- SELECT * FROM cart;
-- SELECT * FROM orders;
