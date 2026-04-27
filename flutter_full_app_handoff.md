# MindSense Pro: Full Flutter App Implementation Blueprint

This document is the **Master Specification** for the MindSense Pro mobile application. It outlines the entire scope of work, architecture, API endpoints, hardware integrations, and UI/UX screens required to replicate the existing web platform as a native Flutter app.

---

## 1. Tech Stack & Architecture

*   **Framework:** Flutter (Targeting iOS & Android)
*   **State Management:** `Riverpod` or `BLoC` (Recommended for handling complex async AI state and Gamification loops).
*   **Local Storage:** `Flutter Secure Storage` (for JWT tokens) + `Hive` or `Isar` (for local gamification state & offline history).
*   **Routing:** `GoRouter` or `AutoRoute` (for deep linking and auth guards).
*   **Networking:** `Dio` (preferred over `http` for interceptors, token refresh, and Multipart File uploads for camera/voice).
*   **Hardware Plugins:** `camera`, `record` (or `flutter_sound`), `path_provider`.
*   **Theming:** Dark mode by default, utilizing glassmorphism effects (BackdropFilter).

---

## 2. API Endpoints Map

The app will communicate with the existing Node.js backend and AI servers. All requests (except login/signup) must include the `Bearer` token in the `Authorization` header.

### Authentication & User Management (`/v1/users/`)
| Endpoint | Method | Payload | Description |
| :--- | :--- | :--- | :--- |
| `/v1/users/signup` | POST | `name`, `email`, `password`, `passwordConfirm` | Register a new user |
| `/v1/users/verify` | POST | `email`, `code` | Verify OTP after signup |
| `/v1/users/resendCode`| POST | `email` | Resend OTP code |
| `/v1/users/login` | POST | `email`, `password` | Returns JWT Token & User Data |
| `/v1/users/me` | GET | *None* | Get current logged-in user details |
| `/v1/users/updateMe` | PATCH| `name`, `email` (Multipart if avatar) | Update profile details |
| `/v1/users/updateMyPassword`| PATCH| `passwordCurrent`, `password`, `passwordConfirm` | Change password |
| `/v1/users/forgotPassword`| POST | `email` | Request reset code |
| `/v1/users/verifyResetCode`| POST | `email`, `code` | Verify password reset code |
| `/v1/users/resetPassword` | PATCH| `email`, `code`, `newPassword` | Set new password |

### Contacts & Emergency
| Endpoint | Method | Payload | Description |
| :--- | :--- | :--- | :--- |
| `/v1/users/add-contact` | POST | `name`, `email`, `phone`, `relation` | Add an emergency contact |
| `/v1/users/notify-contact`| POST | *None* | Trigger emergency alert to contacts |

### AI & Emotion Analysis
| Endpoint | Method | Payload | Description |
| :--- | :--- | :--- | :--- |
| `/emotion/all` | POST | `face` (File), `voice` (File) | Unified scan (Image + Audio) |
| `/emotion/face` | POST | `file` (Image File) | Face scan only |
| `/emotion/voice` | POST | `file` (Audio File) | Voice scan only |
| `/emotion/history` | GET | `?limit=100` | Fetch past emotion logs |
| `/intervention/` | POST | `state` (String: e.g., 'Anxious')| Get AI-generated advice |

---

## 3. Screen-by-Screen Breakdown

### A. Auth Flow (Unauthenticated)
1.  **Splash Screen:** Check local storage for JWT. If valid -> Dashboard. Else -> Login.
2.  **Login Screen:** Email/Password fields. Link to Signup & Forgot Password.
3.  **Signup Screen:** Form validation. Routes to OTP Verification.
4.  **OTP Verification Screen:** 6-digit pin input. Handles resend logic.
5.  **Password Reset Flow:** 3 steps (Enter Email -> Enter OTP -> Enter New Password).

### B. Core Application (Authenticated)
1.  **Dashboard / Home:**
    *   Greeting with user name.
    *   High-level summary (Current Streak, XP Level).
    *   Recent Emotion Chart (Line chart using `fl_chart`).
    *   "Daily AI Intervention" / Quote based on the last detected emotion (calls `/intervention/`).
2.  **Emotion Tracker (The Core Feature):**
    *   **UI:** Buttons for "Live Camera", "Upload Photo", "Record Voice", "Upload Audio".
    *   **Hardware:** Implement a live camera feed (`CameraPreview`). Implement a voice recording visualizer.
    *   **Action:** Submit Multipart Form Data to `/emotion/all` (or specific endpoint). Show a loading spinner during AI processing.
    *   **Result View:** Show the detected emotion, confidence percentage, AI advice, and the **Game Recommendation Card**.
