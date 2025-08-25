import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

enum ErrorType {
  network,
  authentication,
  validation,
  permission,
  notFound,
  serverError,
  unknown,
}

class AppError {
  final ErrorType type;
  final String message;
  final String? details;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppError({
    required this.type,
    required this.message,
    this.details,
    this.originalError,
    this.stackTrace,
  });

  factory AppError.network([String? message]) {
    return AppError(
      type: ErrorType.network,
      message: message ?? 'Network error. Please check your internet connection.',
    );
  }

  factory AppError.authentication([String? message]) {
    return AppError(
      type: ErrorType.authentication,
      message: message ?? 'Authentication failed. Please sign in again.',
    );
  }

  factory AppError.validation(String message) {
    return AppError(
      type: ErrorType.validation,
      message: message,
    );
  }

  factory AppError.permission([String? message]) {
    return AppError(
      type: ErrorType.permission,
      message: message ?? 'You do not have permission to perform this action.',
    );
  }

  factory AppError.notFound([String? message]) {
    return AppError(
      type: ErrorType.notFound,
      message: message ?? 'The requested resource was not found.',
    );
  }

  factory AppError.serverError([String? message]) {
    return AppError(
      type: ErrorType.serverError,
      message: message ?? 'Server error. Please try again later.',
    );
  }

  factory AppError.unknown([String? message, dynamic originalError, StackTrace? stackTrace]) {
    return AppError(
      type: ErrorType.unknown,
      message: message ?? 'An unexpected error occurred.',
      originalError: originalError,
      stackTrace: stackTrace,
    );
  }

  @override
  String toString() {
    return 'AppError(type: $type, message: $message)';
  }
}

class ErrorHandlingService {
  static final ErrorHandlingService _instance = ErrorHandlingService._internal();
  factory ErrorHandlingService() => _instance;
  ErrorHandlingService._internal();

  /// Convert various exceptions to AppError
  static AppError handleException(dynamic error, [StackTrace? stackTrace]) {
    if (error is AppError) {
      return error;
    }

    final errorMessage = error.toString().toLowerCase();

    // Network errors
    if (errorMessage.contains('network') ||
        errorMessage.contains('connection') ||
        errorMessage.contains('timeout') ||
        errorMessage.contains('unreachable')) {
      return AppError.network();
    }

    // Authentication errors
    if (errorMessage.contains('unauthorized') ||
        errorMessage.contains('authentication') ||
        errorMessage.contains('token') ||
        errorMessage.contains('session')) {
      return AppError.authentication();
    }

    // Permission errors
    if (errorMessage.contains('permission') ||
        errorMessage.contains('forbidden') ||
        errorMessage.contains('access denied')) {
      return AppError.permission();
    }

    // Not found errors
    if (errorMessage.contains('not found') ||
        errorMessage.contains('404')) {
      return AppError.notFound();
    }

    // Server errors
    if (errorMessage.contains('server') ||
        errorMessage.contains('500') ||
        errorMessage.contains('503') ||
        errorMessage.contains('502')) {
      return AppError.serverError();
    }

    // Validation errors (custom exceptions)
    if (error is Exception && errorMessage.contains('validation')) {
      return AppError.validation(error.toString().replaceFirst('Exception: ', ''));
    }

    // Log unknown errors in debug mode
    if (kDebugMode) {
      debugPrint('Unknown error: $error');
      if (stackTrace != null) {
        debugPrint('Stack trace: $stackTrace');
      }
    }

    return AppError.unknown(
      error.toString().replaceFirst('Exception: ', ''),
      error,
      stackTrace,
    );
  }

