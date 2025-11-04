const db = require("../config/db");

const User = {
  // Ambil semua user
  getAll: async () => {
    const [rows] = await db.promise().query(
      "SELECT u.*, r.nama_role FROM users u JOIN roles r ON u.id_role = r.id_role"
    );
    return rows;
  },

  // Cari user berdasarkan username
  findByUsername: async (username) => {
    const [rows] = await db.promise().query(
      "SELECT u.*, r.nama_role FROM users u JOIN roles r ON u.id_role = r.id_role WHERE u.username = ?",
      [username]
    );
    return rows[0];
  },

  // Tambah user baru
  create: async (data) => {
    const connection = await db.promise().getConnection();
    try {
      await connection.beginTransaction();

      // Insert ke tabel users
      const [userResult] = await connection.query(
        "INSERT INTO users (nama_user, username, password, id_role) VALUES (?, ?, ?, ?)",
        [data.nama_user, data.username, data.password, data.id_role || 3]
      );

      // Jika role adalah customer (3), buat juga record di tabel customers
      if (data.id_role === 3 || !data.id_role) {
        await connection.query(
          "INSERT INTO customers (nama, tanggal_daftar) VALUES (?, CURDATE())",
          [data.nama_user]
        );
      }

      await connection.commit();
      return userResult.insertId;
    } catch (error) {
      await connection.rollback();
      throw error;
    } finally {
      connection.release();
    }
  },

  // Update user
  update: async (id, data) => {
    const [result] = await db.promise().query(
      "UPDATE users SET nama_user = ?, username = ?, password = ? WHERE id_user = ?",
      [data.nama_user, data.username, data.password, id]
    );
    return result.affectedRows > 0;
  },

  // Hapus user
  delete: async (id) => {
    const [result] = await db.promise().query(
      "DELETE FROM users WHERE id_user = ?",
      [id]
    );
    return result.affectedRows > 0;
  }
};

module.exports = User;