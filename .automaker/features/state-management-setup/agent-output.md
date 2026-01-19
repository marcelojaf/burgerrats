
🔧 Tool: Task
Input: {
  "subagent_type": "Explore",
  "prompt": "Explore this Flutter codebase to understand:\n1. The overall project structure\n2. Any existing state management setup (look for riverpod, provider, bloc, or similar)\n3. The dependency injection setup in lib/core/di/\n4. How features are organized\n5. The pubspec.yaml to see current dependencies\n\nFocus on understanding the patterns used so I can implement Riverpod state management appropriately.",
  "description": "Explore codebase structure"
}

🔧 Tool: Bash
Input: {
  "command": "find /Users/marcelo/dev/burgerrats -type f -name \"*.dart\" | head -20",
  "description": "List dart files to understand project structure"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/pubspec.yaml"
}

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/lib/",
  "description": "List lib directory structure"
}

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/lib/core/",
  "description": "List core directory structure"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/di/injection.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/di/register_module.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/main.dart"
}

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/lib/features/",
  "description": "List features directory"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/features.dart"
}

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/lib/features/auth/",
  "description": "List auth feature structure"
}

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/lib/features/home/",
  "description": "List home feature structure"
}

🔧 Tool: Bash
Input: {
  "command": "find /Users/marcelo/dev/burgerrats/lib/core/services -type f -name \"*.dart\"",
  "description": "Find all service files"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/services/app_service.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/services/permission_service.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/services/photo_capture_service.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/core.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/di/injection.config.dart",
  "limit": 100
}

🔧 Tool: Bash
Input: {
  "command": "find /Users/marcelo/dev/burgerrats/lib/features -type f -name \"*.dart\" | head -30",
  "description": "Find dart files in features directory"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/router/router.dart",
  "limit": 150
}

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/lib/features/auth/presentation/",
  "description": "List auth presentation structure"
}

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/lib/features/home/presentation/",
  "description": "List home presentation structure"
}

🔧 Tool: Bash
Input: {
  "command": "find /Users/marcelo/dev/burgerrats/lib/core/router -type f -name \"*.dart\" | xargs ls -lah",
  "description": "List router files"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/home/presentation/pages/home_page.dart",
  "limit": 100
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/presentation/pages/login_page.dart",
  "limit": 100
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/splash/presentation/pages/splash_page.dart",
  "limit": 100
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/router/app_router.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/router/app_routes.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/errors/exceptions.dart",
  "limit": 80
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/data/repositories/auth_repository_impl.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/domain/repositories/auth_repository.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/auth.dart"
}

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/lib/shared/",
  "description": "List shared directory"
}

🔧 Tool: Bash
Input: {
  "command": "find /Users/marcelo/dev/burgerrats/lib/shared -type f -name \"*.dart\"",
  "description": "Find dart files in shared"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/shared/widgets/widgets.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/shared/shared.dart"
}

🔧 Tool: Bash
Input: {
  "command": "tree -L 2 /Users/marcelo/dev/burgerrats/lib/ -d -I '__pycache__'",
  "description": "Show directory tree of lib structure"
}

🔧 Tool: Bash
Input: {
  "command": "find /Users/marcelo/dev/burgerrats/lib -type d -not -path '*/\\.*' | sort",
  "description": "Show all directories in lib"
}

🔧 Tool: Bash
Input: {
  "command": "wc -l /Users/marcelo/dev/burgerrats/pubspec.yaml",
  "description": "Check pubspec size"
}
Now let me read the key files to understand the exact implementation details before planning my approach:

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/pubspec.yaml"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/main.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/di/injection.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/core.dart"
}
Let me also check the existing features and services to understand the patterns better:

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/domain/repositories/auth_repository.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/services/permission_service.dart"
}

🔧 Tool: Glob
Input: {
  "pattern": "lib/features/**/*.dart"
}
Now let me check a page to understand the current UI patterns:

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/presentation/pages/login_page.dart"
}
Now I have a complete understanding of the codebase. Let me create a todo list and implement Riverpod state management:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Add Riverpod dependencies to pubspec.yaml",
      "status": "in_progress",
      "activeForm": "Adding Riverpod dependencies"
    },
    {
      "content": "Create base state management infrastructure",
      "status": "pending",
      "activeForm": "Creating state management infrastructure"
    },
    {
      "content": "Create auth state provider with Firebase integration",
      "status": "pending",
      "activeForm": "Creating auth state provider"
    },
    {
      "content": "Create common state patterns (loading, async)",
      "status": "pending",
      "activeForm": "Creating common state patterns"
    },
    {
      "content": "Wrap app with ProviderScope in main.dart",
      "status": "pending",
      "activeForm": "Wrapping app with ProviderScope"
    },
    {
      "content": "Update core barrel exports",
      "status": "pending",
      "activeForm": "Updating core barrel exports"
    },
    {
      "content": "Run flutter pub get to install dependencies",
      "status": "pending",
      "activeForm": "Installing dependencies"
    },
    {
      "content": "Verify implementation by running build",
      "status": "pending",
      "activeForm": "Verifying implementation"
    }
  ]
}

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/pubspec.yaml",
  "old_string": "  # Dependency Injection - Service locator pattern\n  get_it: ^8.0.3\n  injectable: ^2.5.0",
  "new_string": "  # Dependency Injection - Service locator pattern\n  get_it: ^8.0.3\n  injectable: ^2.5.0\n\n  # State Management - Riverpod\n  flutter_riverpod: ^2.6.1\n  riverpod_annotation: ^2.6.1"
}

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/pubspec.yaml",
  "old_string": "  # Code generation for injectable\n  build_runner: ^2.4.15\n  injectable_generator: ^2.6.3",
  "new_string": "  # Code generation for injectable and riverpod\n  build_runner: ^2.4.15\n  injectable_generator: ^2.6.3\n  riverpod_generator: ^2.6.3\n  custom_lint: ^0.7.0\n  riverpod_lint: ^2.6.3"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Add Riverpod dependencies to pubspec.yaml",
      "status": "completed",
      "activeForm": "Adding Riverpod dependencies"
    },
    {
      "content": "Create base state management infrastructure",
      "status": "in_progress",
      "activeForm": "Creating state management infrastructure"
    },
    {
      "content": "Create auth state provider with Firebase integration",
      "status": "pending",
      "activeForm": "Creating auth state provider"
    },
    {
      "content": "Create common state patterns (loading, async)",
      "status": "pending",
      "activeForm": "Creating common state patterns"
    },
    {
      "content": "Wrap app with ProviderScope in main.dart",
      "status": "pending",
      "activeForm": "Wrapping app with ProviderScope"
    },
    {
      "content": "Update core barrel exports",
      "status": "pending",
      "activeForm": "Updating core barrel exports"
    },
    {
      "content": "Run flutter pub get to install dependencies",
      "status": "pending",
      "activeForm": "Installing dependencies"
    },
    {
      "content": "Verify implementation by running build",
      "status": "pending",
      "activeForm": "Verifying implementation"
    }
  ]
}
Now let me create the state management infrastructure. First, I'll create the directory structure and base files:

🔧 Tool: Bash
Input: {
  "command": "mkdir -p /Users/marcelo/dev/burgerrats/lib/core/state",
  "description": "Create state directory"
}

🔧 Tool: Write
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/state/state.dart",
  "content": "// State management barrel export\n//\n// This module provides Riverpod-based state management for the BurgerRats app.\n// It includes base notifiers, common state patterns, and provider utilities.\n\nexport 'base_state.dart';\nexport 'base_notifier.dart';\nexport 'providers/auth_state_provider.dart';\nexport 'providers/app_state_provider.dart';\n"
}

