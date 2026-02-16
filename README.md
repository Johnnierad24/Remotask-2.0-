# CANARY - Fair Remote Micro-Jobs Platform

A fair and transparent remote micro-jobs platform built specifically for African youth, offering reliable payments, clear rules, and skill development opportunities.

## 🌟 Features

### For Workers
- ✅ Browse and complete micro-tasks (image annotation, transcription, data entry, etc.)
- ✅ Transparent pricing and clear task instructions
- ✅ Secure wallet with multiple payout options (M-Pesa, Airtel Money, MTN MoMo, Bank Transfer)
- ✅ Track submission status (Pending, Approved, Rejected)
- ✅ Fair rejection system with clear reasons

### For Clients
- ✅ Create and manage tasks easily
- ✅ Upload task files and instructions
- ✅ Review worker submissions
- ✅ Approve or reject work with feedback
- ✅ Transparent billing and wallet management

### For Admins
- ✅ Dashboard with platform statistics
- ✅ User management
- ✅ Task oversight
- ✅ Payout approval system

## 🛠️ Tech Stack

### Backend (NestJS + PostgreSQL)
- **Framework:** NestJS (Node.js)
- **Database:** PostgreSQL
- **ORM:** Prisma
- **Authentication:** JWT
- **File Storage:** Supabase Storage
- **Payments:** Flutterwave
- **Email:** Nodemailer

### Frontend (Flutter)
- **Framework:** Flutter (Mobile + Web)
- **State Management:** Provider
- **HTTP Client:** Dio
- **Routing:** Go Router (ready to integrate)
- **Secure Storage:** Flutter Secure Storage

## 📁 Project Structure

```
Remotask-2.0/
├── backend/                 # NestJS backend
│   ├── src/
│   │   ├── main.ts         # Application entry point
│   │   ├── app.module.ts   # Root module
│   │   ├── storage/        # Supabase file storage service
│   │   └── payment/        # Flutterwave payment service
│   ├── auth/               # Authentication & all controllers/services
│   ├── prisma/             # Database schema & migrations
│   ├── .env                # Environment variables (git-ignored)
│   ├── .env.example        # Environment template
│   └── package.json
├── frontend/               # Flutter frontend
│   └── remotask_frontend/
│       ├── lib/
│       │   ├── main.dart
│       │   ├── services/   # API service (Dio)
│       │   ├── screens/    # All UI screens
│       │   │   ├── worker/ # Worker-specific screens
│       │   │   ├── client/ # Client-specific screens
│       │   │   └── admin/  # Admin dashboard
│       │   └── widgets/
│       └── pubspec.yaml
├── .env.production.template # Production environment template
├── docker-compose.yml      # Local development with Docker
├── Dockerfile.backend      # Backend Docker image
├── render.yaml             # Render.com deployment config
├── railway.json            # Railway deployment config
└── README.md               # This file
```

## 🚀 Quick Start

### Prerequisites
- **Node.js** 20+ and npm
- **PostgreSQL** 15+
- **Flutter** 3.9+
- **Dart** SDK

### Backend Setup

1. **Navigate to backend directory:**
   ```bash
   cd backend
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Set up environment variables:**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

4. **Set up database:**
   ```bash
   # Make sure PostgreSQL is running
   npx prisma migrate dev --name init
   npx prisma generate
   ```

5. **Start development server:**
   ```bash
   npm run start:dev
   ```

   Backend will run on `http://localhost:3000/api/v1`

### Frontend Setup

1. **Navigate to frontend directory:**
   ```bash
   cd frontend/remotask_frontend
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Update API base URL:**
   - Open `lib/services/api_service.dart`
   - Update `baseUrl` to match your backend URL

4. **Run the app:**
   ```bash
   # For web
   flutter run -d chrome

   # For mobile (with emulator/device connected)
   flutter run
   ```

## 🔧 Configuration

### Database Setup

1. **Local PostgreSQL:**
   ```bash
   # Create database
   createdb remotaskdb

   # Update DATABASE_URL in .env
   DATABASE_URL="postgresql://postgres:password@localhost:5432/remotaskdb"
   ```

2. **Using Docker Compose:**
   ```bash
   docker-compose up -d postgres
   ```

### Supabase Setup (File Storage)

1. Create account at [supabase.com](https://supabase.com)
2. Create a new project
3. Go to **Storage** → Create bucket named `remotask-files`
4. Get API keys from **Settings** → **API**
5. Update `.env`:
   ```env
   SUPABASE_URL="https://your-project.supabase.co"
   SUPABASE_ANON_KEY="your-anon-key"
   SUPABASE_SERVICE_ROLE_KEY="your-service-role-key"
   ```

### Flutterwave Setup (Payments)

1. Sign up at [flutterwave.com](https://flutterwave.com)
2. Get API keys from **Settings** → **API**
3. Start with TEST keys for development
4. Update `.env`:
   ```env
   FLUTTERWAVE_PUBLIC_KEY="FLWPUBK_TEST-xxxxx"
   FLUTTERWAVE_SECRET_KEY="FLWSECK_TEST-xxxxx"
   ```

## 🐳 Docker Deployment

### Local Development with Docker

```bash
# Start all services (PostgreSQL + Backend)
docker-compose up

