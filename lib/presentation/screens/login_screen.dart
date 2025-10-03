// Tela de login simples: solicita o domínio do portal e inicia OAuth.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/auth_notifier.dart';
import '../../state/providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _portalCtrl = TextEditingController(text: 'SEU_PORTAL.bitrix24.com');
  final _clientIdCtrl = TextEditingController(text: 'SEU_CLIENT_ID');

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Entrar no Bitrix24')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Smart Bitrix24 - 1.0 Lite',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _portalCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Domínio do Portal Bitrix24',
                      hintText: 'ex.: suaconta.bitrix24.com',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Informe o domínio do portal';
                      if (!v.contains('bitrix24')) return 'Domínio inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _clientIdCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Client ID do App Bitrix24',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.isEmpty) ? 'Informe o Client ID' : null,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.login),
                      label: authState is AuthLoading ? const Text('Entrando...') : const Text('Entrar com Bitrix24'),
                      onPressed: authState is AuthLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                await ref.read(authProvider.notifier).signIn(
                                      clientId: _clientIdCtrl.text.trim(),
                                      portalDomain: _portalCtrl.text.trim(),
                                    );
                              }
                            },
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Ao continuar, você concorda com a Política de Privacidade e o Termo de Consentimento.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}