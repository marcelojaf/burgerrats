const fs = require('fs');
const path = require('path');

const features = [
  {
    id: 'i18n-setup-flutter-localizations',
    title: 'Setup Flutter Localizations Package',
    description: 'Configure flutter_localizations and intl packages for internationalization support',
    status: 'backlog',
    priority: 'high',
    category: 'localization',
    acceptanceCriteria: [
      'Add flutter_localizations and intl packages to pubspec.yaml',
      'Configure MaterialApp with localizationsDelegates and supportedLocales',
      'Set pt_BR as default locale and en_US as supported locale',
      'Add intl_utils configuration to pubspec.yaml for code generation'
    ],
    technicalNotes: [
      'Use flutter_localizations package from Flutter SDK',
      'Configure intl: ^0.18.0 or latest compatible version',
      'Add intl_utils for ARB file generation',
      'Update MaterialApp in main.dart with localization config'
    ],
    dependencies: [],
    estimatedEffort: 'small',
    affectedFiles: [
      'pubspec.yaml',
      'lib/main.dart'
    ]
  },
  {
    id: 'i18n-arb-files-structure',
    title: 'Create ARB Files Structure',
    description: 'Set up ARB (Application Resource Bundle) files for pt-BR and en-US translations',
    status: 'backlog',
    priority: 'high',
    category: 'localization',
    acceptanceCriteria: [
      'Create lib/l10n directory structure',
      'Create app_pt_BR.arb with all existing Portuguese strings',
      'Create app_en_US.arb with English translations',
      'Add metadata and placeholders for dynamic content',
      'Configure l10n.yaml for code generation'
    ],
    technicalNotes: [
      'ARB files should include all user-facing strings from the app',
      'Extract strings from: auth pages, league pages, check-in pages, profile pages',
      'Include error messages, validation messages, button labels, titles',
      'Add @-prefixed metadata for context and placeholders',
      'Use ICU MessageFormat for plurals and selects if needed'
    ],
    dependencies: ['i18n-setup-flutter-localizations'],
    estimatedEffort: 'large',
    affectedFiles: [
      'lib/l10n/app_pt_BR.arb',
      'lib/l10n/app_en_US.arb',
      'l10n.yaml'
    ]
  },
  {
    id: 'i18n-generate-localizations',
    title: 'Generate Localization Classes',
    description: 'Run Flutter localization generation and create AppLocalizations classes',
    status: 'backlog',
    priority: 'high',
    category: 'localization',
    acceptanceCriteria: [
      'Run flutter gen-l10n command successfully',
      'Generated AppLocalizations class available',
      'Generated AppLocalizations.of(context) helper works',
      'Verify generated files in .dart_tool/flutter_gen/gen_l10n/',
      'Add generation command to README.md'
    ],
    technicalNotes: [
      'Command: flutter gen-l10n',
      'Generated files are in .dart_tool/flutter_gen/gen_l10n/',
      'Add .dart_tool/ to .gitignore if not present',
      'Verify AppLocalizations delegate is properly configured',
      'Document generation process in project docs'
    ],
    dependencies: ['i18n-arb-files-structure'],
    estimatedEffort: 'small',
    affectedFiles: [
      '.dart_tool/flutter_gen/gen_l10n/',
      'README.md',
      '.gitignore'
    ]
  },
  {
    id: 'i18n-migrate-auth-feature',
    title: 'Migrate Auth Feature to i18n',
    description: 'Replace hardcoded Portuguese strings in auth feature with localized strings',
    status: 'backlog',
    priority: 'high',
    category: 'localization',
    acceptanceCriteria: [
      'All strings in login_page.dart use AppLocalizations',
      'All strings in register_page.dart use AppLocalizations',
      'All strings in forgot_password_page.dart use AppLocalizations',
      'All strings in email_verification_page.dart use AppLocalizations',
      'Auth error messages are localized',
      'Validation messages are localized'
    ],
    technicalNotes: [
      'Import package:flutter_gen/gen_l10n/app_localizations.dart',
      'Access strings via AppLocalizations.of(context)!.stringKey',
      'Update AuthRepository error messages to use localized strings',
      'Consider creating a helper for common validation messages',
      'Test both pt-BR and en-US locales'
    ],
    dependencies: ['i18n-generate-localizations'],
    estimatedEffort: 'medium',
    affectedFiles: [
      'lib/features/auth/presentation/pages/login_page.dart',
      'lib/features/auth/presentation/pages/register_page.dart',
      'lib/features/auth/presentation/pages/forgot_password_page.dart',
      'lib/features/auth/presentation/pages/email_verification_page.dart',
      'lib/features/auth/data/repositories/auth_repository_impl.dart'
    ]
  },
  {
    id: 'i18n-migrate-leagues-feature',
    title: 'Migrate Leagues Feature to i18n',
    description: 'Replace hardcoded Portuguese strings in leagues feature with localized strings',
    status: 'backlog',
    priority: 'high',
    category: 'localization',
    acceptanceCriteria: [
      'All strings in leagues_page.dart use AppLocalizations',
      'All strings in league_details_page.dart use AppLocalizations',
      'All strings in league_settings_page.dart use AppLocalizations',
      'League creation/join dialogs are localized',
      'Error messages and validations are localized',
      'Leaderboard screen strings are localized'
    ],
    technicalNotes: [
      'Pay attention to dynamic content (league names, member counts, etc)',
      'Use ICU MessageFormat for plurals (e.g., "1 member" vs "2 members")',
      'Localize invite code generation messages',
      'Update LeagueRepository error messages',
      'Test both pt-BR and en-US locales'
    ],
    dependencies: ['i18n-generate-localizations'],
    estimatedEffort: 'large',
    affectedFiles: [
      'lib/features/leagues/presentation/pages/leagues_page.dart',
      'lib/features/leagues/presentation/pages/league_details_page.dart',
      'lib/features/leagues/presentation/pages/league_settings_page.dart',
      'lib/features/leagues/presentation/providers/*.dart',
      'lib/features/leagues/data/repositories/league_repository_impl.dart'
    ]
  },
  {
    id: 'i18n-migrate-checkins-feature',
    title: 'Migrate Check-ins Feature to i18n',
    description: 'Replace hardcoded Portuguese strings in check-ins feature with localized strings',
    status: 'backlog',
    priority: 'high',
    category: 'localization',
    acceptanceCriteria: [
      'All strings in check_ins_page.dart use AppLocalizations',
      'All strings in create_check_in_page.dart use AppLocalizations',
      'All strings in check_in_details_page.dart use AppLocalizations',
      'Check-in validation messages are localized',
      'Photo upload messages are localized',
      'Date/time formatting respects locale'
    ],
    technicalNotes: [
      'Use intl DateFormat for date/time localization',
      'Localize camera/gallery permission messages',
      'Update CheckInRepository error messages',
      'Consider localization for relative time ("2 hours ago")',
      'Test both pt-BR and en-US locales'
    ],
    dependencies: ['i18n-generate-localizations'],
    estimatedEffort: 'medium',
    affectedFiles: [
      'lib/features/check_ins/presentation/pages/check_ins_page.dart',
      'lib/features/check_ins/presentation/pages/create_check_in_page.dart',
      'lib/features/check_ins/presentation/pages/check_in_details_page.dart',
      'lib/features/check_ins/presentation/providers/*.dart',
      'lib/features/check_ins/data/repositories/check_in_repository_impl.dart'
    ]
  },
  {
    id: 'i18n-migrate-profile-feature',
    title: 'Migrate Profile Feature to i18n',
    description: 'Replace hardcoded Portuguese strings in profile feature with localized strings',
    status: 'backlog',
    priority: 'medium',
    category: 'localization',
    acceptanceCriteria: [
      'All strings in profile_page.dart use AppLocalizations',
      'All strings in edit_profile_page.dart use AppLocalizations',
      'All strings in settings_page.dart use AppLocalizations',
      'Profile validation messages are localized',
      'Settings options are localized'
    ],
    technicalNotes: [
      'Localize profile field labels and placeholders',
      'Update profile update success/error messages',
      'Consider adding language selector in settings',
      'Test both pt-BR and en-US locales'
    ],
    dependencies: ['i18n-generate-localizations'],
    estimatedEffort: 'medium',
    affectedFiles: [
      'lib/features/profile/presentation/pages/profile_page.dart',
      'lib/features/profile/presentation/pages/edit_profile_page.dart',
      'lib/features/profile/presentation/pages/settings_page.dart'
    ]
  },
  {
    id: 'i18n-migrate-shared-widgets',
    title: 'Migrate Shared Widgets to i18n',
    description: 'Replace hardcoded Portuguese strings in shared widgets and components',
    status: 'backlog',
    priority: 'medium',
    category: 'localization',
    acceptanceCriteria: [
      'All strings in shared widgets use AppLocalizations',
      'Error dialog messages are localized',
      'Loading indicators text is localized',
      'Common button labels are localized',
      'Empty state messages are localized'
    ],
    technicalNotes: [
      'Review all widgets in lib/shared/widgets/',
      'Localize generic error messages',
      'Consider creating reusable localized widgets',
      'Test both pt-BR and en-US locales'
    ],
    dependencies: ['i18n-generate-localizations'],
    estimatedEffort: 'small',
    affectedFiles: [
      'lib/shared/widgets/*.dart'
    ]
  },
  {
    id: 'i18n-locale-switcher-service',
    title: 'Create Locale Switcher Service',
    description: 'Implement service to allow users to change app language at runtime',
    status: 'backlog',
    priority: 'medium',
    category: 'localization',
    acceptanceCriteria: [
      'Create LocaleService with @LazySingleton annotation',
      'Implement methods to get/set current locale',
      'Persist locale preference using SharedPreferences',
      'Create Riverpod provider for locale state',
      'Integrate with MaterialApp.locale',
      'Add language switcher UI in settings page'
    ],
    technicalNotes: [
      'Store locale preference as language code (pt, en)',
      'Default to system locale if no preference set',
      'Use shared_preferences for persistence',
      'Create localeProvider in core/state/providers/',
      'Update MaterialApp in main.dart to use localeProvider',
      'Add language selection dropdown in settings'
    ],
    dependencies: ['i18n-migrate-profile-feature'],
    estimatedEffort: 'medium',
    affectedFiles: [
      'lib/core/services/locale_service.dart',
      'lib/core/state/providers/locale_provider.dart',
      'lib/main.dart',
      'lib/features/profile/presentation/pages/settings_page.dart',
      'pubspec.yaml'
    ]
  },
  {
    id: 'i18n-notification-messages',
    title: 'Localize Notification Messages',
    description: 'Ensure FCM notification messages support multiple languages',
    status: 'backlog',
    priority: 'low',
    category: 'localization',
    acceptanceCriteria: [
      'Check-in reminder notifications use user locale',
      'League invitation notifications use user locale',
      'Activity notifications use user locale',
      'Store user locale preference in Firestore',
      'Cloud Functions send notifications in user preferred language'
    ],
    technicalNotes: [
      'Add locale field to user document in Firestore',
      'Update NotificationService to include locale info',
      'Consider implementing notification templates per locale',
      'May require Firebase Cloud Functions updates',
      'Test notifications in both pt-BR and en-US'
    ],
    dependencies: ['i18n-locale-switcher-service'],
    estimatedEffort: 'medium',
    affectedFiles: [
      'lib/core/services/notification_service.dart',
      'lib/core/services/check_in_notification_service.dart',
      'lib/core/services/reminder_scheduler_service.dart'
    ]
  },
  {
    id: 'i18n-testing-coverage',
    title: 'Add i18n Testing Coverage',
    description: 'Create tests to ensure localization works correctly across the app',
    status: 'backlog',
    priority: 'low',
    category: 'localization',
    acceptanceCriteria: [
      'Unit tests for LocaleService',
      'Widget tests verify strings are not hardcoded',
      'Test locale switching functionality',
      'Test ARB files have matching keys',
      'Test pluralization and ICU MessageFormat',
      'Document localization testing approach'
    ],
    technicalNotes: [
      'Use flutter_test package with localization support',
      'Mock AppLocalizations in widget tests',
      'Create helper to verify all ARB keys match',
      'Test edge cases (missing translations, null contexts)',
      'Add CI check to validate ARB files'
    ],
    dependencies: ['i18n-locale-switcher-service'],
    estimatedEffort: 'medium',
    affectedFiles: [
      'test/core/services/locale_service_test.dart',
      'test/l10n/arb_validation_test.dart',
      'test/features/*/presentation/pages/*_test.dart'
    ]
  }
];

const featuresDir = path.join(__dirname, '..', 'features');

features.forEach(feature => {
  const featureDir = path.join(featuresDir, feature.id);
  if (!fs.existsSync(featureDir)) {
    fs.mkdirSync(featureDir, { recursive: true });
  }

  const featureFile = path.join(featureDir, 'feature.json');
  fs.writeFileSync(featureFile, JSON.stringify(feature, null, 2));
});

console.log('✅ Created ' + features.length + ' localization features successfully');
