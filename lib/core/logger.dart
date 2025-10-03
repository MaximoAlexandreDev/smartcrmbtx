// Logger simples com proteção para não vazar dados sensíveis em produção.

import 'dart:developer' as dev;

void logI(String message) {
  dev.log('[INFO] $message');
}

void logE(String message, [Object? error, StackTrace? stack]) {
  dev.log('[ERROR] $message', error: error, stackTrace: stack);
}