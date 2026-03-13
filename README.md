# 📝 Mini TaskHub – Flutter Developer Assignment

## 🚀 Overview

Mini TaskHub is a clean, modern personal task management application built using **Flutter** and **Supabase**.

The app allows users to securely manage tasks with real-time synchronization, smooth animations, and a responsive **Material 3** UI.

---

## ✨ Features

- 🔐 Email/Password Authentication (Supabase Auth)
- ➕ Add Tasks
- ✏️ Edit Tasks
- 🗑 Delete Tasks (Swipe to Delete)
- ✅ Mark Tasks as Completed
- ⚡ Real-time Updates (Supabase Realtime)
- 🔄 Pull-to-Refresh
- 🌙 Light / Dark Mode Toggle
- 🎨 Smooth UI Animations
- 🧪 Unit Test for Task Model Serialization

---

## 🛠 Tech Stack

- **Flutter**
- **Riverpod** (State Management)
- **Supabase** (Authentication + Database + Realtime)
- **Material 3**
- **Dart**

---

## 🏗 Architecture

The project follows a clean and modular folder structure:

```
lib/
├── app/              # Theme configuration
├── auth/             # Authentication screens & service
├── dashboard/        # Dashboard UI, TaskTile, TaskModel
├── providers/        # Riverpod providers
├── main.dart         # App entry point
```

State management is handled using **Riverpod**, ensuring separation of concerns and reactive UI updates.

---

## 🔐 Supabase Setup

### 1️⃣ Create a Supabase Project  
Go to: https://supabase.com

### 2️⃣ Create Tasks Table

```sql
create extension if not exists "uuid-ossp";

create table tasks (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id) on delete cascade,
  title text not null,
  is_completed boolean default false,
  created_at timestamp with time zone default now()
);
```

### 3️⃣ Enable Row Level Security

```sql
alter table tasks enable row level security;
```

### 4️⃣ Add Security Policy

```sql
create policy "Users can manage their tasks"
on tasks
for all
using (auth.uid() = user_id);
```

This ensures users can only access their own tasks.

---

## ▶️ How to Run

```bash
flutter pub get
flutter run
```

Replace the Supabase URL and anon key inside `main.dart` with your own credentials.

---

## 🔄 Hot Reload vs Hot Restart

| Feature      | Hot Reload | Hot Restart |
|-------------|------------|------------|
| Rebuild UI  | ✅         | ✅         |
| Reset State | ❌         | ✅         |
| Speed       | Faster     | Slightly slower |

Hot Reload updates UI without losing application state.  
Hot Restart resets the entire app state.

---

## 🧪 Testing

A unit test is included for Task model JSON serialization.

Run:

```bash
flutter test
```

---

## 🎥 Demo Video

📎 **Demo Link:** *(Add your YouTube / Google Drive link here)*

---

## ⏱ Development Time

Completed in approximately **14–15 hours** within the given 3-day timeline.

---

## 🏁 Bonus Implemented

- ✅ Task Editing
- ✅ Real-time Updates
- ✅ Theme Toggle
- ✅ Pull-to-Refresh
- ✅ Smooth Animations

---

## 📌 Final Notes

- Clean modular architecture
- Secure Supabase integration with RLS
- Reactive UI using Riverpod
- Production-style animations and theming
