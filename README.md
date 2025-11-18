📚 SmartBook App

SmartBook App is a smart book reading and listening application designed to provide a seamless experience for discovering, reading, and listening to books. The project is built with a complete Client-Server architecture using Flutter (Frontend) and Node.js (Backend).

🚀 Key Features

🏠 Home Screen

Discovery: Displays latest books, featured books (based on ratings), and top authors.

Categorization: Filter books by categories (Self-help, Business, Literature, etc.).

📖 Book Detail

Info: View comprehensive book details (author, description, rating).

Chapter List: Easy access to all chapters.

Quick Start: "Read Now" button automatically opens the first chapter.

👓 Book Reader

Rich Text Rendering: Displays chapter content in HTML format for better typography.

Smart Navigation: Switch between chapters (Previous/Next) directly from the reading screen.

Utility Toolbar: Audio player, Summary view, and AI Chat integration (UI).

🛠 Tech Stack

📱 Mobile App (Frontend)

Technology

Description

Flutter

Main framework for building cross-platform UI.

BLoC Pattern

Professional State Management, separating UI and Logic.

Http

For making RESTful API calls to the backend.

Flutter Dotenv

Managing environment variables securely.

Flutter Widget from HTML

Rendering rich book content from HTML strings.

🔙 Backend Server

Technology

Description

Node.js & Express

Building the RESTful API.

MongoDB & Mongoose

NoSQL database for storing Books, Chapters, Authors.

Cors

Handling Cross-Origin Resource Sharing security.

⚙️ Installation & Setup Guide

1. Backend (Server)

# 1. Navigate to the backend directory

cd smartbook-backend

# 2. Install dependencies

npm install

# 3. Create .env file in the root of backend and add:

# MONGO_URI=mongodb+srv://<user>:<pass>@<cluster>.mongodb.net/smartbook?retryWrites=true&w=majority

# PORT=5001

# 4. Start the server

npm run dev

Server will run at: http://localhost:5001 (or your LAN IP).

2. Mobile App (Flutter)

# 1. Navigate to the app directory

cd smart_reader_app

# 2. Install dependencies

flutter pub get

# 3. Create .env file in the root of Flutter app:

# baseURL=http://YOUR_IP_ADDRESS:5001

# (Example: baseURL=[http://192.168.1.5:5001](http://192.168.1.5:5001))

# 4. Run the app

flutter run

📸 Screenshots

<div style="display: flex; justify-content: space-between;">
<img src="assets/screenshots/intro1.jpg" width="32%" alt="" />
<img src="assets/screenshots/intro2.jpg" width="32%" alt="" />
<img src="assets/screenshots/intro3.jpg" width="32%" alt="" />
</div>

<div style="display: flex; justify-content: space-between;">
<img src="assets/screenshots/login.jpg" width="32%" alt="" />
<img src="assets/screenshots/register.jpg" width="32%" alt="" />
<img src="assets/screenshots/home1.jpg" width="32%" alt="" />
</div>

<div style="display: flex; justify-content: space-between;">
<img src="assets/screenshots/home2.jpg" width="32%" alt="" />
<img src="assets/screenshots/categories.jpg" width="32%" alt="" />
<img src="assets/screenshots/detail_cate.jpg" width="32%" alt="" />
</div>

<div style="display: flex; justify-content: space-between;">
<img src="assets/screenshots/home2.jpg" width="32%" alt="" />
<img src="assets/screenshots/categories.jpg" width="32%" alt="" />
<img src="assets/screenshots/detail_cate.jpg" width="32%" alt="" />
</div>

<div style="display: flex; justify-content: space-between;">
<img src="assets/screenshots/detail1.jpg" width="32%" alt="" />
<img src="assets/screenshots/detail2.jpg" width="32%" alt="" />
<img src="assets/screenshots/read.jpg" width="32%" alt="" />
</div>
