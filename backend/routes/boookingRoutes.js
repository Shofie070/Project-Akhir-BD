const express = require("express");
const router = express.Router();
const db = require('../config/db');

// GET /api/bookings - get all bookings with details
router.get('/', async (req, res) => {
  try {
    const query = `
      SELECT b.*, c.nama as customer_name, g.nama_game, con.jenis_console, con.nomor_unit
      FROM bookings b
      LEFT JOIN customers c ON b.id_customer = c.id_customer
      LEFT JOIN games g ON b.id_game = g.id_game
      LEFT JOIN console con ON b.id_console = con.id_console
      ORDER BY b.tanggal DESC
    `;
    
    const [bookings] = await db.promise().query(query);
    console.log('Fetched bookings:', bookings); // Debug log
    
    res.json(bookings.map(booking => ({
      id: booking.id_booking,
      customerName: booking.customer_name,
      gameName: booking.nama_game,
      console: `${booking.jenis_console} (${booking.nomor_unit})`,
      date: booking.tanggal,
      status: booking.status,
      startTime: booking.waktu_mulai,
      endTime: booking.waktu_selesai
    })));
  } catch (err) {
    console.error('Failed to fetch bookings:', err);
    res.status(500).json({ error: err.message });
  }
});

// PUT /api/bookings/:id/status - update booking status
router.put('/:id/status', async (req, res) => {
  const { status } = req.body;
  const { id } = req.params;

  try {
    await db.promise().query(
      'UPDATE bookings SET status = ? WHERE id_booking = ?',
      [status, id]
    );
    
    // If approved, update console status
    if (status === 'approved') {
      await db.promise().query(
        'UPDATE console c JOIN bookings b ON c.id_console = b.id_console SET c.status = "dipakai" WHERE b.id_booking = ?',
        [id]
      );
    }
    
    // If completed, update console status back to available
    if (status === 'completed') {
      await db.promise().query(
        'UPDATE console c JOIN bookings b ON c.id_console = b.id_console SET c.status = "tersedia" WHERE b.id_booking = ?',
        [id]
      );
    }
    
    res.json({ message: 'Booking status updated successfully' });
  } catch (err) {
    console.error('Failed to update booking status:', err);
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
