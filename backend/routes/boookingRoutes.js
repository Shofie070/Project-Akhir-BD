const express = require("express");
const router = express.Router();
const db = require('../config/db');

// GET /api/bookings - get all bookings with customer & room info
router.get('/', async (req, res) => {
  try {
    const query = `
      SELECT b.*, c.nama as customer_name, r.nama_room as room_name, r.lokasi as room_location
      FROM booking b
      LEFT JOIN customers c ON b.id_customer = c.id_customer
      LEFT JOIN rooms r ON b.id_room = r.id_room
      ORDER BY b.tanggal DESC
    `;

    const [bookings] = await db.promise().query(query);

    res.json(bookings.map(booking => ({
      id: booking.id_booking,
      customerName: booking.customer_name,
      roomName: booking.room_name,
      roomLocation: booking.room_location,
      date: booking.tanggal,
      status: booking.status,
      startTime: booking.jam_mulai,
      endTime: booking.jam_selesai
    })));
  } catch (err) {
    console.error('Failed to fetch bookings:', err);
    res.status(500).json({ error: err.message });
  }
});

// POST /api/bookings - create a booking
router.post('/', async (req, res) => {
  const { id_customer, id_room, tanggal, jam_mulai, jam_selesai, status } = req.body;
  if (!id_customer || !id_room || !tanggal || !jam_mulai || !jam_selesai) {
    return res.status(400).json({ error: 'Missing required booking fields' });
  }

  try {
    const [result] = await db.promise().query(
      'INSERT INTO booking (id_customer, id_room, tanggal, jam_mulai, jam_selesai, status) VALUES (?, ?, ?, ?, ?, ?)',
      [id_customer, id_room, tanggal, jam_mulai, jam_selesai, status || 'pending']
    );

    const [rows] = await db.promise().query('SELECT * FROM booking WHERE id_booking = ?', [result.insertId]);
    res.status(201).json(rows[0]);
  } catch (err) {
    console.error('Failed to create booking:', err);
    res.status(500).json({ error: err.message });
  }
});

// PUT /api/bookings/:id/status - update booking status and room status accordingly
router.put('/:id/status', async (req, res) => {
  const { status } = req.body;
  const { id } = req.params;

  if (!status) return res.status(400).json({ error: 'Missing status in body' });

  try {
    const [updateResult] = await db.promise().query(
      'UPDATE booking SET status = ? WHERE id_booking = ?',
      [status, id]
    );

    if (updateResult.affectedRows === 0) {
      return res.status(404).json({ error: 'Booking not found' });
    }

    // If confirmed, mark room as dipakai; if cancelled, mark room as tersedia
    if (status === 'confirmed') {
      await db.promise().query(
        'UPDATE rooms SET status = "dipakai" WHERE id_room = (SELECT id_room FROM booking WHERE id_booking = ?)',
        [id]
      );
    } else if (status === 'cancelled') {
      await db.promise().query(
        'UPDATE rooms SET status = "tersedia" WHERE id_room = (SELECT id_room FROM booking WHERE id_booking = ?)',
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
