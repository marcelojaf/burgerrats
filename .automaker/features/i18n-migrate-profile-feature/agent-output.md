I'll implement the internationalization (i18n) migration for the profile feature. Let me start by exploring the codebase to understand the existing structure and patterns.

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Explore profile feature structure and existing i18n setup",
      "status": "in_progress",
      "activeForm": "Exploring profile feature structure and i18n setup"
    },
    {
      "content": "Identify all hardcoded Portuguese strings in profile feature",
      "status": "pending",
      "activeForm": "Identifying hardcoded Portuguese strings"
    },
    {
      "content": "Add profile strings to ARB files",
      "status": "pending",
      "activeForm": "Adding profile strings to ARB files"
    },
    {
      "content": "Replace hardcoded strings with localized strings",
      "status": "pending",
      "activeForm": "Replacing hardcoded strings with localized strings"
    },
    {
      "content": "Run code generation for localizations",
      "status": "pending",
      "activeForm": "Running code generation"
    },
    {
      "content": "Verify implementation",
      "status": "pending",
      "activeForm": "Verifying implementation"
    }
  ]
}

🔧 Tool: Glob
Input: {
  "pattern": "lib/features/profile/**/*.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\l10n\\app_en.arb"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\l10n\\app_pt.arb"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\shared\\extensions\\context_extensions.dart"
}
Now let me read the profile feature files to understand the hardcoded strings:

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\profile_page.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\edit_profile_page.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\settings_page.dart"
}
Now I have a clear picture of the profile feature files and the hardcoded strings. Let me update my todo list and identify all hardcoded strings:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Explore profile feature structure and existing i18n setup",
      "status": "completed",
      "activeForm": "Exploring profile feature structure and i18n setup"
    },
    {
      "content": "Identify all hardcoded Portuguese strings in profile feature",
      "status": "completed",
      "activeForm": "Identifying hardcoded Portuguese strings"
    },
    {
      "content": "Add missing profile strings to ARB files",
      "status": "in_progress",
      "activeForm": "Adding missing profile strings to ARB files"
    },
    {
      "content": "Replace hardcoded strings with localized strings in profile_page.dart",
      "status": "pending",
      "activeForm": "Replacing hardcoded strings in profile_page.dart"
    },
    {
      "content": "Replace hardcoded strings with localized strings in edit_profile_page.dart",
      "status": "pending",
      "activeForm": "Replacing hardcoded strings in edit_profile_page.dart"
    },
    {
      "content": "Replace hardcoded strings with localized strings in settings_page.dart",
      "status": "pending",
      "activeForm": "Replacing hardcoded strings in settings_page.dart"
    },
    {
      "content": "Run code generation for localizations",
      "status": "pending",
      "activeForm": "Running code generation"
    },
    {
      "content": "Verify implementation compiles correctly",
      "status": "pending",
      "activeForm": "Verifying implementation"
    }
  ]
}
Based on my analysis, here are the hardcoded strings I found:

**profile_page.dart:**
- 'Profile' (AppBar title)
- 'Erro ao carregar perfil' 
- 'Tentar novamente'
- 'Check-ins' (stat label)
- 'Streak' (stat label)
- 'Leagues' (stat label)
- 'Edit Profile'
- 'Check-in History'
- 'My Leagues'
- 'Logout'
- 'Tem certeza que deseja sair?'
- 'Cancelar'
- 'Sair'

**edit_profile_page.dart:**
- 'Perfil atualizado com sucesso!'
- 'Erro ao atualizar perfil. Tente novamente.'
- 'Foto atualizada com sucesso!'
- 'Erro ao atualizar foto no perfil.'
- 'Erro ao enviar foto. Tente novamente.'
- 'Erro ao selecionar foto: ...'
- 'Perfil atualizado com sucesso!' (snackbar)
- 'Editar Perfil'
- 'Salvar'
- 'Remover foto selecionada'
- 'Nome'
- 'Por favor, insira seu nome'
- 'Nome deve ter pelo menos 2 caracteres'
- 'Email'
- 'O email não pode ser alterado'

**settings_page.dart:**
- 'Configurações'
- 'Notificações'
- 'Tema'
- 'Idioma'
- 'Português'
- 'Política de Privacidade'
- 'Termos de Uso'
- 'Sobre'
- 'Versão 1.0.0'
- 'Excluir Conta'
- 'Tem certeza que deseja excluir sua conta? Esta ação não pode ser desfeita.'
- 'Cancelar'
- 'Excluir'
- 'Claro'
- 'Escuro'
- 'Sistema'
- 'Selecionar Tema'

Most of these strings already exist in the ARB files. Let me check which ones are missing and add them:

🔧 Tool: Grep
Input: {
  "pattern": "\"removeSelectedPhoto\"|\"pleaseEnterName\"|\"nameMustHaveMinChars\"|\"emailCannotBeChanged\"|\"profileUpdatedSuccess\"|\"errorUpdatingProfile\"|\"photoUpdatedSuccess\"|\"errorUpdatingPhoto\"|\"errorUploadingPhoto\"|\"errorSelectingPhoto\"",
  "path": "C:\\dev\\burgerrats\\lib\\l10n"
}
These strings are missing. Let me add the missing profile-related strings to both ARB files:

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\l10n\\app_en.arb",
  "offset": 660
}
Now let me add the missing strings for the profile feature to both ARB files:

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\l10n\\app_en.arb",
  "old_string": "  \"memberSingular\": \"member\",\n  \"membersPlural\": \"members\"\n}",
  "new_string": "  \"memberSingular\": \"member\",\n  \"membersPlural\": \"members\",\n\n  \"removeSelectedPhoto\": \"Remove selected photo\",\n  \"pleaseEnterName\": \"Please enter your name\",\n  \"nameMustHaveMinChars\": \"Name must have at least {min} characters\",\n  \"@nameMustHaveMinChars\": {\n    \"placeholders\": {\n      \"min\": {\n        \"type\": \"int\"\n      }\n    }\n  },\n  \"emailCannotBeChanged\": \"Email cannot be changed\",\n  \"profileUpdatedSuccess\": \"Profile updated successfully!\",\n  \"errorUpdatingProfile\": \"Error updating profile. Try again.\",\n  \"photoUpdatedSuccess\": \"Photo updated successfully!\",\n  \"errorUpdatingPhoto\": \"Error updating profile photo.\",\n  \"errorUploadingPhoto\": \"Error uploading photo. Try again.\",\n  \"errorSelectingPhoto\": \"Error selecting photo: {error}\",\n  \"@errorSelectingPhoto\": {\n    \"placeholders\": {\n      \"error\": {\n        \"type\": \"String\"\n      }\n    }\n  }\n}"
}
Now let me add the same strings to the Portuguese ARB file:

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\l10n\\app_pt.arb",
  "old_string": "  \"memberSingular\": \"membro\",\n  \"membersPlural\": \"membros\"\n}",
  "new_string": "  \"memberSingular\": \"membro\",\n  \"membersPlural\": \"membros\",\n\n  \"removeSelectedPhoto\": \"Remover foto selecionada\",\n  \"@removeSelectedPhoto\": {\n    \"description\": \"Button text to remove selected photo\"\n  },\n\n  \"pleaseEnterName\": \"Por favor, insira seu nome\",\n  \"@pleaseEnterName\": {\n    \"description\": \"Name field validation error\"\n  },\n\n  \"nameMustHaveMinChars\": \"Nome deve ter pelo menos {min} caracteres\",\n  \"@nameMustHaveMinChars\": {\n    \"description\": \"Name minimum characters validation error\",\n    \"placeholders\": {\n      \"min\": {\n        \"type\": \"int\"\n      }\n    }\n  },\n\n  \"emailCannotBeChanged\": \"O email nao pode ser alterado\",\n  \"@emailCannotBeChanged\": {\n    \"description\": \"Email field help text\"\n  },\n\n  \"profileUpdatedSuccess\": \"Perfil atualizado com sucesso!\",\n  \"@profileUpdatedSuccess\": {\n    \"description\": \"Profile updated success message\"\n  },\n\n  \"errorUpdatingProfile\": \"Erro ao atualizar perfil. Tente novamente.\",\n  \"@errorUpdatingProfile\": {\n    \"description\": \"Error updating profile message\"\n  },\n\n  \"photoUpdatedSuccess\": \"Foto atualizada com sucesso!\",\n  \"@photoUpdatedSuccess\": {\n    \"description\": \"Photo updated success message\"\n  },\n\n  \"errorUpdatingPhoto\": \"Erro ao atualizar foto no perfil.\",\n  \"@errorUpdatingPhoto\": {\n    \"description\": \"Error updating profile photo message\"\n  },\n\n  \"errorUploadingPhoto\": \"Erro ao enviar foto. Tente novamente.\",\n  \"@errorUploadingPhoto\": {\n    \"description\": \"Error uploading photo message\"\n  },\n\n  \"errorSelectingPhoto\": \"Erro ao selecionar foto: {error}\",\n  \"@errorSelectingPhoto\": {\n    \"description\": \"Error selecting photo message\",\n    \"placeholders\": {\n      \"error\": {\n        \"type\": \"String\"\n      }\n    }\n  }\n}"
}
Now let me update the todo list and start replacing hardcoded strings in the profile pages:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Explore profile feature structure and existing i18n setup",
      "status": "completed",
      "activeForm": "Exploring profile feature structure and i18n setup"
    },
    {
      "content": "Identify all hardcoded Portuguese strings in profile feature",
      "status": "completed",
      "activeForm": "Identifying hardcoded Portuguese strings"
    },
    {
      "content": "Add missing profile strings to ARB files",
      "status": "completed",
      "activeForm": "Adding missing profile strings to ARB files"
    },
    {
      "content": "Replace hardcoded strings with localized strings in profile_page.dart",
      "status": "in_progress",
      "activeForm": "Replacing hardcoded strings in profile_page.dart"
    },
    {
      "content": "Replace hardcoded strings with localized strings in edit_profile_page.dart",
      "status": "pending",
      "activeForm": "Replacing hardcoded strings in edit_profile_page.dart"
    },
    {
      "content": "Replace hardcoded strings with localized strings in settings_page.dart",
      "status": "pending",
      "activeForm": "Replacing hardcoded strings in settings_page.dart"
    },
    {
      "content": "Run code generation for localizations",
      "status": "pending",
      "activeForm": "Running code generation"
    },
    {
      "content": "Verify implementation compiles correctly",
      "status": "pending",
      "activeForm": "Verifying implementation"
    }
  ]
}
Now let me update profile_page.dart to use localized strings:

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\profile_page.dart",
  "old_string": "import 'package:cached_network_image/cached_network_image.dart';\nimport 'package:flutter/material.dart';\nimport 'package:flutter_riverpod/flutter_riverpod.dart';\nimport 'package:go_router/go_router.dart';\n\nimport '../../../../core/router/app_routes.dart';\nimport '../../../../core/state/providers/auth_state_provider.dart';\nimport '../providers/user_profile_provider.dart';",
  "new_string": "import 'package:cached_network_image/cached_network_image.dart';\nimport 'package:flutter/material.dart';\nimport 'package:flutter_riverpod/flutter_riverpod.dart';\nimport 'package:go_router/go_router.dart';\n\nimport '../../../../core/router/app_routes.dart';\nimport '../../../../core/state/providers/auth_state_provider.dart';\nimport '../../../../shared/extensions/context_extensions.dart';\nimport '../providers/user_profile_provider.dart';"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\profile_page.dart",
  "old_string": "    return Scaffold(\n      appBar: AppBar(\n        title: const Text('Profile'),\n        actions: [\n          IconButton(\n            icon: const Icon(Icons.settings),\n            onPressed: () => context.push(AppRoutes.settings),\n          ),\n        ],\n      ),\n      body: profileAsync.when(\n        data: (profile) => _ProfileContent(profile: profile),\n        loading: () => basicInfo != null\n            ? _ProfileContent(profile: basicInfo, isLoading: true)\n            : const Center(child: CircularProgressIndicator()),\n        error: (error, stack) => Center(\n          child: Column(\n            mainAxisAlignment: MainAxisAlignment.center,\n            children: [\n              const Icon(Icons.error_outline, size: 48),\n              const SizedBox(height: 16),\n              Text(\n                'Erro ao carregar perfil',\n                style: Theme.of(context).textTheme.titleMedium,\n              ),\n              const SizedBox(height: 8),\n              TextButton(\n                onPressed: () => ref.invalidate(userProfileProvider),\n                child: const Text('Tentar novamente'),\n              ),\n            ],\n          ),\n        ),\n      ),\n    );",
  "new_string": "    return Scaffold(\n      appBar: AppBar(\n        title: Text(context.l10n.profile),\n        actions: [\n          IconButton(\n            icon: const Icon(Icons.settings),\n            onPressed: () => context.push(AppRoutes.settings),\n          ),\n        ],\n      ),\n      body: profileAsync.when(\n        data: (profile) => _ProfileContent(profile: profile),\n        loading: () => basicInfo != null\n            ? _ProfileContent(profile: basicInfo, isLoading: true)\n            : const Center(child: CircularProgressIndicator()),\n        error: (error, stack) => Center(\n          child: Column(\n            mainAxisAlignment: MainAxisAlignment.center,\n            children: [\n              const Icon(Icons.error_outline, size: 48),\n              const SizedBox(height: 16),\n              Text(\n                context.l10n.errorLoadingProfile,\n                style: Theme.of(context).textTheme.titleMedium,\n              ),\n              const SizedBox(height: 8),\n              TextButton(\n                onPressed: () => ref.invalidate(userProfileProvider),\n                child: Text(context.l10n.tryAgain),\n              ),\n            ],\n          ),\n        ),\n      ),\n    );"
}
Now let me update the _ProfileContent class:

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\profile_page.dart",
  "old_string": "          Row(\n            mainAxisAlignment: MainAxisAlignment.spaceEvenly,\n            children: [\n              _StatCard(\n                label: 'Check-ins',\n                value: isLoading ? '-' : profile.totalCheckIns.toString(),\n                icon: Icons.restaurant,\n                isLoading: isLoading,\n              ),\n              _StatCard(\n                label: 'Streak',\n                value: isLoading\n                    ? '-'\n                    : profile.currentStreak > 0\n                        ? '${profile.currentStreak}d'\n                        : '0',\n                icon: Icons.local_fire_department,\n                isLoading: isLoading,\n                highlight: profile.hasActiveStreak,\n              ),\n              _StatCard(\n                label: 'Leagues',\n                value: isLoading ? '-' : profile.leaguesJoined.toString(),\n                icon: Icons.emoji_events,\n                isLoading: isLoading,\n              ),\n            ],\n          ),",
  "new_string": "          Row(\n            mainAxisAlignment: MainAxisAlignment.spaceEvenly,\n            children: [\n              _StatCard(\n                label: context.l10n.checkIns,\n                value: isLoading ? '-' : profile.totalCheckIns.toString(),\n                icon: Icons.restaurant,\n                isLoading: isLoading,\n              ),\n              _StatCard(\n                label: context.l10n.streak,\n                value: isLoading\n                    ? '-'\n                    : profile.currentStreak > 0\n                        ? '${profile.currentStreak}d'\n                        : '0',\n                icon: Icons.local_fire_department,\n                isLoading: isLoading,\n                highlight: profile.hasActiveStreak,\n              ),\n              _StatCard(\n                label: context.l10n.leagues,\n                value: isLoading ? '-' : profile.leaguesJoined.toString(),\n                icon: Icons.emoji_events,\n                isLoading: isLoading,\n              ),\n            ],\n          ),"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\profile_page.dart",
  "old_string": "          Card(\n            child: Column(\n              children: [\n                ListTile(\n                  leading: const Icon(Icons.edit),\n                  title: const Text('Edit Profile'),\n                  trailing: const Icon(Icons.chevron_right),\n                  onTap: () => context.push(AppRoutes.editProfile),\n                ),\n                const Divider(height: 1),\n                ListTile(\n                  leading: const Icon(Icons.history),\n                  title: const Text('Check-in History'),\n                  trailing: const Icon(Icons.chevron_right),\n                  onTap: () => context.push(AppRoutes.checkIns),\n                ),\n                const Divider(height: 1),\n                ListTile(\n                  leading: const Icon(Icons.emoji_events),\n                  title: const Text('My Leagues'),\n                  trailing: const Icon(Icons.chevron_right),\n                  onTap: () => context.push(AppRoutes.leagues),\n                ),\n              ],\n            ),\n          ),\n          const SizedBox(height: 16),\n          Card(\n            child: ListTile(\n              leading: Icon(\n                Icons.logout,\n                color: Theme.of(context).colorScheme.error,\n              ),\n              title: Text(\n                'Logout',\n                style: TextStyle(\n                  color: Theme.of(context).colorScheme.error,\n                ),\n              ),\n              onTap: () => _showLogoutConfirmation(context, ref),\n            ),\n          ),",
  "new_string": "          Card(\n            child: Column(\n              children: [\n                ListTile(\n                  leading: const Icon(Icons.edit),\n                  title: Text(context.l10n.editProfile),\n                  trailing: const Icon(Icons.chevron_right),\n                  onTap: () => context.push(AppRoutes.editProfile),\n                ),\n                const Divider(height: 1),\n                ListTile(\n                  leading: const Icon(Icons.history),\n                  title: Text(context.l10n.checkInHistory),\n                  trailing: const Icon(Icons.chevron_right),\n                  onTap: () => context.push(AppRoutes.checkIns),\n                ),\n                const Divider(height: 1),\n                ListTile(\n                  leading: const Icon(Icons.emoji_events),\n                  title: Text(context.l10n.myLeagues),\n                  trailing: const Icon(Icons.chevron_right),\n                  onTap: () => context.push(AppRoutes.leagues),\n                ),\n              ],\n            ),\n          ),\n          const SizedBox(height: 16),\n          Card(\n            child: ListTile(\n              leading: Icon(\n                Icons.logout,\n                color: Theme.of(context).colorScheme.error,\n              ),\n              title: Text(\n                context.l10n.logout,\n                style: TextStyle(\n                  color: Theme.of(context).colorScheme.error,\n                ),\n              ),\n              onTap: () => _showLogoutConfirmation(context, ref),\n            ),\n          ),"
}
Now let me update the logout confirmation dialog:

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\profile_page.dart",
  "old_string": "  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {\n    showDialog(\n      context: context,\n      builder: (context) => AlertDialog(\n        title: const Text('Logout'),\n        content: const Text('Tem certeza que deseja sair?'),\n        actions: [\n          TextButton(\n            onPressed: () => Navigator.of(context).pop(),\n            child: const Text('Cancelar'),\n          ),\n          TextButton(\n            onPressed: () {\n              Navigator.of(context).pop();\n              ref.read(authNotifierProvider.notifier).signOut();\n            },\n            style: TextButton.styleFrom(\n              foregroundColor: Theme.of(context).colorScheme.error,\n            ),\n            child: const Text('Sair'),\n          ),\n        ],\n      ),\n    );\n  }",
  "new_string": "  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {\n    showDialog(\n      context: context,\n      builder: (dialogContext) => AlertDialog(\n        title: Text(context.l10n.logout),\n        content: Text(context.l10n.logoutConfirmation),\n        actions: [\n          TextButton(\n            onPressed: () => Navigator.of(dialogContext).pop(),\n            child: Text(context.l10n.cancel),\n          ),\n          TextButton(\n            onPressed: () {\n              Navigator.of(dialogContext).pop();\n              ref.read(authNotifierProvider.notifier).signOut();\n            },\n            style: TextButton.styleFrom(\n              foregroundColor: Theme.of(context).colorScheme.error,\n            ),\n            child: Text(context.l10n.logout),\n          ),\n        ],\n      ),\n    );\n  }"
}
Now let me update the todo list and move to edit_profile_page.dart:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Explore profile feature structure and existing i18n setup",
      "status": "completed",
      "activeForm": "Exploring profile feature structure and i18n setup"
    },
    {
      "content": "Identify all hardcoded Portuguese strings in profile feature",
      "status": "completed",
      "activeForm": "Identifying hardcoded Portuguese strings"
    },
    {
      "content": "Add missing profile strings to ARB files",
      "status": "completed",
      "activeForm": "Adding missing profile strings to ARB files"
    },
    {
      "content": "Replace hardcoded strings with localized strings in profile_page.dart",
      "status": "completed",
      "activeForm": "Replacing hardcoded strings in profile_page.dart"
    },
    {
      "content": "Replace hardcoded strings with localized strings in edit_profile_page.dart",
      "status": "in_progress",
      "activeForm": "Replacing hardcoded strings in edit_profile_page.dart"
    },
    {
      "content": "Replace hardcoded strings with localized strings in settings_page.dart",
      "status": "pending",
      "activeForm": "Replacing hardcoded strings in settings_page.dart"
    },
    {
      "content": "Run code generation for localizations",
      "status": "pending",
      "activeForm": "Running code generation"
    },
    {
      "content": "Verify implementation compiles correctly",
      "status": "pending",
      "activeForm": "Verifying implementation"
    }
  ]
}
Now let me update edit_profile_page.dart. First, add the import and then update the strings:

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\edit_profile_page.dart",
  "old_string": "import 'dart:io';\n\nimport 'package:cached_network_image/cached_network_image.dart';\nimport 'package:flutter/material.dart';\nimport 'package:flutter_riverpod/flutter_riverpod.dart';\nimport 'package:go_router/go_router.dart';\n\nimport '../../../../core/di/injection.dart';\nimport '../../../../core/services/firebase_storage_service.dart';\nimport '../../../../core/services/image_compression_service.dart';\nimport '../../../../core/services/photo_capture_service.dart';\nimport '../../../../core/state/providers/auth_state_provider.dart';\nimport '../providers/user_profile_provider.dart';",
  "new_string": "import 'dart:io';\n\nimport 'package:cached_network_image/cached_network_image.dart';\nimport 'package:flutter/material.dart';\nimport 'package:flutter_riverpod/flutter_riverpod.dart';\nimport 'package:go_router/go_router.dart';\n\nimport '../../../../core/di/injection.dart';\nimport '../../../../core/services/firebase_storage_service.dart';\nimport '../../../../core/services/image_compression_service.dart';\nimport '../../../../core/services/photo_capture_service.dart';\nimport '../../../../core/state/providers/auth_state_provider.dart';\nimport '../../../../l10n/app_localizations.dart';\nimport '../../../../shared/extensions/context_extensions.dart';\nimport '../providers/user_profile_provider.dart';"
}
The EditProfileNotifier class has hardcoded Portuguese strings. Since notifiers don't have access to BuildContext, we'll need to handle these differently - the messages will be passed from the UI layer. Let me update the notifier to use message keys and let the UI translate them:

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\edit_profile_page.dart",
  "offset": 60,
  "limit": 100
}
I see the notifier has hardcoded strings. For state notifiers, a common approach is to use message keys instead. Let me change the approach - I'll modify the state to use enum message keys instead of raw strings, and let the UI handle translation. However, this is a significant refactor. A simpler approach is to make the notifier methods accept the localized strings as parameters. Let me implement a cleaner solution:

I'll update the notifier to return success/failure without messages, and let the UI handle the messages:

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\edit_profile_page.dart",
  "old_string": "/// Notifier for edit profile state\nclass EditProfileNotifier extends StateNotifier<EditProfileState> {\n  final AuthNotifier _authNotifier;\n  final FirebaseStorageService _storageService;\n  final ImageCompressionService _compressionService;\n\n  EditProfileNotifier(\n    this._authNotifier,\n    this._storageService,\n    this._compressionService,\n  ) : super(const EditProfileState());\n\n  Future<bool> updateDisplayName(String displayName) async {\n    state = state.copyWith(isSaving: true, clearError: true, clearSuccess: true);\n\n    final success = await _authNotifier.updateDisplayName(displayName);\n\n    if (success) {\n      state = state.copyWith(\n        isSaving: false,\n        successMessage: 'Perfil atualizado com sucesso!',\n      );\n    } else {\n      state = state.copyWith(\n        isSaving: false,\n        errorMessage: 'Erro ao atualizar perfil. Tente novamente.',\n      );\n    }\n\n    return success;\n  }\n\n  void setSelectedPhoto(File photo) {\n    state = state.copyWith(selectedPhoto: photo);\n  }\n\n  void clearSelectedPhoto() {\n    state = state.copyWith(clearPhoto: true);\n  }\n\n  Future<bool> uploadProfilePhoto(String userId) async {\n    if (state.selectedPhoto == null) return false;\n\n    state = state.copyWith(\n      isUploadingPhoto: true,\n      uploadProgress: 0.0,\n      clearError: true,\n      clearSuccess: true,\n    );\n\n    try {\n      // Compress the image first\n      final compressionResult = await _compressionService.compressImage(\n        state.selectedPhoto!.path,\n        options: CompressionOptions.profilePhoto,\n      );\n\n      // Upload to Firebase Storage\n      final uploadResult = await _storageService.uploadProfilePhoto(\n        userId: userId,\n        file: compressionResult.file,\n        onProgress: (progress) {\n          state = state.copyWith(uploadProgress: progress);\n        },\n      );\n\n      // Update Auth profile with photo URL\n      final success = await _authNotifier.updatePhotoURL(uploadResult.downloadUrl);\n\n      if (success) {\n        state = state.copyWith(\n          isUploadingPhoto: false,\n          uploadProgress: 1.0,\n          successMessage: 'Foto atualizada com sucesso!',\n          clearPhoto: true,\n        );\n        return true;\n      } else {\n        state = state.copyWith(\n          isUploadingPhoto: false,\n          errorMessage: 'Erro ao atualizar foto no perfil.',\n        );\n        return false;\n      }\n    } catch (e) {\n      state = state.copyWith(\n        isUploadingPhoto: false,\n        errorMessage: 'Erro ao enviar foto. Tente novamente.',\n      );\n      return false;\n    }\n  }\n\n  void clearMessages() {\n    state = state.copyWith(clearError: true, clearSuccess: true);\n  }\n}",
  "new_string": "/// Message key enum for localized messages\nenum ProfileMessageKey {\n  profileUpdatedSuccess,\n  errorUpdatingProfile,\n  photoUpdatedSuccess,\n  errorUpdatingPhoto,\n  errorUploadingPhoto,\n}\n\n/// Notifier for edit profile state\nclass EditProfileNotifier extends StateNotifier<EditProfileState> {\n  final AuthNotifier _authNotifier;\n  final FirebaseStorageService _storageService;\n  final ImageCompressionService _compressionService;\n\n  EditProfileNotifier(\n    this._authNotifier,\n    this._storageService,\n    this._compressionService,\n  ) : super(const EditProfileState());\n\n  /// Gets localized message based on key\n  static String getLocalizedMessage(ProfileMessageKey key, AppLocalizations l10n) {\n    switch (key) {\n      case ProfileMessageKey.profileUpdatedSuccess:\n        return l10n.profileUpdatedSuccess;\n      case ProfileMessageKey.errorUpdatingProfile:\n        return l10n.errorUpdatingProfile;\n      case ProfileMessageKey.photoUpdatedSuccess:\n        return l10n.photoUpdatedSuccess;\n      case ProfileMessageKey.errorUpdatingPhoto:\n        return l10n.errorUpdatingPhoto;\n      case ProfileMessageKey.errorUploadingPhoto:\n        return l10n.errorUploadingPhoto;\n    }\n  }\n\n  Future<ProfileMessageKey?> updateDisplayName(String displayName) async {\n    state = state.copyWith(isSaving: true, clearError: true, clearSuccess: true);\n\n    final success = await _authNotifier.updateDisplayName(displayName);\n\n    state = state.copyWith(isSaving: false);\n\n    return success ? ProfileMessageKey.profileUpdatedSuccess : ProfileMessageKey.errorUpdatingProfile;\n  }\n\n  void setSelectedPhoto(File photo) {\n    state = state.copyWith(selectedPhoto: photo);\n  }\n\n  void clearSelectedPhoto() {\n    state = state.copyWith(clearPhoto: true);\n  }\n\n  Future<ProfileMessageKey?> uploadProfilePhoto(String userId) async {\n    if (state.selectedPhoto == null) return null;\n\n    state = state.copyWith(\n      isUploadingPhoto: true,\n      uploadProgress: 0.0,\n      clearError: true,\n      clearSuccess: true,\n    );\n\n    try {\n      // Compress the image first\n      final compressionResult = await _compressionService.compressImage(\n        state.selectedPhoto!.path,\n        options: CompressionOptions.profilePhoto,\n      );\n\n      // Upload to Firebase Storage\n      final uploadResult = await _storageService.uploadProfilePhoto(\n        userId: userId,\n        file: compressionResult.file,\n        onProgress: (progress) {\n          state = state.copyWith(uploadProgress: progress);\n        },\n      );\n\n      // Update Auth profile with photo URL\n      final success = await _authNotifier.updatePhotoURL(uploadResult.downloadUrl);\n\n      if (success) {\n        state = state.copyWith(\n          isUploadingPhoto: false,\n          uploadProgress: 1.0,\n          clearPhoto: true,\n        );\n        return ProfileMessageKey.photoUpdatedSuccess;\n      } else {\n        state = state.copyWith(isUploadingPhoto: false);\n        return ProfileMessageKey.errorUpdatingPhoto;\n      }\n    } catch (e) {\n      state = state.copyWith(isUploadingPhoto: false);\n      return ProfileMessageKey.errorUploadingPhoto;\n    }\n  }\n\n  void clearMessages() {\n    state = state.copyWith(clearError: true, clearSuccess: true);\n  }\n}"
}
Now I need to update the UI methods that use the notifier. Let me read and update the _selectPhoto and _saveProfile methods:

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\edit_profile_page.dart",
  "offset": 220,
  "limit": 80
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\edit_profile_page.dart",
  "old_string": "  Future<void> _selectPhoto() async {\n    final photoCaptureService = ref.read(photoCaptureServiceProvider);\n\n    try {\n      final result = await photoCaptureService.captureWithSourceSelector(\n        context,\n        options: const PhotoCaptureOptions(\n          maxWidth: 500,\n          maxHeight: 500,\n          imageQuality: 80,\n        ),\n      );\n\n      if (result != null && mounted) {\n        ref.read(editProfileNotifierProvider.notifier).setSelectedPhoto(result.file);\n        setState(() {});\n      }\n    } catch (e) {\n      if (mounted) {\n        ScaffoldMessenger.of(context).showSnackBar(\n          SnackBar(\n            content: Text('Erro ao selecionar foto: ${e.toString()}'),\n            backgroundColor: Theme.of(context).colorScheme.error,\n          ),\n        );\n      }\n    }\n  }\n\n  Future<void> _saveProfile() async {\n    if (!_formKey.currentState!.validate()) return;\n\n    final notifier = ref.read(editProfileNotifierProvider.notifier);\n    final profile = ref.read(userBasicInfoProvider);\n    final editState = ref.read(editProfileNotifierProvider);\n\n    bool photoSuccess = true;\n    bool nameSuccess = true;\n\n    // Upload photo if selected\n    if (editState.selectedPhoto != null && profile != null) {\n      photoSuccess = await notifier.uploadProfilePhoto(profile.uid);\n    }\n\n    // Update display name if changed\n    if (_hasNameChanges) {\n      nameSuccess = await notifier.updateDisplayName(_nameController.text.trim());\n    }\n\n    if (photoSuccess && nameSuccess && mounted) {\n      ref.invalidate(userProfileProvider);\n      ScaffoldMessenger.of(context).showSnackBar(\n        const SnackBar(\n          content: Text('Perfil atualizado com sucesso!'),\n          backgroundColor: Colors.green,\n        ),\n      );\n      context.pop();\n    }\n  }",
  "new_string": "  Future<void> _selectPhoto() async {\n    final photoCaptureService = ref.read(photoCaptureServiceProvider);\n\n    try {\n      final result = await photoCaptureService.captureWithSourceSelector(\n        context,\n        options: const PhotoCaptureOptions(\n          maxWidth: 500,\n          maxHeight: 500,\n          imageQuality: 80,\n        ),\n      );\n\n      if (result != null && mounted) {\n        ref.read(editProfileNotifierProvider.notifier).setSelectedPhoto(result.file);\n        setState(() {});\n      }\n    } catch (e) {\n      if (mounted) {\n        ScaffoldMessenger.of(context).showSnackBar(\n          SnackBar(\n            content: Text(context.l10n.errorSelectingPhoto(e.toString())),\n            backgroundColor: Theme.of(context).colorScheme.error,\n          ),\n        );\n      }\n    }\n  }\n\n  Future<void> _saveProfile() async {\n    if (!_formKey.currentState!.validate()) return;\n\n    final notifier = ref.read(editProfileNotifierProvider.notifier);\n    final profile = ref.read(userBasicInfoProvider);\n    final editState = ref.read(editProfileNotifierProvider);\n\n    ProfileMessageKey? photoResult;\n    ProfileMessageKey? nameResult;\n\n    // Upload photo if selected\n    if (editState.selectedPhoto != null && profile != null) {\n      photoResult = await notifier.uploadProfilePhoto(profile.uid);\n    }\n\n    // Update display name if changed\n    if (_hasNameChanges) {\n      nameResult = await notifier.updateDisplayName(_nameController.text.trim());\n    }\n\n    final hasPhotoError = photoResult == ProfileMessageKey.errorUpdatingPhoto ||\n        photoResult == ProfileMessageKey.errorUploadingPhoto;\n    final hasNameError = nameResult == ProfileMessageKey.errorUpdatingProfile;\n\n    if (!hasPhotoError && !hasNameError && mounted) {\n      ref.invalidate(userProfileProvider);\n      ScaffoldMessenger.of(context).showSnackBar(\n        SnackBar(\n          content: Text(context.l10n.profileUpdatedSuccess),\n          backgroundColor: Colors.green,\n        ),\n      );\n      context.pop();\n    } else if (mounted) {\n      // Show the first error encountered\n      final errorKey = hasPhotoError ? photoResult! : nameResult!;\n      ScaffoldMessenger.of(context).showSnackBar(\n        SnackBar(\n          content: Text(EditProfileNotifier.getLocalizedMessage(errorKey, context.l10n)),\n          backgroundColor: Theme.of(context).colorScheme.error,\n        ),\n      );\n    }\n  }"
}
Now let me update the build method UI strings:

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\edit_profile_page.dart",
  "offset": 300,
  "limit": 130
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\edit_profile_page.dart",
  "old_string": "    // Show error if any\n    ref.listen<EditProfileState>(editProfileNotifierProvider, (previous, next) {\n      if (next.errorMessage != null && previous?.errorMessage != next.errorMessage) {\n        ScaffoldMessenger.of(context).showSnackBar(\n          SnackBar(\n            content: Text(next.errorMessage!),\n            backgroundColor: Theme.of(context).colorScheme.error,\n          ),\n        );\n      }\n    });\n\n    final isBusy = editState.isSaving || editState.isUploadingPhoto;\n\n    return Scaffold(\n      appBar: AppBar(\n        title: const Text('Editar Perfil'),\n        actions: [\n          TextButton(\n            onPressed: isBusy || !_hasChanges ? null : _saveProfile,\n            child: isBusy\n                ? const SizedBox(\n                    width: 20,\n                    height: 20,\n                    child: CircularProgressIndicator(strokeWidth: 2),\n                  )\n                : Text(\n                    'Salvar',\n                    style: TextStyle(\n                      color: _hasChanges\n                          ? Theme.of(context).colorScheme.primary\n                          : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),\n                    ),\n                  ),\n          ),\n        ],\n      ),",
  "new_string": "    final isBusy = editState.isSaving || editState.isUploadingPhoto;\n\n    return Scaffold(\n      appBar: AppBar(\n        title: Text(context.l10n.editProfile),\n        actions: [\n          TextButton(\n            onPressed: isBusy || !_hasChanges ? null : _saveProfile,\n            child: isBusy\n                ? const SizedBox(\n                    width: 20,\n                    height: 20,\n                    child: CircularProgressIndicator(strokeWidth: 2),\n                  )\n                : Text(\n                    context.l10n.save,\n                    style: TextStyle(\n                      color: _hasChanges\n                          ? Theme.of(context).colorScheme.primary\n                          : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),\n                    ),\n                  ),\n          ),\n        ],\n      ),"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\edit_profile_page.dart",
  "old_string": "                    if (editState.selectedPhoto != null) ...[\n                      const SizedBox(height: 8),\n                      TextButton.icon(\n                        onPressed: isBusy\n                            ? null\n                            : () {\n                                ref.read(editProfileNotifierProvider.notifier).clearSelectedPhoto();\n                                setState(() {});\n                              },\n                        icon: const Icon(Icons.close, size: 16),\n                        label: const Text('Remover foto selecionada'),\n                        style: TextButton.styleFrom(\n                          foregroundColor: Theme.of(context).colorScheme.error,\n                        ),\n                      ),\n                    ],\n                    const SizedBox(height: 32),\n                    TextFormField(\n                      controller: _nameController,\n                      decoration: const InputDecoration(\n                        labelText: 'Nome',\n                        prefixIcon: Icon(Icons.person),\n                        border: OutlineInputBorder(),\n                      ),\n                      textCapitalization: TextCapitalization.words,\n                      enabled: !isBusy,\n                      onChanged: (_) => _onFieldChanged(),\n                      validator: (value) {\n                        if (value == null || value.trim().isEmpty) {\n                          return 'Por favor, insira seu nome';\n                        }\n                        if (value.trim().length < 2) {\n                          return 'Nome deve ter pelo menos 2 caracteres';\n                        }\n                        return null;\n                      },\n                    ),\n                    const SizedBox(height: 16),\n                    TextFormField(\n                      initialValue: profile.email,\n                      decoration: const InputDecoration(\n                        labelText: 'Email',\n                        prefixIcon: Icon(Icons.email),\n                        border: OutlineInputBorder(),\n                      ),\n                      enabled: false,\n                    ),",
  "new_string": "                    if (editState.selectedPhoto != null) ...[\n                      const SizedBox(height: 8),\n                      TextButton.icon(\n                        onPressed: isBusy\n                            ? null\n                            : () {\n                                ref.read(editProfileNotifierProvider.notifier).clearSelectedPhoto();\n                                setState(() {});\n                              },\n                        icon: const Icon(Icons.close, size: 16),\n                        label: Text(context.l10n.removeSelectedPhoto),\n                        style: TextButton.styleFrom(\n                          foregroundColor: Theme.of(context).colorScheme.error,\n                        ),\n                      ),\n                    ],\n                    const SizedBox(height: 32),\n                    TextFormField(\n                      controller: _nameController,\n                      decoration: InputDecoration(\n                        labelText: context.l10n.name,\n                        prefixIcon: const Icon(Icons.person),\n                        border: const OutlineInputBorder(),\n                      ),\n                      textCapitalization: TextCapitalization.words,\n                      enabled: !isBusy,\n                      onChanged: (_) => _onFieldChanged(),\n                      validator: (value) {\n                        if (value == null || value.trim().isEmpty) {\n                          return context.l10n.pleaseEnterName;\n                        }\n                        if (value.trim().length < 2) {\n                          return context.l10n.nameMustHaveMinChars(2);\n                        }\n                        return null;\n                      },\n                    ),\n                    const SizedBox(height: 16),\n                    TextFormField(\n                      initialValue: profile.email,\n                      decoration: InputDecoration(\n                        labelText: context.l10n.email,\n                        prefixIcon: const Icon(Icons.email),\n                        border: const OutlineInputBorder(),\n                      ),\n                      enabled: false,\n                    ),"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\edit_profile_page.dart",
  "old_string": "                    const SizedBox(height: 8),\n                    Text(\n                      'O email nao pode ser alterado',\n                      style: Theme.of(context).textTheme.bodySmall?.copyWith(\n                            color: Theme.of(context).colorScheme.onSurfaceVariant,\n                          ),\n                    ),",
  "new_string": "                    const SizedBox(height: 8),\n                    Text(\n                      context.l10n.emailCannotBeChanged,\n                      style: Theme.of(context).textTheme.bodySmall?.copyWith(\n                            color: Theme.of(context).colorScheme.onSurfaceVariant,\n                          ),\n                    ),"
}
Now let me update the todo list and move to settings_page.dart:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Explore profile feature structure and existing i18n setup",
      "status": "completed",
      "activeForm": "Exploring profile feature structure and i18n setup"
    },
    {
      "content": "Identify all hardcoded Portuguese strings in profile feature",
      "status": "completed",
      "activeForm": "Identifying hardcoded Portuguese strings"
    },
    {
      "content": "Add missing profile strings to ARB files",
      "status": "completed",
      "activeForm": "Adding missing profile strings to ARB files"
    },
    {
      "content": "Replace hardcoded strings with localized strings in profile_page.dart",
      "status": "completed",
      "activeForm": "Replacing hardcoded strings in profile_page.dart"
    },
    {
      "content": "Replace hardcoded strings with localized strings in edit_profile_page.dart",
      "status": "completed",
      "activeForm": "Replacing hardcoded strings in edit_profile_page.dart"
    },
    {
      "content": "Replace hardcoded strings with localized strings in settings_page.dart",
      "status": "in_progress",
      "activeForm": "Replacing hardcoded strings in settings_page.dart"
    },
    {
      "content": "Run code generation for localizations",
      "status": "pending",
      "activeForm": "Running code generation"
    },
    {
      "content": "Verify implementation compiles correctly",
      "status": "pending",
      "activeForm": "Verifying implementation"
    }
  ]
}
Now let me update settings_page.dart:

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\settings_page.dart",
  "old_string": "import 'package:flutter/material.dart';\nimport 'package:flutter_riverpod/flutter_riverpod.dart';\nimport 'package:go_router/go_router.dart';\n\nimport '../../../../core/router/app_routes.dart';\nimport '../../../../core/state/providers/app_state_provider.dart';",
  "new_string": "import 'package:flutter/material.dart';\nimport 'package:flutter_riverpod/flutter_riverpod.dart';\nimport 'package:go_router/go_router.dart';\n\nimport '../../../../core/router/app_routes.dart';\nimport '../../../../core/state/providers/app_state_provider.dart';\nimport '../../../../shared/extensions/context_extensions.dart';"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\settings_page.dart",
  "old_string": "    return Scaffold(\n      appBar: AppBar(\n        title: const Text('Configurações'),\n      ),\n      body: ListView(\n        children: [\n          const ListTile(\n            leading: Icon(Icons.notifications),\n            title: Text('Notificações'),\n            trailing: Switch(\n              value: true,\n              onChanged: null,\n            ),\n          ),\n          const Divider(height: 1),\n          ListTile(\n            leading: const Icon(Icons.dark_mode),\n            title: const Text('Tema'),\n            subtitle: Text(_getThemeModeLabel(themeMode)),\n            trailing: const Icon(Icons.chevron_right),\n            onTap: () => _showThemeSelectionDialog(context, ref, themeMode),\n          ),\n          const Divider(height: 1),\n          const ListTile(\n            leading: Icon(Icons.language),\n            title: Text('Idioma'),\n            trailing: Text('Português'),\n          ),\n          const Divider(height: 1),\n          const ListTile(\n            leading: Icon(Icons.privacy_tip),\n            title: Text('Política de Privacidade'),\n            trailing: Icon(Icons.chevron_right),\n          ),\n          const Divider(height: 1),\n          const ListTile(\n            leading: Icon(Icons.description),\n            title: Text('Termos de Uso'),\n            trailing: Icon(Icons.chevron_right),\n          ),\n          const Divider(height: 1),\n          const ListTile(\n            leading: Icon(Icons.info),\n            title: Text('Sobre'),\n            subtitle: Text('Versão 1.0.0'),\n          ),\n          const Divider(height: 1),\n          ListTile(\n            leading: Icon(\n              Icons.delete_forever,\n              color: Theme.of(context).colorScheme.error,\n            ),\n            title: Text(\n              'Excluir Conta',\n              style: TextStyle(\n                color: Theme.of(context).colorScheme.error,\n              ),\n            ),\n            onTap: () {\n              showDialog(\n                context: context,\n                builder: (context) => AlertDialog(\n                  title: const Text('Excluir Conta'),\n                  content: const Text(\n                    'Tem certeza que deseja excluir sua conta? '\n                    'Esta ação não pode ser desfeita.',\n                  ),\n                  actions: [\n                    TextButton(\n                      onPressed: () => Navigator.pop(context),\n                      child: const Text('Cancelar'),\n                    ),\n                    TextButton(\n                      onPressed: () {\n                        Navigator.pop(context);\n                        context.go(AppRoutes.login);\n                      },\n                      child: Text(\n                        'Excluir',\n                        style: TextStyle(\n                          color: Theme.of(context).colorScheme.error,\n                        ),\n                      ),\n                    ),\n                  ],\n                ),\n              );\n            },\n          ),\n        ],\n      ),\n    );",
  "new_string": "    return Scaffold(\n      appBar: AppBar(\n        title: Text(context.l10n.settings),\n      ),\n      body: ListView(\n        children: [\n          ListTile(\n            leading: const Icon(Icons.notifications),\n            title: Text(context.l10n.notifications),\n            trailing: const Switch(\n              value: true,\n              onChanged: null,\n            ),\n          ),\n          const Divider(height: 1),\n          ListTile(\n            leading: const Icon(Icons.dark_mode),\n            title: Text(context.l10n.theme),\n            subtitle: Text(_getThemeModeLabel(context, themeMode)),\n            trailing: const Icon(Icons.chevron_right),\n            onTap: () => _showThemeSelectionDialog(context, ref, themeMode),\n          ),\n          const Divider(height: 1),\n          ListTile(\n            leading: const Icon(Icons.language),\n            title: Text(context.l10n.language),\n            trailing: Text(context.l10n.portuguese),\n          ),\n          const Divider(height: 1),\n          ListTile(\n            leading: const Icon(Icons.privacy_tip),\n            title: Text(context.l10n.privacyPolicy),\n            trailing: const Icon(Icons.chevron_right),\n          ),\n          const Divider(height: 1),\n          ListTile(\n            leading: const Icon(Icons.description),\n            title: Text(context.l10n.termsOfUse),\n            trailing: const Icon(Icons.chevron_right),\n          ),\n          const Divider(height: 1),\n          ListTile(\n            leading: const Icon(Icons.info),\n            title: Text(context.l10n.about),\n            subtitle: Text(context.l10n.version('1.0.0')),\n          ),\n          const Divider(height: 1),\n          ListTile(\n            leading: Icon(\n              Icons.delete_forever,\n              color: Theme.of(context).colorScheme.error,\n            ),\n            title: Text(\n              context.l10n.deleteAccount,\n              style: TextStyle(\n                color: Theme.of(context).colorScheme.error,\n              ),\n            ),\n            onTap: () {\n              showDialog(\n                context: context,\n                builder: (dialogContext) => AlertDialog(\n                  title: Text(context.l10n.deleteAccount),\n                  content: Text(context.l10n.deleteAccountConfirmation),\n                  actions: [\n                    TextButton(\n                      onPressed: () => Navigator.pop(dialogContext),\n                      child: Text(context.l10n.cancel),\n                    ),\n                    TextButton(\n                      onPressed: () {\n                        Navigator.pop(dialogContext);\n                        context.go(AppRoutes.login);\n                      },\n                      child: Text(\n                        context.l10n.delete,\n                        style: TextStyle(\n                          color: Theme.of(context).colorScheme.error,\n                        ),\n                      ),\n                    ),\n                  ],\n                ),\n              );\n            },\n          ),\n        ],\n      ),\n    );"
}
Now I need to update the _getThemeModeLabel method to accept context and use localized strings:

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\settings_page.dart",
  "old_string": "  String _getThemeModeLabel(ThemeMode mode) {\n    switch (mode) {\n      case ThemeMode.light:\n        return 'Claro';\n      case ThemeMode.dark:\n        return 'Escuro';\n      case ThemeMode.system:\n        return 'Sistema';\n    }\n  }",
  "new_string": "  String _getThemeModeLabel(BuildContext context, ThemeMode mode) {\n    switch (mode) {\n      case ThemeMode.light:\n        return context.l10n.light;\n      case ThemeMode.dark:\n        return context.l10n.dark;\n      case ThemeMode.system:\n        return context.l10n.system;\n    }\n  }"
}
Now let me update the theme selection dialog:

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\settings_page.dart",
  "old_string": "  void _showThemeSelectionDialog(\n    BuildContext context,\n    WidgetRef ref,\n    ThemeMode currentMode,\n  ) {\n    showDialog(\n      context: context,\n      builder: (context) => AlertDialog(\n        title: const Text('Selecionar Tema'),\n        content: Column(\n          mainAxisSize: MainAxisSize.min,\n          children: [\n            _ThemeOption(\n              icon: Icons.light_mode,\n              label: 'Claro',\n              isSelected: currentMode == ThemeMode.light,\n              onTap: () {\n                ref.read(appStateProvider.notifier).setThemeMode(ThemeMode.light);\n                Navigator.pop(context);\n              },\n            ),\n            const SizedBox(height: 8),\n            _ThemeOption(\n              icon: Icons.dark_mode,\n              label: 'Escuro',\n              isSelected: currentMode == ThemeMode.dark,\n              onTap: () {\n                ref.read(appStateProvider.notifier).setThemeMode(ThemeMode.dark);\n                Navigator.pop(context);\n              },\n            ),\n            const SizedBox(height: 8),\n            _ThemeOption(\n              icon: Icons.settings_suggest,\n              label: 'Sistema',\n              isSelected: currentMode == ThemeMode.system,\n              onTap: () {\n                ref.read(appStateProvider.notifier).setThemeMode(ThemeMode.system);\n                Navigator.pop(context);\n              },\n            ),\n          ],\n        ),\n        actions: [\n          TextButton(\n            onPressed: () => Navigator.pop(context),\n            child: const Text('Cancelar'),\n          ),\n        ],\n      ),\n    );\n  }",
  "new_string": "  void _showThemeSelectionDialog(\n    BuildContext context,\n    WidgetRef ref,\n    ThemeMode currentMode,\n  ) {\n    showDialog(\n      context: context,\n      builder: (dialogContext) => AlertDialog(\n        title: Text(context.l10n.selectTheme),\n        content: Column(\n          mainAxisSize: MainAxisSize.min,\n          children: [\n            _ThemeOption(\n              icon: Icons.light_mode,\n              label: context.l10n.light,\n              isSelected: currentMode == ThemeMode.light,\n              onTap: () {\n                ref.read(appStateProvider.notifier).setThemeMode(ThemeMode.light);\n                Navigator.pop(dialogContext);\n              },\n            ),\n            const SizedBox(height: 8),\n            _ThemeOption(\n              icon: Icons.dark_mode,\n              label: context.l10n.dark,\n              isSelected: currentMode == ThemeMode.dark,\n              onTap: () {\n                ref.read(appStateProvider.notifier).setThemeMode(ThemeMode.dark);\n                Navigator.pop(dialogContext);\n              },\n            ),\n            const SizedBox(height: 8),\n            _ThemeOption(\n              icon: Icons.settings_suggest,\n              label: context.l10n.system,\n              isSelected: currentMode == ThemeMode.system,\n              onTap: () {\n                ref.read(appStateProvider.notifier).setThemeMode(ThemeMode.system);\n                Navigator.pop(dialogContext);\n              },\n            ),\n          ],\n        ),\n        actions: [\n          TextButton(\n            onPressed: () => Navigator.pop(dialogContext),\n            child: Text(context.l10n.cancel),\n          ),\n        ],\n      ),\n    );\n  }"
}
Now let me update the todo list and run code generation:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Explore profile feature structure and existing i18n setup",
      "status": "completed",
      "activeForm": "Exploring profile feature structure and i18n setup"
    },
    {
      "content": "Identify all hardcoded Portuguese strings in profile feature",
      "status": "completed",
      "activeForm": "Identifying hardcoded Portuguese strings"
    },
    {
      "content": "Add missing profile strings to ARB files",
      "status": "completed",
      "activeForm": "Adding missing profile strings to ARB files"
    },
    {
      "content": "Replace hardcoded strings with localized strings in profile_page.dart",
      "status": "completed",
      "activeForm": "Replacing hardcoded strings in profile_page.dart"
    },
    {
      "content": "Replace hardcoded strings with localized strings in edit_profile_page.dart",
      "status": "completed",
      "activeForm": "Replacing hardcoded strings in edit_profile_page.dart"
    },
    {
      "content": "Replace hardcoded strings with localized strings in settings_page.dart",
      "status": "completed",
      "activeForm": "Replacing hardcoded strings in settings_page.dart"
    },
    {
      "content": "Run code generation for localizations",
      "status": "in_progress",
      "activeForm": "Running code generation"
    },
    {
      "content": "Verify implementation compiles correctly",
      "status": "pending",
      "activeForm": "Verifying implementation"
    }
  ]
}

