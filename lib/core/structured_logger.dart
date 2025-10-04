// Copyright (c) Maximo Tecnologia 2025
// Logger estruturado aprimorado com níveis e segurança

import 'dart:developer' as dev;

enum LogLevel {
  debug,
  info,
  warning,
  error,
}

class StructuredLogger {
  StructuredLogger._();

  static bool _isProduction = false;
  static final List<String> _sensitiveKeys = [
    'token',
    'password',
    'secret',
    'authorization',
    'access_token',
    'refresh_token',
  ];

  /// Configura se está em produção (menos logs)
  static void setProduction(bool production) {
    _isProduction = production;
  }

  /// Remove dados sensíveis de objetos antes de logar
  static dynamic _sanitize(dynamic data) {
    if (data is String) {
      // Verifica se contém palavras sensíveis
      for (final key in _sensitiveKeys) {
        if (data.toLowerCase().contains(key)) {
          return '***REDACTED***';
        }
      }
      return data;
    }
    
    if (data is Map) {
      final sanitized = <String, dynamic>{};
      data.forEach((key, value) {
        if (_sensitiveKeys.any((s) => key.toString().toLowerCase().contains(s))) {
          sanitized[key.toString()] = '***REDACTED***';
        } else {
          sanitized[key.toString()] = _sanitize(value);
        }
      });
      return sanitized;
    }
    
    if (data is List) {
      return data.map(_sanitize).toList();
    }
    
    return data;
  }

  static void log(String message, {
    LogLevel level = LogLevel.info,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    // Em produção, não loga debug
    if (_isProduction && level == LogLevel.debug) {
      return;
    }

    final sanitizedContext = context != null ? _sanitize(context) : null;
    final sanitizedError = error != null ? _sanitize(error) : null;

    final levelStr = level.name.toUpperCase();
    final timestamp = DateTime.now().toIso8601String();
    final contextStr = sanitizedContext != null ? ' | context: $sanitizedContext' : '';
    
    final logMessage = '[$timestamp] [$levelStr] $message$contextStr';

    if (error != null) {
      dev.log(
        logMessage,
        error: sanitizedError,
        stackTrace: stackTrace,
        level: _getLevelValue(level),
      );
    } else {
      dev.log(
        logMessage,
        level: _getLevelValue(level),
      );
    }
  }

  static int _getLevelValue(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
    }
  }

  static void debug(String message, {Map<String, dynamic>? context}) {
    log(message, level: LogLevel.debug, context: context);
  }

  static void info(String message, {Map<String, dynamic>? context}) {
    log(message, level: LogLevel.info, context: context);
  }

  static void warning(String message, {Map<String, dynamic>? context}) {
    log(message, level: LogLevel.warning, context: context);
  }

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    log(
      message,
      level: LogLevel.error,
      error: error,
      stackTrace: stackTrace,
      context: context,
    );
  }
}
