// Estado e ações de autenticação.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/bitrix/auth_service.dart';
import '../core/config.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class Authenticated extends AuthState {
  final String userId;
  const Authenticated(this.userId);
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _auth;

  AuthNotifier(this._auth) : super(const AuthInitial());

  Future<void> signIn({
    required String clientId,
    required String portalDomain,
  }) async {
    state = const AuthLoading();

    final res = await _auth.signIn(
      clientId: clientId,
      redirectUri: 'smartbitrix24://auth/callback',
      portalDomain: portalDomain,
    );

    // Guardar portal para instanciar o cliente REST
    AppConfig.portalDomain = res.portalDomain;

    state = Authenticated(res.userId);
  }

  Future<void> signOut() async {
    await _auth.signOut();
    state = const Unauthenticated();
  }
}