🔧 Tool: Bash
Input: {
  "command": "cd /c/dev/burgerrats && flutter gen-l10n 2>&1",
  "description": "Generate Flutter localizations",
  "timeout": 120000
}
The localizations were generated. Now let me verify that the code compiles correctly:

🔧 Tool: Bash
Input: {
  "command": "cd /c/dev/burgerrats && flutter analyze lib/features/profile/ 2>&1",
  "description": "Analyze profile feature files",
  "timeout": 120000
}
Excellent! The profile feature files have no issues. Let me update the todo and run a full build to verify everything compiles:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Explore profile feature structure and existing i18n setup",
      "status": "completed",
      "activeForm": "Exploring profile feature structure and i18n setup"
    },
    {
      "content": "Identify all hardcoded Portuguese strings in profile feature",
      "status": "completed",
      "activeForm": "Identifying hardcoded Portuguese strings"
    },
    {
      "content": "Add missing profile strings to ARB files",
      "status": "completed",
      "activeForm": "Adding missing profile strings to ARB files"
    },
    {
      "content": "Replace hardcoded strings with localized strings in profile_page.dart",
      "status": "completed",
      "activeForm": "Replacing hardcoded strings in profile_page.dart"
    },
    {
      "content": "Replace hardcoded strings with localized strings in edit_profile_page.dart",
      "status": "completed",
      "activeForm": "Replacing hardcoded strings in edit_profile_page.dart"
    },
    {
      "content": "Replace hardcoded strings with localized strings in settings_page.dart",
      "status": "completed",
      "activeForm": "Replacing hardcoded strings in settings_page.dart"
    },
    {
      "content": "Run code generation for localizations",
      "status": "completed",
      "activeForm": "Running code generation"
    },
    {
      "content": "Verify implementation compiles correctly",
      "status": "in_progress",
      "activeForm": "Verifying implementation"
    }
  ]
}

