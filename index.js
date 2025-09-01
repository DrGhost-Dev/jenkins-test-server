const express = require('express');
const app = express();
const PORT = 80;

app.get('/', (req, res) => {
  res.send('Hello, World! CI/CD test successful with Node.js.');
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`abServer is running on http://0.0.0.0:${PORT}`);
});