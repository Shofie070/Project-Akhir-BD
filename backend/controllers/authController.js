const db = require("../config/db");
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// Login controller
exports.login = async (req, res) => {
  console.log("=== Login Attempt ===");
  console.log("Headers:", req.headers);
  console.log("Body:", req.body);
  console.log("Method:", req.method);
  console.log("URL:", req.url);
  
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).json({ 
      message: "Username dan password wajib diisi!" 
    });
  }

  try {
    // Cek user di database
    const sql = "SELECT u.*, r.nama_role FROM users u JOIN roles r ON u.id_role = r.id_role WHERE username = ?";
    const [users] = await db.promise().query(sql, [username]);

    if (users.length === 0) {
      return res.status(401).json({ 
        message: "Username tidak ditemukan!" 
      });
    }

    const user = users[0];

    // Untuk sementara compare password langsung (karena di database masih plain text)
    // TODO: Implementasi bcrypt nanti
    if (password !== user.password) {
      return res.status(401).json({ 
        message: "Password salah!" 
      });
    }

    // Generate JWT token
    const token = jwt.sign(
      { 
        id: user.id_user,
        username: user.username,
        role: user.nama_role
      },
      process.env.JWT_SECRET || 'your-secret-key',
      { expiresIn: '24h' }
    );

    // Response sukses
    res.json({
      message: "Login berhasil!",
      token: token,
      user: {
        id: user.id_user,
        nama: user.nama_user,
        username: user.username,
        role: user.nama_role
      }
    });

  } catch (error) {
    console.error("Login error:", error);
    res.status(500).json({ 
      message: "Terjadi kesalahan pada server" 
    });
  }
};

// Register controller
exports.register = async (req, res) => {
  const { nama_user, username, password } = req.body;

  console.log("Register attempt data:", req.body);

  if (!nama_user || !username || !password) {
    return res.status(400).json({ 
      message: "Nama, username, dan password wajib diisi!" 
    });
  }

  try {
    // Cek apakah username sudah ada
    const [existinguser] = await db.promise().query(
      "SELECT * FROM users WHERE username = ?", 
      [username]
    );

    if (existinguser.length > 0) {
      return res.status(400).json({ 
        message: "Username sudah digunakan!" 
      });
    }

    // Default role adalah 3 (Customer)
    const sql = `
      INSERT INTO users (nama_user, username, password, id_role) 
      VALUES (?, ?, ?, 3)
    `;
    
    const [result] = await db.promise().query(sql, [
      nama_user,
      username,
      password // Untuk sementara simpan password as-is
    ]);

    // Buat customer record baru
    const customerSql = `
      INSERT INTO customers (nama, tanggal_daftar) 
      VALUES (?, CURDATE())
    `;
    await db.promise().query(customerSql, [nama_user]);

    res.status(201).json({
      message: "Registrasi berhasil!",
      user: {
        id: result.insertId,
        nama: nama_user,
        username: username,
        role: 'Customer'
      }
    });

  } catch (error) {
    console.error("Register error:", error);
    res.status(500).json({ 
      message: "Terjadi kesalahan pada server" 
    });
  }
};