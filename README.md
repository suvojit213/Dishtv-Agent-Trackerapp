# DishTV Agent Tracker Tracker 📊

**DishTV Agent Tracker** is a powerful and intuitive Flutter application designed to help DishTV field agents track their daily work, monitor performance, and calculate their monthly salary with ease. Built with a focus on a clean user interface and practical features, this app serves as a perfect tool for agents to stay organized and motivated.

![App Banner or Logo](https://placehold.co/800x200/252525/FFFFFF/png?text=DishTV+Agent+Tracker)

---

## ✨ Features

This application is packed with features designed to make performance tracking seamless and efficient:

- **📅 Daily Entry Management:** Easily add, edit, or delete daily work entries, including login hours and call counts.
- **🗓️ Monthly Summaries:** Get a clear overview of your monthly performance with automatically calculated totals and averages.
- **💰 Automated Salary Calculation:** Instantly see your estimated monthly salary, including:
    - **Base Salary:** Calculated based on the number of calls.
    - **Bonus Achievement:** Automatically checks if you've met the bonus criteria (e.g., 750+ calls & 100+ hours).
- **🎯 Goal Setting & Tracking:** Set monthly goals for login hours and calls, and track your progress with beautiful circular progress bars.
- **📄 CSV Export:** Export detailed monthly reports as a clean, formatted CSV file to share or for your personal records.
- **🌗 Light & Dark Mode:** A beautifully crafted, theme-aware UI that looks stunning in both light and dark modes, complete with a smooth animated switcher.
- **🔄 Swipe Navigation:** Effortlessly navigate between Dashboard, Monthly, and Reports screens with intuitive swipe gestures.
- **🚀 Performance Optimized:** - **Native Splash Screen:** A professional splash screen for a faster, more polished app startup experience.
    - **Lazy Loading & Caching:** Smooth scrolling and instant data retrieval for previously viewed months.
- **🔒 Offline First:** All your data is securely stored locally on your device using SQFlite, so you can use the app anytime, anywhere, without an internet connection.
- **ℹ️ About Section:** A dedicated section to know more about the app and its developer.

---

## 🛠️ Tech Stack & Architecture

This project is built using modern technologies and follows a clean architecture pattern.

- **Framework:** Flutter
- **Language:** Dart
- **Architecture:** BLoC (Business Logic Component) for State Management
- **Database:** SQFlite for local storage
- **Key Packages:**
    - `flutter_bloc`: For predictable state management.
    - `equatable`: To simplify value equality checks.
    - `sqflite` & `path_provider`: For local database operations.
    - `intl`: For date formatting.
    - `percent_indicator`: For the beautiful goal progress bars.
    - `csv` & `share_plus`: For exporting and sharing reports.
    - `flutter_launcher_icons` & `flutter_native_splash`: For app branding.
    - `shimmer`: For professional loading animations.
    - `permission_handler`, `open_file`, `device_info_plus`: For handling permissions and files.

---

## 🚀 Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

- Flutter SDK: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
- A code editor like Android Studio or VS Code.

### Installation

1.  **Clone the repo**
    ```sh
    git clone [https://github.com/your_username/your_repository_name.git](https://github.com/your_username/your_repository_name.git)
    ```
2.  **Navigate to the project directory**
    ```sh
    cd your_repository_name
    ```
3.  **Install dependencies**
    ```sh
    flutter pub get
    ```
4.  **Run the app**
    ```sh
    flutter run
    ```

---

## 👨‍💻 About the Developer

This application was conceptualized and developed with passion by **Suvojeet Sengupta**.

> "And this is made by me and I am learning."

### ✨ Credits

A special thanks to **Sudhanshu** for rigorous testing and to everyone else who contributed and made this project possible.

---
