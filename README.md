
# Smart Doc AI 📄✨

AI-powered document scanner built with Flutter — scan any document, extract text with OCR, analyze with Groq AI.

---

## Screenshots

---

## Features
- 📷 Scan via camera or gallery
- 🔍 On-device OCR (Google ML Kit)
- 🤖 AI Analysis — Summarize, Translate, Q&A
- 💾 Local history with Hive
- 🌙 Dark theme with animations

---

## Tech Stack
| Package | Purpose |
|---------|---------|
| flutter_riverpod | State management |
| google_mlkit_text_recognition | On-device OCR |
| http | Groq API calls |
| hive_flutter | Local storage |
| flutter_dotenv | API key management |

---

## Setup

```bash
git clone https://github.com/yourusername/smart_doc_ai.git
cd smart_doc_ai
flutter pub get
```

Create `.env` file:
```
GROQ_API_KEY=your_key_here
```

```bash
dart run build_runner build
flutter run
```

Get free Groq API key → [console.groq.com](https://console.groq.com)

---

## Architecture
```
Service → Repository → Provider → Screen
```
- **Service** — external tools (ML Kit, HTTP)
- **Repository** — business logic
- **Provider** — Riverpod state
- **Screen** — UI only

---

> Built with Flutter + Groq AI (Llama 3.1)