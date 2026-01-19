# Configuração do Firebase - BurgerRats

## ⚠️ ALERTA DE SEGURANÇA CRÍTICO

**As Google API Keys expostas no repositório foram detectadas pelo GitHub.**

### 🚨 Ação Imediata Necessária

Você **DEVE** revogar as seguintes API keys comprometidas:
- **Android Key**: `AIzaSyBlx31c6ZXii7keadznwVnFggNG8d2NMyA`
- **iOS Key**: `AIzaSyAJMRzehR9UYGqIa1vGHpaifi0iZek7rXg`

Essas keys foram expostas publicamente no commit `29240ed5` e podem ser usadas por qualquer pessoa que tenha acesso ao histórico do Git.

---

## 🔑 Como Revogar as Keys Comprometidas

### 1. Acessar Google Cloud Console

1. Acesse [Google Cloud Console](https://console.cloud.google.com/)
2. Selecione o projeto: **burgerrats-1d62d**
3. No menu lateral, vá em **APIs & Services** > **Credentials**

### 2. Revogar as Keys Antigas

1. Procure pelas API Keys listadas acima
2. Clique em cada uma delas
3. Clique em **DELETE** para revogar completamente
4. Confirme a exclusão

### 3. Gerar Novas Configurações

Após revogar as keys antigas:

1. Acesse o [Firebase Console](https://console.firebase.google.com/)
2. Selecione o projeto **burgerrats-1d62d**
3. Vá em **Project Settings** (ícone de engrenagem ⚙️)

#### Para Android:
1. Na seção "Your apps", encontre o app Android
2. Clique nos três pontos ⋮ > **Delete this app**
3. Confirme a exclusão
4. Clique em **Add app** > **Android**
5. Registre novamente com package: `com.cklabs.burgerrats`
6. Baixe o novo `google-services.json`
7. Coloque em: `android/app/google-services.json`

#### Para iOS:
1. Na seção "Your apps", encontre o app iOS
2. Clique nos três pontos ⋮ > **Delete this app**
3. Confirme a exclusão
4. Clique em **Add app** > **iOS**
5. Registre novamente com Bundle ID: `com.cklabs.burgerrats`
6. Baixe o novo `GoogleService-Info.plist`
7. Coloque em: `ios/Runner/GoogleService-Info.plist`

---

## 📋 Configuração Normal do Firebase

### Prerequisites

- A Google account
- Access to [Firebase Console](https://console.firebase.google.com/)
- Flutter development environment set up

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Create a project"** (or **"Add project"**)
3. Enter project name: `burgerrats` (or your preferred name)
4. Enable/disable Google Analytics as desired
5. Click **"Create project"**

## Step 2: Enable Firebase Services

### Authentication

1. In Firebase Console, go to **Build > Authentication**
2. Click **"Get started"**
3. Enable the following sign-in providers:
   - **Email/Password**: Click, toggle "Enable", and save
   - **Google** (optional): Click, toggle "Enable", configure OAuth consent, and save

### Cloud Firestore

1. Go to **Build > Firestore Database**
2. Click **"Create database"**
3. Select **"Start in test mode"** (for development) or **"Start in production mode"**
4. Choose your preferred location (e.g., `us-central1`, `southamerica-east1`)
5. Click **"Enable"**

### Storage

1. Go to **Build > Storage**
2. Click **"Get started"**
3. Accept the default security rules (for development) or customize them
4. Choose your storage location
5. Click **"Done"**

### Cloud Messaging

1. Go to **Build > Cloud Messaging**
2. Cloud Messaging is automatically enabled for your project
3. Note your **Server Key** for backend integration (Settings > Project Settings > Cloud Messaging)

## Step 3: Register Android App

1. In Firebase Console, go to **Project Settings** (gear icon)
2. Click **"Add app"** and select **Android**
3. Enter the following:
   - **Android package name**: `com.burgerrats.burgerrats`
   - **App nickname**: `BurgerRats Android` (optional)
   - **Debug signing certificate SHA-1**: (optional, but recommended for Google Sign-In)
     ```bash
     # Get SHA-1 from debug keystore:
     keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
     ```
4. Click **"Register app"**
5. Download `google-services.json`
6. **IMPORTANT**: Replace the placeholder file at:
   ```
   android/app/google-services.json
   ```

## Step 4: Register iOS App

1. In Firebase Console, go to **Project Settings** (gear icon)
2. Click **"Add app"** and select **iOS**
3. Enter the following:
   - **Apple bundle ID**: `com.burgerrats.burgerrats`
   - **App nickname**: `BurgerRats iOS` (optional)
   - **App Store ID**: (leave empty for now)
4. Click **"Register app"**
5. Download `GoogleService-Info.plist`
6. **IMPORTANT**: Replace the placeholder file at:
   ```
   ios/Runner/GoogleService-Info.plist
   ```

## Step 5: iOS Additional Setup

### APNs Configuration (for Push Notifications)

1. Create an Apple Developer account if you don't have one
2. In Apple Developer Portal:
   - Go to **Certificates, Identifiers & Profiles**
   - Create an APNs key or certificate
3. In Firebase Console:
   - Go to **Project Settings > Cloud Messaging > Apple app configuration**
   - Upload your APNs authentication key or certificates

### Xcode Configuration

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select the Runner target
3. Go to **Signing & Capabilities**
4. Add these capabilities:
   - **Push Notifications**
   - **Background Modes** (select "Background fetch" and "Remote notifications")

## Step 6: Run Flutter Commands

```bash
# Navigate to project directory
cd /path/to/burgerrats

# Get dependencies
flutter pub get

# For iOS, install CocoaPods dependencies
cd ios && pod install && cd ..

# Run the app
flutter run
```

## Verification

After setup, verify Firebase is working:

1. Run the app on a device/emulator
2. Check the console for "Firebase initialized successfully"
3. Check Firebase Console for app connections

## Security Rules (Production)

Before going to production, update your security rules:

### Firestore Rules Example

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Leagues are readable by members
    match /leagues/{leagueId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid in resource.data.members;
    }
  }
}
```

### Storage Rules Example

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Troubleshooting

### Android Build Errors

- Ensure `minSdk` is at least 23
- Run `flutter clean && flutter pub get`
- Check that `google-services.json` is in the correct location

### iOS Build Errors

- Run `cd ios && pod install --repo-update`
- Ensure `GoogleService-Info.plist` is in `ios/Runner/`
- Check Xcode signing settings

### Firebase Initialization Errors

- Verify config files match your Firebase project
- Check that all services are enabled in Firebase Console
- Ensure internet connectivity

## Environment Configuration

For different environments (dev, staging, prod), you can:

1. Create separate Firebase projects
2. Use `--dart-define` to switch between config files
3. Implement `FirebaseOptions` for each environment

## Next Steps

After completing setup:

1. Implement authentication flows
2. Set up Firestore data models
3. Configure Storage for file uploads
4. Implement push notification handling
5. Set up analytics (optional)
