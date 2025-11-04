const mysql = require('mysql2');

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'penyewaan_playstation'
});

db.connect((err) => {
  if (err) {
    console.error('Koneksi database gagal:', err);
  } else {
    console.log('✅ Connected to MySQL Database penyewaan_playstation');
  }
});

module.exports = db;