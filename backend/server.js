const express = require('express');
const os = require('os');
const app = express();

const PORT = 3000;
const REGION = process.env.REGION || 'Default-Region';

// 1. Root Endpoint
app.get('/', (req, res) => {
  res.json({
    message: "Welcome to the High-Availability Store",
    region: REGION,
    container: os.hostname(),
    uptime: process.uptime()
  });
});

// 2. The Status Endpoint
// Simplified route to stop the crash
app.get('/status', (req, res) => {
  res.json({
    status: "healthy",
    region: REGION,
    containerId: os.hostname(),
    timestamp: new Date().toISOString()
    // db_config: getDbConnection('READ') // COMMENTED OUT FOR TESTING
  });
});
// 3. Database logic
function getDbConnection(queryType) {
  if (queryType === 'WRITE') {
    return 'postgres://user:pass@postgres-primary:5432/db';
  } else {
    return 'postgres://user:pass@postgres-replica:5432/db';
  }
}

app.listen(PORT, () => {
  console.log(`Backend live in ${REGION} on port ${PORT}`);
});