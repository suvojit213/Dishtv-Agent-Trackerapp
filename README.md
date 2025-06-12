# DishTV Agent Tracker

## Overview

DishTV Agent Tracker is a robust and intuitive mobile application developed using Flutter, designed to empower DishTV field agents in efficiently managing their daily tasks, monitoring performance metrics, and accurately calculating their monthly earnings. This application emphasizes a clean user interface and practical functionalities, serving as an indispensable tool for agents to maintain organization and motivation.




## Features

This application is packed with features designed to make performance tracking seamless and efficient:

*   **Daily Entry Management:** Agents can easily add, edit, or delete daily work entries, including login hours and call counts.
*   **Monthly Summaries:** Provides a clear overview of monthly performance with automatically calculated totals and averages.
*   **Automated Salary Calculation:** Instantly calculates estimated monthly salary, including base salary based on call volume and bonus achievement based on predefined criteria (e.g., 750+ calls & 100+ hours).
*   **Goal Setting & Tracking:** Allows agents to set monthly goals for login hours and calls, with progress visualized through intuitive circular progress bars.
*   **CSV Export:** Enables export of detailed monthly reports as a clean, formatted CSV file for sharing or personal records.
*   **Light & Dark Mode:** Features a beautifully crafted, theme-aware UI that supports both light and dark modes, complete with a smooth animated switcher.
*   **Swipe Navigation:** Offers effortless navigation between Dashboard, Monthly, and Reports screens using intuitive swipe gestures.
*   **Performance Optimized:** Includes a professional native splash screen for faster startup and utilizes lazy loading and caching for smooth scrolling and instant data retrieval for previously viewed months.
*   **Offline First:** All data is securely stored locally on the device using SQFlite, ensuring the app can be used anytime, anywhere, without an internet connection.
*   **About Section:** A dedicated section providing information about the app and its developer.




## Tech Stack & Architecture

This project is built using modern technologies and follows a clean architecture pattern, specifically the BLoC (Business Logic Component) pattern for state management.

*   **Framework:** Flutter
*   **Language:** Dart
*   **Architecture:** BLoC (Business Logic Component) for State Management
*   **Database:** SQFlite for local storage
*   **Key Packages:**
    *   `flutter_bloc`: For predictable state management.
    *   `equatable`: To simplify value equality checks.
    *   `sqflite` & `path_provider`: For local database operations.
    *   `intl`: For date formatting.
    *   `fl_chart`: For creating various types of charts.
    *   `shared_preferences`: For persisting simple data.
    *   `google_fonts`: For custom fonts.
    *   `permission_handler`: For handling permissions.
    *   `open_file`: For opening files.
    *   `device_info_plus`: For device information.
    *   `pdf`: For PDF generation.
    *   `share_plus`: For sharing content.
    *   `shimmer`: For professional loading animations.
    *   `percent_indicator`: For goal progress bars.




## Installation & Usage

To get a local copy of the project up and running, follow these simple steps:

### Prerequisites

*   Flutter SDK: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
*   A code editor like Android Studio or VS Code.

### Steps

1.  **Clone the repository**
    ```bash
    git clone https://github.com/suvojit213/Dishtv-Agent-Trackerapp.git
    ```
2.  **Navigate to the project directory**
    ```bash
    cd Dishtv-Agent-Trackerapp
    ```
3.  **Install dependencies**
    ```bash
    flutter pub get
    ```
4.  **Run the application**
    ```bash
    flutter run
    ```




## About the Developer

This application was conceptualized and developed by **Suvojeet Sengupta**.

> "And this is made by me and I am learning."

A special thanks to **Di Bhai (Mouma)**  **Sudhanshu** for rigorous testing and to everyone else who contributed and made this project possible.