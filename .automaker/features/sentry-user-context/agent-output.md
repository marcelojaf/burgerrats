
🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Explore existing Sentry and auth state code",
      "status": "in_progress",
      "activeForm": "Exploring existing Sentry and auth state code"
    },
    {
      "content": "Plan implementation approach for user context",
      "status": "pending",
      "activeForm": "Planning implementation approach"
    },
    {
      "content": "Implement user context capture in Sentry",
      "status": "pending",
      "activeForm": "Implementing user context capture"
    },
    {
      "content": "Integrate with auth state provider",
      "status": "pending",
      "activeForm": "Integrating with auth state provider"
    }
  ]
}

🔧 Tool: Glob
Input: {
  "pattern": "**/*sentry*"
}

🔧 Tool: Grep
Input: {
  "pattern": "authStateProvider|authNotifierProvider",
  "glob": "*.dart"
}

🔧 Tool: Glob
Input: {
  "pattern": "lib/core/services/*"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\sentry_service.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\state\\providers\\auth_state_provider.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\di\\injection.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\main.dart"
}
Now I have a good understanding of the code. Let me mark the first task as complete and plan the implementation:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Explore existing Sentry and auth state code",
      "status": "completed",
      "activeForm": "Exploring existing Sentry and auth state code"
    },
    {
      "content": "Plan implementation approach for user context",
      "status": "in_progress",
      "activeForm": "Planning implementation approach"
    },
    {
      "content": "Create SentryUserContextProvider to listen to auth state",
      "status": "pending",
      "activeForm": "Creating SentryUserContextProvider"
    },
    {
      "content": "Initialize provider in BurgerRatsApp widget",
      "status": "pending",
      "activeForm": "Initializing provider in app"
    }
  ]
}
Based on my exploration, here's what I found:

1. **SentryService** (`lib/core/services/sentry_service.dart`) - Already has `setUserContext()` and `clearUserContext()` methods ready to use
2. **AuthStateProvider** (`lib/core/state/providers/auth_state_provider.dart`) - Has `authStateProvider` (StreamProvider<User?>) and `authNotifierProvider` 
3. **main.dart** - Uses `ConsumerStatefulWidget` for `BurgerRatsApp` which can access Riverpod state

**Implementation Plan:**
1. Create a new provider that listens to `authStateProvider` and automatically updates Sentry user context
2. Initialize this provider in the `BurgerRatsApp` widget so it activates when the app starts

Let me implement this:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Explore existing Sentry and auth state code",
      "status": "completed",
      "activeForm": "Exploring existing Sentry and auth state code"
    },
    {
      "content": "Plan implementation approach for user context",
      "status": "completed",
      "activeForm": "Planning implementation approach"
    },
    {
      "content": "Create SentryUserContextProvider to listen to auth state",
      "status": "in_progress",
      "activeForm": "Creating SentryUserContextProvider"
    },
    {
      "content": "Initialize provider in BurgerRatsApp widget",
      "status": "pending",
      "activeForm": "Initializing provider in app"
    }
  ]
}

🔧 Tool: Glob
Input: {
  "pattern": "lib/core/state/providers/*"
}

