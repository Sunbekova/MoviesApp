# 🎬 MoviesProject — Your Personal Movie Explorer App

MoviesProject is an elegant iOS app built with **Swift** that allows users to browse trending and searched movies, watch trailers via YouTube, and post reviews. The app seamlessly integrates **TMDb API**, **YouTube API**, and **Firebase Firestore** to provide real-time data and persistent user interaction.

---

### 🎥 Demo Video

<table>
  <tr>
    <td><a href="https://github.com/user-attachments/assets/4ddbadb9-32ea-437f-a1a6-fd8dd1b541c3"><img src="https://github.com/user-attachments/assets/4ddbadb9-32ea-437f-a1a6-fd8dd1b541c3" width="200"/></a></td>
    <td><a href="https://github.com/user-attachments/assets/ec2b17f3-d9b4-40b5-8a31-6867f9a47c69"><img src="https://github.com/user-attachments/assets/ec2b17f3-d9b4-40b5-8a31-6867f9a47c69" width="200"/></a></td>
    <td><a href="https://github.com/user-attachments/assets/ef18f163-25e8-49cb-9d9a-b2ad0b336834"><img src="https://github.com/user-attachments/assets/ef18f163-25e8-49cb-9d9a-b2ad0b336834" width="200"/></a></td>
  </tr>
  <tr>
    <td><a href="https://github.com/user-attachments/assets/153223c0-344c-4d49-b5c7-025587b8ef66"><img src="https://github.com/user-attachments/assets/153223c0-344c-4d49-b5c7-025587b8ef66" width="200"/></a></td>
    <td><a href="https://github.com/user-attachments/assets/3b4f4d23-1ad5-405a-bd60-0aac5b76140f"><img src="https://github.com/user-attachments/assets/3b4f4d23-1ad5-405a-bd60-0aac5b76140f" width="200"/></a></td>
    <td><a href="https://github.com/user-attachments/assets/e6ce4529-123e-4274-8ea1-1a1b19e65487"><img src="https://github.com/user-attachments/assets/e6ce4529-123e-4274-8ea1-1a1b19e65487" width="200"/></a></td>
  </tr>
</table>

---

## 📱 Screenshots

### 🏠 Home View
<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/45663d89-7063-4a40-8de1-9bad79413391" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/2131ec95-52a0-4b50-94ad-30309ecb3acc" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/6c5ff19e-99b6-4758-b041-339786ff4c11" width="200"/></td>
  </tr>
</table>

### 🎬 Movie Detail View

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/b5fa2a54-e97e-4e1f-9de2-56b3dba0dd89" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/e0ee8f9f-f566-473d-aa49-bbb134d3562d" width="200"/></td>
  </tr>
</table>

### 📝 Reviews View

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/b6aa85bf-9d9e-4ac5-ad10-b93c702a2652" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/2a2a786a-7f1f-4294-a0fc-73b4c17f1cb6" width="200"/></td>       
    <td><img src="https://github.com/user-attachments/assets/2413e66b-7a47-4fbd-b145-0662909660e1" width="200"/></td>

  </tr>
</table>

### 🔎 Search View

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/1fe904c6-0ac5-40c2-9b11-dacb45023492" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/d026ad87-fa12-4c69-afa5-4cefb5d75c35" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/ff77a55e-8007-409c-8f6a-a6ab4ba29526" width="200"/></td>
  </tr>
</table>

### 🔐 Login View

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/73c3f540-1442-4379-b94c-4056d0de93ca" width="200"/></td>
    <td><img src="https://github.com/user-attachments/assets/c0e4a262-946a-4f71-9c23-0b9c65a53c18" width="200"/></td>
  </tr>
</table>

---

## 🚀 Features Overview

| Feature                        | Description                                                                 |
|-------------------------------|-----------------------------------------------------------------------------|
| 🔍 Search Movies              | Fetches movies via **TMDb API** using search queries                       |
| 🌟 Favorite Movies            | Add/remove favorite titles using `UserDefaults` for local persistence       |
| ▶️ Watch Trailers             | Embedded YouTube trailers using **YouTube Data API v3** and **WebKit**      |
| 📝 Add & View Reviews         | Store and display user reviews using **Firebase Firestore**                |
| 🔐 Authenticated Reviews      | Only the user who wrote the review can delete it (**Firebase Auth**)       |

---

## 🧱 App Architecture

The project follows the **MVVM** architecture pattern:

| Layer       | Responsibilities                                                                 |
|-------------|------------------------------------------------------------------------------------|
| `Model`     | Structures like `Title`, `Review`, `VideoElement`, conforming to `Codable`         |
| `ViewModel` | Handles business logic, API calls, and Firebase operations                         |
| `View`      | SwiftUI / UIKit views for displaying trending movies, details, reviews, etc.       |

---

## Project Members
| Full Name | ID | GitHub |
|-----------|----|--------|
| Suanbekova Aisha | 22B030589 | [Suanbekova](https://github.com/Sunbekova/) |
| Tulepbergen Anel | 22B030602| [Tulepbergen](https://github.com/tttulepbergen) |
| Stelmakh Polina | 22B030588 | [Stelmakh](https://github.com/po133na) |


