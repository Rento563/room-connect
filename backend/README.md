# Rento Django Backend

Django REST API server for the Rento Flutter mobile application.

## Prerequisites
- Python 3.9+

## Setup

```bash
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## Running the Backend

```bash
cd backend
source venv/bin/activate
python manage.py migrate
python manage.py runserver
```

The backend will start on http://localhost:8000

## Environment Variables

Create a `.env` file in `backend/` if needed:

```
SECRET_KEY=your_secret_key
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
PORT=8000
```

## Endpoints

- `GET /`
- `GET /health`
- `GET /api/users/`
- `GET /api/rooms/`

## Notes

- CORS is open in development (`CORS_ALLOW_ALL_ORIGINS=True`).
- Database uses local SQLite (`backend/db.sqlite3`).