  /// Show error message to user
  static void showError(BuildContext context, dynamic error) {
    final appError = handleException(error);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(appError.message),
        backgroundColor: _getErrorColor(appError.type),
        duration: _getErrorDuration(appError.type),
        action: appError.type == ErrorType.network
            ? SnackBarAction(
                label: 'Retry',
                onPressed: () {
                  // This could trigger a retry mechanism
                },
                textColor: Colors.white,
              )
            : null,
      ),
    );
  }

  /// Show error dialog
  static void showErrorDialog(BuildContext context, dynamic error, {
    String? title,
    VoidCallback? onRetry,
  }) {
    final appError = handleException(error);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(
              _getErrorIcon(appError.type),
              color: _getErrorColor(appError.type),
            ),
            const SizedBox(width: 8),
            Text(
              title ?? _getErrorTitle(appError.type),
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          appError.message,
          style: const TextStyle(
            fontFamily: 'Manrope',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
          if (onRetry != null && appError.type == ErrorType.network)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF483FA9),
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }

  /// Get error color based on type
  static Color _getErrorColor(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return Colors.orange;
      case ErrorType.authentication:
        return Colors.red;
      case ErrorType.validation:
        return Colors.amber;
      case ErrorType.permission:
        return Colors.red;
      case ErrorType.notFound:
        return Colors.grey;
      case ErrorType.serverError:
        return Colors.red;
      case ErrorType.unknown:
        return Colors.grey;
    }
  }

  /// Get error duration based on type
  static Duration _getErrorDuration(ErrorType type) {
    switch (type) {
      case ErrorType.validation:
        return const Duration(seconds: 4);
      case ErrorType.network:
        return const Duration(seconds: 6);
      default:
        return const Duration(seconds: 4);
    }
  }

  /// Get error icon based on type
  static IconData _getErrorIcon(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return Icons.wifi_off;
      case ErrorType.authentication:
        return Icons.lock;
      case ErrorType.validation:
        return Icons.warning;
      case ErrorType.permission:
        return Icons.block;
      case ErrorType.notFound:
        return Icons.search_off;
      case ErrorType.serverError:
        return Icons.error;
      case ErrorType.unknown:
        return Icons.help_outline;
    }
  }

  /// Get error title based on type
  static String _getErrorTitle(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return 'Connection Error';
      case ErrorType.authentication:
        return 'Authentication Error';
      case ErrorType.validation:
        return 'Validation Error';
      case ErrorType.permission:
        return 'Permission Error';
      case ErrorType.notFound:
        return 'Not Found';
      case ErrorType.serverError:
        return 'Server Error';
      case ErrorType.unknown:
        return 'Error';
    }
  }

  /// Safe async operation wrapper
  static Future<T?> safeAsyncOperation<T>(
    Future<T> Function() operation, {
    required BuildContext context,
    bool showLoading = false,
    String? loadingMessage,
    bool showError = true,
    VoidCallback? onError,
  }) async {
    try {
      if (showLoading) {
        _showLoadingDialog(context, loadingMessage);
      }

      final result = await operation();

      if (showLoading) {
        Navigator.of(context).pop(); // Hide loading
      }

      return result;
    } catch (error, stackTrace) {
      if (showLoading && Navigator.of(context).canPop()) {
        Navigator.of(context).pop(); // Hide loading
      }

      if (showError) {
        ErrorHandlingService.showError(context, error);
      }

      if (onError != null) {
        onError();
      }

      if (kDebugMode) {
        debugPrint('Safe async operation error: $error');
        debugPrint('Stack trace: $stackTrace');
      }

      return null;
    }
  }

  /// Show loading dialog
  static void _showLoadingDialog(BuildContext context, String? message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: Color(0xFF483FA9),
            ),
            const SizedBox(height: 16),
            Text(
              message ?? 'Please wait...',
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Validate and execute operation with error handling
  static Future<T?> validateAndExecute<T>(
    Future<T> Function() operation, {
    required BuildContext context,
    List<String? Function()> validators = const [],
    bool showLoading = false,
    String? loadingMessage,
  }) async {
    // Run validators
    for (final validator in validators) {
      final error = validator();
      if (error != null) {
        showError(context, AppError.validation(error));
        return null;
      }
    }

    // Execute operation
    return await safeAsyncOperation(
      operation,
      context: context,
      showLoading: showLoading,
      loadingMessage: loadingMessage,
    );
  }

  /// Log error for debugging
  static void logError(dynamic error, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      final appError = handleException(error, stackTrace);
      debugPrint('Error logged: $appError');
      if (appError.originalError != null) {
        debugPrint('Original error: ${appError.originalError}');
      }
      if (appError.stackTrace != null) {
        debugPrint('Stack trace: ${appError.stackTrace}');
      }
    }
  }
}