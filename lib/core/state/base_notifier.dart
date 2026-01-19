import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'base_state.dart';

/// Base class for async notifiers that work with [AsyncState].
///
/// Provides common patterns for loading, success, and error handling.
/// Extend this class for feature-specific notifiers.
///
/// Example:
/// ```dart
/// class ItemsNotifier extends BaseAsyncNotifier<List<Item>> {
///   final ItemRepository _repository;
///
///   ItemsNotifier(this._repository);
///
///   Future<void> loadItems() => execute(() => _repository.getItems());
/// }
/// ```
abstract class BaseAsyncNotifier<T> extends StateNotifier<AsyncState<T>> {
  BaseAsyncNotifier() : super(const AsyncState.initial());

  /// Executes an async operation with automatic state management.
  ///
  /// Sets loading state, executes the operation, and updates to success or error.
  /// Optionally preserves previous data during loading with [preserveData].
  Future<void> execute(
    Future<T> Function() operation, {
    bool preserveData = false,
  }) async {
    state = preserveData && state.hasData
        ? AsyncState.loading(state.data)
        : const AsyncState.loading();

    try {
      final result = await operation();
      state = AsyncState.success(result);
    } catch (e, stackTrace) {
      _handleError(e, stackTrace);
    }
  }

  /// Executes an async operation that doesn't return data.
  ///
  /// Useful for operations like delete, update where you don't need to
  /// update the state data but want to track loading/error states.
  Future<bool> executeAction(Future<void> Function() action) async {
    final previousData = state.data;
    state = AsyncState.loading(previousData);

    try {
      await action();
      if (previousData != null) {
        state = AsyncState.success(previousData);
      } else {
        state = const AsyncState.initial();
      }
      return true;
    } catch (e, stackTrace) {
      _handleError(e, stackTrace);
      return false;
    }
  }

  /// Resets the state to initial
  void reset() {
    state = const AsyncState.initial();
  }

  /// Sets an error state manually
  void setError(String message, [Object? error]) {
    state = AsyncState.error(message, error);
  }

  /// Sets data directly without going through loading state
  void setData(T data) {
    state = AsyncState.success(data);
  }

  /// Handles errors by setting error state
  ///
  /// Override this method to customize error handling (e.g., logging)
  void _handleError(Object error, StackTrace stackTrace) {
    final message = _extractErrorMessage(error);
    state = AsyncState.error(message, error);
  }

  /// Extracts a user-friendly error message from an error object
  ///
  /// Override this to customize error message extraction
  String _extractErrorMessage(Object error) {
    return error.toString();
  }
}

/// Base class for paginated data notifiers.
///
/// Provides common patterns for loading paginated data with infinite scrolling.
///
/// Example:
/// ```dart
/// class ItemsListNotifier extends BasePaginatedNotifier<Item> {
///   final ItemRepository _repository;
///
///   ItemsListNotifier(this._repository);
///
///   @override
///   Future<List<Item>> fetchPage(int page) => _repository.getItems(page: page);
/// }
/// ```
abstract class BasePaginatedNotifier<T>
    extends StateNotifier<PaginatedState<T>> {
  BasePaginatedNotifier() : super(const PaginatedState.initial());

  /// Override to implement page fetching logic
  ///
  /// [page] is 0-indexed
  Future<List<T>> fetchPage(int page);

  /// Number of items per page
  int get pageSize => 20;

  /// Loads the first page of data
  Future<void> loadInitial() async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
    );

    try {
      final items = await fetchPage(0);
      state = PaginatedState(
        items: items,
        isLoading: false,
        hasMore: items.length >= pageSize,
        currentPage: 0,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Loads the next page of data
  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.currentPage + 1;
      final newItems = await fetchPage(nextPage);

      state = state.copyWith(
        items: [...state.items, ...newItems],
        isLoadingMore: false,
        hasMore: newItems.length >= pageSize,
        currentPage: nextPage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Refreshes the list by reloading from the first page
  Future<void> refresh() async {
    state = const PaginatedState.initial();
    await loadInitial();
  }

  /// Adds an item to the beginning of the list
  void addItem(T item) {
    state = state.copyWith(items: [item, ...state.items]);
  }

  /// Removes an item from the list
  void removeItem(T item) {
    state = state.copyWith(
      items: state.items.where((i) => i != item).toList(),
    );
  }

  /// Updates an item in the list
  void updateItem(T oldItem, T newItem) {
    final index = state.items.indexOf(oldItem);
    if (index != -1) {
      final newItems = List<T>.from(state.items);
      newItems[index] = newItem;
      state = state.copyWith(items: newItems);
    }
  }
}

/// Mixin for notifiers that need to track form submission state.
///
/// Use with [StateNotifier] to add form handling capabilities.
mixin FormNotifierMixin<T> on StateNotifier<T> {
  bool _isSubmitting = false;
  String? _errorMessage;
  final Map<String, String> _fieldErrors = {};

  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  Map<String, String> get fieldErrors => Map.unmodifiable(_fieldErrors);

  /// Sets the submitting state
  void setSubmitting(bool value) {
    _isSubmitting = value;
    // Trigger rebuild - subclass should call notifyListeners or update state
  }

  /// Sets a field-specific error
  void setFieldError(String field, String error) {
    _fieldErrors[field] = error;
  }

  /// Clears a field-specific error
  void clearFieldError(String field) {
    _fieldErrors.remove(field);
  }

  /// Sets a general error message
  void setErrorMessage(String? message) {
    _errorMessage = message;
  }

  /// Clears all errors
  void clearErrors() {
    _fieldErrors.clear();
    _errorMessage = null;
  }

  /// Validates that a field is not empty
  bool validateRequired(String field, String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      setFieldError(field, message ?? 'Este campo e obrigatorio');
      return false;
    }
    clearFieldError(field);
    return true;
  }

  /// Validates email format
  bool validateEmail(String field, String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      setFieldError(field, message ?? 'Email e obrigatorio');
      return false;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      setFieldError(field, message ?? 'Email invalido');
      return false;
    }

    clearFieldError(field);
    return true;
  }

  /// Validates minimum length
  bool validateMinLength(
    String field,
    String? value,
    int minLength, {
    String? message,
  }) {
    if (value == null || value.length < minLength) {
      setFieldError(
        field,
        message ?? 'Minimo de $minLength caracteres',
      );
      return false;
    }
    clearFieldError(field);
    return true;
  }
}