🔧 Tool: Write
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/state/base_state.dart",
  "content": "import 'package:flutter/foundation.dart';\n\n/// Base class for all feature states in the application.\n///\n/// Provides common state patterns like loading, error handling, and data.\n/// Use [AsyncState] for async operations or extend this for custom states.\n@immutable\nabstract class BaseState {\n  const BaseState();\n}\n\n/// Represents the status of an async operation\nenum AsyncStatus {\n  /// Initial state, no operation started\n  initial,\n\n  /// Operation is in progress\n  loading,\n\n  /// Operation completed successfully\n  success,\n\n  /// Operation failed with an error\n  error,\n}\n\n/// Generic state class for async operations with data\n///\n/// This is a simpler alternative to Riverpod's AsyncValue when you need\n/// more control over the state transitions or want to preserve previous\n/// data during loading states.\n///\n/// Example usage:\n/// ```dart\n/// class MyNotifier extends StateNotifier<AsyncState<List<Item>>> {\n///   MyNotifier() : super(const AsyncState.initial());\n///\n///   Future<void> loadItems() async {\n///     state = state.copyWith(status: AsyncStatus.loading);\n///     try {\n///       final items = await repository.getItems();\n///       state = AsyncState.success(items);\n///     } catch (e) {\n///       state = AsyncState.error(e.toString());\n///     }\n///   }\n/// }\n/// ```\n@immutable\nclass AsyncState<T> extends BaseState {\n  /// The current status of the async operation\n  final AsyncStatus status;\n\n  /// The data, if available\n  final T? data;\n\n  /// The error message, if any\n  final String? errorMessage;\n\n  /// The original error object, if any\n  final Object? error;\n\n  const AsyncState._({\n    required this.status,\n    this.data,\n    this.errorMessage,\n    this.error,\n  });\n\n  /// Creates an initial state with no data\n  const AsyncState.initial()\n      : status = AsyncStatus.initial,\n        data = null,\n        errorMessage = null,\n        error = null;\n\n  /// Creates a loading state, optionally preserving previous data\n  const AsyncState.loading([T? previousData])\n      : status = AsyncStatus.loading,\n        data = previousData,\n        errorMessage = null,\n        error = null;\n\n  /// Creates a success state with data\n  const AsyncState.success(T this.data)\n      : status = AsyncStatus.success,\n        errorMessage = null,\n        error = null;\n\n  /// Creates an error state with message and optional error object\n  const AsyncState.error(this.errorMessage, [this.error])\n      : status = AsyncStatus.error,\n        data = null;\n\n  /// Whether the state is in initial status\n  bool get isInitial => status == AsyncStatus.initial;\n\n  /// Whether the state is loading\n  bool get isLoading => status == AsyncStatus.loading;\n\n  /// Whether the state completed successfully\n  bool get isSuccess => status == AsyncStatus.success;\n\n  /// Whether the state has an error\n  bool get isError => status == AsyncStatus.error;\n\n  /// Whether data is available (could be from previous successful load)\n  bool get hasData => data != null;\n\n  /// Whether an error message is available\n  bool get hasError => errorMessage != null;\n\n  /// Creates a copy of this state with the given fields replaced\n  AsyncState<T> copyWith({\n    AsyncStatus? status,\n    T? data,\n    String? errorMessage,\n    Object? error,\n  }) {\n    return AsyncState._(\n      status: status ?? this.status,\n      data: data ?? this.data,\n      errorMessage: errorMessage ?? this.errorMessage,\n      error: error ?? this.error,\n    );\n  }\n\n  /// Pattern matching helper for handling different states\n  ///\n  /// Example:\n  /// ```dart\n  /// state.when(\n  ///   initial: () => Text('Ready to load'),\n  ///   loading: () => CircularProgressIndicator(),\n  ///   success: (data) => Text('Got: $data'),\n  ///   error: (message) => Text('Error: $message'),\n  /// )\n  /// ```\n  R when<R>({\n    required R Function() initial,\n    required R Function() loading,\n    required R Function(T data) success,\n    required R Function(String? message) error,\n  }) {\n    switch (status) {\n      case AsyncStatus.initial:\n        return initial();\n      case AsyncStatus.loading:\n        return loading();\n      case AsyncStatus.success:\n        return success(data as T);\n      case AsyncStatus.error:\n        return error(errorMessage);\n    }\n  }\n\n  /// Pattern matching helper with optional handlers\n  ///\n  /// Returns [orElse] for unhandled states\n  R maybeWhen<R>({\n    R Function()? initial,\n    R Function()? loading,\n    R Function(T data)? success,\n    R Function(String? message)? error,\n    required R Function() orElse,\n  }) {\n    switch (status) {\n      case AsyncStatus.initial:\n        return initial?.call() ?? orElse();\n      case AsyncStatus.loading:\n        return loading?.call() ?? orElse();\n      case AsyncStatus.success:\n        return success?.call(data as T) ?? orElse();\n      case AsyncStatus.error:\n        return error?.call(errorMessage) ?? orElse();\n    }\n  }\n\n  @override\n  bool operator ==(Object other) {\n    if (identical(this, other)) return true;\n    return other is AsyncState<T> &&\n        other.status == status &&\n        other.data == data &&\n        other.errorMessage == errorMessage;\n  }\n\n  @override\n  int get hashCode => Object.hash(status, data, errorMessage);\n\n  @override\n  String toString() {\n    return 'AsyncState(status: $status, data: $data, errorMessage: $errorMessage)';\n  }\n}\n\n/// State for paginated data\n///\n/// Useful for infinite scrolling lists or paginated API responses.\n@immutable\nclass PaginatedState<T> extends BaseState {\n  /// The list of items loaded so far\n  final List<T> items;\n\n  /// Whether initial loading is in progress\n  final bool isLoading;\n\n  /// Whether more items are being loaded\n  final bool isLoadingMore;\n\n  /// Whether there are more items to load\n  final bool hasMore;\n\n  /// Current page number (0-indexed)\n  final int currentPage;\n\n  /// Error message if any\n  final String? errorMessage;\n\n  const PaginatedState({\n    this.items = const [],\n    this.isLoading = false,\n    this.isLoadingMore = false,\n    this.hasMore = true,\n    this.currentPage = 0,\n    this.errorMessage,\n  });\n\n  /// Initial empty state\n  const PaginatedState.initial()\n      : items = const [],\n        isLoading = false,\n        isLoadingMore = false,\n        hasMore = true,\n        currentPage = 0,\n        errorMessage = null;\n\n  /// Whether the list is empty and not loading\n  bool get isEmpty => items.isEmpty && !isLoading;\n\n  /// Whether this is the first load\n  bool get isFirstLoad => items.isEmpty && isLoading;\n\n  /// Creates a copy with updated fields\n  PaginatedState<T> copyWith({\n    List<T>? items,\n    bool? isLoading,\n    bool? isLoadingMore,\n    bool? hasMore,\n    int? currentPage,\n    String? errorMessage,\n  }) {\n    return PaginatedState(\n      items: items ?? this.items,\n      isLoading: isLoading ?? this.isLoading,\n      isLoadingMore: isLoadingMore ?? this.isLoadingMore,\n      hasMore: hasMore ?? this.hasMore,\n      currentPage: currentPage ?? this.currentPage,\n      errorMessage: errorMessage,\n    );\n  }\n\n  @override\n  bool operator ==(Object other) {\n    if (identical(this, other)) return true;\n    return other is PaginatedState<T> &&\n        listEquals(other.items, items) &&\n        other.isLoading == isLoading &&\n        other.isLoadingMore == isLoadingMore &&\n        other.hasMore == hasMore &&\n        other.currentPage == currentPage &&\n        other.errorMessage == errorMessage;\n  }\n\n  @override\n  int get hashCode => Object.hash(\n        Object.hashAll(items),\n        isLoading,\n        isLoadingMore,\n        hasMore,\n        currentPage,\n        errorMessage,\n      );\n}\n\n/// State for form handling\n///\n/// Tracks form submission status and validation errors.\n@immutable\nclass FormState extends BaseState {\n  /// Whether the form is currently submitting\n  final bool isSubmitting;\n\n  /// Whether the form was submitted successfully\n  final bool isSuccess;\n\n  /// Validation errors by field name\n  final Map<String, String> fieldErrors;\n\n  /// General form error message\n  final String? errorMessage;\n\n  const FormState({\n    this.isSubmitting = false,\n    this.isSuccess = false,\n    this.fieldErrors = const {},\n    this.errorMessage,\n  });\n\n  /// Initial form state\n  const FormState.initial()\n      : isSubmitting = false,\n        isSuccess = false,\n        fieldErrors = const {},\n        errorMessage = null;\n\n  /// Whether the form has any validation errors\n  bool get hasErrors => fieldErrors.isNotEmpty || errorMessage != null;\n\n  /// Gets the error for a specific field\n  String? errorFor(String field) => fieldErrors[field];\n\n  /// Creates a copy with updated fields\n  FormState copyWith({\n    bool? isSubmitting,\n    bool? isSuccess,\n    Map<String, String>? fieldErrors,\n    String? errorMessage,\n  }) {\n    return FormState(\n      isSubmitting: isSubmitting ?? this.isSubmitting,\n      isSuccess: isSuccess ?? this.isSuccess,\n      fieldErrors: fieldErrors ?? this.fieldErrors,\n      errorMessage: errorMessage,\n    );\n  }\n\n  @override\n  bool operator ==(Object other) {\n    if (identical(this, other)) return true;\n    return other is FormState &&\n        other.isSubmitting == isSubmitting &&\n        other.isSuccess == isSuccess &&\n        mapEquals(other.fieldErrors, fieldErrors) &&\n        other.errorMessage == errorMessage;\n  }\n\n  @override\n  int get hashCode => Object.hash(\n        isSubmitting,\n        isSuccess,\n        Object.hashAll(fieldErrors.entries),\n        errorMessage,\n      );\n}\n"
}

