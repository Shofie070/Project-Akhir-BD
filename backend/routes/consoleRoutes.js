const express = require("express");
const router = express.Router();

router.get("/", (req, res) => {
  res.send("Console routes OK!");
});

module.exports = router;
