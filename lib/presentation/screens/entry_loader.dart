import 'package:flutter/material.dart';
import 'package:hangman_game/application/entry_pool.dart';
import 'package:hangman_game/application/game_controller.dart';
import 'package:hangman_game/data/entry_data_exception.dart';
import 'package:hangman_game/domain/repositories/entry_repository.dart';
import 'package:hangman_game/presentation/screens/setup_screen.dart';

/// Carrega os dados do JSON e, em seguida, abre a configuração da partida.
class EntryLoader extends StatefulWidget {
  const EntryLoader({super.key, required this.repository});

  final EntryRepository repository;

  @override
  State<EntryLoader> createState() => _EntryLoaderState();
}

class _EntryLoaderState extends State<EntryLoader> {
  late Future<GameController> _controllerFuture;
  GameController? _controller;

  @override
  void initState() {
    super.initState();
    _controllerFuture = _load();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<GameController> _load() async {
    final entries = await widget.repository.loadEntries();
    final controller = GameController(pool: EntryPool(entries));
    _controller?.dispose();
    _controller = controller;
    return controller;
  }

  void _retry() {
    setState(() {
      _controllerFuture = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GameController>(
      future: _controllerFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _LoadErrorView(
            message: _describeError(snapshot.error),
            onRetry: _retry,
          );
        }
        final controller = snapshot.data;
        if (controller == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return SetupScreen(controller: controller);
      },
    );
  }

  String _describeError(Object? error) => error is EntryDataException
      ? error.message
      : 'Erro inesperado ao carregar os dados: $error';
}

class _LoadErrorView extends StatelessWidget {
  const _LoadErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 56,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Não foi possível carregar o jogo',
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