🔧 Tool: Write
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/state/base_notifier.dart",
  "content": "import 'package:flutter_riverpod/flutter_riverpod.dart';\n\nimport 'base_state.dart';\n\n/// Base class for async notifiers that work with [AsyncState].\n///\n/// Provides common patterns for loading, success, and error handling.\n/// Extend this class for feature-specific notifiers.\n///\n/// Example:\n/// ```dart\n/// class ItemsNotifier extends BaseAsyncNotifier<List<Item>> {\n///   final ItemRepository _repository;\n///\n///   ItemsNotifier(this._repository);\n///\n///   Future<void> loadItems() => execute(() => _repository.getItems());\n/// }\n/// ```\nabstract class BaseAsyncNotifier<T> extends StateNotifier<AsyncState<T>> {\n  BaseAsyncNotifier() : super(const AsyncState.initial());\n\n  /// Executes an async operation with automatic state management.\n  ///\n  /// Sets loading state, executes the operation, and updates to success or error.\n  /// Optionally preserves previous data during loading with [preserveData].\n  Future<void> execute(\n    Future<T> Function() operation, {\n    bool preserveData = false,\n  }) async {\n    state = preserveData && state.hasData\n        ? AsyncState.loading(state.data)\n        : const AsyncState.loading();\n\n    try {\n      final result = await operation();\n      state = AsyncState.success(result);\n    } catch (e, stackTrace) {\n      _handleError(e, stackTrace);\n    }\n  }\n\n  /// Executes an async operation that doesn't return data.\n  ///\n  /// Useful for operations like delete, update where you don't need to\n  /// update the state data but want to track loading/error states.\n  Future<bool> executeAction(Future<void> Function() action) async {\n    final previousData = state.data;\n    state = AsyncState.loading(previousData);\n\n    try {\n      await action();\n      if (previousData != null) {\n        state = AsyncState.success(previousData);\n      } else {\n        state = const AsyncState.initial();\n      }\n      return true;\n    } catch (e, stackTrace) {\n      _handleError(e, stackTrace);\n      return false;\n    }\n  }\n\n  /// Resets the state to initial\n  void reset() {\n    state = const AsyncState.initial();\n  }\n\n  /// Sets an error state manually\n  void setError(String message, [Object? error]) {\n    state = AsyncState.error(message, error);\n  }\n\n  /// Sets data directly without going through loading state\n  void setData(T data) {\n    state = AsyncState.success(data);\n  }\n\n  /// Handles errors by setting error state\n  ///\n  /// Override this method to customize error handling (e.g., logging)\n  void _handleError(Object error, StackTrace stackTrace) {\n    final message = _extractErrorMessage(error);\n    state = AsyncState.error(message, error);\n  }\n\n  /// Extracts a user-friendly error message from an error object\n  ///\n  /// Override this to customize error message extraction\n  String _extractErrorMessage(Object error) {\n    return error.toString();\n  }\n}\n\n/// Base class for paginated data notifiers.\n///\n/// Provides common patterns for loading paginated data with infinite scrolling.\n///\n/// Example:\n/// ```dart\n/// class ItemsListNotifier extends BasePaginatedNotifier<Item> {\n///   final ItemRepository _repository;\n///\n///   ItemsListNotifier(this._repository);\n///\n///   @override\n///   Future<List<Item>> fetchPage(int page) => _repository.getItems(page: page);\n/// }\n/// ```\nabstract class BasePaginatedNotifier<T>\n    extends StateNotifier<PaginatedState<T>> {\n  BasePaginatedNotifier() : super(const PaginatedState.initial());\n\n  /// Override to implement page fetching logic\n  ///\n  /// [page] is 0-indexed\n  Future<List<T>> fetchPage(int page);\n\n  /// Number of items per page\n  int get pageSize => 20;\n\n  /// Loads the first page of data\n  Future<void> loadInitial() async {\n    if (state.isLoading) return;\n\n    state = state.copyWith(\n      isLoading: true,\n      errorMessage: null,\n    );\n\n    try {\n      final items = await fetchPage(0);\n      state = PaginatedState(\n        items: items,\n        isLoading: false,\n        hasMore: items.length >= pageSize,\n        currentPage: 0,\n      );\n    } catch (e) {\n      state = state.copyWith(\n        isLoading: false,\n        errorMessage: e.toString(),\n      );\n    }\n  }\n\n  /// Loads the next page of data\n  Future<void> loadMore() async {\n    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;\n\n    state = state.copyWith(isLoadingMore: true);\n\n    try {\n      final nextPage = state.currentPage + 1;\n      final newItems = await fetchPage(nextPage);\n\n      state = state.copyWith(\n        items: [...state.items, ...newItems],\n        isLoadingMore: false,\n        hasMore: newItems.length >= pageSize,\n        currentPage: nextPage,\n      );\n    } catch (e) {\n      state = state.copyWith(\n        isLoadingMore: false,\n        errorMessage: e.toString(),\n      );\n    }\n  }\n\n  /// Refreshes the list by reloading from the first page\n  Future<void> refresh() async {\n    state = const PaginatedState.initial();\n    await loadInitial();\n  }\n\n  /// Adds an item to the beginning of the list\n  void addItem(T item) {\n    state = state.copyWith(items: [item, ...state.items]);\n  }\n\n  /// Removes an item from the list\n  void removeItem(T item) {\n    state = state.copyWith(\n      items: state.items.where((i) => i != item).toList(),\n    );\n  }\n\n  /// Updates an item in the list\n  void updateItem(T oldItem, T newItem) {\n    final index = state.items.indexOf(oldItem);\n    if (index != -1) {\n      final newItems = List<T>.from(state.items);\n      newItems[index] = newItem;\n      state = state.copyWith(items: newItems);\n    }\n  }\n}\n\n/// Mixin for notifiers that need to track form submission state.\n///\n/// Use with [StateNotifier] to add form handling capabilities.\nmixin FormNotifierMixin<T> on StateNotifier<T> {\n  bool _isSubmitting = false;\n  String? _errorMessage;\n  final Map<String, String> _fieldErrors = {};\n\n  bool get isSubmitting => _isSubmitting;\n  String? get errorMessage => _errorMessage;\n  Map<String, String> get fieldErrors => Map.unmodifiable(_fieldErrors);\n\n  /// Sets the submitting state\n  void setSubmitting(bool value) {\n    _isSubmitting = value;\n    // Trigger rebuild - subclass should call notifyListeners or update state\n  }\n\n  /// Sets a field-specific error\n  void setFieldError(String field, String error) {\n    _fieldErrors[field] = error;\n  }\n\n  /// Clears a field-specific error\n  void clearFieldError(String field) {\n    _fieldErrors.remove(field);\n  }\n\n  /// Sets a general error message\n  void setErrorMessage(String? message) {\n    _errorMessage = message;\n  }\n\n  /// Clears all errors\n  void clearErrors() {\n    _fieldErrors.clear();\n    _errorMessage = null;\n  }\n\n  /// Validates that a field is not empty\n  bool validateRequired(String field, String? value, {String? message}) {\n    if (value == null || value.trim().isEmpty) {\n      setFieldError(field, message ?? 'Este campo e obrigatorio');\n      return false;\n    }\n    clearFieldError(field);\n    return true;\n  }\n\n  /// Validates email format\n  bool validateEmail(String field, String? value, {String? message}) {\n    if (value == null || value.trim().isEmpty) {\n      setFieldError(field, message ?? 'Email e obrigatorio');\n      return false;\n    }\n\n    final emailRegex = RegExp(r'^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$');\n    if (!emailRegex.hasMatch(value)) {\n      setFieldError(field, message ?? 'Email invalido');\n      return false;\n    }\n\n    clearFieldError(field);\n    return true;\n  }\n\n  /// Validates minimum length\n  bool validateMinLength(\n    String field,\n    String? value,\n    int minLength, {\n    String? message,\n  }) {\n    if (value == null || value.length < minLength) {\n      setFieldError(\n        field,\n        message ?? 'Minimo de $minLength caracteres',\n      );\n      return false;\n    }\n    clearFieldError(field);\n    return true;\n  }\n}\n"
}
Now let me create the providers directory and auth state provider:

🔧 Tool: Bash
Input: {
  "command": "mkdir -p /Users/marcelo/dev/burgerrats/lib/core/state/providers",
  "description": "Create providers directory"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Add Riverpod dependencies to pubspec.yaml",
      "status": "completed",
      "activeForm": "Adding Riverpod dependencies"
    },
    {
      "content": "Create base state management infrastructure",
      "status": "completed",
      "activeForm": "Creating state management infrastructure"
    },
    {
      "content": "Create auth state provider with Firebase integration",
      "status": "in_progress",
      "activeForm": "Creating auth state provider"
    },
    {
      "content": "Create common state patterns (loading, async)",
      "status": "completed",
      "activeForm": "Creating common state patterns"
    },
    {
      "content": "Wrap app with ProviderScope in main.dart",
      "status": "pending",
      "activeForm": "Wrapping app with ProviderScope"
    },
    {
      "content": "Update core barrel exports",
      "status": "pending",
      "activeForm": "Updating core barrel exports"
    },
    {
      "content": "Run flutter pub get to install dependencies",
      "status": "pending",
      "activeForm": "Installing dependencies"
    },
    {
      "content": "Verify implementation by running build",
      "status": "pending",
      "activeForm": "Verifying implementation"
    }
  ]
}

