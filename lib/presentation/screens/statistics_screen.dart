import 'package:flutter/material.dart';
import 'package:hangman_game/application/game_controller.dart';
import 'package:hangman_game/presentation/formatters.dart';

/// Estatísticas acumuladas durante a sessão (RF13).
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key, required this.controller});

  final GameController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estatísticas da sessão')),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final statistics = controller.statistics;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _StatisticTile(
                      icon: Icons.flag_outlined,
                      label: 'Rodadas realizadas',
                      value: '${statistics.completedRounds}',
                    ),
                    _StatisticTile(
                      icon: Icons.emoji_events_outlined,
                      label: 'Vitórias',
                      value: '${statistics.wins} '
                          '(${formatPercent(statistics.winRate)})',
                    ),
                    _StatisticTile(
                      icon: Icons.sentiment_dissatisfied_outlined,
                      label: 'Derrotas',
                      value: '${statistics.losses} '
                          '(${formatPercent(statistics.lossRate)})',
                    ),
                    _StatisticTile(
                      icon: Icons.close,
                      label: 'Erros cometidos',
                      value: '${statistics.totalErrors}',
                    ),
                    _StatisticTile(
                      icon: Icons.lightbulb_outline,
                      label: 'Dicas utilizadas',
                      value: '${statistics.hintsUsed}',
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Os percentuais consideram apenas rodadas concluídas. '
                      'As estatísticas são mantidas enquanto o aplicativo '
                      'estiver aberto.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StatisticTile extends StatelessWidget {
  const _StatisticTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        trailing: Text(value, style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }
}
