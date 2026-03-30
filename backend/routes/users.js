const express = require('express');
const router = express.Router();

// Mock user data - Replace with Supabase calls
let users = {};

// Register new user
router.post('/register', (req, res) => {
  try {
    const { id, name, email, phone, role } = req.body;

    // Validation
    if (!id || !name || !email || !phone || !role) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    // Store user (in production, this would be handled by Supabase Auth)
    users[id] = { id, name, email, phone, role, createdAt: new Date() };

    res.status(201).json({ message: 'User registered successfully', user: users[id] });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get user profile
router.get('/:id', (req, res) => {
  try {
    const { id } = req.params;
    const user = users[id];

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Update user profile
router.put('/:id', (req, res) => {
  try {
    const { id } = req.params;
    const updateData = req.body;

    if (!users[id]) {
      return res.status(404).json({ error: 'User not found' });
    }

    users[id] = { ...users[id], ...updateData, id };
    res.json({ message: 'User updated successfully', user: users[id] });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