🔧 Tool: Write
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/state/providers/auth_state_provider.dart",
  "content": "import 'dart:async';\n\nimport 'package:firebase_auth/firebase_auth.dart';\nimport 'package:flutter_riverpod/flutter_riverpod.dart';\n\nimport '../../di/injection.dart';\nimport '../../../features/auth/domain/repositories/auth_repository.dart';\n\n/// Provides the Firebase Auth instance\nfinal firebaseAuthProvider = Provider<FirebaseAuth>((ref) {\n  return FirebaseAuth.instance;\n});\n\n/// Provides the AuthRepository instance from GetIt\nfinal authRepositoryProvider = Provider<AuthRepository>((ref) {\n  return getIt<AuthRepository>();\n});\n\n/// Stream provider for authentication state changes\n///\n/// This provider exposes the Firebase auth state as a stream,\n/// automatically updating when the user logs in or out.\n///\n/// Usage:\n/// ```dart\n/// final authState = ref.watch(authStateProvider);\n/// authState.when(\n///   data: (user) => user != null ? HomePage() : LoginPage(),\n///   loading: () => SplashPage(),\n///   error: (e, st) => ErrorPage(),\n/// );\n/// ```\nfinal authStateProvider = StreamProvider<User?>((ref) {\n  final auth = ref.watch(firebaseAuthProvider);\n  return auth.authStateChanges();\n});\n\n/// Provider for the current user (nullable)\n///\n/// Returns the currently authenticated user or null if not logged in.\n/// This is a synchronous snapshot - use [authStateProvider] for reactive updates.\nfinal currentUserProvider = Provider<User?>((ref) {\n  final authState = ref.watch(authStateProvider);\n  return authState.valueOrNull;\n});\n\n/// Provider to check if user is authenticated\n///\n/// Returns true if there is a currently authenticated user.\nfinal isAuthenticatedProvider = Provider<bool>((ref) {\n  final user = ref.watch(currentUserProvider);\n  return user != null;\n});\n\n/// Authentication state for UI\nenum AuthStatus {\n  /// Initial state, checking authentication\n  initial,\n\n  /// User is authenticated\n  authenticated,\n\n  /// User is not authenticated\n  unauthenticated,\n\n  /// Authentication is in progress\n  authenticating,\n\n  /// Authentication failed\n  error,\n}\n\n/// State class for authentication operations\nclass AuthState {\n  final AuthStatus status;\n  final User? user;\n  final String? errorMessage;\n\n  const AuthState({\n    this.status = AuthStatus.initial,\n    this.user,\n    this.errorMessage,\n  });\n\n  const AuthState.initial()\n      : status = AuthStatus.initial,\n        user = null,\n        errorMessage = null;\n\n  const AuthState.authenticated(this.user)\n      : status = AuthStatus.authenticated,\n        errorMessage = null;\n\n  const AuthState.unauthenticated()\n      : status = AuthStatus.unauthenticated,\n        user = null,\n        errorMessage = null;\n\n  const AuthState.authenticating()\n      : status = AuthStatus.authenticating,\n        user = null,\n        errorMessage = null;\n\n  const AuthState.error(this.errorMessage)\n      : status = AuthStatus.error,\n        user = null;\n\n  bool get isAuthenticated => status == AuthStatus.authenticated;\n  bool get isLoading => status == AuthStatus.authenticating;\n  bool get hasError => status == AuthStatus.error;\n\n  AuthState copyWith({\n    AuthStatus? status,\n    User? user,\n    String? errorMessage,\n  }) {\n    return AuthState(\n      status: status ?? this.status,\n      user: user ?? this.user,\n      errorMessage: errorMessage ?? this.errorMessage,\n    );\n  }\n\n  @override\n  bool operator ==(Object other) {\n    if (identical(this, other)) return true;\n    return other is AuthState &&\n        other.status == status &&\n        other.user?.uid == user?.uid &&\n        other.errorMessage == errorMessage;\n  }\n\n  @override\n  int get hashCode => Object.hash(status, user?.uid, errorMessage);\n}\n\n/// Notifier for authentication operations\n///\n/// Handles login, registration, logout, and password reset operations.\n/// Integrates with Firebase Auth through the AuthRepository.\n///\n/// Usage:\n/// ```dart\n/// // In a widget\n/// final authNotifier = ref.read(authNotifierProvider.notifier);\n/// await authNotifier.signIn(email: email, password: password);\n/// ```\nclass AuthNotifier extends StateNotifier<AuthState> {\n  final AuthRepository _repository;\n  StreamSubscription<User?>? _authSubscription;\n\n  AuthNotifier(this._repository) : super(const AuthState.initial()) {\n    _init();\n  }\n\n  void _init() {\n    // Listen to auth state changes\n    _authSubscription = _repository.authStateChanges.listen((user) {\n      if (user != null) {\n        state = AuthState.authenticated(user);\n      } else {\n        state = const AuthState.unauthenticated();\n      }\n    });\n  }\n\n  @override\n  void dispose() {\n    _authSubscription?.cancel();\n    super.dispose();\n  }\n\n  /// Signs in a user with email and password\n  Future<bool> signIn({\n    required String email,\n    required String password,\n  }) async {\n    state = const AuthState.authenticating();\n\n    try {\n      final credential = await _repository.signInWithEmailAndPassword(\n        email: email,\n        password: password,\n      );\n      state = AuthState.authenticated(credential.user);\n      return true;\n    } on FirebaseAuthException catch (e) {\n      state = AuthState.error(_mapFirebaseError(e.code));\n      return false;\n    } catch (e) {\n      state = AuthState.error('Erro ao fazer login. Tente novamente.');\n      return false;\n    }\n  }\n\n  /// Creates a new user account\n  Future<bool> signUp({\n    required String email,\n    required String password,\n  }) async {\n    state = const AuthState.authenticating();\n\n    try {\n      final credential = await _repository.createUserWithEmailAndPassword(\n        email: email,\n        password: password,\n      );\n      state = AuthState.authenticated(credential.user);\n      return true;\n    } on FirebaseAuthException catch (e) {\n      state = AuthState.error(_mapFirebaseError(e.code));\n      return false;\n    } catch (e) {\n      state = AuthState.error('Erro ao criar conta. Tente novamente.');\n      return false;\n    }\n  }\n\n  /// Signs out the current user\n  Future<void> signOut() async {\n    try {\n      await _repository.signOut();\n      state = const AuthState.unauthenticated();\n    } catch (e) {\n      state = AuthState.error('Erro ao sair. Tente novamente.');\n    }\n  }\n\n  /// Sends a password reset email\n  Future<bool> sendPasswordReset({required String email}) async {\n    try {\n      await _repository.sendPasswordResetEmail(email: email);\n      return true;\n    } on FirebaseAuthException catch (e) {\n      state = AuthState.error(_mapFirebaseError(e.code));\n      return false;\n    } catch (e) {\n      state = AuthState.error('Erro ao enviar email. Tente novamente.');\n      return false;\n    }\n  }\n\n  /// Clears any error state\n  void clearError() {\n    if (state.hasError) {\n      state = state.user != null\n          ? AuthState.authenticated(state.user)\n          : const AuthState.unauthenticated();\n    }\n  }\n\n  /// Maps Firebase error codes to Portuguese messages\n  String _mapFirebaseError(String code) {\n    switch (code) {\n      case 'user-not-found':\n        return 'Usuario nao encontrado.';\n      case 'wrong-password':\n        return 'Senha incorreta.';\n      case 'invalid-email':\n        return 'Email invalido.';\n      case 'user-disabled':\n        return 'Conta desativada.';\n      case 'email-already-in-use':\n        return 'Email ja esta em uso.';\n      case 'weak-password':\n        return 'Senha muito fraca. Use pelo menos 6 caracteres.';\n      case 'operation-not-allowed':\n        return 'Operacao nao permitida.';\n      case 'too-many-requests':\n        return 'Muitas tentativas. Tente novamente mais tarde.';\n      case 'network-request-failed':\n        return 'Erro de conexao. Verifique sua internet.';\n      default:\n        return 'Erro de autenticacao. Tente novamente.';\n    }\n  }\n}\n\n/// Provider for the AuthNotifier\nfinal authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(\n  (ref) {\n    final repository = ref.watch(authRepositoryProvider);\n    return AuthNotifier(repository);\n  },\n);\n"
}
Now let me create the app state provider for global app state:

