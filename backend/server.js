const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const db = require("./config/db");

const app = express();

// Middleware
app.use(cors());
app.use(bodyParser.json());

// Import routes
const authRoutes = require("./routes/authRoutes");
const userRoutes = require("./routes/userRoutes");
const gameRoutes = require("./routes/gameRoutes");
const consoleRoutes = require("./routes/consoleRoutes");

// Gunakan routes
app.use("/api", authRoutes); // untuk /api/login dan /api/register
app.use("/api/users", userRoutes); // untuk manajemen users
app.use("/api/games", gameRoutes); // games endpoint
app.use("/api/bookings", require("./routes/boookingRoutes")); // bookings endpoint
app.use("/api/consoles", consoleRoutes); // consoles endpoint


// Cek koneksi database
db.connect((err) => {
  if (err) {
    console.error("❌ Gagal konek ke MySQL:", err);
  } else {
    console.log("✅ Terhubung ke MySQL Database penyewaan_playstation");
  }
});

// Endpoint root
app.get("/", (req, res) => {
  res.send("🚴‍♂️ Backend ");
});

// Debug: tampilkan semua routes
app._router.stack.forEach(function(r){
  if (r.route && r.route.path){
    console.log(`${Object.keys(r.route.methods)} ${r.route.path}`)
  }
});

// Tambahkan error handler
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).send('Something broke!');
});

// Tambahkan 404 handler
app.use((req, res, next) => {
  res.status(404).json({
    message: `Cannot ${req.method} ${req.url}`,
    availableRoutes: [
      "POST /api/login",
      "POST /api/register",
      "GET /api/users",
      "POST /api/users",
      "PUT /api/users/:id",
      "DELETE /api/users/:id"
    ]
  });
});

// Jalankan server
const PORT = 4000;
const server = app.listen(PORT, () => {
  console.log(`✅ Server berjalan di http://localhost:${PORT}`);
});

// Handle server errors
server.on('error', (error) => {
  if (error.code === 'EADDRINUSE') {
    console.error(`Port ${PORT} sudah digunakan. Coba port lain atau matikan proses yang menggunakan port ini.`);
  } else {
    console.error('Server error:', error);
  }
  process.exit(1);
});