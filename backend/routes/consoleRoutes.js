const express = require("express");
const router = express.Router();
const db = require("../config/db");

// Get all consoles
router.get("/", (req, res) => {
  db.query("SELECT * FROM console", (err, results) => {
    if (err) {
      console.error("Error fetching consoles:", err);
      return res.status(500).json({ error: err.message });
    }
    console.log("Consoles fetched:", results);
    res.json(results);
  });
});

// Get a specific console
router.get("/:id", async (req, res) => {
  try {
    const [rows] = await db.query("SELECT * FROM console WHERE id_console = ?", [req.params.id]);
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
    const [result] = await db.query(
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
    await db.query(
      "UPDATE console SET jenis_console = ?, nomor_unit = ?, status = ? WHERE id_console = ?",
      [jenis_console, nomor_unit, status, req.params.id]
    );
    res.json({ message: "Console updated successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Delete a console
router.delete("/:id", async (req, res) => {
  try {
    await db.query("DELETE FROM console WHERE id_console = ?", [req.params.id]);
    res.json({ message: "Console deleted successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
