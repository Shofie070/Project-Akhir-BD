const User = require("../models/user");

// Get all users
exports.getAllUsers = async (req, res) => {
  try {
    const users = await User.getAll();
    res.json(users);
  } catch (error) {
    console.error('Error getting users:', error);
    res.status(500).json({ 
      message: "Terjadi kesalahan saat mengambil data users" 
    });
  }
};

// Create new user
exports.createUser = async (req, res) => {
  try {
    const { nama_user, username, password, id_role } = req.body;

    // Validasi input
    if (!nama_user || !username || !password) {
      return res.status(400).json({ 
        message: "Nama, username, dan password wajib diisi!" 
      });
    }

    // Cek username sudah ada atau belum
    const existingUser = await User.findByUsername(username);
    if (existingUser) {
      return res.status(400).json({ 
        message: "Username sudah digunakan!" 
      });
    }

    // Create user
    const userId = await User.create({
      nama_user,
      username,
      password,
      id_role: id_role || 3 // Default to Customer if not specified
    });

    res.status(201).json({
      message: "User berhasil dibuat!",
      userId: userId
    });

  } catch (error) {
    console.error('Error creating user:', error);
    res.status(500).json({ 
      message: "Terjadi kesalahan saat membuat user baru" 
    });
  }
};

// Update user by ID
exports.updateUser = async (req, res) => {
  try {
    const { id } = req.params;
    const { nama_user, username, password } = req.body;

    // Validasi input
    if (!nama_user || !username || !password) {
      return res.status(400).json({ 
        message: "Nama, username, dan password wajib diisi!" 
      });
    }

    // Update user
    const updated = await User.update(id, {
      nama_user,
      username,
      password
    });

    if (!updated) {
      return res.status(404).json({ 
        message: "User tidak ditemukan" 
      });
    }

    res.json({ 
      message: "User berhasil diupdate!" 
    });

  } catch (error) {
    console.error('Error updating user:', error);
    res.status(500).json({ 
      message: "Terjadi kesalahan saat mengupdate user" 
    });
  }
};

// Delete user by ID
exports.deleteUser = async (req, res) => {
  try {
    const { id } = req.params;
    
    // Delete user
    const deleted = await User.delete(id);

    if (!deleted) {
      return res.status(404).json({ 
        message: "User tidak ditemukan" 
      });
    }

    res.json({ 
      message: "User berhasil dihapus!" 
    });

  } catch (error) {
    console.error('Error deleting user:', error);
    res.status(500).json({ 
      message: "Terjadi kesalahan saat menghapus user" 
    });
  }
};