# Stop all services
docker-compose down

# Rebuild after code changes
docker-compose up --build
```

## ☁️ Production Deployment

### Deploy to Railway

1. **Install Railway CLI:**
   ```bash
   npm install -g @railway/cli
   ```

2. **Login and initialize:**
   ```bash
   railway login
   railway init
   ```

3. **Add PostgreSQL database:**
   ```bash
   railway add
   # Select PostgreSQL
   ```

4. **Set environment variables:**
   ```bash
   railway variables set JWT_SECRET="your-secret"
   railway variables set SUPABASE_URL="your-url"
   # ... add all required variables
   ```

5. **Deploy:**
   ```bash
   railway up
   ```

### Deploy to Render

1. **Push code to GitHub**

2. **Connect repository on Render:**
   - Go to [render.com](https://render.com)
   - New → Blueprint
   - Connect your GitHub repo
   - Render will auto-detect `render.yaml`

3. **Add environment variables** in Render dashboard

4. **Deploy!**

## 📱 API Documentation

### Authentication
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - Login user

### Worker APIs
- `GET /api/v1/tasks` - Get available tasks
- `GET /api/v1/tasks/:id` - Get task details
- `POST /api/v1/submissions` - Submit task
- `GET /api/v1/submissions` - Get my submissions
- `GET /api/v1/wallet` - Get wallet info
- `POST /api/v1/wallet/withdraw` - Request withdrawal

### Client APIs
- `POST /api/v1/tasks` - Create task
- `GET /api/v1/tasks/:id/submissions` - Get task submissions
- `POST /api/v1/submissions/:id/approve` - Approve submission
- `POST /api/v1/submissions/:id/reject` - Reject submission

### Admin APIs
- `GET /api/v1/admin/stats` - Get platform statistics
- `GET /api/v1/admin/users` - Get all users
- `GET /api/v1/admin/payouts` - Get payout requests
- `PUT /api/v1/admin/payouts/:id/approve` - Approve payout

## 🔐 Security

- JWT-based authentication
- Password hashing with bcrypt
- Environment variables for sensitive data
- CORS configured for frontend
- Role-based access control (Worker/Client/Admin)
- Input validation with class-validator

## 🧪 Testing

### Backend
```bash
cd backend
npm run test          # Unit tests
npm run test:e2e      # E2E tests
npm run test:cov      # Coverage
```

### Frontend
```bash
cd frontend/remotask_frontend
flutter test
```

## 📝 Environment Variables

See `.env.example` (backend) and `.env.production.template` (root) for all required environment variables.

**Critical variables:**
- `DATABASE_URL` - PostgreSQL connection string
- `JWT_SECRET` - Secret key for JWT (use strong random value)
- `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY` - File storage
- `FLUTTERWAVE_SECRET_KEY` - Payment processing

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

For issues and questions:
- Create an issue on GitHub
- Email: support@remotask.com

## 🎯 Roadmap

- [ ] M-Pesa direct integration (bypassing Flutterwave)
- [ ] Mobile app (iOS + Android) on app stores
- [ ] Skill-based task recommendations
- [ ] Worker rating and leveling system
- [ ] Real-time notifications (WebSocket)
- [ ] Multi-language support
- [ ] Advanced analytics dashboard
- [ ] API rate limiting
- [ ] Worker training modules

## ⚡ Performance Notes

- Backend optimized for low-bandwidth environments
- Frontend Flutter app works on low-end devices
- Database queries optimized with Prisma
- Image optimization for task files
- Caching implemented for frequently accessed data

---

**Built with ❤️ for African youth by the Remotask Team**
