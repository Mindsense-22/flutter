# 🧠 MindSense Pro — Full API & System Reference

> **Flutter Developer's Complete Guide**  
> Backend: Node.js + Express · Base URL: `http://localhost:5020`  
> AI Service: FastAPI · Base URL: `http://localhost:8000`  
> Database: MongoDB · Auth: JWT (Bearer Token)

---

## 📑 Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Environment Setup](#environment-setup)
3. [Running the Stack](#running-the-stack)
4. [Authentication Flow](#authentication-flow)
5. [Backend API — `/api/v1/users`](#backend-api--apiv1users)
6. [Backend API — `/api/emotion`](#backend-api--apiemotion)
7. [Backend API — `/api/intervention`](#backend-api--apiintervention)
8. [AI Service Endpoints (Direct)](#ai-service-endpoints-direct)
9. [Data Models](#data-models)
10. [Error Responses](#error-responses)
11. [Quick Reference Table](#quick-reference-table)

---

## Architecture Overview

```
Flutter App
    │
    ▼
Backend (Node.js + Express :5020)
    ├── /api/v1/users     → Auth, Profile, Trusted Contact
    ├── /api/emotion      → Face & Voice Analysis (proxied to AI)
    └── /api/intervention → AI Advice (proxied to AI)
            │
            ▼
AI Service (FastAPI :8000)
    ├── /analyze-face     → Face Emotion via ViT model
    ├── /analyze-voice    → Voice Emotion via Wav2Vec2
    ├── /analyze-all      → Fusion (Face + Voice weighted)
    ├── /get-advice       → RAG-based coaching (Groq LLM)
    └── /analyze-trends   → Behavioral trend analytics
```

> **Flutter only talks to the Backend (port 5020).**  
> The AI service (port 8000) is internal — the backend proxies calls to it.

---

## Environment Setup

### `back/.env`
```env
PORT=5020
MONGO_URI="mongodb+srv://..."
JWT_SECRET="your_secret_key"
JWT_EXPIRES_IN=90d
EMAIL_USERNAME="your_email@gmail.com"
EMAIL_PASSWORD="your_email_app_password"
AI_BASE_URL=http://ai:8000         # Docker internal / or http://localhost:8000 locally
```

### `ai/.env`
```env
GROQ_API_KEY=your_groq_api_key
```

---

## Running the Stack

```bash
# Full stack (Docker)
docker compose up --build -d

# Locally — Backend
cd back && npm install && npm run dev

# Locally — AI (Python 3.11)
cd ai && pip install -r dependencies.txt && uvicorn ai_server:app --reload --port 8000
```

| Service  | URL                        |
|----------|----------------------------|
| Backend  | http://localhost:5020       |
| AI       | http://localhost:8000       |
| Frontend | http://localhost:3000       |

---

## Authentication Flow

All protected routes require a **Bearer JWT token** in the `Authorization` header:

```
Authorization: Bearer <token>
```

Tokens are returned from: `signup → verify`, `login`, and `resetPassword`.

```
signup ──► verifyAccount ──► [token issued] ──► protected routes
                ▲
                │ (if code expired)
           resendCode
```

---

## Backend API — `/api/v1/users`

### 🔓 Public Routes (No Auth Required)

---

#### `POST /api/v1/users/signup`
Register a new user. Sends a 6-digit verification code to email.

**Request Body:**
```json
{
  "name": "Ahmed Ali",
  "email": "ahmed@example.com",
  "password": "Pass@1234",
  "passwordConfirm": "Pass@1234",
  "age": 25
}
```

> **Password Rules:** Min 8 chars, must contain uppercase, lowercase, number, and special char (`@$!%*?&`)

**Success Response `201`:**
```json
{
  "status": "success",
  "message": "Registration successful! Check your email for the activation code."
}
```

**Error Responses:**
| Code | Reason |
|------|--------|
| `400` | Email already taken, validation error |
| `500` | Email sending failed (user deleted, retry) |

---

#### `POST /api/v1/users/verify`
Verify email with the 6-digit code. **Returns JWT token on success.**

**Request Body:**
```json
{
  "email": "ahmed@example.com",
  "code": "482915"
}
```

**Success Response `200`:**
```json
{
  "status": "success",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "data": {
    "user": {
      "_id": "665f...",
      "name": "Ahmed Ali",
      "email": "ahmed@example.com",
      "age": 25,
      "isVerified": true,
      "createdAt": "2025-04-26T15:00:00.000Z"
    }
  }
}
```

**Error Responses:**
| Code | Reason |
|------|--------|
| `400` | User not found, invalid code, or code expired (10 min TTL) |

---

#### `POST /api/v1/users/resendCode`
Resend a new verification code to email.

**Request Body:**
```json
{
  "email": "ahmed@example.com"
}
```

**Success Response `200`:**
```json
{
  "status": "success",
  "message": "A new code has been sent to your email."
}
```

**Error Responses:**
| Code | Reason |
|------|--------|
| `404` | Email not registered |
| `400` | Account already verified |
| `500` | Email sending failed |

---

#### `POST /api/v1/users/login`
Login with email and password. **Returns JWT token.**

**Request Body:**
```json
{
  "email": "ahmed@example.com",
  "password": "Pass@1234"
}
```

**Success Response `200`:**
```json
{
  "status": "success",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Error Responses:**
| Code | Reason |
|------|--------|
| `400` | Missing email or password |
| `401` | Wrong credentials, or account not verified |

---

#### `POST /api/v1/users/forgotPassword`
Request a password reset code (sent to email).

**Request Body:**
```json
{
  "email": "ahmed@example.com"
}
```

**Success Response `200`:**
```json
{
  "status": "success",
  "message": "A password recovery code has been sent to your email."
}
```

**Error Responses:**
| Code | Reason |
|------|--------|
| `404` | Email not found |
| `500` | Email sending failed |

---

#### `POST /api/v1/users/verifyResetCode`
Verify the password reset code (does **NOT** change the password yet).

**Request Body:**
```json
{
  "email": "ahmed@example.com",
  "code": "391047"
}
```

**Success Response `200`:**
```json
{
  "status": "success",
  "message": "Correct code, now you can update your password"
}
```

**Error Responses:**
| Code | Reason |
|------|--------|
| `400` | Invalid or expired code (10 min TTL) |

---

#### `PATCH /api/v1/users/resetPassword`
Set a new password after verifying the reset code. **Returns a new JWT token.**

**Request Body:**
```json
{
  "email": "ahmed@example.com",
  "code": "391047",
  "newPassword": "NewPass@5678"
}
```

**Success Response `200`:**
```json
{
  "status": "success",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "message": "The password has been successfully changed!"
}
```

---

#### `GET /api/v1/users/approve-contact/:token`
**Web-only link** — Trusted contact clicks this from their email to accept the invitation.  
Returns an HTML confirmation page. Flutter does **NOT** call this directly.

---

### 🔐 Protected Routes (JWT Required)

> Add header: `Authorization: Bearer <token>`

---

#### `GET /api/v1/users/me`
Get the currently authenticated user's profile.

**Success Response `200`:**
```json
{
  "status": "success",
  "data": {
    "user": {
      "_id": "665f...",
      "name": "Ahmed Ali",
      "email": "ahmed@example.com",
      "age": 25,
      "isVerified": true,
      "trustedContact": {
        "name": "Sara",
        "email": "sara@example.com",
        "relationship": "Sister",
        "status": "accepted"
      },
      "createdAt": "2025-04-26T15:00:00.000Z"
    }
  }
}
```

---

#### `PATCH /api/v1/users/updateMe`
Update profile data (name, email, age only).

> ⚠️ Do NOT send `password` here — use `/updateMyPassword` instead.

**Request Body (send only fields you want to update):**
```json
{
  "name": "Ahmed Mohamed",
  "age": 26
}
```

**Success Response `200`:**
```json
{
  "status": "success",
  "data": {
    "user": { "...updatedUserObject" : "..." }
  }
}
```

---

#### `PATCH /api/v1/users/updateMyPassword`
Change password while logged in. **Returns a new JWT token.**

**Request Body:**
```json
{
  "passwordCurrent": "OldPass@1234",
  "password": "NewPass@5678",
  "passwordConfirm": "NewPass@5678"
}
```

**Success Response `200`:**
```json
{
  "status": "success",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "message": "The password has been successfully changed."
}
```

**Error Responses:**
| Code | Reason |
|------|--------|
| `401` | Current password incorrect |

---

#### `POST /api/v1/users/add-contact`
Add a trusted contact. Sends an email invitation to the contact for approval.

**Request Body:**
```json
{
  "contactName": "Sara Ali",
  "contactEmail": "sara@example.com",
  "relationship": "Sister"
}
```

**Success Response `200`:**
```json
{
  "status": "success",
  "message": "An invitation was successfully sent to the trusted person."
}
```

> The contact must click their approval email link.  
> After that, `trustedContact.status` becomes `"accepted"`.

---

#### `POST /api/v1/users/notify-contact`
Manually notify the trusted contact about a dangerous emotional state.

**Request Body:**
```json
{
  "state": "Angry",
  "note": "I've been feeling overwhelmed today."
}
```

> `note` is optional. `state` is required.

**Success Response `200`:**
```json
{
  "status": "success",
  "message": "Trusted contact notified successfully"
}
```

**Error Responses:**
| Code | Reason |
|------|--------|
| `400` | `state` missing, or no accepted trusted contact found |

---

## Backend API — `/api/emotion`

> All routes require: `Authorization: Bearer <token>`

---

#### `POST /api/emotion/face`
Upload a face image → AI detects emotion → saved to DB → returns advice.

**Content-Type:** `multipart/form-data`

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| `file` | File (image) | ✅ | JPEG or PNG face photo |

**Success Response `200`:**
```json
{
  "analysis": {
    "status": "success",
    "state": "Happy",
    "scores": {
      "Angry": 0.05,
      "Sad": 0.10,
      "Happy": 0.80,
      "Neutral": 0.05
    }
  },
  "emotion": {
    "_id": "665...",
    "user": "664...",
    "source": "face",
    "state": "Happy",
    "confidence": 0.80,
    "createdAt": "2025-04-26T15:30:00.000Z"
  },
  "advice": "🎉 أنت بخير! حافظ على هذه الطاقة الإيجابية...",
  "contactNotified": false
}
```

> `contactNotified` becomes `"success"` or `"failed"` if the detected state is dangerous (Sad, Angry, etc.) and a trusted contact exists.

---

#### `POST /api/emotion/voice`
Upload an audio recording → AI detects voice emotion → saved to DB → returns advice.

**Content-Type:** `multipart/form-data`

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| `file` | File (audio) | ✅ | WAV recommended (16kHz mono preferred) |

**Success Response `200`:**
```json
{
  "analysis": {
    "status": "success",
    "final_emotion": "Sad",
    "confidence": 0.72,
    "details": {
      "Happy": 0.05,
      "Sad": 0.72,
      "Angry": 0.10,
      "Neutral": 0.13
    }
  },
  "emotion": {
    "_id": "666...",
    "user": "664...",
    "source": "voice",
    "state": "Sad",
    "confidence": 0.72,
    "createdAt": "2025-04-26T15:35:00.000Z"
  },
  "advice": "💙 أفهم إنك حاسس بحزن...",
  "contactNotified": "success"
}
```

---

#### `POST /api/emotion/all`
Upload both face image + voice clip → AI fuses both results → saved to DB → returns advice.

**Content-Type:** `multipart/form-data`

| Field | Type | Required |
|-------|------|----------|
| `face` | File (image) | ✅ |
| `voice` | File (audio) | ✅ |

**Success Response `200`:**
```json
{
  "analysis": {
    "status": "success",
    "face": {
      "scores": { "Happy": 0.70, "Sad": 0.10, "Angry": 0.12, "Neutral": 0.08 },
      "dominant": "Happy"
    },
    "voice": {
      "scores": { "Happy": 0.30, "Sad": 0.45, "Angry": 0.15, "Neutral": 0.10 },
      "final_emotion": "Sad",
      "confidence": 0.45
    },
    "fusion": {
      "final_state": "Happy",
      "scores": { "Happy": 0.39, "Sad": 0.30, "Angry": 0.13, "Neutral": 0.09 },
      "weights": { "face": 0.4, "voice": 0.6 },
      "conflict": true
    },
    "advice": "🔥 لاحظنا تضارب بين مشاعرك..."
  },
  "emotion": {
    "source": "fusion",
    "state": "Happy",
    "confidence": 0.39
  },
  "advice": "...",
  "contactNotified": false
}
```

> **Fusion Weight Logic:**
> | Voice Confidence | Face Weight | Voice Weight |
> |------------------|-------------|--------------|
> | > 0.8 | 30% | 70% |
> | 0.5 – 0.8 | 40% | 60% |
> | < 0.5 | 60% | 40% |

---

#### `GET /api/emotion/history`
Fetch the user's emotion detection history.

**Query Parameters:**

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `limit` | Number | `50` | Max records to return |
| `source` | String | — | Filter: `"face"`, `"voice"`, or `"fusion"` |
| `from` | ISO Date | — | Start date e.g. `2025-04-01` |
| `to` | ISO Date | — | End date e.g. `2025-04-30` |

**Example:**
```
GET /api/emotion/history?limit=20&source=face&from=2025-04-01&to=2025-04-30
```

**Success Response `200`:**
```json
{
  "status": "success",
  "results": 2,
  "data": [
    {
      "_id": "665...",
      "user": "664...",
      "source": "face",
      "state": "Happy",
      "confidence": 0.80,
      "raw": { "..." : "..." },
      "createdAt": "2025-04-26T15:30:00.000Z"
    }
  ]
}
```

---

#### `GET /api/emotion/report`
Get an aggregated emotion report grouped by day or week.

**Query Parameters:**

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `groupBy` | String | `"daily"` | `"daily"` or `"weekly"` |
| `from` | ISO Date | — | Start date |
| `to` | ISO Date | — | End date |

**Example:**
```
GET /api/emotion/report?groupBy=weekly&from=2025-04-01
```

**Success Response `200` (daily):**
```json
{
  "status": "success",
  "data": [
    {
      "_id": { "state": "Happy", "day": "2025-04-26" },
      "count": 5,
      "avgConfidence": 0.78
    },
    {
      "_id": { "state": "Sad", "day": "2025-04-25" },
      "count": 2,
      "avgConfidence": 0.65
    }
  ]
}
```

**Success Response `200` (weekly):**
```json
{
  "status": "success",
  "data": [
    {
      "_id": { "state": "Happy", "week": 17, "year": 2025 },
      "count": 12,
      "avgConfidence": 0.75
    }
  ]
}
```

---

## Backend API — `/api/intervention`

---

#### `POST /api/intervention`
Get an AI-generated coaching advice for a given mental state.

> 🔓 **Public route — No auth required.**

**Request Body:**
```json
{
  "state": "Sad"
}
```

> Valid states: `"Happy"`, `"Sad"`, `"Angry"`, `"Neutral"` (any variant accepted)

**Success Response `200`:**
```json
{
  "status": "success",
  "advice": "💙 أفهم إنك حاسس بحزن دلوقتي...\n- 🌬️ جرب تاخد نفس عميق...\n- 🎵 اسمع موسيقى بتريحك..."
}
```

---

## AI Service Endpoints (Direct)

> These are **internal** endpoints on port `8000`.  
> Flutter should **NOT** call them directly. Documented here for testing/debugging only.

---

#### `POST /analyze-face`

**Content-Type:** `multipart/form-data`

| Field | Type | Notes |
|-------|------|-------|
| `file` | File (image) | Face photo |

**Model:** `trpakov/vit-face-expression` (HuggingFace ViT)

**Response:**
```json
{
  "status": "success",
  "emotion": {
    "status": "success",
    "state": "Happy",
    "scores": {
      "Angry": 0.05,
      "Sad": 0.10,
      "Happy": 0.80,
      "Neutral": 0.05
    }
  }
}
```

---

#### `POST /analyze-voice`

**Content-Type:** `multipart/form-data`

| Field | Type | Notes |
|-------|------|-------|
| `file` | File (audio) | WAV, 16kHz mono preferred |

**Model:** `superb/wav2vec2-base-superb-er` (HuggingFace Wav2Vec2)

**Response:**
```json
{
  "status": "success",
  "final_emotion": "Sad",
  "confidence": 0.72,
  "details": {
    "Happy": 0.05,
    "Sad": 0.72,
    "Angry": 0.10,
    "Neutral": 0.13
  }
}
```

---

#### `POST /analyze-all`

**Content-Type:** `multipart/form-data`

| Field | Type | Notes |
|-------|------|-------|
| `face` | File (image) | Face photo |
| `voice` | File (audio) | Audio recording |

**Response:**
```json
{
  "status": "success",
  "face": {
    "scores": { "Happy": 0.70, "Sad": 0.10, "Angry": 0.12, "Neutral": 0.08 },
    "dominant": "Happy"
  },
  "voice": {
    "scores": { "Happy": 0.30, "Sad": 0.45, "Angry": 0.15, "Neutral": 0.10 },
    "final_emotion": "Sad",
    "confidence": 0.45
  },
  "fusion": {
    "final_state": "Happy",
    "scores": { "Happy": 0.39, "Sad": 0.30, "Angry": 0.13, "Neutral": 0.09 },
    "weights": { "face": 0.4, "voice": 0.6 },
    "conflict": true
  },
  "advice": "🔥 نصيحة الـ coach..."
}
```

---

#### `POST /get-advice`

**Content-Type:** `application/json`

**Request Body:**
```json
{
  "state": "Angry"
}
```

**Response:**
```json
{
  "status": "success",
  "advice": "🔥 خد نفس عميق دلوقتي...\n- 🌬️ تقنية 4-7-8..."
}
```

**RAG Pipeline:**  
`protocols.pdf` → FAISS vector search → Groq LLM (`openai/gpt-oss-120b`) → Egyptian-dialect coaching advice.

---

#### `POST /analyze-trends`

**Content-Type:** `application/json`

**Request Body:**
```json
{
  "user_emotions": [
    { "date": "2025-04-20", "emotion": "Happy", "confidence": 0.80 },
    { "date": "2025-04-21", "emotion": "Neutral", "confidence": 0.60 },
    { "date": "2025-04-22", "emotion": "Sad", "confidence": 0.70 },
    { "date": "2025-04-23", "emotion": "Sad", "confidence": 0.65 },
    { "date": "2025-04-24", "emotion": "Angry", "confidence": 0.55 }
  ],
  "time_range": "week"
}
```

| Field | Type | Default | Notes |
|-------|------|---------|-------|
| `user_emotions` | Array | — | List of emotion records |
| `time_range` | String | `"week"` | `"week"` or `"month"` |

**Response:**
```json
{
  "dominant_emotion": "Sad",
  "trend": "declining",
  "critical_days": [
    { "date": "2025-04-22", "shift": "From Happy to Sad" }
  ],
  "insights": [
    "Your mood has been trending downward recently. Consider taking a break or trying a breathing exercise.",
    "Your most common emotion is Sad. It might be helpful to explore the root cause."
  ],
  "prediction": "Slightly low - prioritize self-care tomorrow."
}
```

> **Trend Logic:**
> | Trend | Condition |
> |-------|-----------|
> | `improving` | Recent 3-day avg > past avg + 0.2 |
> | `declining` | Recent 3-day avg < past avg - 0.2 |
> | `stable` | Otherwise |

---

## Data Models

### User
```
_id                    : ObjectId
name                   : String   (required)
email                  : String   (required, unique, lowercase)
age                    : Number   (8–100, required)
password               : String   (bcrypt hashed, hidden from responses)
isVerified             : Boolean  (default: false)
trustedContact: {
    name               : String
    email              : String
    phone              : String
    relationship       : String
    status             : "pending" | "accepted" | "rejected"
    confirmationToken  : String   (cleared after accepted)
}
createdAt              : Date
```

### Emotion Record
```
_id        : ObjectId
user       : ObjectId  (ref → User)
source     : "face" | "voice" | "fusion"
state      : String    (e.g. "Happy", "Sad", "Angry", "Neutral")
confidence : Number    (0.0 – 1.0)
raw        : Mixed     (full AI response stored as-is)
createdAt  : Date
```

---

## Dangerous Emotion Auto-Alert

When any emotion detection endpoint (`/face`, `/voice`, `/all`) returns one of these states,  
the system **automatically emails the trusted contact** (if `status === "accepted"`):

```
English : sad · angry · fear · depressed · anxious · stress
Arabic  : حزين · غاضب · خائف · مكتئب
```

The `contactNotified` field in the response tells you the result:

| Value | Meaning |
|-------|---------|
| `false` | Emotion was not dangerous |
| `"success"` | Trusted contact was emailed |
| `"failed"` | No accepted trusted contact, or email failed |

---

## Error Responses

All errors follow this shape:

```json
{
  "status": "fail",
  "message": "Description of what went wrong"
}
```

| HTTP Code | Meaning |
|-----------|---------|
| `400` | Bad request / validation error |
| `401` | Unauthorized — invalid/missing JWT, or wrong credentials |
| `404` | Resource not found |
| `422` | AI analysis failed (model error) |
| `500` | Server / email sending error |

---

## Quick Reference Table

| Method | Endpoint | Auth | Description |
|--------|----------|:----:|-------------|
| POST | `/api/v1/users/signup` | ❌ | Register new user |
| POST | `/api/v1/users/verify` | ❌ | Verify email → returns token |
| POST | `/api/v1/users/resendCode` | ❌ | Resend verification code |
| POST | `/api/v1/users/login` | ❌ | Login → returns token |
| POST | `/api/v1/users/forgotPassword` | ❌ | Send password reset code |
| POST | `/api/v1/users/verifyResetCode` | ❌ | Verify reset code |
| PATCH | `/api/v1/users/resetPassword` | ❌ | Set new password → returns token |
| GET | `/api/v1/users/me` | ✅ | Get my profile |
| PATCH | `/api/v1/users/updateMe` | ✅ | Update name / email / age |
| PATCH | `/api/v1/users/updateMyPassword` | ✅ | Change password → new token |
| POST | `/api/v1/users/add-contact` | ✅ | Invite a trusted contact |
| POST | `/api/v1/users/notify-contact` | ✅ | Manually alert trusted contact |
| POST | `/api/emotion/face` | ✅ | Analyze face image |
| POST | `/api/emotion/voice` | ✅ | Analyze voice audio |
| POST | `/api/emotion/all` | ✅ | Analyze face + voice (fusion) |
| GET | `/api/emotion/history` | ✅ | Get emotion history |
| GET | `/api/emotion/report` | ✅ | Get aggregated report |
| POST | `/api/intervention` | ❌ | Get AI coaching advice |

---

*Last updated: April 2026 — MindSense Pro Graduation Project*
