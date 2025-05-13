# 🎬 MoviesProject — Your Personal Movie Explorer App

MoviesProject is an elegant iOS app built with **Swift** that allows users to browse trending and searched movies, watch trailers via YouTube, and post reviews. The app seamlessly integrates **TMDb API**, **YouTube API**, and **Firebase Firestore** to provide real-time data and persistent user interaction.

---



### 🎥 **Demo Video**

| Demo Video 1 | Demo Video 2 | Demo Video 3 |
|--------------|--------------|--------------|
| [![Watch Demo](https://github.com/user-attachments/assets/b1864a55-6fe9-4745-9c7a-5d93c0397abc)](https://github.com/user-attachments/assets/6ae59bf2-9f5c-485d-b05b-c988f10f4020) | [![Watch Demo](https://github.com/user-attachments/assets/cd039053-cb3d-46f9-82d7-fa7dcdaee536)](https://github.com/user-attachments/assets/cf90c9f5-6e77-4a83-85f5-1e8cd2c88941) | [![Watch Demo](https://github.com/user-attachments/assets/8e8e2954-d257-4c20-b548-25da44506d14)](https://github.com/user-attachments/assets/57dcf3cf-8131-4c62-ad31-ca33d313ab06) |

| Demo Video 4 | Demo Video 5 | Demo Video 6 |
|--------------|--------------|--------------|
| [![Watch Demo](https://github.com/user-attachments/assets/f68a6efd-d1dc-4404-bba5-76dcdfeed0b2)](https://github.com/user-attachments/assets/f68a6efd-d1dc-4404-bba5-76dcdfeed0b2) | [![Watch Demo](https://github.com/user-attachments/assets/26a9b2b8-b3cb-4037-90f3-7c89e1e08a4f)](https://github.com/user-attachments/assets/26a9b2b8-b3cb-4037-90f3-7c89e1e08a4f) | [![Watch Demo](https://github.com/user-attachments/assets/51da7010-cd66-44a1-b2ff-1425b0c06a7d)](https://github.com/user-attachments/assets/51da7010-cd66-44a1-b2ff-1425b0c06a7d) |





### 🔎 Search View

| Image 1 | Image 2 | Image 3 |
|---------|---------|---------|
| ![Image 1](https://github.com/user-attachments/assets/2658f352-eec1-490d-b358-91ffd6db95f7) | ![Image 2](https://github.com/user-attachments/assets/0a36dbf4-d2a3-42a5-8da9-aac4685f3359) | ![Image 3](https://github.com/user-attachments/assets/6c864c9e-8015-4cbe-aa72-a1eefa0852f0) |

---

## 🚀 Features Overview

| Feature                        | Description                                                                 |
|-------------------------------|-----------------------------------------------------------------------------|
| 🔍 Search Movies              | Fetches movies via **TMDb API** using search queries                       |
| 🌟 Favorite Movies            | Add/remove favorite titles using `UserDefaults` for local persistence       |
| ▶️ Watch Trailers             | Embedded YouTube trailers using **YouTube Data API v3** and **WebKit**      |
| 📝 Add & View Reviews         | Store and display user reviews using **Firebase Firestore**                |
| 🔐 Authenticated Reviews      | Only the user who wrote the review can delete it (**Firebase Auth**)       |



## 📱 Screenshots

### 🏠 Home View

| Image 1 | Image 2 | Image 3 |
|---------|---------|---------|
| ![Image 1](https://github.com/user-attachments/assets/0ec4ae7c-f792-4382-b2d9-d03435e0e2bf) | ![Image 2](https://github.com/user-attachments/assets/a63cf133-bb57-4a45-a5f7-ce39189b3fb1) | ![Image 3](https://github.com/user-attachments/assets/c57d1b76-e3ed-41bb-a3ea-66b09a269660) |

---

### 🎬 Movie Detail View

| Image 1 | Image 2 | Image 3 |
|---------|---------|---------|
| ![Image 1](https://github.com/user-attachments/assets/893a3279-1ef4-4caa-9873-98b55e6c7294) | ![Image 2](https://github.com/user-attachments/assets/78e8d319-f2ad-44bf-8bba-5a76b2e5d02e) | ![Image 3](https://github.com/user-attachments/assets/dcc07d8b-6da8-43c7-8a41-24cb0e588f88) |

---

### 🔎 Search View

| Image 1 | Image 2 | Image 3 |
|---------|---------|---------|
| ![Image 1](https://github.com/user-attachments/assets/2658f352-eec1-490d-b358-91ffd6db95f7) | ![Image 2](https://github.com/user-attachments/assets/0a36dbf4-d2a3-42a5-8da9-aac4685f3359) | ![Image 3](https://github.com/user-attachments/assets/6c864c9e-8015-4cbe-aa72-a1eefa0852f0) |

---

### 📝 Reviews View

| Image 1 | Image 2 |
|---------|---------|
| ![Image 1](https://github.com/user-attachments/assets/6bb98b4e-68e8-4738-97ed-917a6c4d5da4) | ![Image 2](https://github.com/user-attachments/assets/955e45fe-d29e-4d0c-ade6-e78794458309) |

---

### 🔐 Login View

| Image 1 | Image 2 |
|---------|---------|
| ![Image 1](https://github.com/user-attachments/assets/a9c6f9e8-064d-4373-8ed3-e3283f583d18) | ![Image 2](https://github.com/user-attachments/assets/9b3a6e87-1980-4bab-91e8-95cbd0dadc06) |


## 🧱 App Architecture

The project follows the **MVVM** architecture pattern:

| Layer       | Responsibilities                                                                 |
|-------------|------------------------------------------------------------------------------------|
| `Model`     | Structures like `Title`, `Review`, `VideoElement`, conforming to `Codable`         |
| `ViewModel` | Handles business logic, API calls, and Firebase operations                         |
| `View`      | SwiftUI / UIKit views for displaying trending movies, details, reviews, etc.       |

🔗 **Navigation flow** is simple and intuitive:
```plaintext
Home → Search → Movie Detail → Watch Trailer / Leave Review
                         ↑
                   Favorites (local)
