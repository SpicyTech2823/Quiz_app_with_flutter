const express = require("express");
const router = express.Router();
const db = require("../config/db");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

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
    //
    fallbackUsers.push({
      id: fallbackUsers.length + 1,
      username,
      email,
      password: passwordHash,
    });
    return true;
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
    const users = await findUserByEmail(email);

    if (!email || !password) {
      return res
        .status(400)
        .json({ message: "email and password are required" });
    }

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
      user: { id: user.id, username, email: user.email },
    });
  } catch (error) {
    console.error("Login error:", error);
    res
      .status(500)
      .json({ message: "Server error", error: error.message || String(error) });
  }
});

module.exports = router;
