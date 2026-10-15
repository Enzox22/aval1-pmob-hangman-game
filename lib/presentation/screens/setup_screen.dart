import 'package:flutter/material.dart';
import 'package:hangman_game/application/game_controller.dart';
import 'package:hangman_game/presentation/labels.dart';
import 'package:hangman_game/presentation/screens/game_screen.dart';
import 'package:hangman_game/presentation/widgets/app_bar_actions.dart';

/// Configuração da partida: escolha de categoria e dificuldade (RF01/RF02).
class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key, required this.controller});

  final GameController controller;

  void _startRound(BuildContext context) {
    if (!controller.startRound()) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => GameScreen(controller: controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo da Forca'),
        actions: [
          StatisticsAction(controller: controller),
          const AboutAction(),
        ],
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) => Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text('Nova rodada', style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  const Text(
                    'Escolha uma categoria e um nível de dificuldade.',
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle('Categoria'),
                  _CategoryMenu(controller: controller),
                  const SizedBox(height: 24),
                  const _SectionTitle('Dificuldade'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final difficulty in controller.difficulties)
                        ChoiceChip(
                          label: Text(difficulty.label),
                          selected:
                              controller.selectedDifficulty == difficulty,
                          onSelected: (_) =>
                              controller.selectDifficulty(difficulty),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _SelectionSummary(controller: controller),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: controller.canStartRound
                        ? () => _startRound(context)
                        : null,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Iniciar rodada'),
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

/// Menu que exibe as categorias somente quando é aberto.
class _CategoryMenu extends StatelessWidget {
  const _CategoryMenu({required this.controller});

  final GameController controller;

  @override
  Widget build(BuildContext context) {
    final selected = controller.selectedCategory;
    return MenuAnchor(
      menuChildren: [
        for (final category in controller.categories)
          MenuItemButton(
            leadingIcon: Icon(category.icon),
            trailingIcon:
                selected == category ? const Icon(Icons.check) : null,
            onPressed: () => controller.selectCategory(category),
            child: Text(category.label),
          ),
      ],
      builder: (context, menu, _) => Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(
          onPressed: () => menu.isOpen ? menu.close() : menu.open(),
          icon: Icon(selected?.icon ?? Icons.menu),
          label: Text(selected?.label ?? 'Menu'),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

/// Mostra claramente as opções escolhidas antes do início da rodada.
class _SelectionSummary extends StatelessWidget {
  const _SelectionSummary({required this.controller});

  final GameController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasSelection = controller.hasSelection;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Opções selecionadas', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            _SummaryLine(
              label: 'Categoria',
              value: controller.selectedCategory?.label ?? 'Não selecionada',
            ),
            _SummaryLine(
              label: 'Dificuldade',
              value:
                  controller.selectedDifficulty?.label ?? 'Não selecionada',
            ),
            if (hasSelection)
              _SummaryLine(
                label: 'Respostas inéditas',
                value: '${controller.remainingForSelection} de '
                    '${controller.totalForSelection}',
              ),
            if (hasSelection && controller.totalForSelection == 0) ...[
              const SizedBox(height: 8),
              Text(
                'Não há respostas para esta combinação.',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ],
            if (controller.isSelectionExhausted) ...[
              const SizedBox(height: 12),
              Text(
                'Todas as respostas desta combinação já foram utilizadas '
                'nesta sessão. Escolha outra combinação ou libere as '
                'respostas para jogá-las novamente.',
                style: TextStyle(color: theme.colorScheme.error),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: controller.resetSelectionUsage,
                icon: const Icon(Icons.restart_alt),
                label: const Text('Liberar respostas novamente'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