🔧 Tool: Write
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\state\\providers\\sentry_user_context_provider.dart",
  "content": "import 'package:firebase_auth/firebase_auth.dart';\nimport 'package:flutter/foundation.dart';\nimport 'package:flutter_riverpod/flutter_riverpod.dart';\n\nimport '../../di/injection.dart';\nimport '../../services/sentry_service.dart';\nimport 'auth_state_provider.dart';\n\n/// Provider that manages Sentry user context based on authentication state\n///\n/// This provider automatically:\n/// - Sets user context (ID, email, displayName) when user logs in\n/// - Clears user context when user logs out\n/// - Updates user context when user data changes\n///\n/// The provider should be watched in the app's root widget to ensure\n/// it's active throughout the app lifecycle.\n///\n/// Usage:\n/// ```dart\n/// // In your root ConsumerWidget\n/// @override\n/// Widget build(BuildContext context, WidgetRef ref) {\n///   // Watch to activate the provider\n///   ref.watch(sentryUserContextProvider);\n///   // ... rest of build\n/// }\n/// ```\nfinal sentryUserContextProvider = Provider<void>((ref) {\n  final sentryService = getIt<SentryService>();\n\n  // Listen to auth state changes\n  ref.listen<AsyncValue<User?>>(\n    authStateProvider,\n    (previous, next) {\n      next.when(\n        data: (user) {\n          if (user != null) {\n            _setUserContext(sentryService, user);\n          } else {\n            _clearUserContext(sentryService);\n          }\n        },\n        loading: () {\n          // Do nothing while loading\n        },\n        error: (error, stackTrace) {\n          // Clear user context on auth error\n          _clearUserContext(sentryService);\n        },\n      );\n    },\n    fireImmediately: true,\n  );\n});\n\n/// Sets the Sentry user context with the authenticated user's information\nvoid _setUserContext(SentryService sentryService, User user) {\n  sentryService.setUserContext(\n    userId: user.uid,\n    email: user.email,\n    displayName: user.displayName,\n    extras: {\n      'email_verified': user.emailVerified,\n      'provider_id': user.providerData.isNotEmpty\n          ? user.providerData.first.providerId\n          : 'unknown',\n      'created_at': user.metadata.creationTime?.toIso8601String(),\n      'last_sign_in': user.metadata.lastSignInTime?.toIso8601String(),\n    },\n  );\n\n  if (kDebugMode) {\n    debugPrint('Sentry: User context updated for ${user.uid}');\n  }\n}\n\n/// Clears the Sentry user context\nvoid _clearUserContext(SentryService sentryService) {\n  sentryService.clearUserContext();\n\n  if (kDebugMode) {\n    debugPrint('Sentry: User context cleared');\n  }\n}\n"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Explore existing Sentry and auth state code",
      "status": "completed",
      "activeForm": "Exploring existing Sentry and auth state code"
    },
    {
      "content": "Plan implementation approach for user context",
      "status": "completed",
      "activeForm": "Planning implementation approach"
    },
    {
      "content": "Create SentryUserContextProvider to listen to auth state",
      "status": "completed",
      "activeForm": "Creating SentryUserContextProvider"
    },
    {
      "content": "Initialize provider in BurgerRatsApp widget",
      "status": "in_progress",
      "activeForm": "Initializing provider in app"
    }
  ]
}
Now let me update `main.dart` to watch this provider in the `BurgerRatsApp` widget:

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\main.dart",
  "old_string": "import 'core/state/providers/app_state_provider.dart';\nimport 'core/state/providers/notification_handler_provider.dart';\nimport 'shared/theme/app_theme.dart';",
  "new_string": "import 'core/state/providers/app_state_provider.dart';\nimport 'core/state/providers/notification_handler_provider.dart';\nimport 'core/state/providers/sentry_user_context_provider.dart';\nimport 'shared/theme/app_theme.dart';"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\main.dart",
  "old_string": "@override\n  Widget build(BuildContext context) {\n    // Watch theme mode from app state\n    final themeMode = ref.watch(themeModeProvider);\n\n    // Watch locale from app state\n    final locale = ref.watch(localeProvider);\n\n    // Watch auth-aware router that automatically handles redirects\n    final router = ref.watch(routerProvider);",
  "new_string": "@override\n  Widget build(BuildContext context) {\n    // Watch theme mode from app state\n    final themeMode = ref.watch(themeModeProvider);\n\n    // Watch locale from app state\n    final locale = ref.watch(localeProvider);\n\n    // Watch auth-aware router that automatically handles redirects\n    final router = ref.watch(routerProvider);\n\n    // Watch Sentry user context provider to automatically update user info on login/logout\n    ref.watch(sentryUserContextProvider);"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Explore existing Sentry and auth state code",
      "status": "completed",
      "activeForm": "Exploring existing Sentry and auth state code"
    },
    {
      "content": "Plan implementation approach for user context",
      "status": "completed",
      "activeForm": "Planning implementation approach"
    },
    {
      "content": "Create SentryUserContextProvider to listen to auth state",
      "status": "completed",
      "activeForm": "Creating SentryUserContextProvider"
    },
    {
      "content": "Initialize provider in BurgerRatsApp widget",
      "status": "completed",
      "activeForm": "Initializing provider in app"
    },
    {
      "content": "Run flutter analyze to verify code",
      "status": "in_progress",
      "activeForm": "Running flutter analyze"
    }
  ]
}

🔧 Tool: Bash
Input: {
  "command": "cd C:/dev/burgerrats && flutter analyze lib/core/state/providers/sentry_user_context_provider.dart lib/main.dart",
  "description": "Analyze new provider and main.dart",
  "timeout": 120000
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Explore existing Sentry and auth state code",
      "status": "completed",
      "activeForm": "Exploring existing Sentry and auth state code"
    },
    {
      "content": "Plan implementation approach for user context",
      "status": "completed",
      "activeForm": "Planning implementation approach"
    },
    {
      "content": "Create SentryUserContextProvider to listen to auth state",
      "status": "completed",
      "activeForm": "Creating SentryUserContextProvider"
    },
    {
      "content": "Initialize provider in BurgerRatsApp widget",
      "status": "completed",
      "activeForm": "Initializing provider in app"
    },
    {
      "content": "Run flutter analyze to verify code",
      "status": "completed",
      "activeForm": "Running flutter analyze"
    }
  ]
}
The implementation is complete. Let me verify the final code:

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\state\\providers\\sentry_user_context_provider.dart"
}
<summary>
## Summary: Configurar Sentry User Context

### Changes Implemented
- Created `sentryUserContextProvider` that listens to Firebase auth state changes
- Automatically sets user context (ID, email, displayName) in Sentry when user logs in
- Automatically clears user context when user logs out or auth errors occur
- Includes extra metadata: `email_verified`, `provider_id`, `created_at`, `last_sign_in`
- Uses `fireImmediately: true` to capture initial auth state on app startup
- Integrated provider into `BurgerRatsApp` widget build method

### Files Modified
- `lib/core/state/providers/sentry_user_context_provider.dart` (new file)
- `lib/main.dart` (added import and provider watch)

### Notes for Developer
- The provider uses the existing `SentryService.setUserContext()` and `clearUserContext()` methods
- User context is automatically updated on every auth state change (login/logout/token refresh)
- Extra metadata attached includes email verification status and authentication provider ID
- Debug prints are included for development visibility (only in debug mode)
- No new dependencies required - uses existing Riverpod and Sentry packages
</summary>