🔧 Tool: Write
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/state/providers/app_state_provider.dart",
  "content": "import 'package:flutter/material.dart';\nimport 'package:flutter_riverpod/flutter_riverpod.dart';\n\n/// Global app state for theme and app-wide settings\nclass AppState {\n  /// Current theme mode\n  final ThemeMode themeMode;\n\n  /// Whether the app has completed initialization\n  final bool isInitialized;\n\n  /// Global loading state for overlay indicators\n  final bool isLoading;\n\n  /// Global error message to display\n  final String? errorMessage;\n\n  const AppState({\n    this.themeMode = ThemeMode.system,\n    this.isInitialized = false,\n    this.isLoading = false,\n    this.errorMessage,\n  });\n\n  const AppState.initial()\n      : themeMode = ThemeMode.system,\n        isInitialized = false,\n        isLoading = false,\n        errorMessage = null;\n\n  AppState copyWith({\n    ThemeMode? themeMode,\n    bool? isInitialized,\n    bool? isLoading,\n    String? errorMessage,\n  }) {\n    return AppState(\n      themeMode: themeMode ?? this.themeMode,\n      isInitialized: isInitialized ?? this.isInitialized,\n      isLoading: isLoading ?? this.isLoading,\n      errorMessage: errorMessage,\n    );\n  }\n\n  @override\n  bool operator ==(Object other) {\n    if (identical(this, other)) return true;\n    return other is AppState &&\n        other.themeMode == themeMode &&\n        other.isInitialized == isInitialized &&\n        other.isLoading == isLoading &&\n        other.errorMessage == errorMessage;\n  }\n\n  @override\n  int get hashCode => Object.hash(\n        themeMode,\n        isInitialized,\n        isLoading,\n        errorMessage,\n      );\n}\n\n/// Notifier for global app state\nclass AppStateNotifier extends StateNotifier<AppState> {\n  AppStateNotifier() : super(const AppState.initial());\n\n  /// Marks the app as initialized\n  void setInitialized() {\n    state = state.copyWith(isInitialized: true);\n  }\n\n  /// Sets the theme mode\n  void setThemeMode(ThemeMode mode) {\n    state = state.copyWith(themeMode: mode);\n  }\n\n  /// Toggles between light and dark theme\n  void toggleTheme() {\n    final newMode = state.themeMode == ThemeMode.light\n        ? ThemeMode.dark\n        : state.themeMode == ThemeMode.dark\n            ? ThemeMode.system\n            : ThemeMode.light;\n    state = state.copyWith(themeMode: newMode);\n  }\n\n  /// Shows a global loading indicator\n  void showLoading() {\n    state = state.copyWith(isLoading: true);\n  }\n\n  /// Hides the global loading indicator\n  void hideLoading() {\n    state = state.copyWith(isLoading: false);\n  }\n\n  /// Sets a global error message\n  void setError(String message) {\n    state = state.copyWith(errorMessage: message);\n  }\n\n  /// Clears the global error message\n  void clearError() {\n    state = state.copyWith(errorMessage: null);\n  }\n}\n\n/// Provider for global app state\nfinal appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>(\n  (ref) => AppStateNotifier(),\n);\n\n/// Provider for current theme mode\nfinal themeModeProvider = Provider<ThemeMode>((ref) {\n  return ref.watch(appStateProvider.select((state) => state.themeMode));\n});\n\n/// Provider for app initialization status\nfinal isAppInitializedProvider = Provider<bool>((ref) {\n  return ref.watch(appStateProvider.select((state) => state.isInitialized));\n});\n\n/// Provider for global loading state\nfinal isGlobalLoadingProvider = Provider<bool>((ref) {\n  return ref.watch(appStateProvider.select((state) => state.isLoading));\n});\n\n/// Provider for global error message\nfinal globalErrorProvider = Provider<String?>((ref) {\n  return ref.watch(appStateProvider.select((state) => state.errorMessage));\n});\n"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Add Riverpod dependencies to pubspec.yaml",
      "status": "completed",
      "activeForm": "Adding Riverpod dependencies"
    },
    {
      "content": "Create base state management infrastructure",
      "status": "completed",
      "activeForm": "Creating state management infrastructure"
    },
    {
      "content": "Create auth state provider with Firebase integration",
      "status": "completed",
      "activeForm": "Creating auth state provider"
    },
    {
      "content": "Create common state patterns (loading, async)",
      "status": "completed",
      "activeForm": "Creating common state patterns"
    },
    {
      "content": "Wrap app with ProviderScope in main.dart",
      "status": "in_progress",
      "activeForm": "Wrapping app with ProviderScope"
    },
    {
      "content": "Update core barrel exports",
      "status": "pending",
      "activeForm": "Updating core barrel exports"
    },
    {
      "content": "Run flutter pub get to install dependencies",
      "status": "pending",
      "activeForm": "Installing dependencies"
    },
    {
      "content": "Verify implementation by running build",
      "status": "pending",
      "activeForm": "Verifying implementation"
    }
  ]
}
Now let me update the main.dart to wrap the app with ProviderScope:

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/main.dart",
  "old_string": "import 'package:flutter/foundation.dart';\nimport 'package:flutter/material.dart';\n\nimport 'core/di/injection.dart';\nimport 'core/errors/error_boundary.dart';\nimport 'core/errors/exceptions.dart';\nimport 'core/firebase/firebase_config.dart';\nimport 'core/router/app_router.dart';\nimport 'shared/theme/app_theme.dart';",
  "new_string": "import 'package:flutter/foundation.dart';\nimport 'package:flutter/material.dart';\nimport 'package:flutter_riverpod/flutter_riverpod.dart';\n\nimport 'core/di/injection.dart';\nimport 'core/errors/error_boundary.dart';\nimport 'core/errors/exceptions.dart';\nimport 'core/firebase/firebase_config.dart';\nimport 'core/router/app_router.dart';\nimport 'core/state/providers/app_state_provider.dart';\nimport 'shared/theme/app_theme.dart';"
}

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/main.dart",
  "old_string": "  // Run app with global error handling\n  GlobalErrorHandler.runAppWithErrorHandling(\n    const BurgerRatsApp(),\n    onError: _handleGlobalError,\n  );\n}",
  "new_string": "  // Run app with global error handling and Riverpod\n  GlobalErrorHandler.runAppWithErrorHandling(\n    const ProviderScope(child: BurgerRatsApp()),\n    onError: _handleGlobalError,\n  );\n}"
}

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/main.dart",
  "old_string": "class BurgerRatsApp extends StatelessWidget {\n  const BurgerRatsApp({super.key});\n\n  @override\n  Widget build(BuildContext context) {\n    return MaterialApp.router(\n      title: 'BurgerRats',\n      debugShowCheckedModeBanner: false,\n      theme: AppTheme.light,\n      darkTheme: AppTheme.dark,\n      themeMode: ThemeMode.system,\n      routerConfig: AppRouter.router,\n      builder: (context, child) {\n        // Wrap the app with ErrorBoundary for uncaught widget errors\n        return ErrorBoundary(\n          onError: _handleGlobalError,\n          child: child ?? const SizedBox.shrink(),\n        );\n      },\n    );\n  }\n}",
  "new_string": "class BurgerRatsApp extends ConsumerWidget {\n  const BurgerRatsApp({super.key});\n\n  @override\n  Widget build(BuildContext context, WidgetRef ref) {\n    // Watch theme mode from app state\n    final themeMode = ref.watch(themeModeProvider);\n\n    return MaterialApp.router(\n      title: 'BurgerRats',\n      debugShowCheckedModeBanner: false,\n      theme: AppTheme.light,\n      darkTheme: AppTheme.dark,\n      themeMode: themeMode,\n      routerConfig: AppRouter.router,\n      builder: (context, child) {\n        // Wrap the app with ErrorBoundary for uncaught widget errors\n        return ErrorBoundary(\n          onError: _handleGlobalError,\n          child: child ?? const SizedBox.shrink(),\n        );\n      },\n    );\n  }\n}"
}
Now let me update the core barrel export to include the state module:

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/core.dart",
  "old_string": "// Core module barrel export\n\n// Constants\nexport 'constants/app_constants.dart';\n\n// Dependency Injection\nexport 'di/injection.dart';\n\n// Errors\nexport 'errors/exceptions.dart';\nexport 'errors/failures.dart';\n\n// Services\nexport 'services/app_service.dart';\nexport 'services/permission_service.dart';\nexport 'services/photo_capture_service.dart';\n\n// Utils\nexport 'utils/typedefs.dart';",
  "new_string": "// Core module barrel export\n\n// Constants\nexport 'constants/app_constants.dart';\n\n// Dependency Injection\nexport 'di/injection.dart';\n\n// Errors\nexport 'errors/exceptions.dart';\nexport 'errors/failures.dart';\n\n// Services\nexport 'services/app_service.dart';\nexport 'services/permission_service.dart';\nexport 'services/photo_capture_service.dart';\n\n// State Management\nexport 'state/state.dart';\n\n// Utils\nexport 'utils/typedefs.dart';"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/core.dart"
}

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/core.dart",
  "old_string": "// Services\nexport 'services/app_service.dart';\nexport 'services/image_compression_service.dart';\nexport 'services/permission_service.dart';\nexport 'services/photo_capture_service.dart';\n\n// Utils\nexport 'utils/typedefs.dart';",
  "new_string": "// Services\nexport 'services/app_service.dart';\nexport 'services/image_compression_service.dart';\nexport 'services/permission_service.dart';\nexport 'services/photo_capture_service.dart';\n\n// State Management\nexport 'state/state.dart';\n\n// Utils\nexport 'utils/typedefs.dart';"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Add Riverpod dependencies to pubspec.yaml",
      "status": "completed",
      "activeForm": "Adding Riverpod dependencies"
    },
    {
      "content": "Create base state management infrastructure",
      "status": "completed",
      "activeForm": "Creating state management infrastructure"
    },
    {
      "content": "Create auth state provider with Firebase integration",
      "status": "completed",
      "activeForm": "Creating auth state provider"
    },
    {
      "content": "Create common state patterns (loading, async)",
      "status": "completed",
      "activeForm": "Creating common state patterns"
    },
    {
      "content": "Wrap app with ProviderScope in main.dart",
      "status": "completed",
      "activeForm": "Wrapping app with ProviderScope"
    },
    {
      "content": "Update core barrel exports",
      "status": "completed",
      "activeForm": "Updating core barrel exports"
    },
    {
      "content": "Run flutter pub get to install dependencies",
      "status": "in_progress",
      "activeForm": "Installing dependencies"
    },
    {
      "content": "Verify implementation by running build",
      "status": "pending",
      "activeForm": "Verifying implementation"
    }
  ]
}
Now let's run flutter pub get to install dependencies and verify everything compiles:

🔧 Tool: Bash
Input: {
  "command": "flutter pub get 2>&1",
  "description": "Install Flutter dependencies",
  "timeout": 120000
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Add Riverpod dependencies to pubspec.yaml",
      "status": "completed",
      "activeForm": "Adding Riverpod dependencies"
    },
    {
      "content": "Create base state management infrastructure",
      "status": "completed",
      "activeForm": "Creating state management infrastructure"
    },
    {
      "content": "Create auth state provider with Firebase integration",
      "status": "completed",
      "activeForm": "Creating auth state provider"
    },
    {
      "content": "Create common state patterns (loading, async)",
      "status": "completed",
      "activeForm": "Creating common state patterns"
    },
    {
      "content": "Wrap app with ProviderScope in main.dart",
      "status": "completed",
      "activeForm": "Wrapping app with ProviderScope"
    },
    {
      "content": "Update core barrel exports",
      "status": "completed",
      "activeForm": "Updating core barrel exports"
    },
    {
      "content": "Run flutter pub get to install dependencies",
      "status": "completed",
      "activeForm": "Installing dependencies"
    },
    {
      "content": "Verify implementation by running build",
      "status": "in_progress",
      "activeForm": "Verifying implementation"
    }
  ]
}

🔧 Tool: Bash
Input: {
  "command": "flutter analyze 2>&1",
  "description": "Analyze Flutter project",
  "timeout": 180000
}
The errors are in a pre-existing image compression service file, not related to my state management implementation. Let me analyze only the state management files to verify they compile correctly:

🔧 Tool: Bash
Input: {
  "command": "flutter analyze lib/core/state/ lib/main.dart 2>&1",
  "description": "Analyze state management files",
  "timeout": 120000
}
The state management files compile without issues. The errors are in the pre-existing `image_compression_service.dart` file (not related to this feature). Let me check and fix that file since it's blocking the build:

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/services/image_compression_service.dart"
}
The issue is that the existing `image_compression_service.dart` has bugs where it's using `CompressFormat` instead of the correct `ImageFormat` enum. This is a pre-existing bug not related to my state management feature. However, let me fix it so the build passes:

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/services/image_compression_service.dart",
  "old_string": "/// Output format for compressed images\nenum ImageFormat {\n  /// JPEG format - best for photos with lossy compression\n  jpeg,\n\n  /// PNG format - lossless compression, larger file size\n  png,\n\n  /// WebP format - modern format with excellent compression\n  webp,\n\n  /// HEIC format - iOS native format with excellent compression\n  heic,\n}",
  "new_string": "/// Output format for compressed images\n/// Note: This maps to flutter_image_compress CompressFormat\nenum ImageFormat {\n  /// JPEG format - best for photos with lossy compression\n  jpeg,\n\n  /// PNG format - lossless compression, larger file size\n  png,\n\n  /// WebP format - modern format with excellent compression\n  webp,\n\n  /// HEIC format - iOS native format with excellent compression\n  heic,\n}"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/services/image_compression_service.dart"
}
I see the file has been partially fixed (the constants now use `ImageFormat.jpeg` instead of `CompressFormat.jpeg`), but the methods at the bottom still use `CompressFormat`. Let me fix those:

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/services/image_compression_service.dart",
  "old_string": "      final result = await FlutterImageCompress.compressWithList(",
  "new_string": "      final result = await compress.FlutterImageCompress.compressWithList("
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/services/image_compression_service.dart"
}
I can see the issue clearly now. The file uses `compress.FlutterImageCompress` on line 298 correctly but later uses `FlutterImageCompress` without the prefix (line 389), and also uses `CompressFormat` without the `compress.` prefix. Let me fix all the remaining issues:

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/services/image_compression_service.dart",
  "old_string": "  /// Compress file using flutter_image_compress\n  Future<Uint8List?> _compressFile(\n    File file,\n    CompressionOptions options,\n  ) async {\n    return FlutterImageCompress.compressWithFile(\n      file.absolute.path,\n      minWidth: options.maxWidth ?? 1920,\n      minHeight: options.maxHeight ?? 1920,\n      quality: options.quality,\n      format: _mapFormat(options.format),\n      keepExif: options.keepExif,\n    );\n  }\n\n  /// Map our format enum to flutter_image_compress format\n  CompressFormat _mapFormat(CompressFormat format) {\n    return switch (format) {\n      CompressFormat.jpeg => CompressFormat.jpeg,\n      CompressFormat.png => CompressFormat.png,\n      CompressFormat.webp => CompressFormat.webp,\n      CompressFormat.heic => CompressFormat.heic,\n    };\n  }\n\n  /// Generate output path based on input path and format\n  String _generateOutputPath(String inputPath, CompressFormat format) {\n    final lastDot = inputPath.lastIndexOf('.');\n    final basePath = lastDot > 0 ? inputPath.substring(0, lastDot) : inputPath;\n    final extension = _getExtension(format);\n    final timestamp = DateTime.now().millisecondsSinceEpoch;\n\n    return '${basePath}_compressed_$timestamp.$extension';\n  }\n\n  /// Get file extension for format\n  String _getExtension(CompressFormat format) {\n    return switch (format) {\n      CompressFormat.jpeg => 'jpg',\n      CompressFormat.png => 'png',\n      CompressFormat.webp => 'webp',\n      CompressFormat.heic => 'heic',\n    };\n  }\n}",
  "new_string": "  /// Compress file using flutter_image_compress\n  Future<Uint8List?> _compressFile(\n    File file,\n    CompressionOptions options,\n  ) async {\n    return compress.FlutterImageCompress.compressWithFile(\n      file.absolute.path,\n      minWidth: options.maxWidth ?? 1920,\n      minHeight: options.maxHeight ?? 1920,\n      quality: options.quality,\n      format: _mapFormat(options.format),\n      keepExif: options.keepExif,\n    );\n  }\n\n  /// Map our format enum to flutter_image_compress format\n  compress.CompressFormat _mapFormat(ImageFormat format) {\n    return switch (format) {\n      ImageFormat.jpeg => compress.CompressFormat.jpeg,\n      ImageFormat.png => compress.CompressFormat.png,\n      ImageFormat.webp => compress.CompressFormat.webp,\n      ImageFormat.heic => compress.CompressFormat.heic,\n    };\n  }\n\n  /// Generate output path based on input path and format\n  String _generateOutputPath(String inputPath, ImageFormat format) {\n    final lastDot = inputPath.lastIndexOf('.');\n    final basePath = lastDot > 0 ? inputPath.substring(0, lastDot) : inputPath;\n    final extension = _getExtension(format);\n    final timestamp = DateTime.now().millisecondsSinceEpoch;\n\n    return '${basePath}_compressed_$timestamp.$extension';\n  }\n\n  /// Get file extension for format\n  String _getExtension(ImageFormat format) {\n    return switch (format) {\n      ImageFormat.jpeg => 'jpg',\n      ImageFormat.png => 'png',\n      ImageFormat.webp => 'webp',\n      ImageFormat.heic => 'heic',\n    };\n  }\n}"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/services/image_compression_service.dart",
  "offset": 380
}
The file has already been fixed. Let me run the analyze again to verify:

🔧 Tool: Bash
Input: {
  "command": "flutter analyze 2>&1",
  "description": "Analyze Flutter project",
  "timeout": 180000
}
All issues resolved. Now let me verify the build compiles:

🔧 Tool: Bash
Input: {
  "command": "flutter build apk --debug 2>&1 | head -50",
  "description": "Build debug APK",
  "timeout": 300000
}
The build is successful. Now let me update the todo list and verify the feature by checking that I can actually check if Flutter's test framework can validate the Riverpod integration. Since this is a Flutter mobile app (not a web app with Playwright), I need to adapt the verification approach:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Add Riverpod dependencies to pubspec.yaml",
      "status": "completed",
      "activeForm": "Adding Riverpod dependencies"
    },
    {
      "content": "Create base state management infrastructure",
      "status": "completed",
      "activeForm": "Creating state management infrastructure"
    },
    {
      "content": "Create auth state provider with Firebase integration",
      "status": "completed",
      "activeForm": "Creating auth state provider"
    },
    {
      "content": "Create common state patterns (loading, async)",
      "status": "completed",
      "activeForm": "Creating common state patterns"
    },
    {
      "content": "Wrap app with ProviderScope in main.dart",
      "status": "completed",
      "activeForm": "Wrapping app with ProviderScope"
    },
    {
      "content": "Update core barrel exports",
      "status": "completed",
      "activeForm": "Updating core barrel exports"
    },
    {
      "content": "Run flutter pub get to install dependencies",
      "status": "completed",
      "activeForm": "Installing dependencies"
    },
    {
      "content": "Verify implementation by running build",
      "status": "completed",
      "activeForm": "Verifying implementation"
    }
  ]
}
The task requested Playwright verification, but this is a Flutter mobile app, not a web application. Playwright is designed for web browser testing, not Flutter mobile apps. Let me create a Flutter widget test instead to verify the state management setup works correctly:

🔧 Tool: Write
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/test/core/state/state_management_test.dart",
  "content": "import 'package:flutter/material.dart';\nimport 'package:flutter_riverpod/flutter_riverpod.dart';\nimport 'package:flutter_test/flutter_test.dart';\n\nimport 'package:burgerrats/core/state/base_state.dart';\nimport 'package:burgerrats/core/state/base_notifier.dart';\nimport 'package:burgerrats/core/state/providers/app_state_provider.dart';\n\nvoid main() {\n  group('AsyncState', () {\n    test('initial state should have correct properties', () {\n      const state = AsyncState<String>.initial();\n\n      expect(state.isInitial, true);\n      expect(state.isLoading, false);\n      expect(state.isSuccess, false);\n      expect(state.isError, false);\n      expect(state.hasData, false);\n      expect(state.data, null);\n    });\n\n    test('loading state should preserve previous data when provided', () {\n      const state = AsyncState<String>.loading('previous');\n\n      expect(state.isLoading, true);\n      expect(state.hasData, true);\n      expect(state.data, 'previous');\n    });\n\n    test('success state should contain data', () {\n      const state = AsyncState<String>.success('test data');\n\n      expect(state.isSuccess, true);\n      expect(state.hasData, true);\n      expect(state.data, 'test data');\n    });\n\n    test('error state should contain error message', () {\n      const state = AsyncState<String>.error('Error message');\n\n      expect(state.isError, true);\n      expect(state.hasError, true);\n      expect(state.errorMessage, 'Error message');\n      expect(state.hasData, false);\n    });\n\n    test('when should call correct handler based on status', () {\n      const initialState = AsyncState<int>.initial();\n      const loadingState = AsyncState<int>.loading();\n      const successState = AsyncState<int>.success(42);\n      const errorState = AsyncState<int>.error('error');\n\n      expect(\n        initialState.when(\n          initial: () => 'initial',\n          loading: () => 'loading',\n          success: (data) => 'success: $data',\n          error: (msg) => 'error: $msg',\n        ),\n        'initial',\n      );\n\n      expect(\n        loadingState.when(\n          initial: () => 'initial',\n          loading: () => 'loading',\n          success: (data) => 'success: $data',\n          error: (msg) => 'error: $msg',\n        ),\n        'loading',\n      );\n\n      expect(\n        successState.when(\n          initial: () => 'initial',\n          loading: () => 'loading',\n          success: (data) => 'success: $data',\n          error: (msg) => 'error: $msg',\n        ),\n        'success: 42',\n      );\n\n      expect(\n        errorState.when(\n          initial: () => 'initial',\n          loading: () => 'loading',\n          success: (data) => 'success: $data',\n          error: (msg) => 'error: $msg',\n        ),\n        'error: error',\n      );\n    });\n\n    test('copyWith should create new instance with updated fields', () {\n      const original = AsyncState<String>.success('original');\n      final updated = original.copyWith(status: AsyncStatus.loading);\n\n      expect(updated.isLoading, true);\n      expect(updated.data, 'original');\n    });\n  });\n\n  group('PaginatedState', () {\n    test('initial state should have correct defaults', () {\n      const state = PaginatedState<String>.initial();\n\n      expect(state.items, isEmpty);\n      expect(state.isLoading, false);\n      expect(state.isLoadingMore, false);\n      expect(state.hasMore, true);\n      expect(state.currentPage, 0);\n      expect(state.isEmpty, true);\n    });\n\n    test('copyWith should update specified fields', () {\n      const state = PaginatedState<String>.initial();\n      final updated = state.copyWith(\n        items: ['item1', 'item2'],\n        isLoading: true,\n        currentPage: 1,\n      );\n\n      expect(updated.items, ['item1', 'item2']);\n      expect(updated.isLoading, true);\n      expect(updated.currentPage, 1);\n      expect(updated.hasMore, true); // unchanged\n    });\n  });\n\n  group('FormState', () {\n    test('initial state should have no errors', () {\n      const state = FormState.initial();\n\n      expect(state.isSubmitting, false);\n      expect(state.isSuccess, false);\n      expect(state.hasErrors, false);\n      expect(state.fieldErrors, isEmpty);\n    });\n\n    test('errorFor should return field error', () {\n      const state = FormState(\n        fieldErrors: {'email': 'Invalid email'},\n      );\n\n      expect(state.errorFor('email'), 'Invalid email');\n      expect(state.errorFor('password'), null);\n    });\n  });\n\n  group('AppStateProvider', () {\n    test('initial app state should have correct defaults', () {\n      final container = ProviderContainer();\n      addTearDown(container.dispose);\n\n      final appState = container.read(appStateProvider);\n\n      expect(appState.themeMode, ThemeMode.system);\n      expect(appState.isInitialized, false);\n      expect(appState.isLoading, false);\n      expect(appState.errorMessage, null);\n    });\n\n    test('setThemeMode should update theme', () {\n      final container = ProviderContainer();\n      addTearDown(container.dispose);\n\n      container.read(appStateProvider.notifier).setThemeMode(ThemeMode.dark);\n\n      expect(container.read(appStateProvider).themeMode, ThemeMode.dark);\n      expect(container.read(themeModeProvider), ThemeMode.dark);\n    });\n\n    test('toggleTheme should cycle through themes', () {\n      final container = ProviderContainer();\n      addTearDown(container.dispose);\n\n      // Start at system\n      expect(container.read(themeModeProvider), ThemeMode.system);\n\n      // Toggle to light\n      container.read(appStateProvider.notifier).toggleTheme();\n      expect(container.read(themeModeProvider), ThemeMode.light);\n\n      // Toggle to dark\n      container.read(appStateProvider.notifier).toggleTheme();\n      expect(container.read(themeModeProvider), ThemeMode.dark);\n\n      // Toggle back to system\n      container.read(appStateProvider.notifier).toggleTheme();\n      expect(container.read(themeModeProvider), ThemeMode.system);\n    });\n\n    test('showLoading and hideLoading should update loading state', () {\n      final container = ProviderContainer();\n      addTearDown(container.dispose);\n\n      expect(container.read(isGlobalLoadingProvider), false);\n\n      container.read(appStateProvider.notifier).showLoading();\n      expect(container.read(isGlobalLoadingProvider), true);\n\n      container.read(appStateProvider.notifier).hideLoading();\n      expect(container.read(isGlobalLoadingProvider), false);\n    });\n\n    test('setError and clearError should manage error state', () {\n      final container = ProviderContainer();\n      addTearDown(container.dispose);\n\n      expect(container.read(globalErrorProvider), null);\n\n      container.read(appStateProvider.notifier).setError('Test error');\n      expect(container.read(globalErrorProvider), 'Test error');\n\n      container.read(appStateProvider.notifier).clearError();\n      expect(container.read(globalErrorProvider), null);\n    });\n\n    test('setInitialized should update initialization status', () {\n      final container = ProviderContainer();\n      addTearDown(container.dispose);\n\n      expect(container.read(isAppInitializedProvider), false);\n\n      container.read(appStateProvider.notifier).setInitialized();\n      expect(container.read(isAppInitializedProvider), true);\n    });\n  });\n\n  group('Widget Integration', () {\n    testWidgets('ProviderScope provides state to widgets', (tester) async {\n      await tester.pumpWidget(\n        ProviderScope(\n          child: Consumer(\n            builder: (context, ref, child) {\n              final themeMode = ref.watch(themeModeProvider);\n              return MaterialApp(\n                themeMode: themeMode,\n                home: Scaffold(\n                  body: Text('Theme: $themeMode'),\n                ),\n              );\n            },\n          ),\n        ),\n      );\n\n      expect(find.text('Theme: ThemeMode.system'), findsOneWidget);\n    });\n  });\n}\n"
}

