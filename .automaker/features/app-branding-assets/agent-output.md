I'll start by exploring the codebase to understand the existing structure and then implement the branding assets integration.

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Explore existing codebase structure for assets and branding",
      "status": "in_progress",
      "activeForm": "Exploring existing codebase structure"
    },
    {
      "content": "Check source branding assets in OneDrive folder",
      "status": "pending",
      "activeForm": "Checking source branding assets"
    },
    {
      "content": "Copy and organize assets to proper directories",
      "status": "pending",
      "activeForm": "Copying and organizing assets"
    },
    {
      "content": "Update splash screen with branded assets",
      "status": "pending",
      "activeForm": "Updating splash screen"
    },
    {
      "content": "Update onboarding screens with branded assets",
      "status": "pending",
      "activeForm": "Updating onboarding screens"
    },
    {
      "content": "Update login screen with branded assets",
      "status": "pending",
      "activeForm": "Updating login screen"
    },
    {
      "content": "Update pubspec.yaml for asset declarations",
      "status": "pending",
      "activeForm": "Updating pubspec.yaml"
    }
  ]
}

🔧 Tool: Bash
Input: {
  "command": "ls -la \"C:\\dev\\burgerrats\\assets\" 2>/dev/null || echo \"assets folder does not exist or is empty\"",
  "description": "Check current assets folder structure"
}

🔧 Tool: Bash
Input: {
  "command": "ls -la \"/c/Users/marce/OneDrive - CK Labs Dev/CKLabs-Projetos/BurgerRats/ImageSets\" 2>/dev/null || ls -la \"C:\\Users\\marce\\OneDrive - CK Labs Dev\\CKLabs-Projetos\\BurgerRats\\ImageSets\" 2>/dev/null || echo \"Source folder not found\"",
  "description": "Check source branding assets folder"
}

🔧 Tool: Glob
Input: {
  "pattern": "lib/features/splash/**/*.dart"
}

🔧 Tool: Glob
Input: {
  "pattern": "lib/features/onboarding/**/*.dart"
}

🔧 Tool: Glob
Input: {
  "pattern": "lib/features/auth/**/*.dart"
}

🔧 Tool: Bash
Input: {
  "command": "ls -laR \"/c/Users/marce/OneDrive - CK Labs Dev/CKLabs-Projetos/BurgerRats/ImageSets\"",
  "description": "List source branding assets in detail"
}

🔧 Tool: Bash
Input: {
  "command": "ls -laR \"C:\\dev\\burgerrats\\assets\"",
  "description": "List current assets structure"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\splash\\presentation\\pages\\splash_page.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\auth\\presentation\\pages\\login_page.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\onboarding\\presentation\\pages\\onboarding_page.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\onboarding\\presentation\\widgets\\onboarding_page_content.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\pubspec.yaml"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Explore existing codebase structure for assets and branding",
      "status": "completed",
      "activeForm": "Exploring existing codebase structure"
    },
    {
      "content": "Check source branding assets in OneDrive folder",
      "status": "completed",
      "activeForm": "Checking source branding assets"
    },
    {
      "content": "Copy and organize assets to proper directories",
      "status": "in_progress",
      "activeForm": "Copying and organizing assets"
    },
    {
      "content": "Update splash screen with branded assets",
      "status": "pending",
      "activeForm": "Updating splash screen"
    },
    {
      "content": "Update onboarding screens with branded assets",
      "status": "pending",
      "activeForm": "Updating onboarding screens"
    },
    {
      "content": "Update login screen with branded assets",
      "status": "pending",
      "activeForm": "Updating login screen"
    },
    {
      "content": "Update pubspec.yaml for asset declarations",
      "status": "pending",
      "activeForm": "Updating pubspec.yaml"
    }
  ]
}
Now I understand the structure. The source folder has:
- **Android**: `drawable-mdpi`, `drawable-hdpi`, `drawable-xhdpi`, `drawable-xxhdpi`, `drawable-xxxhdpi` with logo.png
- **iOS**: `logo.png`, `logo@2x.png`, `logo@3x.png`

For Flutter, I'll use the resolution-aware assets approach with density variants (1x, 2x, 3x). Let me copy and organize the assets:

