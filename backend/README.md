# Rento Backend API

Backend API server for the Rento Flutter mobile application.

## Project Structure

```
rento_backend/
├── server.js          # Main server file
├── package.json       # Node.js dependencies
├── .env               # Environment variables
├── .gitignore         # Git ignore file
└── README.md          # This file
```

## Setup Instructions

### Prerequisites
- Node.js (v14 or higher)
- npm or yarn

### Installation

1. Navigate to the backend directory:
```bash
cd rento_backend
```

2. Install dependencies:
```bash
npm install
```

3. Configure environment variables in `.env` file:
```
PORT=5000
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

### Running the Backend

**Development mode (with auto-reload):**
```bash
npm run dev
```

**Production mode:**
```bash
npm start
```

The backend will start on `http://localhost:5000`

## API Endpoints

### Health Check
- `GET /health` - Check if backend is running

### Users
- `POST /api/users/register` - Register new user
- `GET /api/users/:id` - Get user profile

### Rooms
- `GET /api/rooms` - Get all rooms
- `POST /api/rooms` - Create new room
- `GET /api/rooms/:id` - Get specific room
- `PUT /api/rooms/:id` - Update room
- `DELETE /api/rooms/:id` - Delete room

## Configuration

Update the Flutter app's API base URL in `lib/utils/constants.dart` or create an API service file pointing to this backend:

```dart
const String apiBaseUrl = 'http://localhost:5000';
```

For production, replace with your deployed backend URL.

## Architecture

The backend acts as a middleware between the Flutter frontend and Supabase. It can be extended with:
- Authentication logic
- Image upload handling
- Business logic validation
- Payment processing
- Notification services
- And more...

## Deployment

Deploy to services like:
- Heroku
- DigitalOcean
- AWS
- Railway
- Render
- Vercel

## License

MIT
