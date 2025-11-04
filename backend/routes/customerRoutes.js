const express = require("express");
const router = express.Router();

router.get("/", (req, res) => {
  res.send("Customer routes OK!");
});

module.exports = router;