🔧 Tool: Bash
Input: {
  "command": "mkdir -p \"C:\\dev\\burgerrats\\assets\\images\\2.0x\" \"C:\\dev\\burgerrats\\assets\\images\\3.0x\"",
  "description": "Create density variant directories"
}

🔧 Tool: Bash
Input: {
  "command": "cp \"/c/Users/marce/OneDrive - CK Labs Dev/CKLabs-Projetos/BurgerRats/ImageSets/ios/logo.png\" \"C:\\dev\\burgerrats\\assets\\images\\logo.png\"",
  "description": "Copy 1x logo to assets"
}

🔧 Tool: Bash
Input: {
  "command": "cp \"/c/Users/marce/OneDrive - CK Labs Dev/CKLabs-Projetos/BurgerRats/ImageSets/ios/logo@2x.png\" \"C:\\dev\\burgerrats\\assets\\images\\2.0x\\logo.png\"",
  "description": "Copy 2x logo to assets"
}

🔧 Tool: Bash
Input: {
  "command": "cp \"/c/Users/marce/OneDrive - CK Labs Dev/CKLabs-Projetos/BurgerRats/ImageSets/ios/logo@3x.png\" \"C:\\dev\\burgerrats\\assets\\images\\3.0x\\logo.png\"",
  "description": "Copy 3x logo to assets"
}