🔧 Tool: Bash
Input: {
  "command": "cd /c/dev/burgerrats && flutter analyze 2>&1",
  "description": "Analyze entire Flutter project",
  "timeout": 180000
}
There's an existing error in create_check_in_page.dart that is pre-existing (not related to our changes). The profile feature changes are working correctly. Let me verify by specifically analyzing the profile files:

🔧 Tool: Bash
Input: {
  "command": "cd /c/dev/burgerrats && flutter analyze lib/features/profile/presentation/pages/profile_page.dart lib/features/profile/presentation/pages/edit_profile_page.dart lib/features/profile/presentation/pages/settings_page.dart 2>&1",
  "description": "Analyze specific profile files",
  "timeout": 120000
}
The profile feature files all pass analysis. The errors reported are pre-existing issues unrelated to our i18n migration. Let me update the todo list:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Explore profile feature structure and existing i18n setup",
      "status": "completed",
      "activeForm": "Exploring profile feature structure and i18n setup"
    },
    {
      "content": "Identify all hardcoded Portuguese strings in profile feature",
      "status": "completed",
      "activeForm": "Identifying hardcoded Portuguese strings"
    },
    {
      "content": "Add missing profile strings to ARB files",
      "status": "completed",
      "activeForm": "Adding missing profile strings to ARB files"
    },
    {
      "content": "Replace hardcoded strings with localized strings in profile_page.dart",
      "status": "completed",
      "activeForm": "Replacing hardcoded strings in profile_page.dart"
    },
    {
      "content": "Replace hardcoded strings with localized strings in edit_profile_page.dart",
      "status": "completed",
      "activeForm": "Replacing hardcoded strings in edit_profile_page.dart"
    },
    {
      "content": "Replace hardcoded strings with localized strings in settings_page.dart",
      "status": "completed",
      "activeForm": "Replacing hardcoded strings in settings_page.dart"
    },
    {
      "content": "Run code generation for localizations",
      "status": "completed",
      "activeForm": "Running code generation"
    },
    {
      "content": "Verify implementation compiles correctly",
      "status": "completed",
      "activeForm": "Verifying implementation"
    }
  ]
}
Note: The task mentioned Playwright verification, but this is a Flutter mobile app project (iOS and Android only as stated in CLAUDE.md), not a web app. Playwright is a web testing framework and is not applicable for Flutter mobile apps. Flutter testing would typically be done with `flutter test` or integration tests.

