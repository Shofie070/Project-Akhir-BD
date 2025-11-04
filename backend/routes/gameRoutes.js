const express = require("express");
const router = express.Router();
const db = require('../config/db');

// GET /api/games - return list of games
router.get('/', async (req, res) => {
  try {
    const [rows] = await db.promise().query('SELECT id_game, nama_game, genre, platform FROM games');
    // map DB fields to frontend-friendly keys
    const data = rows.map(r => ({
      id: r.id_game,
      title: r.nama_game,
      genre: r.genre,
      platform: r.platform,
    }));
    res.json(data);
  } catch (err) {
    console.error('Failed to fetch games:', err);
    res.status(500).json({ error: 'Failed to fetch games' });
  }
});

module.exports = router;
