-- Create roles table
CREATE TABLE IF NOT EXISTS roles (
    id_role INT PRIMARY KEY AUTO_INCREMENT,
    nama_role VARCHAR(50) NOT NULL
);

-- Insert default roles
INSERT INTO roles (nama_role) VALUES 
('Admin'),
('Staff'),
('Customer');

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id_user INT PRIMARY KEY AUTO_INCREMENT,
    nama_user VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    id_role INT,
    FOREIGN KEY (id_role) REFERENCES roles(id_role)
);

-- Insert default admin user
INSERT INTO users (nama_user, username, password, id_role) VALUES 
('Administrator', 'admin', 'admin123', 1),
('Staff Demo', 'staff', 'staff123', 2);

-- Create customers table
CREATE TABLE IF NOT EXISTS customers (
    id_customer INT PRIMARY KEY AUTO_INCREMENT,
    nama VARCHAR(100) NOT NULL,
    tanggal_daftar DATE NOT NULL
);

-- Create consoles table
CREATE TABLE IF NOT EXISTS console (
    id_console INT PRIMARY KEY AUTO_INCREMENT,
    jenis_console VARCHAR(50) NOT NULL,
    nomor_unit VARCHAR(20) NOT NULL,
    status VARCHAR(20) DEFAULT 'tersedia'
);

-- Insert some demo consoles
INSERT INTO console (jenis_console, nomor_unit, status) VALUES 
('PlayStation 5', 'PS5-001', 'tersedia'),
('PlayStation 4', 'PS4-001', 'tersedia'),
('PlayStation 4', 'PS4-002', 'tersedia');

-- Create games table
CREATE TABLE IF NOT EXISTS games (
    id_game INT PRIMARY KEY AUTO_INCREMENT,
    nama_game VARCHAR(100) NOT NULL,
    genre VARCHAR(50),
    platform VARCHAR(50) NOT NULL
);

-- Insert some demo games
INSERT INTO games (nama_game, genre, platform) VALUES 
('God of War Ragnarök', 'Action-Adventure', 'PlayStation 5'),
('Spider-Man 2', 'Action-Adventure', 'PlayStation 5'),
('FIFA 23', 'Sports', 'PlayStation 4'),
('The Last of Us Part II', 'Action-Adventure', 'PlayStation 4');