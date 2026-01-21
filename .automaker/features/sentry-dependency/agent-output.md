Vou analisar o contexto atual e implementar a feature de adicionar o pacote `sentry_flutter` ao projeto.

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Verificar estrutura atual do pubspec.yaml",
      "status": "in_progress",
      "activeForm": "Verificando estrutura atual do pubspec.yaml"
    },
    {
      "content": "Pesquisar versão compatível do sentry_flutter com Flutter SDK 3.10.1",
      "status": "pending",
      "activeForm": "Pesquisando versão compatível do sentry_flutter"
    },
    {
      "content": "Adicionar pacote sentry_flutter ao pubspec.yaml",
      "status": "pending",
      "activeForm": "Adicionando pacote sentry_flutter ao pubspec.yaml"
    }
  ]
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\pubspec.yaml"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Verificar estrutura atual do pubspec.yaml",
      "status": "completed",
      "activeForm": "Verificando estrutura atual do pubspec.yaml"
    },
    {
      "content": "Pesquisar versão compatível do sentry_flutter com Flutter SDK 3.10.1",
      "status": "in_progress",
      "activeForm": "Pesquisando versão compatível do sentry_flutter"
    },
    {
      "content": "Adicionar pacote sentry_flutter ao pubspec.yaml",
      "status": "pending",
      "activeForm": "Adicionando pacote sentry_flutter ao pubspec.yaml"
    }
  ]
}
Vou pesquisar a versão mais recente e compatível do `sentry_flutter`:

🔧 Tool: WebSearch
Input: {
  "query": "sentry_flutter pub.dev latest version 2025"
}

🔧 Tool: WebFetch
Input: {
  "url": "https://pub.dev/packages/sentry_flutter",
  "prompt": "What is the latest version of sentry_flutter? What are the SDK requirements (Dart SDK and Flutter SDK minimum versions)?"
}
Encontrei a versão mais recente: **9.10.0**. Vou verificar a compatibilidade com mais detalhes consultando o changelog ou requirements:

🔧 Tool: WebFetch
Input: {
  "url": "https://pub.dev/packages/sentry_flutter/versions",
  "prompt": "List the recent versions of sentry_flutter and their Dart/Flutter SDK requirements. I need to find a version compatible with Dart SDK 3.10.1"
}
A versão 9.10.0 é compatível com Dart SDK ^3.10.1. Agora vou adicionar o pacote ao pubspec.yaml:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Verificar estrutura atual do pubspec.yaml",
      "status": "completed",
      "activeForm": "Verificando estrutura atual do pubspec.yaml"
    },
    {
      "content": "Pesquisar versão compatível do sentry_flutter com Flutter SDK 3.10.1",
      "status": "completed",
      "activeForm": "Pesquisando versão compatível do sentry_flutter"
    },
    {
      "content": "Adicionar pacote sentry_flutter ao pubspec.yaml",
      "status": "in_progress",
      "activeForm": "Adicionando pacote sentry_flutter ao pubspec.yaml"
    }
  ]
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\pubspec.yaml",
  "old_string": "  # Cached network images for efficient loading with caching\n  cached_network_image: ^3.4.1\n\ndev_dependencies:",
  "new_string": "  # Cached network images for efficient loading with caching\n  cached_network_image: ^3.4.1\n\n  # Sentry - Crash reporting and performance monitoring\n  sentry_flutter: ^9.10.0\n\ndev_dependencies:"
}
Agora vou verificar se o pacote pode ser resolvido corretamente executando `flutter pub get`:

🔧 Tool: Bash
Input: {
  "command": "cd C:/dev/burgerrats && flutter pub get",
  "description": "Install Flutter dependencies",
  "timeout": 120000
}

🔧 Tool: Bash
Input: {
  "command": "cd C:/dev/burgerrats && export PUB_CACHE=\"$HOME/.pub-cache\" && flutter pub get",
  "description": "Install Flutter dependencies with PUB_CACHE",
  "timeout": 120000
}
O pacote foi instalado com sucesso. Vou atualizar o todo list:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Verificar estrutura atual do pubspec.yaml",
      "status": "completed",
      "activeForm": "Verificando estrutura atual do pubspec.yaml"
    },
    {
      "content": "Pesquisar versão compatível do sentry_flutter com Flutter SDK 3.10.1",
      "status": "completed",
      "activeForm": "Pesquisando versão compatível do sentry_flutter"
    },
    {
      "content": "Adicionar pacote sentry_flutter ao pubspec.yaml",
      "status": "completed",
      "activeForm": "Adicionando pacote sentry_flutter ao pubspec.yaml"
    }
  ]
}
<summary>
## Summary: Adicionar o pacote sentry_flutter no pubspec.yaml

### Changes Implemented
- Adicionado o pacote `sentry_flutter` versão ^9.10.0 ao pubspec.yaml
- Versão escolhida é a mais recente estável, compatível com Dart SDK ^3.10.1 (requer Dart SDK 3.5+)
- Executado `flutter pub get` com sucesso para validar a resolução de dependências

### Files Modified
- `pubspec.yaml` - Adicionada dependência sentry_flutter:102

### Notes for Developer
- O pacote sentry_flutter ^9.10.0 foi adicionado com suporte para:
  - Crash reporting nativo (Android/iOS)
  - Performance monitoring
  - Captura automática de erros em Isolates
  - Suporte a PlatformDispatcher.onError (Flutter 3.3+)
- O projeto já possui a configuração de secrets para Sentry DSN em `.secrets/app_secrets.json` conforme documentado no CLAUDE.md
- Próximos passos: Implementar inicialização do Sentry no app (features relacionadas: sentry-app-init, sentry-service)

Sources:
- [sentry_flutter | Flutter package](https://pub.dev/packages/sentry_flutter)
- [sentry_flutter versions](https://pub.dev/packages/sentry_flutter/versions)
</summary>