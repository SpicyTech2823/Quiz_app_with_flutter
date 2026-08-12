const express = require("express");
const router = express.Router();
const db = require("../config/db");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const auth = require("../middleware/auth");

const fallbackUsers = [];

async function findUserByEmail(email) {
  try {
    const [rows] = await db
      .promise()
      .query("SELECT * FROM users WHERE email = ?", [email]);
    return rows;
  } catch (error) {
    console.error(
      "Database lookup failed, using in-memory fallback:",
      error.message || error,
    );
    return fallbackUsers.filter((user) => user.email === email);
  }
}

async function saveUser(username, email, passwordHash) {
  try {
    await db
      .promise()
      .query("INSERT INTO users (name, email, password) VALUES (?, ?, ?)", [
        username,
        email,
        passwordHash,
      ]);
    return true;
  } catch (error) {
    console.error(
      "Database write failed, using in-memory fallback:",
      error.message || error,
    );

    const newUser = {
      id: fallbackUsers.length + 1,
      username,
      email,
      password: passwordHash,
      phone: "",
      bio: ""
    };
    fallbackUsers.push(newUser);
    return true;
  }
}

async function updateUser(id, username, email, phone, bio) {
  try {
    // Try to update including phone and bio columns
    await db
      .promise()
      .query("UPDATE users SET name = ?, email = ?, phone = ?, bio = ? WHERE id = ?", [
        username,
        email,
        phone,
        bio,
        id,
      ]);
    return true;
  } catch (error) {
    console.error("Database update failed, attempting fallback or partial update:", error.message);

    // Fallback to in-memory if user exists there
    const userIndex = fallbackUsers.findIndex((u) => u.id === id);
    if (userIndex !== -1) {
      fallbackUsers[userIndex] = {
        ...fallbackUsers[userIndex],
        username,
        email,
        phone,
        bio
      };
      return true;
    }

    // If database exists but columns don't, try updating just name and email
    try {
      await db
        .promise()
        .query("UPDATE users SET name = ?, email = ? WHERE id = ?", [
          username,
          email,
          id,
        ]);
      return true;
    } catch (innerError) {
      console.error("Total update failure:", innerError.message);
      return false;
    }
  }
}

// User registration route
router.post("/register", async (req, res) => {
  try {
    const { username, email, password } = req.body || {};

    if (!username || !email || !password) {
      return res
        .status(400)
        .json({ message: "username, email and password are required" });
    }

    const existing = await findUserByEmail(email);
    if (existing.length > 0) {
      return res.status(400).json({ message: "User already exists" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    await saveUser(username, email, hashedPassword);

    res.status(201).json({ message: "User registered successfully" });
  } catch (error) {
    console.error("Register error:", error);
    res
      .status(500)
      .json({ message: "Server error", error: error.message || String(error) });
  }
});

// User login route
router.post("/login", async (req, res) => {
  try {
    const { email, password } = req.body || {};

    if (!email || !password) {
      return res
        .status(400)
        .json({ message: "email and password are required" });
    }

    const users = await findUserByEmail(email);

    if (users.length === 0) {
      return res.status(400).json({ message: "Invalid email or password" });
    }

    const user = users[0];
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: "Invalid email or password" });
    }

    const token = jwt.sign({ id: user.id }, process.env.JWT_SECRET, {
      expiresIn: "1h",
    });

    const username = user.username || user.name || "User";

    res.status(200).json({
      token,
      user: {
        id: user.id,
        username,
        email: user.email,
        phone: user.phone || "",
        bio: user.bio || ""
      },
    });
  } catch (error) {
    console.error("Login error:", error);
    res
      .status(500)
      .json({ message: "Server error", error: error.message || String(error) });
  }
});

// Update profile route
router.put("/update-profile", auth, async (req, res) => {
  try {
    const { username, email, phone, bio } = req.body;
    const userId = req.user.id;

    if (!username || !email) {
      return res.status(400).json({ message: "Username and email are required" });
    }

    const success = await updateUser(userId, username, email, phone, bio);

    if (success) {
      res.status(200).json({
        message: "Profile updated successfully",
        user: { username, email, phone, bio }
      });
    } else {
      res.status(500).json({ message: "Failed to update profile" });
    }
  } catch (error) {
    console.error("Update profile error:", error);
    res.status(500).json({ message: "Server error" });
  }
});

module.exports = router;
