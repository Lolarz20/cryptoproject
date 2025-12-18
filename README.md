# CryptoMarket Analytics Platform

A high-performance, real-time cryptocurrency analytics and trading bot management platform. Designed to provide traders with instant insights through advanced technical indicators (RSI, SMA) and interactive visualization tools.

---

## 🛠️ Tech Stack

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)
![NodeJS](https://img.shields.io/badge/node.js-6DA55F?style=for-the-badge&logo=node.js&logoColor=white)
![Google Cloud](https://img.shields.io/badge/GoogleCloud-%234285F4.svg?style=for-the-badge&logo=google-cloud&logoColor=white)

**Frontend:**
*   **Flutter (Dart)**: Cross-platform mobile architecture.
*   **FL Chart**: Complex financial charting and data visualization.
*   **Firebase SDK**: Real-time database streams and authentication.

**Backend:**
*   **Node.js (Firebase Cloud Functions)**: Serverless compute for heavy calculations.
*   **Firestore**: NoSQL database for caching market states and indicator data.
*   **Axios & Node-Fetch**: Efficient HTTP networking for high-frequency API polling.

---

## 🚀 Key Features

*   **Real-Time Market Data**: Aggregates live cryptocurrency data from major exchanges (Binance).
*   **Technical Analysis Engine**: Server-side calculation of Relative Strength Index (RSI) and Simple Moving Averages (SMA) to reduce client load.
*   **Interactive Charting**: Dynamic, touch-responsive financial charts for visualizing price trends and indicators.
*   **Trading Bot Management**: Dedicated admin interface for configuring and monitoring automated trading strategies.
*   **Robust Backend Proxy**: Implements secure proxying (BRD SuperProxy) in Cloud Functions to bypass rate limits and ensure connection stability.

---

## 🔒 Security & Best Practices

**This repository has been prepared for a public portfolio showcase.**

**Security Notice:**
For security reasons, all sensitive "Hardcoded Secrets" (including API Keys, Private Keys, Service Account Credentials, and Proxy Passwords) have been sanitized from the codebase.
*   All secret values have been replaced with empty strings (`""`).
*   Deprecation comments (`// API Key deprecated`) have been added to relevant lines to indicate where configuration is required.

Refactoring the code to remove these hardcoded values demonstrates adherence to **DevSecOps** best practices, ensuring that no sensitive credentials are potentially leaked in version control history.

---

## 💡 What I Learned

Building this project presented several complex technical challenges:
*   **Asynchronous Data Streams**: Mastering `StreamBuilder` and Dart's async/await patterns to handle high-frequency market updates without UI jank.
*   **Serverless Architecture**: Designing efficient Cloud Functions in Node.js to offload heavy mathematical computations (like RSI/SMA buffers) from the mobile device, extending battery life and improving app performance.
*   **API Rate Limiting & Proxying**: Solving 429 (Too Many Requests) errors by implementing a rotating proxy strategy within the backend infrastructure.
*   **State Management**: Coordinating complex state between local widget trees and global Firestore streams.

---

## ⚡ Quick Start

To run this project locally, you will need **Flutter SDK** and **Node.js** installed.

### 1. Clone & Install Dependencies

**Flutter App:**
```bash
flutter pub get
```

**Backend (Cloud Functions):**
```bash
cd functions
npm install
```

### 2. Configuration
Since sensitive keys have been removed, you must provide your own credentials:
*   **Firebase**: Generate `firebase_options.dart` using FlutterFire CLI.
*   **Backend**: Add your Service Account credentials and API keys in `functions/index.js` (or use Environment Variables, which is the recommended approach for production).

### 3. Run
```bash
flutter run
```

---
Made with <3 Radek Soysal