🔧 Tool: Bash
Input: {
  "command": "flutter test test/core/state/state_management_test.dart 2>&1",
  "description": "Run state management tests",
  "timeout": 180000
}
There's a name collision with Flutter's built-in `FormState`. Let me rename our FormState class and fix the test:

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/state/base_state.dart",
  "offset": 210
}

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/state/base_state.dart",
  "old_string": "/// State for form handling\n///\n/// Tracks form submission status and validation errors.\n@immutable\nclass FormState extends BaseState {",
  "new_string": "/// State for form handling\n///\n/// Tracks form submission status and validation errors.\n/// Note: Named AppFormState to avoid collision with Flutter's FormState\n@immutable\nclass AppFormState extends BaseState {"
}

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/state/base_state.dart",
  "old_string": "  /// Initial form state\n  const FormState.initial()\n      : isSubmitting = false,\n        isSuccess = false,\n        fieldErrors = const {},\n        errorMessage = null;",
  "new_string": "  /// Initial form state\n  const AppFormState.initial()\n      : isSubmitting = false,\n        isSuccess = false,\n        fieldErrors = const {},\n        errorMessage = null;"
}

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/state/base_state.dart",
  "old_string": "  /// Creates a copy with updated fields\n  FormState copyWith({\n    bool? isSubmitting,\n    bool? isSuccess,\n    Map<String, String>? fieldErrors,\n    String? errorMessage,\n  }) {\n    return FormState(",
  "new_string": "  /// Creates a copy with updated fields\n  AppFormState copyWith({\n    bool? isSubmitting,\n    bool? isSuccess,\n    Map<String, String>? fieldErrors,\n    String? errorMessage,\n  }) {\n    return AppFormState("
}

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/state/base_state.dart",
  "old_string": "  @override\n  bool operator ==(Object other) {\n    if (identical(this, other)) return true;\n    return other is FormState &&\n        other.isSubmitting == isSubmitting &&\n        other.isSuccess == isSuccess &&\n        mapEquals(other.fieldErrors, fieldErrors) &&\n        other.errorMessage == errorMessage;\n  }",
  "new_string": "  @override\n  bool operator ==(Object other) {\n    if (identical(this, other)) return true;\n    return other is AppFormState &&\n        other.isSubmitting == isSubmitting &&\n        other.isSuccess == isSuccess &&\n        mapEquals(other.fieldErrors, fieldErrors) &&\n        other.errorMessage == errorMessage;\n  }"
}
Now update the test file:

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/test/core/state/state_management_test.dart",
  "old_string": "  group('FormState', () {\n    test('initial state should have no errors', () {\n      const state = FormState.initial();\n\n      expect(state.isSubmitting, false);\n      expect(state.isSuccess, false);\n      expect(state.hasErrors, false);\n      expect(state.fieldErrors, isEmpty);\n    });\n\n    test('errorFor should return field error', () {\n      const state = FormState(\n        fieldErrors: {'email': 'Invalid email'},\n      );\n\n      expect(state.errorFor('email'), 'Invalid email');\n      expect(state.errorFor('password'), null);\n    });\n  });",
  "new_string": "  group('AppFormState', () {\n    test('initial state should have no errors', () {\n      const state = AppFormState.initial();\n\n      expect(state.isSubmitting, false);\n      expect(state.isSuccess, false);\n      expect(state.hasErrors, false);\n      expect(state.fieldErrors, isEmpty);\n    });\n\n    test('errorFor should return field error', () {\n      const state = AppFormState(\n        fieldErrors: {'email': 'Invalid email'},\n      );\n\n      expect(state.errorFor('email'), 'Invalid email');\n      expect(state.errorFor('password'), null);\n    });\n  });"
}
Now run the tests again:

🔧 Tool: Bash
Input: {
  "command": "flutter test test/core/state/state_management_test.dart 2>&1",
  "description": "Run state management tests",
  "timeout": 180000
}
I missed renaming the constructor. Let me read the full FormState/AppFormState section and fix it:

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/state/base_state.dart",
  "offset": 285
}

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/state/base_state.dart",
  "old_string": "  const FormState({\n    this.isSubmitting = false,\n    this.isSuccess = false,\n    this.fieldErrors = const {},\n    this.errorMessage,\n  });",
  "new_string": "  const AppFormState({\n    this.isSubmitting = false,\n    this.isSuccess = false,\n    this.fieldErrors = const {},\n    this.errorMessage,\n  });"
}

🔧 Tool: Bash
Input: {
  "command": "flutter test test/core/state/state_management_test.dart 2>&1",
  "description": "Run state management tests",
  "timeout": 180000
}
All 17 tests passed. The state management implementation is verified and working correctly. Let me now clean up the test file since it was meant for verification:

🔧 Tool: Bash
Input: {
  "command": "rm /Users/marcelo/dev/burgerrats/test/core/state/state_management_test.dart",
  "description": "Remove verification test file"
}
Let me verify the final project state by running analyze one more time:

🔧 Tool: Bash
Input: {
  "command": "flutter analyze 2>&1",
  "description": "Final project analysis",
  "timeout": 180000
}
Let me also list the final files created for this feature:

🔧 Tool: Glob
Input: {
  "pattern": "lib/core/state/**/*.dart"
}
<summary>
## Summary: State Management Setup with Riverpod

### Changes Implemented
- Added `flutter_riverpod` (^2.6.1) and `riverpod_annotation` (^2.6.1) dependencies for state management
- Added `riverpod_generator`, `riverpod_lint`, and `custom_lint` dev dependencies for code generation and linting
- Created comprehensive state management infrastructure:
  - **Base state classes** (`AsyncState`, `PaginatedState`, `AppFormState`) with common patterns for async operations, pagination, and form handling
  - **Base notifiers** (`BaseAsyncNotifier`, `BasePaginatedNotifier`) with reusable logic for common operations
  - **Form validation mixin** (`FormNotifierMixin`) for field validation
- Created **Auth state provider** with Firebase Auth integration:
  - `authStateProvider` - Stream provider for auth state changes
  - `currentUserProvider` - Current user access
  - `isAuthenticatedProvider` - Authentication status check
  - `authNotifierProvider` - State notifier for login, signup, logout, and password reset operations
  - Portuguese error messages for Firebase auth errors
- Created **App state provider** for global app state:
  - Theme mode management with toggle functionality
  - Global loading state
  - App initialization status
  - Global error message handling
- Wrapped the app with `ProviderScope` in `main.dart`
- Updated `BurgerRatsApp` to use `ConsumerWidget` for reactive theme updates
- Fixed pre-existing bug in `image_compression_service.dart` (unrelated to this feature)

### Files Modified
- `pubspec.yaml` - Added Riverpod dependencies
- `lib/main.dart` - Added ProviderScope wrapper and ConsumerWidget
- `lib/core/core.dart` - Added state module export
- `lib/core/services/image_compression_service.dart` - Fixed CompressFormat references (pre-existing bug)

### Files Created
- `lib/core/state/state.dart` - Barrel export for state management module
- `lib/core/state/base_state.dart` - Base state classes (AsyncState, PaginatedState, AppFormState)
- `lib/core/state/base_notifier.dart` - Base notifier classes and mixins
- `lib/core/state/providers/auth_state_provider.dart` - Authentication state management
- `lib/core/state/providers/app_state_provider.dart` - Global app state management

### Notes for Developer
- The existing GetIt/Injectable DI setup is preserved and coexists with Riverpod
- Use GetIt for service dependencies (PermissionService, PhotoCaptureService, etc.)
- Use Riverpod providers for UI state management
- `AppFormState` was named to avoid collision with Flutter's built-in `FormState`
- The auth provider integrates with the existing `AuthRepository` from GetIt
- To add feature-specific providers, create them in `lib/features/[feature]/presentation/providers/`

### Verification Status
- Project compiles successfully (`flutter analyze` - no issues)
- Debug APK builds successfully (`flutter build apk --debug`)
- State management functionality verified through unit tests (17 tests passed) covering:
  - AsyncState pattern matching and state transitions
  - PaginatedState for infinite scroll scenarios
  - AppFormState for form validation
  - AppStateProvider theme management, loading states, and error handling
  - Widget integration with ProviderScope
</summary>