Let me verify our localization files are correctly formatted by checking the generated localizations:

🔧 Tool: Bash
Input: {
  "command": "cd /c/dev/burgerrats && ls -la lib/l10n/ 2>&1",
  "description": "List l10n directory contents"
}
The localizations were generated. Let me verify the generated AppLocalizations class contains our new methods:

🔧 Tool: Grep
Input: {
  "pattern": "removeSelectedPhoto|pleaseEnterName|nameMustHaveMinChars|emailCannotBeChanged|profileUpdatedSuccess|errorSelectingPhoto",
  "path": "C:\\dev\\burgerrats\\lib\\l10n\\app_localizations.dart",
  "output_mode": "content"
}
All our new localization keys are in the generated file. The implementation is complete.

<summary>
## Summary: Replace hardcoded Portuguese strings in profile feature with localized strings

### Changes Implemented
- Added 10 new localization keys for profile feature strings to both `app_en.arb` and `app_pt.arb`:
  - `removeSelectedPhoto`
  - `pleaseEnterName`
  - `nameMustHaveMinChars` (with placeholder)
  - `emailCannotBeChanged`
  - `profileUpdatedSuccess`
  - `errorUpdatingProfile`
  - `photoUpdatedSuccess`
  - `errorUpdatingPhoto`
  - `errorUploadingPhoto`
  - `errorSelectingPhoto` (with placeholder)

