const express = require("express");
const router = express.Router();
const db = require('../config/db');

// GET /api/games - return list of games
router.get('/', async (req, res) => {
  try {
    const [rows] = await db.promise().query('SELECT id_game, nama_game, genre, platform FROM games');
    const data = rows.map(r => ({
      id: r.id_game,
      namaGame: r.nama_game,
      genre: r.genre,
      platform: r.platform,
    }));
    res.json(data);
  } catch (err) {
    console.error('Failed to fetch games:', err);
    res.status(500).json({ error: 'Failed to fetch games' });
  }
});

// GET /api/games/:id - get a specific game
router.get('/:id', async (req, res) => {
  try {
    const [rows] = await db.promise().query(
      'SELECT id_game, nama_game, genre, platform FROM games WHERE id_game = ?',
      [req.params.id]
    );
    if (rows.length === 0) {
      return res.status(404).json({ error: 'Game not found' });
    }
    const game = rows[0];
    res.json({
      id: game.id_game,
      namaGame: game.nama_game,
      genre: game.genre,
      platform: game.platform,
    });
  } catch (err) {
    console.error('Failed to fetch game:', err);
    res.status(500).json({ error: 'Failed to fetch game' });
  }
});

// POST /api/games - create a new game
router.post('/', async (req, res) => {
  const { namaGame, genre, platform } = req.body;
  try {
    const [result] = await db.promise().query(
      'INSERT INTO games (nama_game, genre, platform) VALUES (?, ?, ?)',
      [namaGame, genre, platform]
    );
    const [newGame] = await db.promise().query(
      'SELECT id_game, nama_game, genre, platform FROM games WHERE id_game = ?',
      [result.insertId]
    );
    res.status(201).json({
      id: newGame[0].id_game,
      namaGame: newGame[0].nama_game,
      genre: newGame[0].genre,
      platform: newGame[0].platform,
    });
  } catch (err) {
    console.error('Failed to create game:', err);
    res.status(500).json({ error: 'Failed to create game' });
  }
});

// PUT /api/games/:id - update a game
router.put('/:id', async (req, res) => {
  const { namaGame, genre, platform } = req.body;
  try {
    const [result] = await db.promise().query(
      'UPDATE games SET nama_game = ?, genre = ?, platform = ? WHERE id_game = ?',
      [namaGame, genre, platform, req.params.id]
    );
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Game not found' });
    }
    const [updatedGame] = await db.promise().query(
      'SELECT id_game, nama_game, genre, platform FROM games WHERE id_game = ?',
      [req.params.id]
    );
    res.json({
      id: updatedGame[0].id_game,
      namaGame: updatedGame[0].nama_game,
      genre: updatedGame[0].genre,
      platform: updatedGame[0].platform,
    });
  } catch (err) {
    console.error('Failed to update game:', err);
    res.status(500).json({ error: 'Failed to update game' });
  }
});

// DELETE /api/games/:id - delete a game
router.delete('/:id', async (req, res) => {
  try {
    const [result] = await db.promise().query(
      'DELETE FROM games WHERE id_game = ?',
      [req.params.id]
    );
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Game not found' });
    }
    res.json({ message: 'Game deleted successfully' });
  } catch (err) {
    console.error('Failed to delete game:', err);
    res.status(500).json({ error: 'Failed to delete game' });
  }
});

module.exports = router;