3.  **Mind Games Hub (Gamification):**
    *   **Top:** Player Stats (Level Badge, XP Progress Bar, Flame Streak).
    *   **Middle:** Game Canvas. Dynamically loads the recommended mini-game. (See *Gamification Engine* section below).
    *   **Bottom:** List of recent game sessions.
4.  **Analysis & Reports (History):**
    *   Fetch from `/emotion/history`.
    *   Display a calendar heat-map or timeline list of past moods.
    *   Implement filtering (Last 7 days, 30 days).
5.  **Trusted Contacts:**
    *   List of added contacts.
    *   Form to add a new contact.
    *   **SOS Button:** Prominent button to hit `/v1/users/notify-contact`.
6.  **Profile Settings:**
    *   Edit Name/Email.
    *   Change Password.
    *   Logout button (clears local storage, routes to Login).

---

## 4. Hardware Integrations (Crucial for Mobile)

The developer must configure native permissions for both iOS (`Info.plist`) and Android (`AndroidManifest.xml`).

1.  **Camera & Photo Gallery:**
    *   Packages: `camera`, `image_picker`.
    *   Feature: User must be able to snap a live selfie. The image must be compressed before sending to the backend to reduce latency.
2.  **Microphone:**
    *   Packages: `record` or `flutter_sound`.
    *   Feature: Record audio. The backend expects specific formats (e.g., WAV or WebM). The Flutter app must record in a compatible format or convert it locally. Add a waveform animation package (like `audio_waveforms`) for visual feedback while recording.

---

## 5. The Gamification System (Client-Side Logic)

The games and gamification logic run *entirely on the device*. 

### Local State to Persist (`Hive` or `SharedPrefs`):
*   `xp` (int)
*   `points` (int)
*   `streak_days` (int)
*   `last_played` (DateTime)

### The 9 Mini-Games to Build Natively:
These should be built as reusable Flutter Widgets.
1.  **Cloud Breathing:** Animated expanding/contracting `Container`.
2.  **Memory Match:** 4x4 Grid of flipping cards (`Matrix4` transforms).
3.  **Balloon Pop:** Balloons moving bottom-to-top (`AnimatedPositioned`).
4.  **Sorting Storm:** Draggable emojis into category bins.
5.  **Speed Tap:** Randomly appearing/disappearing buttons on a `Stack`.
6.  **Word Builder:** Scrambled letter buttons to spell words.
7.  **Ice Breaker:** Tap to draw crack lines on a block (`CustomPainter`), then breathe.
8.  **Focus Flow:** Stroop Test (Word "BLUE" colored Red. Tap "RED").
9.  **Pattern Chain:** Simon-says memory sequence.

*(Note: The algorithm that maps emotions to these games is detailed in the `flutter_gamification_handoff.md` document).*

---

## 6. Implementation Roadmap / Sprint Plan

### Sprint 1: Setup, Auth, & Routing (1.5 Weeks)
*   Initialize Flutter project, configure themes (Dark Mode / Glassmorphism).
*   Setup `Dio` interceptors (injecting Bearer token).
*   Setup `GoRouter` with protected routes.
*   Build complete Auth flow (Login, Signup, OTP, Reset Password).
*   Implement Profile Settings & Edit Profile.

### Sprint 2: Core Hardware & AI Tracking (1.5 Weeks)
*   Integrate Camera & Microphone permissions.
*   Build the Live Camera preview and Voice recorder UI.
*   Implement the Multipart upload logic to `/emotion/*` endpoints.
*   Build the AI Result screen (parsing and displaying the complex JSON response).

### Sprint 3: Dashboard, Analytics, & Contacts (1 Week)
*   Build the Dashboard UI with charts (`fl_chart`).
*   Build the History/Analytics screen.
*   Build Trusted Contacts CRUD and SOS trigger.

### Sprint 4: Gamification Engine & State (1 Week)
*   Set up local storage for XP, Levels, and Streaks.
*   Port the Game Engine logic (Emotion -> Game Spec generator).
*   Build the Games Hub UI (Stats bar, history list).
*   Connect the AI Result screen to route to the Games Hub.

### Sprint 5: Mini-Games Implementation (2 Weeks)
*   Build the 9 mini-game widgets (starting with simple UI ones like Focus Flow and Word Builder, moving to animation-heavy ones like Breathing and Balloon Pop).
*   Wire up the "Game Complete" callbacks to award XP and trigger Level-up Snackbars.

### Sprint 6: Polish & Launch Prep (1 Week)
*   Test on physical iOS and Android devices (crucial for camera/mic latency).
*   Refine animations and UI transitions.
*   Handle network edge cases (timeouts during large media uploads).
*   Generate app icons and splash screens.