- Migrated all hardcoded strings in `profile_page.dart` to use `context.l10n.*` localization calls
- Migrated all hardcoded strings in `edit_profile_page.dart` to use localized strings
- Migrated all hardcoded strings in `settings_page.dart` to use localized strings
- Refactored `EditProfileNotifier` to use `ProfileMessageKey` enum for message types instead of hardcoded strings, allowing the UI layer to handle localization

### Files Modified
- `lib/l10n/app_en.arb` - Added 10 new English translation keys
- `lib/l10n/app_pt.arb` - Added 10 new Portuguese translation keys
- `lib/features/profile/presentation/pages/profile_page.dart` - Replaced hardcoded strings with localized versions
- `lib/features/profile/presentation/pages/edit_profile_page.dart` - Replaced hardcoded strings with localized versions, added `ProfileMessageKey` enum
- `lib/features/profile/presentation/pages/settings_page.dart` - Replaced hardcoded strings with localized versions

### Notes for Developer
- The existing errors in the codebase (related to `create_check_in_page.dart` and test files) are pre-existing issues unrelated to this i18n migration
- All profile feature files pass Flutter analyze with no issues
- The `ProfileMessageKey` enum pattern was introduced in `edit_profile_page.dart` to cleanly handle localization in state notifiers that don't have access to `BuildContext`
- Run `flutter gen-l10n` if you need to regenerate the localization files after any ARB changes

### Verification Status
- Note: Playwright verification is not applicable to this Flutter mobile project (iOS/Android only). The implementation was verified using:
  - `flutter gen-l10n` - Successfully generated localization files
  - `flutter analyze lib/features/profile/` - No issues found
  - All 3 profile page files pass analysis individually
</summary>