# ❌ Base image cũ, không pin digest (SEC-9 / CODE-008)
FROM node:16

WORKDIR /app

# ❌ Copy toàn bộ, gồm cả secret nếu có (SEC-6)
COPY . .

# ❌ Cài đặt chạy cả install script (SEC-3)
RUN npm install

# ❌ Chạy bằng root (OPR-001 / SEC-5)
# (không có USER directive)

EXPOSE 3000
CMD ["node", "src/server.js"]