🔧 Tool: Bash
Input: {
  "command": "ls -la \"C:\\dev\\burgerrats\\assets\\images\" && ls -la \"C:\\dev\\burgerrats\\assets\\images\\2.0x\" && ls -la \"C:\\dev\\burgerrats\\assets\\images\\3.0x\"",
  "description": "Verify assets were copied correctly"
}
Now let me update the pubspec.yaml to declare the new logo asset:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Explore existing codebase structure for assets and branding",
      "status": "completed",
      "activeForm": "Exploring existing codebase structure"
    },
    {
      "content": "Check source branding assets in OneDrive folder",
      "status": "completed",
      "activeForm": "Checking source branding assets"
    },
    {
      "content": "Copy and organize assets to proper directories",
      "status": "completed",
      "activeForm": "Copying and organizing assets"
    },
    {
      "content": "Update pubspec.yaml for asset declarations",
      "status": "in_progress",
      "activeForm": "Updating pubspec.yaml"
    },
    {
      "content": "Update splash screen with branded assets",
      "status": "pending",
      "activeForm": "Updating splash screen"
    },
    {
      "content": "Update onboarding screens with branded assets",
      "status": "pending",
      "activeForm": "Updating onboarding screens"
    },
    {
      "content": "Update login screen with branded assets",
      "status": "pending",
      "activeForm": "Updating login screen"
    }
  ]
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\pubspec.yaml",
  "old_string": "  # Assets - App logos and images\n  assets:\n    - assets/images/logo_bg.png\n    - assets/images/logo_rato.png",
  "new_string": "  # Assets - App logos and images\n  assets:\n    - assets/images/logo.png\n    - assets/images/logo_bg.png\n    - assets/images/logo_rato.png"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Explore existing codebase structure for assets and branding",
      "status": "completed",
      "activeForm": "Exploring existing codebase structure"
    },
    {
      "content": "Check source branding assets in OneDrive folder",
      "status": "completed",
      "activeForm": "Checking source branding assets"
    },
    {
      "content": "Copy and organize assets to proper directories",
      "status": "completed",
      "activeForm": "Copying and organizing assets"
    },
    {
      "content": "Update pubspec.yaml for asset declarations",
      "status": "completed",
      "activeForm": "Updating pubspec.yaml"
    },
    {
      "content": "Update splash screen with branded assets",
      "status": "in_progress",
      "activeForm": "Updating splash screen"
    },
    {
      "content": "Update onboarding screens with branded assets",
      "status": "pending",
      "activeForm": "Updating onboarding screens"
    },
    {
      "content": "Update login screen with branded assets",
      "status": "pending",
      "activeForm": "Updating login screen"
    }
  ]
}
Now let me update the splash screen to use the new branded logo. The current splash screen uses `logo_bg.png` and `logo_rato.png` as overlays. The new `logo.png` appears to be a complete logo, so I'll update the splash screen to use it:

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\splash\\presentation\\pages\\splash_page.dart",
  "old_string": "                // Logo with background\n                Stack(\n                  alignment: Alignment.center,\n                  children: [\n                    // Background circle/glow effect\n                    Container(\n                      width: 200,\n                      height: 200,\n                      decoration: BoxDecoration(\n                        shape: BoxShape.circle,\n                        boxShadow: [\n                          BoxShadow(\n                            color: AppColors.primary.withValues(alpha: 0.3),\n                            blurRadius: 30,\n                            spreadRadius: 10,\n                          ),\n                        ],\n                      ),\n                    ),\n                    // Logo background\n                    ClipOval(\n                      child: Image.asset(\n                        'assets/images/logo_bg.png',\n                        width: 180,\n                        height: 180,\n                        fit: BoxFit.cover,\n                        errorBuilder: (context, error, stackTrace) {\n                          return Container(\n                            width: 180,\n                            height: 180,\n                            decoration: BoxDecoration(\n                              shape: BoxShape.circle,\n                              color: AppColors.primaryContainer,\n                            ),\n                          );\n                        },\n                      ),\n                    ),\n                    // Logo rat overlay\n                    Image.asset(\n                      'assets/images/logo_rato.png',\n                      width: 140,\n                      height: 140,\n                      fit: BoxFit.contain,\n                      errorBuilder: (context, error, stackTrace) {\n                        return Icon(\n                          Icons.restaurant,\n                          size: 100,\n                          color: AppColors.primary,\n                        );\n                      },\n                    ),\n                  ],\n                ),",
  "new_string": "                // Logo with background glow effect\n                Container(\n                  decoration: BoxDecoration(\n                    boxShadow: [\n                      BoxShadow(\n                        color: AppColors.primary.withValues(alpha: 0.3),\n                        blurRadius: 30,\n                        spreadRadius: 10,\n                      ),\n                    ],\n                  ),\n                  child: Image.asset(\n                    'assets/images/logo.png',\n                    width: 200,\n                    height: 200,\n                    fit: BoxFit.contain,\n                    errorBuilder: (context, error, stackTrace) {\n                      return Container(\n                        width: 200,\n                        height: 200,\n                        decoration: BoxDecoration(\n                          shape: BoxShape.circle,\n                          color: AppColors.primaryContainer,\n                        ),\n                        child: Icon(\n                          Icons.restaurant,\n                          size: 100,\n                          color: AppColors.primary,\n                        ),\n                      );\n                    },\n                  ),\n                ),"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Explore existing codebase structure for assets and branding",
      "status": "completed",
      "activeForm": "Exploring existing codebase structure"
    },
    {
      "content": "Check source branding assets in OneDrive folder",
      "status": "completed",
      "activeForm": "Checking source branding assets"
    },
    {
      "content": "Copy and organize assets to proper directories",
      "status": "completed",
      "activeForm": "Copying and organizing assets"
    },
    {
      "content": "Update pubspec.yaml for asset declarations",
      "status": "completed",
      "activeForm": "Updating pubspec.yaml"
    },
    {
      "content": "Update splash screen with branded assets",
      "status": "completed",
      "activeForm": "Updating splash screen"
    },
    {
      "content": "Update onboarding screens with branded assets",
      "status": "in_progress",
      "activeForm": "Updating onboarding screens"
    },
    {
      "content": "Update login screen with branded assets",
      "status": "pending",
      "activeForm": "Updating login screen"
    }
  ]
}
Now let me update the onboarding page to use the branded logo. The onboarding has pages with icons - I'll update the first page (welcome page) to use the logo instead of an icon, and make the widget more flexible to support both images and icons:

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\onboarding\\presentation\\widgets\\onboarding_page_content.dart",
  "old_string": "/// Widget that displays the content for a single onboarding page\n///\n/// Shows an icon, title, description, and optional highlight text\n/// in a visually appealing layout.\nclass OnboardingPageContent extends StatelessWidget {\n  const OnboardingPageContent({\n    super.key,\n    required this.icon,\n    required this.title,\n    required this.description,\n    this.highlightText,\n  });\n\n  /// The icon to display at the top of the page\n  final IconData icon;\n\n  /// The main title text\n  final String title;\n\n  /// The description text explaining the feature\n  final String description;\n\n  /// Optional highlight text shown below the description\n  final String? highlightText;\n\n  @override\n  Widget build(BuildContext context) {\n    final theme = Theme.of(context);\n\n    return Padding(\n      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),\n      child: Column(\n        mainAxisAlignment: MainAxisAlignment.center,\n        children: [\n          // Icon with background circle\n          Container(\n            width: 140,\n            height: 140,\n            decoration: BoxDecoration(\n              shape: BoxShape.circle,\n              color: theme.colorScheme.primaryContainer,\n              boxShadow: [\n                BoxShadow(\n                  color: AppColors.primary.withValues(alpha: 0.2),\n                  blurRadius: 20,\n                  spreadRadius: 5,\n                ),\n              ],\n            ),\n            child: Icon(\n              icon,\n              size: 64,\n              color: theme.colorScheme.primary,\n            ),\n          ),",
  "new_string": "/// Widget that displays the content for a single onboarding page\n///\n/// Shows an icon or image, title, description, and optional highlight text\n/// in a visually appealing layout.\nclass OnboardingPageContent extends StatelessWidget {\n  const OnboardingPageContent({\n    super.key,\n    this.icon,\n    this.imagePath,\n    required this.title,\n    required this.description,\n    this.highlightText,\n  }) : assert(icon != null || imagePath != null, 'Either icon or imagePath must be provided');\n\n  /// The icon to display at the top of the page (optional if imagePath is provided)\n  final IconData? icon;\n\n  /// The image path to display at the top of the page (optional if icon is provided)\n  final String? imagePath;\n\n  /// The main title text\n  final String title;\n\n  /// The description text explaining the feature\n  final String description;\n\n  /// Optional highlight text shown below the description\n  final String? highlightText;\n\n  @override\n  Widget build(BuildContext context) {\n    final theme = Theme.of(context);\n\n    return Padding(\n      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),\n      child: Column(\n        mainAxisAlignment: MainAxisAlignment.center,\n        children: [\n          // Image or Icon with background\n          if (imagePath != null)\n            Container(\n              decoration: BoxDecoration(\n                boxShadow: [\n                  BoxShadow(\n                    color: AppColors.primary.withValues(alpha: 0.2),\n                    blurRadius: 20,\n                    spreadRadius: 5,\n                  ),\n                ],\n              ),\n              child: Image.asset(\n                imagePath!,\n                width: 140,\n                height: 140,\n                fit: BoxFit.contain,\n                errorBuilder: (context, error, stackTrace) {\n                  return _buildIconContainer(theme);\n                },\n              ),\n            )\n          else\n            _buildIconContainer(theme),"
}
Now I need to add the `_buildIconContainer` method at the end of the class and read the rest of the file to complete the changes:

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\onboarding\\presentation\\widgets\\onboarding_page_content.dart"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\onboarding\\presentation\\widgets\\onboarding_page_content.dart",
  "old_string": "          ],\n        ],\n      ),\n    );\n  }\n}",
  "new_string": "          ],\n        ],\n      ),\n    );\n  }\n\n  Widget _buildIconContainer(ThemeData theme) {\n    return Container(\n      width: 140,\n      height: 140,\n      decoration: BoxDecoration(\n        shape: BoxShape.circle,\n        color: theme.colorScheme.primaryContainer,\n        boxShadow: [\n          BoxShadow(\n            color: AppColors.primary.withValues(alpha: 0.2),\n            blurRadius: 20,\n            spreadRadius: 5,\n          ),\n        ],\n      ),\n      child: Icon(\n        icon ?? Icons.restaurant_menu,\n        size: 64,\n        color: theme.colorScheme.primary,\n      ),\n    );\n  }\n}"
}
Now let me update the onboarding page to use the logo on the first page:

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\onboarding\\presentation\\pages\\onboarding_page.dart",
  "old_string": "                  children: const [\n                    OnboardingPageContent(\n                      icon: Icons.restaurant_menu,\n                      title: 'Bem-vindo ao BurgerRats!',\n                      description:\n                          'Registre suas visitas a hamburguerias, avalie seus burgers favoritos e compartilhe suas experiencias com amigos.',\n                      highlightText: 'Sua jornada burger começa aqui!',\n                    ),",
  "new_string": "                  children: const [\n                    OnboardingPageContent(\n                      imagePath: 'assets/images/logo.png',\n                      title: 'Bem-vindo ao BurgerRats!',\n                      description:\n                          'Registre suas visitas a hamburguerias, avalie seus burgers favoritos e compartilhe suas experiencias com amigos.',\n                      highlightText: 'Sua jornada burger começa aqui!',\n                    ),"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Explore existing codebase structure for assets and branding",
      "status": "completed",
      "activeForm": "Exploring existing codebase structure"
    },
    {
      "content": "Check source branding assets in OneDrive folder",
      "status": "completed",
      "activeForm": "Checking source branding assets"
    },
    {
      "content": "Copy and organize assets to proper directories",
      "status": "completed",
      "activeForm": "Copying and organizing assets"
    },
    {
      "content": "Update pubspec.yaml for asset declarations",
      "status": "completed",
      "activeForm": "Updating pubspec.yaml"
    },
    {
      "content": "Update splash screen with branded assets",
      "status": "completed",
      "activeForm": "Updating splash screen"
    },
    {
      "content": "Update onboarding screens with branded assets",
      "status": "completed",
      "activeForm": "Updating onboarding screens"
    },
    {
      "content": "Update login screen with branded assets",
      "status": "in_progress",
      "activeForm": "Updating login screen"
    }
  ]
}
Now let me update the login page to use the branded logo instead of the generic restaurant icon:

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\auth\\presentation\\pages\\login_page.dart",
  "old_string": "                children: [\n                  // Logo\n                  Icon(\n                    Icons.restaurant,\n                    size: AppSpacing.xxxl,\n                    color: context.colorScheme.primary,\n                  ),\n                  AppSpacing.gapVerticalMd,\n\n                  // Title",
  "new_string": "                children: [\n                  // Logo\n                  Image.asset(\n                    'assets/images/logo.png',\n                    width: AppSpacing.xxxl,\n                    height: AppSpacing.xxxl,\n                    fit: BoxFit.contain,\n                    errorBuilder: (context, error, stackTrace) {\n                      return Icon(\n                        Icons.restaurant,\n                        size: AppSpacing.xxxl,\n                        color: context.colorScheme.primary,\n                      );\n                    },\n                  ),\n                  AppSpacing.gapVerticalMd,\n\n                  // Title"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Explore existing codebase structure for assets and branding",
      "status": "completed",
      "activeForm": "Exploring existing codebase structure"
    },
    {
      "content": "Check source branding assets in OneDrive folder",
      "status": "completed",
      "activeForm": "Checking source branding assets"
    },
    {
      "content": "Copy and organize assets to proper directories",
      "status": "completed",
      "activeForm": "Copying and organizing assets"
    },
    {
      "content": "Update pubspec.yaml for asset declarations",
      "status": "completed",
      "activeForm": "Updating pubspec.yaml"
    },
    {
      "content": "Update splash screen with branded assets",
      "status": "completed",
      "activeForm": "Updating splash screen"
    },
    {
      "content": "Update onboarding screens with branded assets",
      "status": "completed",
      "activeForm": "Updating onboarding screens"
    },
    {
      "content": "Update login screen with branded assets",
      "status": "completed",
      "activeForm": "Updating login screen"
    },
    {
      "content": "Run flutter analyze to check for errors",
      "status": "in_progress",
      "activeForm": "Running flutter analyze"
    }
  ]
}
Let me run flutter analyze to check for errors:

🔧 Tool: Bash
Input: {
  "command": "cd \"C:\\dev\\burgerrats\" && flutter analyze 2>&1 | head -100",
  "description": "Run flutter analyze to check errors",
  "timeout": 180000
}

🔧 Tool: Bash
Input: {
  "command": "cd /c/dev/burgerrats && /c/dev/flutter/bin/flutter analyze 2>&1 | head -100",
  "description": "Run flutter analyze to check errors",
  "timeout": 180000
}

🔧 Tool: Bash
Input: {
  "command": "which flutter || where flutter",
  "description": "Find flutter binary location"
}
Flutter is not in PATH. Let me try an alternate approach using PowerShell:

🔧 Tool: Bash
Input: {
  "command": "cd /c/dev/burgerrats && dart analyze 2>&1 | head -100",
  "description": "Run dart analyze to check errors",
  "timeout": 180000
}
Let me check if there are any errors by checking if the files are syntactically correct with the changed code - reading to make sure everything is in order:

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\splash\\presentation\\pages\\splash_page.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\auth\\presentation\\pages\\login_page.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\onboarding\\presentation\\widgets\\onboarding_page_content.dart"
}
The code looks correct. Let me verify the final asset structure and check the pubspec.yaml one more time:

🔧 Tool: Bash
Input: {
  "command": "ls -laR \"C:\\dev\\burgerrats\\assets\"",
  "description": "Verify final assets structure"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Explore existing codebase structure for assets and branding",
      "status": "completed",
      "activeForm": "Exploring existing codebase structure"
    },
    {
      "content": "Check source branding assets in OneDrive folder",
      "status": "completed",
      "activeForm": "Checking source branding assets"
    },
    {
      "content": "Copy and organize assets to proper directories",
      "status": "completed",
      "activeForm": "Copying and organizing assets"
    },
    {
      "content": "Update pubspec.yaml for asset declarations",
      "status": "completed",
      "activeForm": "Updating pubspec.yaml"
    },
    {
      "content": "Update splash screen with branded assets",
      "status": "completed",
      "activeForm": "Updating splash screen"
    },
    {
      "content": "Update onboarding screens with branded assets",
      "status": "completed",
      "activeForm": "Updating onboarding screens"
    },
    {
      "content": "Update login screen with branded assets",
      "status": "completed",
      "activeForm": "Updating login screen"
    },
    {
      "content": "Run flutter analyze to check for errors",
      "status": "completed",
      "activeForm": "Running flutter analyze"
    }
  ]
}
Regarding the Playwright verification requirement in the task description: This is a **Flutter mobile app** (not a web application), so Playwright cannot be used for verification since Playwright is a web browser automation tool. Playwright is designed for testing web applications in browsers (Chrome, Firefox, Safari), while this is a native mobile app built with Flutter for iOS and Android.

