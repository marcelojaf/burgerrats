import 'package:flutter/foundation.dart';

/// Base class for all feature states in the application.
///
/// Provides common state patterns like loading, error handling, and data.
/// Use [AsyncState] for async operations or extend this for custom states.
@immutable
abstract class BaseState {
  const BaseState();
}

/// Represents the status of an async operation
enum AsyncStatus {
  /// Initial state, no operation started
  initial,

  /// Operation is in progress
  loading,

  /// Operation completed successfully
  success,

  /// Operation failed with an error
  error,
}

/// Generic state class for async operations with data
///
/// This is a simpler alternative to Riverpod's AsyncValue when you need
/// more control over the state transitions or want to preserve previous
/// data during loading states.
///
/// Example usage:
/// ```dart
/// class MyNotifier extends StateNotifier<AsyncState<List<Item>>> {
///   MyNotifier() : super(const AsyncState.initial());
///
///   Future<void> loadItems() async {
///     state = state.copyWith(status: AsyncStatus.loading);
///     try {
///       final items = await repository.getItems();
///       state = AsyncState.success(items);
///     } catch (e) {
///       state = AsyncState.error(e.toString());
///     }
///   }
/// }
/// ```
@immutable
class AsyncState<T> extends BaseState {
  /// The current status of the async operation
  final AsyncStatus status;

  /// The data, if available
  final T? data;

  /// The error message, if any
  final String? errorMessage;

  /// The original error object, if any
  final Object? error;

  const AsyncState._({
    required this.status,
    this.data,
    this.errorMessage,
    this.error,
  });

  /// Creates an initial state with no data
  const AsyncState.initial()
      : status = AsyncStatus.initial,
        data = null,
        errorMessage = null,
        error = null;

  /// Creates a loading state, optionally preserving previous data
  const AsyncState.loading([T? previousData])
      : status = AsyncStatus.loading,
        data = previousData,
        errorMessage = null,
        error = null;

  /// Creates a success state with data
  const AsyncState.success(T this.data)
      : status = AsyncStatus.success,
        errorMessage = null,
        error = null;

  /// Creates an error state with message and optional error object
  const AsyncState.error(this.errorMessage, [this.error])
      : status = AsyncStatus.error,
        data = null;

  /// Whether the state is in initial status
  bool get isInitial => status == AsyncStatus.initial;

  /// Whether the state is loading
  bool get isLoading => status == AsyncStatus.loading;

  /// Whether the state completed successfully
  bool get isSuccess => status == AsyncStatus.success;

  /// Whether the state has an error
  bool get isError => status == AsyncStatus.error;

  /// Whether data is available (could be from previous successful load)
  bool get hasData => data != null;

  /// Whether an error message is available
  bool get hasError => errorMessage != null;

  /// Creates a copy of this state with the given fields replaced
  AsyncState<T> copyWith({
    AsyncStatus? status,
    T? data,
    String? errorMessage,
    Object? error,
  }) {
    return AsyncState._(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
      error: error ?? this.error,
    );
  }

  /// Pattern matching helper for handling different states
  ///
  /// Example:
  /// ```dart
  /// state.when(
  ///   initial: () => Text('Ready to load'),
  ///   loading: () => CircularProgressIndicator(),
  ///   success: (data) => Text('Got: $data'),
  ///   error: (message) => Text('Error: $message'),
  /// )
  /// ```
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(T data) success,
    required R Function(String? message) error,
  }) {
    switch (status) {
      case AsyncStatus.initial:
        return initial();
      case AsyncStatus.loading:
        return loading();
      case AsyncStatus.success:
        return success(data as T);
      case AsyncStatus.error:
        return error(errorMessage);
    }
  }

  /// Pattern matching helper with optional handlers
  ///
  /// Returns [orElse] for unhandled states
  R maybeWhen<R>({
    R Function()? initial,
    R Function()? loading,
    R Function(T data)? success,
    R Function(String? message)? error,
    required R Function() orElse,
  }) {
    switch (status) {
      case AsyncStatus.initial:
        return initial?.call() ?? orElse();
      case AsyncStatus.loading:
        return loading?.call() ?? orElse();
      case AsyncStatus.success:
        return success?.call(data as T) ?? orElse();
      case AsyncStatus.error:
        return error?.call(errorMessage) ?? orElse();
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AsyncState<T> &&
        other.status == status &&
        other.data == data &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => Object.hash(status, data, errorMessage);

  @override
  String toString() {
    return 'AsyncState(status: $status, data: $data, errorMessage: $errorMessage)';
  }
}

/// State for paginated data
///
/// Useful for infinite scrolling lists or paginated API responses.
@immutable
class PaginatedState<T> extends BaseState {
  /// The list of items loaded so far
  final List<T> items;

  /// Whether initial loading is in progress
  final bool isLoading;

  /// Whether more items are being loaded
  final bool isLoadingMore;

  /// Whether there are more items to load
  final bool hasMore;

  /// Current page number (0-indexed)
  final int currentPage;

  /// Error message if any
  final String? errorMessage;

  const PaginatedState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentPage = 0,
    this.errorMessage,
  });

  /// Initial empty state
  const PaginatedState.initial()
      : items = const [],
        isLoading = false,
        isLoadingMore = false,
        hasMore = true,
        currentPage = 0,
        errorMessage = null;

  /// Whether the list is empty and not loading
  bool get isEmpty => items.isEmpty && !isLoading;

  /// Whether this is the first load
  bool get isFirstLoad => items.isEmpty && isLoading;

  /// Creates a copy with updated fields
  PaginatedState<T> copyWith({
    List<T>? items,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    String? errorMessage,
  }) {
    return PaginatedState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: errorMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaginatedState<T> &&
        listEquals(other.items, items) &&
        other.isLoading == isLoading &&
        other.isLoadingMore == isLoadingMore &&
        other.hasMore == hasMore &&
        other.currentPage == currentPage &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAll(items),
        isLoading,
        isLoadingMore,
        hasMore,
        currentPage,
        errorMessage,
      );
}

/// State for form handling
///
/// Tracks form submission status and validation errors.
/// Note: Named AppFormState to avoid collision with Flutter's FormState
@immutable
class AppFormState extends BaseState {
  /// Whether the form is currently submitting
  final bool isSubmitting;

  /// Whether the form was submitted successfully
  final bool isSuccess;

  /// Validation errors by field name
  final Map<String, String> fieldErrors;

  /// General form error message
  final String? errorMessage;

  const AppFormState({
    this.isSubmitting = false,
    this.isSuccess = false,
    this.fieldErrors = const {},
    this.errorMessage,
  });

  /// Initial form state
  const AppFormState.initial()
      : isSubmitting = false,
        isSuccess = false,
        fieldErrors = const {},
        errorMessage = null;

  /// Whether the form has any validation errors
  bool get hasErrors => fieldErrors.isNotEmpty || errorMessage != null;

  /// Gets the error for a specific field
  String? errorFor(String field) => fieldErrors[field];

  /// Creates a copy with updated fields
  AppFormState copyWith({
    bool? isSubmitting,
    bool? isSuccess,
    Map<String, String>? fieldErrors,
    String? errorMessage,
  }) {
    return AppFormState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      errorMessage: errorMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppFormState &&
        other.isSubmitting == isSubmitting &&
        other.isSuccess == isSuccess &&
        mapEquals(other.fieldErrors, fieldErrors) &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => Object.hash(
        isSubmitting,
        isSuccess,
        Object.hashAll(fieldErrors.entries),
        errorMessage,
      );
}
