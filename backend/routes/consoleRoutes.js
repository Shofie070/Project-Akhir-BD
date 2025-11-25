const express = require("express");
const router = express.Router();
const db = require("../config/db");

// Get all consoles
router.get("/", async (req, res) => {
  try {
    const [results] = await db.promise().query("SELECT * FROM console");
    res.json(results);
  } catch (err) {
    console.error("Error fetching consoles:", err);
    res.status(500).json({ error: err.message });
  }
});

// Get a specific console
router.get("/:id", async (req, res) => {
  try {
    const [rows] = await db.promise().query("SELECT * FROM console WHERE id_console = ?", [req.params.id]);
    if (rows.length === 0) {
      return res.status(404).json({ message: "Console not found" });
    }
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Create a new console
router.post("/", async (req, res) => {
  const { jenis_console, nomor_unit, status } = req.body;
  try {
    const [result] = await db.promise().query(
      "INSERT INTO console (jenis_console, nomor_unit, status) VALUES (?, ?, ?)",
      [jenis_console, nomor_unit, status || "tersedia"]
    );
    res.status(201).json({ id: result.insertId, ...req.body });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Update a console
router.put("/:id", async (req, res) => {
  const { jenis_console, nomor_unit, status } = req.body;
  try {
    const [result] = await db.promise().query(
      "UPDATE console SET jenis_console = ?, nomor_unit = ?, status = ? WHERE id_console = ?",
      [jenis_console, nomor_unit, status, req.params.id]
    );
      if (result.affectedRows === 0) return res.status(404).json({ message: 'Console not found' });
      // Return the updated row
      const [rows] = await db.promise().query("SELECT * FROM console WHERE id_console = ?", [req.params.id]);
      res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Delete a console
router.delete("/:id", async (req, res) => {
  try {
    const [result] = await db.promise().query("DELETE FROM console WHERE id_console = ?", [req.params.id]);
    if (result.affectedRows === 0) return res.status(404).json({ message: 'Console not found' });
    res.json({ message: "Console deleted successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
