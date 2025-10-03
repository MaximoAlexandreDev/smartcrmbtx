// Tela principal: Acesso a tarefas e sincronização manual.

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/providers.dart';
import 'tasks_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sync = ref.watch(syncProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Bitrix24'),
        actions: [
          IconButton(
            tooltip: 'Sincronizar agora',
            icon: sync.syncing ? const CircularProgressIndicator() : const Icon(Icons.sync),
            onPressed: sync.syncing
                ? null
                : () async {
                    final conn = await Connectivity().checkConnectivity();
                    if (conn.contains(ConnectivityResult.none)) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sem conexão. Tente novamente mais tarde.')),
                        );
                      }
                      return;
                    }
                    await ref.read(syncProvider.notifier).sync();
                  },
          ),
          IconButton(
            tooltip: 'Configurações',
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: const TasksScreen(),
    );
  }
}