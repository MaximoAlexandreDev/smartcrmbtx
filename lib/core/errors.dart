// Tipos de erros controlados para domínio e infraestrutura.

sealed class AppError implements Exception {
  final String message;
  final String? code;
  final Object? cause;
  final StackTrace? stackTrace;

  AppError(this.message, {this.code, this.cause, this.stackTrace});

  @override
  String toString() => 'AppError(code=$code, message=$message)';
}

class NetworkError extends AppError {
  NetworkError(super.message, {super.code, super.cause, super.stackTrace});
}

class AuthError extends AppError {
  AuthError(super.message, {super.code, super.cause, super.stackTrace});
}

class StorageError extends AppError {
  StorageError(super.message, {super.code, super.cause, super.stackTrace});
}

class ApiError extends AppError {
  ApiError(super.message, {super.code, super.cause, super.stackTrace});
}