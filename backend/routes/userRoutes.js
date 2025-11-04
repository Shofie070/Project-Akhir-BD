const express = require("express");
const router = express.Router();
const userController = require("../controllers/userController");

// Get all users
router.get("/", userController.getAllUsers);

// Create new user
router.post("/", userController.createUser);

// Update user by ID
router.put("/:id", userController.updateUser);

// Delete user by ID
router.delete("/:id", userController.deleteUser);

module.exports = router;