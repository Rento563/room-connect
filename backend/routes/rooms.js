const express = require('express');
const router = express.Router();

// Mock rooms data - Replace with Supabase calls
let rooms = {};

// Get all rooms
router.get('/', (req, res) => {
  try {
    const roomList = Object.values(rooms);
    res.json(roomList);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Create new room
router.post('/', (req, res) => {
  try {
    const { id, title, description, price, location, images, roomType, ownerId, amenities } = req.body;

    // Validation
    if (!id || !title || !price || !location || !ownerId) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    const room = {
      id,
      title,
      description,
      price,
      location,
      images: images || [],
      roomType,
      ownerId,
      amenities: amenities || [],
      createdAt: new Date()
    };

    rooms[id] = room;
    res.status(201).json({ message: 'Room created successfully', room });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get specific room
router.get('/:id', (req, res) => {
  try {
    const { id } = req.params;
    const room = rooms[id];

    if (!room) {
      return res.status(404).json({ error: 'Room not found' });
    }

    res.json(room);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Update room
router.put('/:id', (req, res) => {
  try {
    const { id } = req.params;
    const updateData = req.body;

    if (!rooms[id]) {
      return res.status(404).json({ error: 'Room not found' });
    }

    rooms[id] = { ...rooms[id], ...updateData, id };
    res.json({ message: 'Room updated successfully', room: rooms[id] });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Delete room
router.delete('/:id', (req, res) => {
  try {
    const { id } = req.params;

    if (!rooms[id]) {
      return res.status(404).json({ error: 'Room not found' });
    }

    delete rooms[id];
    res.json({ message: 'Room deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get rooms by owner
router.get('/owner/:ownerId', (req, res) => {
  try {
    const { ownerId } = req.params;
    const ownerRooms = Object.values(rooms).filter(room => room.ownerId === ownerId);
    res.json(ownerRooms);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
