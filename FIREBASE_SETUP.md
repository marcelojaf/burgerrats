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

### Pré-requisitos

- Uma conta Google
- Acesso ao [Firebase Console](https://console.firebase.google.com/)
- Ambiente de desenvolvimento Flutter configurado

## Passo 1: Criar Projeto Firebase

1. Acesse o [Firebase Console](https://console.firebase.google.com/)
2. Clique em **"Criar um projeto"** (ou **"Adicionar projeto"**)
3. Digite o nome do projeto: `burgerrats` (ou o nome de sua preferência)
4. Habilite/desabilite o Google Analytics conforme desejado
5. Clique em **"Criar projeto"**

## Passo 2: Habilitar Serviços Firebase

### Authentication

1. No Firebase Console, vá em **Build > Authentication**
2. Clique em **"Começar"**
3. Habilite os seguintes provedores de login:
   - **Email/Senha**: Clique, ative "Habilitar" e salve
   - **Google** (opcional): Clique, ative "Habilitar", configure o consentimento OAuth e salve

### Cloud Firestore

1. Vá em **Build > Firestore Database**
2. Clique em **"Criar banco de dados"**
3. Selecione **"Iniciar em modo de teste"** (para desenvolvimento) ou **"Iniciar em modo de produção"**
4. Escolha sua localização preferida (ex: `us-central1`, `southamerica-east1`)
5. Clique em **"Habilitar"**

### Storage

1. Vá em **Build > Storage**
2. Clique em **"Começar"**
3. Aceite as regras de segurança padrão (para desenvolvimento) ou personalize-as
4. Escolha a localização do armazenamento
5. Clique em **"Concluído"**

### Cloud Messaging

1. Vá em **Build > Cloud Messaging**
2. O Cloud Messaging já vem habilitado automaticamente no seu projeto
3. Anote sua **Server Key** para integração backend (Settings > Project Settings > Cloud Messaging)

## Passo 3: Registrar App Android

1. No Firebase Console, vá em **Project Settings** (ícone de engrenagem)
2. Clique em **"Adicionar app"** e selecione **Android**
3. Preencha o seguinte:
   - **Nome do pacote Android**: `com.burgerrats.burgerrats`
   - **Apelido do app**: `BurgerRats Android` (opcional)
   - **Certificado SHA-1 de debug**: (opcional, mas recomendado para Google Sign-In)
     ```bash
     # Obter SHA-1 do keystore de debug:
     keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
     ```
4. Clique em **"Registrar app"**
5. Baixe o `google-services.json`
6. **IMPORTANTE**: Substitua o arquivo placeholder em:
   ```
   android/app/google-services.json
   ```

## Passo 4: Registrar App iOS

1. No Firebase Console, vá em **Project Settings** (ícone de engrenagem)
2. Clique em **"Adicionar app"** e selecione **iOS**
3. Preencha o seguinte:
   - **Bundle ID Apple**: `com.burgerrats.burgerrats`
   - **Apelido do app**: `BurgerRats iOS` (opcional)
   - **App Store ID**: (deixe vazio por enquanto)
4. Clique em **"Registrar app"**
5. Baixe o `GoogleService-Info.plist`
6. **IMPORTANTE**: Substitua o arquivo placeholder em:
   ```
   ios/Runner/GoogleService-Info.plist
   ```

## Passo 5: Configuração Adicional iOS

### Configuração APNs (para Notificações Push)

1. Crie uma conta Apple Developer se você ainda não tiver
2. No Apple Developer Portal:
   - Vá em **Certificates, Identifiers & Profiles**
   - Crie uma chave ou certificado APNs
3. No Firebase Console:
   - Vá em **Project Settings > Cloud Messaging > Apple app configuration**
   - Faça upload da sua chave de autenticação ou certificados APNs

### Configuração Xcode

1. Abra `ios/Runner.xcworkspace` no Xcode
2. Selecione o target Runner
3. Vá em **Signing & Capabilities**
4. Adicione estas capabilities:
   - **Push Notifications**
   - **Background Modes** (selecione "Background fetch" e "Remote notifications")

## Passo 6: Executar Comandos Flutter

```bash
# Navegue até o diretório do projeto
cd /path/to/burgerrats

# Obter dependências
flutter pub get

# Para iOS, instalar dependências CocoaPods
cd ios && pod install && cd ..

# Executar o app
flutter run
```

## Verificação

Após a configuração, verifique se o Firebase está funcionando:

1. Execute o app em um dispositivo/emulador
2. Verifique no console a mensagem "Firebase initialized successfully"
3. Verifique no Firebase Console as conexões do app

## Regras de Segurança (Produção)

Antes de ir para produção, atualize suas regras de segurança:

### Exemplo de Regras Firestore

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Usuários só podem ler/escrever seus próprios dados
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Ligas são legíveis por membros
    match /leagues/{leagueId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid in resource.data.members;
    }
  }
}
```

### Exemplo de Regras Storage

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

## Solução de Problemas

### Erros de Build Android

- Certifique-se de que o `minSdk` é pelo menos 23
- Execute `flutter clean && flutter pub get`
- Verifique se o `google-services.json` está no local correto

### Erros de Build iOS

- Execute `cd ios && pod install --repo-update`
- Certifique-se de que o `GoogleService-Info.plist` está em `ios/Runner/`
- Verifique as configurações de assinatura no Xcode

### Erros de Inicialização Firebase

- Verifique se os arquivos de configuração correspondem ao seu projeto Firebase
- Verifique se todos os serviços estão habilitados no Firebase Console
- Certifique-se de ter conectividade com a internet

## Configuração de Ambientes

Para diferentes ambientes (dev, staging, prod), você pode:

1. Criar projetos Firebase separados
2. Usar `--dart-define` para alternar entre arquivos de configuração
3. Implementar `FirebaseOptions` para cada ambiente

## Próximos Passos

Após completar a configuração:

1. Implementar fluxos de autenticação
2. Configurar modelos de dados Firestore
3. Configurar Storage para upload de arquivos
4. Implementar tratamento de notificações push
5. Configurar analytics (opcional)
