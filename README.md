# MegaPayer P2P App Documentation

## Installation Guide

To get started with the **MegaPayer P2P app**, follow these steps for smooth installation and setup.

### Prerequisites

Ensure you have Flutter installed. The project requires the following versions:

- **Flutter Version:** 3.24.2 (Stable)
- **Dart Version:** 3.5.2
- **DevTools Version:** 2.37.2

To install Flutter, visit the official repository: [Flutter GitHub](https://github.com/flutter/flutter.git).

### Setup Instructions

1. **Clone the Repository**  
   Clone the project to your local machine using the following commands:
   ```bash
   git clone <repository-url>
   cd <project-directory>

2. **Install Dependencies**
   Run the following command to install all necessary dependencies:
   ```bash
   flutter run

 This command will download and install the required packages for the app.
  
3. **Select Device**
After dependencies are installed, select your target device to run the app.

4. **Run Without Debugging**
   Use the following command to run the project in release mode:
   ```bash
   flutter run --release

The app will now start running on the selected device.

### Now, after each command block, the new instructions appear on separate lines, as requested.
### App Flow
Once the app is running, the following screens and features will be available:
**Login Screen:**
After launching the app, you'll be directed to the login screen. Upon successfully logging in, you will be redirected to the Market Page.
**Market Page:**
Here, you can view all available trading options and advertisements.
**Wallet Page:**
Manage your wallet from this page. You can perform actions such as withdrawing and depositing funds.
**Dashboard:**
This section displays your profile and trade summaries. The dashboard includes:
  - **Username**
  - **Trade Summary**
  - **Ads Summary**
  - **Latest Advertisement**
  - **Referral Link**
**Trade Page:**
This page consists of two tabs:
  - **Running Trades**
  - **Completed Trades**
**Menu Page:**
Access all other features from the menu, including:
  - **Profile**
  - **KYC Verification**
  - **Change Password**
  - **Notifications**
  - **Deposit History**
  - **Transactions**
  - **Two-Factor Verification**
  - **Support**
  - **Ticker**
  - **Sign Out**
### APK Creation
To generate an APK for your app, run the following command:
   ```bash
  flutter build apk --release
The APK file will be created in the build/app/outputs/flutter-apk/ directory.




