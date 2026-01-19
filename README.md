# burgerrats

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

---

## Configuracao do Firebase Authentication

Este projeto utiliza o Firebase Authentication para gerenciar autenticacao de usuarios. Abaixo estao as instrucoes para configurar e gerenciar a autenticacao no portal do Firebase.

### Acessando o Console do Firebase

1. Acesse o [Console do Firebase](https://console.firebase.google.com/)
2. Selecione o projeto **burgerrats**
3. No menu lateral, clique em **Authentication**

### Habilitando Metodos de Login

Para que os usuarios possam se cadastrar e fazer login no aplicativo:

1. No Console do Firebase, va em **Authentication** > **Sign-in method**
2. Clique em **Email/Senha**
3. Ative a opcao **Email/Senha**
4. Clique em **Salvar**

### Gerenciando Usuarios

#### Visualizar Usuarios Cadastrados

1. Va em **Authentication** > **Users**
2. Aqui voce pode ver todos os usuarios registrados no aplicativo
3. A lista mostra: email, data de criacao, ultimo login e UID do usuario

#### Adicionar Usuario Manualmente

1. Em **Authentication** > **Users**, clique em **Adicionar usuario**
2. Preencha o email e senha
3. Clique em **Adicionar usuario**

#### Desativar ou Excluir Usuario

1. Em **Authentication** > **Users**, localize o usuario
2. Clique nos tres pontos (menu) ao lado do usuario
3. Selecione **Desativar conta** para bloquear o acesso ou **Excluir conta** para remover permanentemente

#### Redefinir Senha de Usuario

1. Em **Authentication** > **Users**, localize o usuario
2. Clique nos tres pontos (menu) ao lado do usuario
3. Selecione **Redefinir senha**
4. O usuario recebera um email com link para redefinir a senha

### Configurando Templates de Email

Personalize os emails enviados aos usuarios (verificacao, redefinicao de senha):

1. Va em **Authentication** > **Templates**
2. Selecione o template que deseja editar:
   - **Verificacao de endereco de email**
   - **Redefinicao de senha**
   - **Alteracao de endereco de email**
3. Clique em **Editar modelo**
4. Personalize:
   - **Nome do remetente**: Nome que aparece no email
   - **Endereco de email do remetente**: Email que envia as mensagens
   - **Assunto**: Titulo do email
   - **Mensagem**: Corpo do email (pode usar HTML)
5. Clique em **Salvar**

### Configurando Dominio Personalizado

Para emails mais profissionais com seu dominio:

1. Va em **Authentication** > **Templates**
2. Clique em **Personalizar dominio**
3. Siga as instrucoes para verificar seu dominio
4. Configure os registros DNS conforme indicado

### Configurando Provedores de Identidade Adicionais (Opcional)

Se desejar adicionar login com Google, Apple, etc:

1. Va em **Authentication** > **Sign-in method**
2. Clique no provedor desejado (Google, Apple, Facebook, etc)
3. Siga as instrucoes especificas para cada provedor
4. Cada provedor requer configuracao adicional (chaves de API, certificados, etc)

### Monitorando Uso e Cotas

1. Va em **Authentication** > **Usage**
2. Visualize estatisticas de:
   - Usuarios ativos
   - Novos cadastros
   - Logins por periodo

### Regras de Seguranca

O Firebase Authentication trabalha em conjunto com as regras de seguranca do Firestore e Storage. Certifique-se de que suas regras verificam a autenticacao:

```javascript
// Exemplo de regra do Firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      // Apenas usuarios autenticados podem ler seus proprios dados
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### Solucao de Problemas Comuns

| Erro | Causa | Solucao |
|------|-------|---------|
| `email-already-in-use` | Email ja cadastrado | Usar outro email ou fazer login |
| `weak-password` | Senha muito fraca | Usar senha com 6+ caracteres |
| `invalid-email` | Email mal formatado | Verificar formato do email |
| `user-not-found` | Usuario nao existe | Verificar email ou criar conta |
| `wrong-password` | Senha incorreta | Tentar novamente ou redefinir senha |
| `too-many-requests` | Muitas tentativas | Aguardar alguns minutos |
| `network-request-failed` | Sem internet | Verificar conexao |

### Suporte

Para mais informacoes, consulte a [documentacao oficial do Firebase Authentication](https://firebase.google.com/docs/auth).

---

## Configuracao do Firebase Storage

Este projeto utiliza o Firebase Storage para armazenar fotos de check-ins e perfis de usuarios. Abaixo estao as instrucoes para configurar e gerenciar o armazenamento no portal do Firebase.

### Acessando o Console do Firebase Storage

1. Acesse o [Console do Firebase](https://console.firebase.google.com/)
2. Selecione o projeto **burgerrats**
3. No menu lateral, clique em **Storage**

### Ativando o Firebase Storage

Se o Storage ainda nao estiver ativado:

1. No Console do Firebase, va em **Storage**
2. Clique em **Comecar** ou **Get Started**
3. Selecione o modo de regras de seguranca:
   - **Modo de producao**: Requer autenticacao (recomendado)
   - **Modo de teste**: Permite acesso temporario sem autenticacao (apenas para desenvolvimento)
4. Escolha a localizacao do servidor (recomendado: `southamerica-east1` para Brasil)
5. Clique em **Concluido**

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

### Configurando Regras de Seguranca

As regras de seguranca controlam quem pode ler e gravar arquivos. Acesse **Storage** > **Regras** e configure:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Funcao auxiliar para verificar autenticacao
    function isAuthenticated() {
      return request.auth != null;
    }

    // Funcao para verificar se o usuario e o dono do arquivo
    function isOwner(userId) {
      return request.auth != null && request.auth.uid == userId;
    }

    // Funcao para validar tipo de arquivo (imagens)
    function isValidImageType() {
      return request.resource.contentType.matches('image/.*');
    }

    // Funcao para validar tamanho (maximo 10MB)
    function isValidSize() {
      return request.resource.size < 10 * 1024 * 1024;
    }

    // Regras para fotos de check-in
    match /check-ins/{userId}/{allPaths=**} {
      // Qualquer usuario autenticado pode visualizar fotos de check-in
      allow read: if isAuthenticated();

      // Apenas o dono pode fazer upload/deletar suas proprias fotos
      allow write: if isOwner(userId) && isValidImageType() && isValidSize();
      allow delete: if isOwner(userId);
    }

    // Regras para fotos de perfil
    match /profile-photos/{userId}/{allPaths=**} {
      // Qualquer usuario autenticado pode visualizar fotos de perfil
      allow read: if isAuthenticated();

      // Apenas o dono pode fazer upload/deletar sua foto de perfil
      allow write: if isOwner(userId) && isValidImageType() && isValidSize();
      allow delete: if isOwner(userId);
    }
  }
}
```

### Monitorando Uso e Armazenamento

1. Va em **Storage** > **Uso** para visualizar:
   - Espaco total utilizado
   - Numero de arquivos
   - Transferencia de dados
   - Operacoes realizadas

### Gerenciando Arquivos

#### Navegando pelos Arquivos

1. Va em **Storage** > **Arquivos**
2. Navegue pelas pastas clicando nelas
3. Use a barra de caminho para voltar a pastas anteriores

#### Visualizando Detalhes do Arquivo

1. Clique em um arquivo para ver:
   - URL de download
   - Tipo de conteudo
   - Tamanho
   - Data de criacao
   - Metadados personalizados

#### Excluindo Arquivos Manualmente

1. Navegue ate o arquivo
2. Clique nos tres pontos (menu) ao lado do arquivo
3. Selecione **Excluir**
4. Confirme a exclusao

**Atencao**: A exclusao e permanente e nao pode ser desfeita.

#### Fazendo Upload Manual

1. Navegue ate a pasta desejada
2. Clique em **Fazer upload de arquivo**
3. Selecione o arquivo do seu computador
4. O arquivo sera enviado automaticamente

### Configurando CORS (Cross-Origin Resource Sharing)

Se as imagens nao carregarem no aplicativo web, configure o CORS:

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

**Nota**: Para producao, substitua `"*"` pelos dominios especificos do seu aplicativo.

### Configurando Backup (Opcional)

Para fazer backup automatico dos arquivos:

1. Acesse o [Google Cloud Console](https://console.cloud.google.com/)
2. Va em **Cloud Storage** > **Transfer**
3. Configure uma transferencia agendada para outro bucket

### Limites e Cotas

| Recurso | Plano Gratuito (Spark) | Plano Pago (Blaze) |
|---------|------------------------|-------------------|
| Armazenamento | 5 GB | Pago por uso |
| Downloads | 1 GB/dia | Pago por uso |
| Uploads | 1 GB/dia | Pago por uso |
| Operacoes | 50.000/dia | Pago por uso |

### Solucao de Problemas Comuns

| Erro | Causa | Solucao |
|------|-------|---------|
| `storage/unauthorized` | Usuario nao autenticado ou sem permissao | Verificar regras de seguranca e login do usuario |
| `storage/canceled` | Upload cancelado | Tentar novamente |
| `storage/object-not-found` | Arquivo nao existe | Verificar caminho do arquivo |
| `storage/quota-exceeded` | Limite de armazenamento excedido | Excluir arquivos ou fazer upgrade do plano |
| `storage/retry-limit-exceeded` | Muitas tentativas falharam | Verificar conexao e tentar novamente |

### Boas Praticas

1. **Compressao de Imagens**: O aplicativo comprime automaticamente as imagens antes do upload para economizar espaco e banda.

2. **Nomes de Arquivo Unicos**: O aplicativo gera nomes unicos com timestamp para evitar conflitos.

3. **Metadados**: Cada arquivo armazena metadados como ID do usuario, ID da liga e data de upload.

4. **Cache**: As imagens sao configuradas com cache de 1 ano para check-ins e 1 dia para fotos de perfil.

5. **Limite de Tamanho**: O aplicativo limita uploads a 10MB para evitar uso excessivo.

### Suporte

Para mais informacoes, consulte a [documentacao oficial do Firebase Storage](https://firebase.google.com/docs/storage).
