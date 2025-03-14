# Fullstack App

> A full demo of a **custome verification code sign-in and sign-up process** integrating **Firebase** and **Flutter** incorporating sending an emails using Functions trigger extension and using Flutter localization (example .arb files are provided).

## 🎥 Demo video

1. [Watch email demo](https://drive.google.com/file/d/1pwQ9UXaI6a1hiecuw4O9LR2LAgy8sZvr/view?usp=drive_link)
2. [Watch localizationd demo](https://drive.google.com/file/d/1pwQ9UXaI6a1hiecuw4O9LR2LAgy8sZvr/view?usp=drive_link)

## 📌 Tech Stack

- **Flutter**: 3.19.2
- **Dart**: 3.7.0
- **Node.js**: 21.6.2
- **Npm**: 10.4.0
- **Typescript**: 4.9.5
- **Firebase**: 13.5.1

---

## 📚 Table of Contents

- [Installation](#installation)
- [Running the Demo](#how-to-run-demo)
- [Generating Localization Files](#generate-intl-files)
- [Running Firebase Functions](#run-firebase-functions-local-api-calls)
- [Running Firebase Emulator](#run-firebase-emulator)
- [Email Automation Setup](#-email-automation-setup-firebase-trigger-email--sendgrid)
- [Release History](#release-history)
- [Troubleshooting](#troubleshooting)
- [Firebase Configuration for iOS](#-firebase-configuration-for-ios)
- [Meta](#meta)
- [License](#copyrights)

---

## 🚀 Installation

This project runs on **OSX, Linux, and Windows**.

### 1️⃣ Install Dependencies

1. **Clone the repository:**

   ```sh
   git clone https://github.com/Gugunner/fullstack-app-demo.git
   cd fullstack-app-demo
   ```

2. **Install Flutter dependencies:**

   ```sh
   flutter pub get
   ```

3. **Install Node.js dependencies for Firebase Functions:**
   ```sh
   cd functions
   npm install
   cd ..
   ```

---

### 2️⃣ Set Up Firebase CLI (Required)

To manage Firebase services, you must install and configure the **Firebase CLI**.

📌 **Follow the official Firebase CLI installation guide:**
➡️ [Firebase CLI Setup](https://firebase.google.com/docs/cli#setup)

After installing, **log in to Firebase**:

```sh
firebase login
```

---

### 3️⃣ Configure Firebase and Download Required Files

#### 🔹 **Select Your Firebase Project**

The project supports multiple environments (`dev`, `stage`, and `prod`).
By default, `dev` is included, but you can **optionally add `stage` and `prod`**.

Run:

```sh
firebase use --add
```

Then, select or add the appropriate Firebase project.

#### 🔹 **Download Required Firebase Files**

Once your project is set up, **download the required Firebase configuration files**:

- **For Android:** Place `google-services.json` in `android/app/src/dev/`
- **For iOS:** Place `GoogleService-Info.plist` in `ios/config/dev/`
- **For web** Handles the information from a .env file, check .env.example to know what information to add

  > 🚀 **Tip:** If using multiple environments ios, also place `GoogleService-Info.plist` in `ios/config/stage/` and `ios/config/prod/`.

  > 🚀 **Tip:** If using multiple environments android, also place `google-services.json` in `android/app/src/stage/` and `android/app/src/prod/`.

To learn more how to configure flavors in Flutter please read this amazing article written by `Animesh Jain` on [Medium](https://medium.com/@animeshjain/build-flavors-in-flutter-android-and-ios-with-different-firebase-projects-per-flavor-27c5c5dac10b)

---

### 4️⃣ Set Up Firebase Local Emulator (Recommended for Local Testing)

To run Firebase services locally (Firestore, Authentication, Functions), set up the **Firebase Emulator Suite**.

#### ✅ **Install Firebase Emulators**

Run:

```sh
firebase setup:emulators:ui
```

Then, start the local emulators:

```sh
firebase emulators:start --import=../seed_export --export-on-exit=../seed_export
```

This will enable **Firestore, Authentication, and Cloud Functions** to run locally.

#### 🔹 **Enable Firestore and Authentication Emulation**

You must enable Firestore and Authentication emulation in your local environment:

1. Open the **Firebase Emulator UI** by running:
   ```sh
   firebase emulators:start
   ```
2. Navigate to `http://localhost:4000` to access the emulator interface.

> 💡 **Tip:** If you are using vscode run the task Firebase import emulator.

---

### 5️⃣ Configure Environment Variables

This project requires environment variables to be set up before running.

#### ✅ **.env File Setup**

- **For Firebase Emulator Mode:** Create a `.env.local` file.
- **For Firebase App Mode:** Create a `.env.dev` file.

📌 **Example:**
A template is provided in `.env.example`. To set up your environment, run:

```sh
cp .env.example .env.local
```

or

```sh
cp .env.example .env.dev
```

Then, edit the file and fill in the required values.

---

### 6️⃣ Generate Firebase Configuration Files

Once the required files are in place, run:

```sh
flutterfire configure
```

This will create the necessary **Firebase options** files for your Flutter project.

---

### ✅ Final Check

Before proceeding, ensure you have:
✔️ Installed **Firebase CLI** ([Setup Guide](https://firebase.google.com/docs/cli#setup))
✔️ Logged into **Firebase**
✔️ Selected your **Firebase Project**
✔️ Downloaded **`google-services.json` & `GoogleService-Info.plist`**
✔️ Installed **Firebase Emulator** (if running locally)
✔️ Created **`.env.local` or `.env.dev`**
✔️ Ran `flutterfire configure`

Now you’re ready to run the project! 🚀

---

## ❗ Important: Scope of This README

This README covers **only running the app in local emulator mode**.
If you want to use a **Firebase Cloud project**, you must:

1. **Correctly configure Firebase** for cloud deployment.
2. **Upload Firebase Functions** using:
   ```sh
   firebase deploy --only functions
   ```
3. **Ensure Firestore and Authentication rules are configured**.

📌 **Refer to Firebase official documentation** for production deployment instructions:
➡️ [Firebase Setup Guide](https://firebase.google.com/docs)

---

## 📌 Meta

- **Author:** Raul Alonzo
- **LinkedIn:** [@Raul-Alonzo-Mendoza](https://linkedin.com/in/raull-alonzo-mendoza)
- **Email:** ram2489@gmail.com

---

## ©️ Copyrights

**All logos, images and names have have copyright licenses and can only be used inside the scope provided in this project for demo purposes.**
