const express = require('express');
const { execSync } = require('child_process');
const jwt = require('jsonwebtoken');

const app = express();
app.use(express.json());

// ❌ SAST-1: Hardcoded secret (CODE-002 / CICD-SEC-6)
const JWT_SECRET = 'sup3r-s3cr3t-hardcoded-key-do-not-do-this';
const DB_PASSWORD = 'Payment$DB_Pr0d_2024!';

// ❌ SAST-2: Command Injection (CWE-78)
app.get('/ping', (req, res) => {
  const host = req.query.host;
  // Nội suy input người dùng thẳng vào shell -> command injection
  const output = execSync(`ping -c 1 ${host}`).toString();
  res.send(output);
});

// ❌ SAST-3: SQL Injection dạng chuỗi (mô phỏng)
app.get('/user', (req, res) => {
  const id = req.query.id;
  const query = "SELECT * FROM users WHERE id = '" + id + "'";
  res.json({ query, note: 'query duoc ghep chuoi tu input -> SQLi' });
});

// ❌ SAST-4: JWT verify tắt kiểm tra chữ ký
app.get('/whoami', (req, res) => {
  const token = req.headers.authorization;
  // decode KHONG verify -> chap nhan token gia mao
  const payload = jwt.decode(token);
  res.json({ user: payload });
});

app.get('/health', (_req, res) => res.json({ status: 'ok' }));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`vuln-pay-api on :${PORT}`));

module.exports = app;
