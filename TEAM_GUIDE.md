# StudySpot — Team Collaboration Guide

> Please read this entire guide before starting!

---

## 1. Project Setup (One-time only)

### 1-1. Clone the repository

```bash
git clone https://github.com/bright-hunter/studyspot.git
cd studyspot
```

### 1-2. Install Flutter packages

```bash
flutter pub get
```

### 1-3. Verify the app runs

```bash
flutter run
```

If you see the splash screen on the emulator or device, you're good to go!

---

## 2. Branch Rules

### Branch Structure

```
main        ← Stable code only (Hunter manages all merges)
  └── dev   ← Development integration branch (all work starts here)
       ├── feature/list-screen       ← Member A
       ├── feature/detail-screen     ← Member B
       ├── feature/map-screen        ← Member C
       └── feature/favorites-screen  ← Member D
```

### Important Rules

- **DO NOT push directly to the `main` branch!**
- All work must be done on a feature branch created from `dev`
- When your work is complete, open a Pull Request (PR) and Hunter will review and merge

---

## 3. Daily Workflow (Every time you start working)

### Step 1: Get the latest dev branch

```bash
git checkout dev
git pull origin dev
```

### Step 2: Create your feature branch (first time only)

```bash
git checkout -b feature/your-branch-name
```

If your branch already exists:

```bash
git checkout feature/your-branch-name
git merge dev
```

### Step 3: Do your coding work

### Step 4: Commit your changes

```bash
git add .
git commit -m "feat: brief description of what you did"
```

### Step 5: Push your branch

```bash
git push origin feature/your-branch-name
```

### Step 6: Open a Pull Request

1. Go to the GitHub repository website
2. Click "Compare & Pull Request" button
3. Set base: `dev` ← compare: `feature/your-branch-name`
4. Write a brief description of your changes
5. Click "Create Pull Request"
6. Hunter will review and merge into dev

---

## 4. Commit Message Rules

```
feat: add new feature          (e.g., feat: add search bar to list screen)
fix: fix a bug                 (e.g., fix: fix rating slider not saving)
style: UI/design changes       (e.g., style: update list item card layout)
docs: documentation changes    (e.g., docs: update README)
refactor: code improvement     (e.g., refactor: simplify database query)
```

---

## 5. Resolving Merge Conflicts

If you and another team member edited the same file, a conflict may occur.

```bash
# 1. Get the latest dev
git checkout dev
git pull origin dev

# 2. Switch to your branch and merge dev into it
git checkout feature/your-branch-name
git merge dev

# 3. Open the conflicting files in Android Studio and resolve them
# 4. After fixing, commit the changes
git add .
git commit -m "fix: resolve merge conflict"
git push origin feature/your-branch-name
```

If you're unsure how to resolve a conflict, contact Hunter!

---

## 6. Team Assignments

### Member A (Hunter) — Project Lead + List Screen

- **Files:** `lib/screens/list_screen.dart`
- **Branch:** `feature/list-screen`
- **Tasks:**
  - Display study spots using ListView + ListTile
  - Search functionality with TextField
  - Category filtering with FilterChip (All, Library, Cafe, Quiet)
  - FAB button to navigate to Add New Spot screen
- **Widgets:** ListView, ListTile, TextField, FilterChip, FloatingActionButton, Card, Icon
- **Events:** onChanged, onSelected, onTap, onPressed

### Member B — Detail/Edit Screen + Add Spot Screen

- **Files:** `lib/screens/detail_screen.dart`, `lib/screens/add_spot_screen.dart`
- **Branch:** `feature/detail-screen`
- **Tasks:**
  - View/edit form for study spot information
  - Category selection (DropdownButton)
  - Rating input (Slider)
  - Amenity tags (Chip)
  - Favorite toggle (Switch)
  - Save/Delete buttons to persist data in SQLite
  - Add Spot screen for creating new entries
- **Widgets:** TextField, DropdownButton, Slider, Chip, Switch, ElevatedButton, Image
- **Events:** onChanged, onDeleted, onPressed

### Member C — Map Screen

- **Files:** `lib/screens/map_screen.dart`
- **Branch:** `feature/map-screen`
- **Tasks:**
  - Display map using flutter_map
  - Load study spots from SQLite and show as markers
  - Color-coded markers: Library=Blue, Cafe=Green, Co-working=Orange
  - Tap marker to show BottomSheet with spot info
  - "View" button to navigate to Detail screen
- **Widgets:** FlutterMap, Marker, BottomSheet, Card, ElevatedButton
- **Events:** onTap (marker), onPressed

### Member D — Favorites Screen + Splash Polish

- **Files:** `lib/screens/favorites_screen.dart`, `lib/screens/splash_screen.dart`
- **Branch:** `feature/favorites-screen`
- **Tasks:**
  - Display favorite spots list (filtered by is_favorite = 1)
  - Swipe to remove from favorites (Dismissible)
  - SnackBar with "Undo" action
  - Polish splash screen design (image/animation)
- **Widgets:** ListView, ListTile, Dismissible, SnackBar, Icon
- **Events:** onTap, onDismissed

---

## 7. Shared Code (Do NOT modify without permission!)

| File                                | Description                                                        |
| ----------------------------------- | ------------------------------------------------------------------ |
| `lib/models/study_spot.dart`        | Data model (toMap, fromMap, copyWith)                              |
| `lib/database/database_helper.dart` | SQLite CRUD (insert, getAll, update, delete, getFavorites, search) |
| `lib/services/api_service.dart`     | REST API calls (weather, place search)                             |
| `lib/main.dart`                     | App entry point, theme configuration                               |
| `lib/screens/home_screen.dart`      | BottomNavigationBar (3-tab structure)                              |

If you need to modify any of these files, please talk to Hunter first.

---

## 8. Project Schedule

| Phase   | Period          | Tasks                                                        |
| ------- | --------------- | ------------------------------------------------------------ |
| Phase 1 | Apr 2 – Apr 10  | Basic UI implementation for each screen + SQLite integration |
| Phase 2 | Apr 11 – Apr 17 | API integration + Map integration + Cross-screen testing     |
| Phase 3 | Apr 18 – Apr 23 | Full integration testing + Bug fixes + Final documentation   |

### Deadline: **April 23, 2026 (Wed) 11:59 PM — NO LATE SUBMISSIONS ACCEPTED!**

---

## 9. Getting Help

- **Git issues:** Contact Hunter
- **Code questions:** Share in the team group chat
- **flutter_map docs:** https://docs.fleaflet.dev/
- **sqflite docs:** https://pub.dev/packages/sqflite
- **Flutter widgets:** https://docs.flutter.dev/ui/widgets

Let's build a great app together!