For Flutter apps, the appropriate testing tools would be:
- `flutter test` for unit and widget tests
- `flutter drive` or `integration_test` for integration tests
- Flutter's built-in widget testing framework

Since Flutter CLI is not available in the current PATH and this is a mobile app that requires device emulators/simulators to run, manual verification would need to be done by the developer.

<summary>
## Summary: Integrate BurgerRats branding assets

### Changes Implemented
- Copied branded logo assets from source folder to Flutter's resolution-aware assets structure
- Created density variants for proper device scaling: 1x (287KB), 2x (999KB), and 3x (2.2MB)
- Updated splash screen to use the new `logo.png` branding asset with glow effect
- Updated onboarding page to support both images and icons, using branded logo on the welcome page
- Updated login page to display the branded logo instead of a generic icon
- Updated pubspec.yaml to declare the new logo.png asset

### Files Modified
- `pubspec.yaml` - Added `assets/images/logo.png` declaration
- `lib/features/splash/presentation/pages/splash_page.dart` - Replaced logo_bg/logo_rato Stack with single branded logo.png
- `lib/features/onboarding/presentation/widgets/onboarding_page_content.dart` - Added `imagePath` parameter to support images alongside icons
- `lib/features/onboarding/presentation/pages/onboarding_page.dart` - Updated first onboarding page to use logo.png
- `lib/features/auth/presentation/pages/login_page.dart` - Replaced Icon widget with Image.asset for branded logo

### Files Added (Assets)
- `assets/images/logo.png` - 1x resolution (287KB)
- `assets/images/2.0x/logo.png` - 2x resolution (999KB)  
- `assets/images/3.0x/logo.png` - 3x resolution (2.2MB)

### Notes for Developer
- All image assets include errorBuilder fallbacks to gracefully handle loading failures
- The OnboardingPageContent widget was enhanced to accept either `icon` or `imagePath` parameters (at least one required)
- Existing `logo_bg.png` and `logo_rato.png` assets remain in the codebase if needed elsewhere
- Run `flutter pub get` after pulling changes to ensure assets are properly recognized
- The feature description mentions store icons (appstore.png 1024x1024, playstore.png 512x512) but these were not found in the source ImageSets folder - they may need to be added separately

### Verification Status
- Playwright verification is NOT applicable for this Flutter mobile app (Playwright is a web browser testing tool)
- Code was reviewed for syntax correctness and follows existing patterns
- Flutter analysis could not be run due to flutter CLI not being in PATH
- Recommend running `flutter analyze` and testing on emulator/device manually
</summary>