# burgerrats

Um aplicativo Flutter para competições de hambúrgueres entre amigos.

## Plataformas Suportadas

Este projeto é desenvolvido exclusivamente para **iOS** e **Android**. Plataformas desktop (Windows, Linux, macOS) e Web não são suportadas.

## Primeiros Passos

Este projeto utiliza Flutter para desenvolvimento mobile. Para começar:

1. Certifique-se de ter o Flutter SDK instalado
2. Configure o Firebase seguindo as instruções em `FIREBASE_SETUP.md`
3. Execute `flutter pub get` para instalar as dependências
4. Para iOS, execute `cd ios && pod install && cd ..`
5. Execute o app com `flutter run`

## Recursos

- [Documentação Flutter](https://docs.flutter.dev/)
- [Configuração do Firebase](./FIREBASE_SETUP.md)
- [Lab: Escreva seu primeiro app Flutter](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Exemplos úteis de Flutter](https://docs.flutter.dev/cookbook)

---

## Configuração do Firebase Authentication

Este projeto utiliza o Firebase Authentication para gerenciar autenticação de usuários. Abaixo estão as instruções para configurar e gerenciar a autenticação no portal do Firebase.

### Acessando o Console do Firebase

1. Acesse o [Console do Firebase](https://console.firebase.google.com/)
2. Selecione o projeto **burgerrats**
3. No menu lateral, clique em **Authentication**

### Habilitando Métodos de Login

Para que os usuários possam se cadastrar e fazer login no aplicativo:

1. No Console do Firebase, vá em **Authentication** > **Sign-in method**
2. Clique em **Email/Senha**
3. Ative a opção **Email/Senha**
4. Clique em **Salvar**

### Gerenciando Usuários

#### Visualizar Usuários Cadastrados

1. Vá em **Authentication** > **Users**
2. Aqui você pode ver todos os usuários registrados no aplicativo
3. A lista mostra: email, data de criação, último login e UID do usuário

#### Adicionar Usuário Manualmente

1. Em **Authentication** > **Users**, clique em **Adicionar usuário**
2. Preencha o email e senha
3. Clique em **Adicionar usuário**

#### Desativar ou Excluir Usuário

1. Em **Authentication** > **Users**, localize o usuário
2. Clique nos três pontos (menu) ao lado do usuário
3. Selecione **Desativar conta** para bloquear o acesso ou **Excluir conta** para remover permanentemente

#### Redefinir Senha de Usuário

1. Em **Authentication** > **Users**, localize o usuário
2. Clique nos três pontos (menu) ao lado do usuário
3. Selecione **Redefinir senha**
4. O usuário receberá um email com link para redefinir a senha

### Configurando Templates de Email

Personalize os emails enviados aos usuários (verificação, redefinição de senha):

1. Vá em **Authentication** > **Templates**
2. Selecione o template que deseja editar:
   - **Verificação de endereço de email**
   - **Redefinição de senha**
   - **Alteração de endereço de email**
3. Clique em **Editar modelo**
4. Personalize:
   - **Nome do remetente**: Nome que aparece no email
   - **Endereço de email do remetente**: Email que envia as mensagens
   - **Assunto**: Título do email
   - **Mensagem**: Corpo do email (pode usar HTML)
5. Clique em **Salvar**

### Configurando Domínio Personalizado

Para emails mais profissionais com seu domínio:

1. Vá em **Authentication** > **Templates**
2. Clique em **Personalizar domínio**
3. Siga as instruções para verificar seu domínio
4. Configure os registros DNS conforme indicado

### Configurando Provedores de Identidade Adicionais (Opcional)

Se desejar adicionar login com Google, Apple, etc:

1. Vá em **Authentication** > **Sign-in method**
2. Clique no provedor desejado (Google, Apple, Facebook, etc)
3. Siga as instruções específicas para cada provedor
4. Cada provedor requer configuração adicional (chaves de API, certificados, etc)

### Monitorando Uso e Cotas

1. Vá em **Authentication** > **Usage**
2. Visualize estatísticas de:
   - Usuários ativos
   - Novos cadastros
   - Logins por período

### Regras de Segurança

O Firebase Authentication trabalha em conjunto com as regras de segurança do Firestore e Storage. Certifique-se de que suas regras verificam a autenticação:

```javascript
// Exemplo de regra do Firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      // Apenas usuários autenticados podem ler seus próprios dados
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### Solução de Problemas Comuns

| Erro | Causa | Solução |
|------|-------|---------|
| `email-already-in-use` | Email já cadastrado | Usar outro email ou fazer login |
| `weak-password` | Senha muito fraca | Usar senha com 6+ caracteres |
| `invalid-email` | Email mal formatado | Verificar formato do email |
| `user-not-found` | Usuário não existe | Verificar email ou criar conta |
| `wrong-password` | Senha incorreta | Tentar novamente ou redefinir senha |
| `too-many-requests` | Muitas tentativas | Aguardar alguns minutos |
| `network-request-failed` | Sem internet | Verificar conexão |

### Suporte

Para mais informações, consulte a [documentação oficial do Firebase Authentication](https://firebase.google.com/docs/auth).

---

## Configuração do Firebase Storage

Este projeto utiliza o Firebase Storage para armazenar fotos de check-ins e perfis de usuários. Abaixo estão as instruções para configurar e gerenciar o armazenamento no portal do Firebase.

### Acessando o Console do Firebase Storage

1. Acesse o [Console do Firebase](https://console.firebase.google.com/)
2. Selecione o projeto **burgerrats**
3. No menu lateral, clique em **Storage**

### Ativando o Firebase Storage

Se o Storage ainda não estiver ativado:

1. No Console do Firebase, vá em **Storage**
2. Clique em **Começar**
3. Selecione o modo de regras de segurança:
   - **Modo de produção**: Requer autenticação (recomendado)
   - **Modo de teste**: Permite acesso temporário sem autenticação (apenas para desenvolvimento)
4. Escolha a localização do servidor (recomendado: `southamerica-east1` para Brasil)
5. Clique em **Concluído**

### Estrutura de Pastas

O aplicativo organiza os arquivos da seguinte forma:

```
storage/
├── check-ins/
│   └── {userId}/
│       └── {ano}/
│           └── {mes}/
│               └── {dia}/
│                   └── {imagem}.jpg
└── profile-photos/
    └── {userId}/
        └── {imagem}.jpg
```

### Configurando Regras de Segurança

As regras de segurança controlam quem pode ler e gravar arquivos. Acesse **Storage** > **Regras** e configure:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Função auxiliar para verificar autenticação
    function isAuthenticated() {
      return request.auth != null;
    }

    // Função para verificar se o usuário é o dono do arquivo
    function isOwner(userId) {
      return request.auth != null && request.auth.uid == userId;
    }

    // Função para validar tipo de arquivo (imagens)
    function isValidImageType() {
      return request.resource.contentType.matches('image/.*');
    }

    // Função para validar tamanho (máximo 10MB)
    function isValidSize() {
      return request.resource.size < 10 * 1024 * 1024;
    }

    // Regras para fotos de check-in
    match /check-ins/{userId}/{allPaths=**} {
      // Qualquer usuário autenticado pode visualizar fotos de check-in
      allow read: if isAuthenticated();

      // Apenas o dono pode fazer upload/deletar suas próprias fotos
      allow write: if isOwner(userId) && isValidImageType() && isValidSize();
      allow delete: if isOwner(userId);
    }

    // Regras para fotos de perfil
    match /profile-photos/{userId}/{allPaths=**} {
      // Qualquer usuário autenticado pode visualizar fotos de perfil
      allow read: if isAuthenticated();

      // Apenas o dono pode fazer upload/deletar sua foto de perfil
      allow write: if isOwner(userId) && isValidImageType() && isValidSize();
      allow delete: if isOwner(userId);
    }
  }
}
```

### Monitorando Uso e Armazenamento

1. Vá em **Storage** > **Uso** para visualizar:
   - Espaço total utilizado
   - Número de arquivos
   - Transferência de dados
   - Operações realizadas

### Gerenciando Arquivos

#### Navegando pelos Arquivos

1. Vá em **Storage** > **Arquivos**
2. Navegue pelas pastas clicando nelas
3. Use a barra de caminho para voltar a pastas anteriores

#### Visualizando Detalhes do Arquivo

1. Clique em um arquivo para ver:
   - URL de download
   - Tipo de conteúdo
   - Tamanho
   - Data de criação
   - Metadados personalizados

#### Excluindo Arquivos Manualmente

1. Navegue até o arquivo
2. Clique nos três pontos (menu) ao lado do arquivo
3. Selecione **Excluir**
4. Confirme a exclusão

**Atenção**: A exclusão é permanente e não pode ser desfeita.

#### Fazendo Upload Manual

1. Navegue até a pasta desejada
2. Clique em **Fazer upload de arquivo**
3. Selecione o arquivo do seu computador
4. O arquivo será enviado automaticamente

### Configurando CORS (Cross-Origin Resource Sharing)

Se as imagens não carregarem no aplicativo web, configure o CORS:

1. Instale o [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
2. Crie um arquivo `cors.json`:

```json
[
  {
    "origin": ["*"],
    "method": ["GET", "HEAD"],
    "maxAgeSeconds": 3600
  }
]
```

3. Execute o comando:

```bash
gsutil cors set cors.json gs://burgerrats.appspot.com
```

**Nota**: Para produção, substitua `"*"` pelos domínios específicos do seu aplicativo.

### Configurando Backup (Opcional)

Para fazer backup automático dos arquivos:

1. Acesse o [Google Cloud Console](https://console.cloud.google.com/)
2. Vá em **Cloud Storage** > **Transfer**
3. Configure uma transferência agendada para outro bucket

### Limites e Cotas

| Recurso | Plano Gratuito (Spark) | Plano Pago (Blaze) |
|---------|------------------------|-------------------|
| Armazenamento | 5 GB | Pago por uso |
| Downloads | 1 GB/dia | Pago por uso |
| Uploads | 1 GB/dia | Pago por uso |
| Operações | 50.000/dia | Pago por uso |

### Solução de Problemas Comuns

| Erro | Causa | Solução |
|------|-------|---------|
| `storage/unauthorized` | Usuário não autenticado ou sem permissão | Verificar regras de segurança e login do usuário |
| `storage/canceled` | Upload cancelado | Tentar novamente |
| `storage/object-not-found` | Arquivo não existe | Verificar caminho do arquivo |
| `storage/quota-exceeded` | Limite de armazenamento excedido | Excluir arquivos ou fazer upgrade do plano |
| `storage/retry-limit-exceeded` | Muitas tentativas falharam | Verificar conexão e tentar novamente |

### Boas Práticas

1. **Compressão de Imagens**: O aplicativo comprime automaticamente as imagens antes do upload para economizar espaço e banda.

2. **Nomes de Arquivo Únicos**: O aplicativo gera nomes únicos com timestamp para evitar conflitos.

3. **Metadados**: Cada arquivo armazena metadados como ID do usuário, ID da liga e data de upload.

4. **Cache**: As imagens são configuradas com cache de 1 ano para check-ins e 1 dia para fotos de perfil.

5. **Limite de Tamanho**: O aplicativo limita uploads a 10MB para evitar uso excessivo.

### Suporte

Para mais informações, consulte a [documentação oficial do Firebase Storage](https://firebase.google.com/docs/storage).

---

## Configuração do Firebase Cloud Messaging (FCM)

Este projeto utiliza o Firebase Cloud Messaging para enviar notificações push para usuários no iOS e Android. Abaixo estão as instruções para configurar e gerenciar notificações push no portal do Firebase.

### Acessando o Console do Firebase Cloud Messaging

1. Acesse o [Console do Firebase](https://console.firebase.google.com/)
2. Selecione o projeto **burgerrats**
3. No menu lateral, clique em **Engage** > **Messaging** (ou **Cloud Messaging**)

### Ativando o Firebase Cloud Messaging

O FCM já vem habilitado por padrão em projetos Firebase. Para verificar:

1. No Console do Firebase, vá em **Project Settings** (engrenagem no canto superior)
2. Clique na aba **Cloud Messaging**
3. Verifique se o **Cloud Messaging API (V1)** está habilitado
4. Se estiver desabilitado, clique no link para habilitar no Google Cloud Console

### Configuração no iOS

#### Passo 1: Criar Certificado APNs ou Chave de Autenticação

Para que notificações funcionem no iOS, você precisa configurar o APNs (Apple Push Notification service):

**Opção A - Usando Chave de Autenticação APNs (Recomendado):**

1. Acesse o [Apple Developer Portal](https://developer.apple.com/account/)
2. Vá em **Certificates, Identifiers & Profiles**
3. Clique em **Keys** no menu lateral
4. Clique no botão **+** para criar uma nova chave
5. Dê um nome para a chave (ex: "BurgerRats FCM Key")
6. Marque a opção **Apple Push Notifications service (APNs)**
7. Clique em **Continue** e depois **Register**
8. **IMPORTANTE**: Faça download do arquivo `.p8` - você só pode baixá-lo uma vez!
9. Anote o **Key ID** exibido na página

**Opção B - Usando Certificado APNs:**

1. No Apple Developer Portal, vá em **Certificates**
2. Clique no botão **+** para criar um novo certificado
3. Selecione **Apple Push Notification service SSL (Sandbox & Production)**
4. Selecione o App ID do BurgerRats
5. Siga as instruções para gerar e baixar o certificado `.cer`
6. Exporte como `.p12` no Keychain Access do Mac

#### Passo 2: Configurar APNs no Firebase

1. No Console do Firebase, vá em **Project Settings** > **Cloud Messaging**
2. Role até a seção **Apple app configuration**
3. Na seção do seu app iOS, clique em **Upload** ao lado de:
   - **APNs Authentication Key** (para arquivo `.p8`) - informe o Key ID e Team ID
   - Ou **APNs Certificates** (para arquivo `.p12`)
4. Faça upload do arquivo correspondente

#### Passo 3: Habilitar Push Notifications no Xcode

1. Abra o projeto iOS no Xcode (`ios/Runner.xcworkspace`)
2. Selecione o target **Runner**
3. Vá na aba **Signing & Capabilities**
4. Clique em **+ Capability**
5. Adicione **Push Notifications**
6. Adicione **Background Modes** e marque:
   - **Background fetch**
   - **Remote notifications**

### Configuração no Android

O Android não requer configuração adicional além do arquivo `google-services.json` que já deve estar no projeto. Verifique:

1. O arquivo `android/app/google-services.json` existe e está atualizado
2. No arquivo `android/app/build.gradle.kts`, o plugin `com.google.gms.google-services` está aplicado
3. As permissões de notificação estão no `AndroidManifest.xml`:
   - `android.permission.POST_NOTIFICATIONS` (Android 13+)
   - `android.permission.VIBRATE`
   - `android.permission.RECEIVE_BOOT_COMPLETED`

### Enviando Notificações pelo Console

#### Enviar Notificação de Teste

1. No Console do Firebase, vá em **Messaging**
2. Clique em **Create your first campaign** ou **New campaign**
3. Selecione **Firebase Notification messages**
4. Clique em **Create**
5. Preencha:
   - **Notification title**: Título da notificação
   - **Notification text**: Corpo da mensagem
   - **Notification image** (opcional): URL de uma imagem
6. Clique em **Send test message**
7. Insira o **FCM registration token** do dispositivo de teste
8. Clique em **Test**

#### Enviar Notificação para Tópicos

1. Na seção **Target**, selecione **Topic**
2. Insira o nome do tópico:
   - `league_{leagueId}` - para notificar membros de uma liga específica
3. Configure agendamento e opções adicionais conforme necessário
4. Clique em **Review** e depois **Publish**

#### Enviar Notificação para Todos os Usuários

1. Na seção **Target**, selecione **User segment**
2. Configure os filtros desejados ou deixe em branco para todos
3. Clique em **Review** e depois **Publish**

### Canais de Notificação (Android)

O aplicativo define os seguintes canais de notificação no Android:

| Canal | ID | Descrição |
|-------|-----|-----------|
| Geral | `burgerrats_default_channel` | Notificações gerais do aplicativo |
| Check-ins | `burgerrats_checkins_channel` | Notificações sobre novos check-ins |
| Ligas | `burgerrats_leagues_channel` | Convites e atualizações de ligas |
| Lembretes | `burgerrats_reminders_channel` | Lembretes para fazer check-in |

Para enviar notificações em um canal específico, inclua no payload:

```json
{
  "message": {
    "android": {
      "notification": {
        "channel_id": "burgerrats_checkins_channel"
      }
    }
  }
}
```

### Estrutura de Tópicos

O aplicativo utiliza tópicos para segmentar notificações:

| Tópico | Formato | Uso |
|--------|---------|-----|
| Liga | `league_{leagueId}` | Notificar membros de uma liga específica |

Usuários são automaticamente inscritos nos tópicos das ligas quando entram e desinscritos quando saem.

### Enviando Notificações via API (Backend)

Para enviar notificações programaticamente do backend, use a API HTTP v1 do FCM:

#### Autenticação

1. No Console do Firebase, vá em **Project Settings** > **Service Accounts**
2. Clique em **Generate new private key**
3. Salve o arquivo JSON com segurança (nunca comite no repositório!)
4. Use este arquivo para autenticar requests à API

#### Exemplo de Request

```bash
# Obter token de acesso OAuth2
ACCESS_TOKEN=$(gcloud auth application-default print-access-token)

# Enviar notificação
curl -X POST \
  'https://fcm.googleapis.com/v1/projects/burgerrats-1d62d/messages:send' \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{
    "message": {
      "topic": "league_abc123",
      "notification": {
        "title": "Novo Check-in!",
        "body": "João fez check-in no Burger King"
      },
      "data": {
        "type": "check_in",
        "leagueId": "abc123",
        "checkInId": "xyz789"
      }
    }
  }'
```

### Gerenciando Tokens FCM

#### Tokens no Firestore

O aplicativo armazena tokens FCM de duas formas:

1. **Coleção `fcm_tokens`**: Documento por combinação usuário+token
   ```json
   {
     "token": "cToken...",
     "userId": "user123",
     "platform": "android",
     "createdAt": "...",
     "updatedAt": "..."
   }
   ```

2. **Documento do usuário em `users`**:
   ```json
   {
     "fcmToken": "cToken...",
     "fcmTokenUpdatedAt": "..."
   }
   ```

#### Limpeza de Tokens Inválidos

Tokens podem se tornar inválidos quando:
- Usuário desinstala o app
- Usuário limpa dados do app
- Token expira (raro)

Ao enviar notificação e receber erro `UNREGISTERED`, remova o token do Firestore.

### Testando Notificações

#### No Dispositivo Físico

1. Instale o app em um dispositivo físico (notificações não funcionam bem no simulador iOS)
2. Faça login no aplicativo
3. Copie o FCM token dos logs (procure por "FCM Token:")
4. Use o Console do Firebase para enviar uma notificação de teste

#### Com Firebase CLI

```bash
# Instalar Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Enviar notificação de teste
firebase messaging:send --project burgerrats-1d62d \
  --token "DEVICE_FCM_TOKEN" \
  --title "Teste" \
  --body "Notificação de teste"
```

### Monitorando Notificações

1. No Console do Firebase, vá em **Messaging**
2. Clique em uma campanha para ver métricas:
   - **Sent**: Quantas notificações foram enviadas
   - **Received**: Quantas foram recebidas (Android apenas)
   - **Opened**: Quantas foram abertas pelo usuário

### Solução de Problemas Comuns

| Problema | Causa | Solução |
|----------|-------|---------|
| Notificações não chegam no iOS | APNs não configurado | Configure certificado/chave APNs no Firebase |
| Notificações não chegam no Android | Canal bloqueado | Verificar configurações de notificação do app |
| Token nulo | Permissão negada | Verificar se usuário permitiu notificações |
| Erro UNREGISTERED | Token inválido | Remover token do Firestore |
| Notificações atrasadas | Modo econômico | Desativar otimização de bateria para o app |
| Não funciona em background | Configuração iOS | Verificar Background Modes no Xcode |
| Erro de autenticação API | Credenciais inválidas | Verificar service account JSON |

### Boas Práticas

1. **Solicite Permissão no Momento Certo**: Não peça permissão de notificação logo ao abrir o app. Espere um momento relevante, como quando o usuário entrar em uma liga.

2. **Permita Controle do Usuário**: Ofereça opções para o usuário escolher quais tipos de notificação deseja receber.

3. **Evite Spam**: Não envie notificações excessivas. Use com moderação.

4. **Inclua Dados de Navegação**: Sempre inclua dados no payload para que o app possa navegar para a tela correta ao abrir.

5. **Teste em Dispositivos Reais**: Simuladores/emuladores podem ter comportamento diferente.

6. **Monitore Métricas**: Acompanhe taxas de abertura e ajuste sua estratégia.

### Suporte

Para mais informações, consulte a [documentação oficial do Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging).
