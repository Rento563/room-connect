# Room Connect - Supabase Setup Guide

This document explains how to set up Supabase for your Room Connect app.

## Prerequisites

1. Create a Supabase account at https://supabase.com
2. Create a new project in Supabase
3. Get your project URL and anon key from Project Settings → API

## Step 1: Configure Supabase in Flutter

Your app is already configured in: lib/utils/supabase_config.dart

## Step 2: Create Database Tables

Run the following SQL in Supabase Dashboard → SQL Editor:

### Table 1: Users

```sql
CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  phone TEXT,
  role TEXT NOT NULL CHECK (role IN ('tenant', 'landowner')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view all users" ON users FOR SELECT USING (true);
CREATE POLICY "Users can insert own profile" ON users FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON users FOR UPDATE USING (auth.uid() = id);
```

### Table 2: Rooms

```sql
CREATE TABLE rooms (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT,
  price NUMERIC NOT NULL,
  location TEXT NOT NULL,
  images TEXT[] DEFAULT '{}',
  room_type TEXT,
  owner_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  amenities TEXT[] DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE rooms ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view rooms" ON rooms FOR SELECT USING (true);
CREATE POLICY "Owners can insert rooms" ON rooms FOR INSERT WITH CHECK (auth.uid() = owner_id);
CREATE POLICY "Owners can update rooms" ON rooms FOR UPDATE USING (auth.uid() = owner_id);
CREATE POLICY "Owners can delete rooms" ON rooms FOR DELETE USING (auth.uid() = owner_id);
```

### Table 3: Messages

```sql
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  room_id UUID NOT NULL REFERENCES rooms(id) ON DELETE CASCADE,
  tenant_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  message TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
```

## Step 3: Set up Storage

1. Go to Supabase Dashboard → Storage
2. Create bucket named "room-images" (make it public)
3. Allow jpg, jpeg, png, webp file types

## Step 4: Test Your Setup

Run: flutter run
