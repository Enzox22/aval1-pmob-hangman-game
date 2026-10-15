import 'package:flutter/material.dart';
import 'package:hangman_game/application/game_controller.dart';
import 'package:hangman_game/domain/models/guess_outcome.dart';
import 'package:hangman_game/domain/models/hangman_round.dart';
import 'package:hangman_game/domain/models/round_status.dart';
import 'package:hangman_game/presentation/labels.dart';
import 'package:hangman_game/presentation/widgets/answer_board.dart';
import 'package:hangman_game/presentation/widgets/app_bar_actions.dart';
import 'package:hangman_game/presentation/widgets/guess_feedback.dart';
import 'package:hangman_game/presentation/widgets/hangman_drawing.dart';
import 'package:hangman_game/presentation/widgets/hint_section.dart';
import 'package:hangman_game/presentation/widgets/letter_keyboard.dart';
import 'package:hangman_game/presentation/widgets/round_info_bar.dart';
import 'package:hangman_game/presentation/widgets/round_result_panel.dart';

enum _ExhaustedAction { resetAnswers, changeSelection }

/// Tela principal da rodada.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.controller});

  final GameController controller;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const double _wideLayoutBreakpoint = 720;

  GuessOutcome? _lastOutcome;
  String? _lastLetter;

  GameController get _controller => widget.controller;

  void _onLetterSelected(String letter) {
    final outcome = _controller.guess(letter);
    setState(() {
      _lastOutcome = outcome;
      _lastLetter = letter;
    });
  }

  void _startNextRound() {
    if (_controller.startRound()) {
      setState(() {
        _lastOutcome = null;
        _lastLetter = null;
      });
      return;
    }
    _showExhaustedDialog();
  }

  Future<void> _showExhaustedDialog() async {
    final category = _controller.selectedCategory?.label ?? '';
    final difficulty = _controller.selectedDifficulty?.label ?? '';
    final action = await showDialog<_ExhaustedAction>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Respostas esgotadas'),
        content: Text(
          'Todas as respostas de $category ($difficulty) já foram '
          'utilizadas nesta sessão.',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(_ExhaustedAction.changeSelection),
            child: const Text('Escolher outra combinação'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(context).pop(_ExhaustedAction.resetAnswers),
            child: const Text('Liberar e jogar'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    switch (action) {
      case _ExhaustedAction.resetAnswers:
        _controller.resetSelectionUsage();
        _startNextRound();
      case _ExhaustedAction.changeSelection:
        Navigator.of(context).pop();
      case null:
        break;
    }
  }

  Future<void> _confirmAbandon() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Abandonar rodada?'),
        content: const Text(
          'A rodada em andamento não será contabilizada nas estatísticas, '
          'e a resposta sorteada continuará marcada como utilizada.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Continuar jogando'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Abandonar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final round = _controller.currentRound;
        if (round == null) return const Scaffold();
        return PopScope(
          canPop: round.isFinished,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _confirmAbandon();
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Jogo da Forca'),
              actions: [StatisticsAction(controller: _controller)],
            ),
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) =>
                    constraints.maxWidth >= _wideLayoutBreakpoint
                        ? _buildWideLayout(context, round)
                        : _buildCompactLayout(context, round),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompactLayout(BuildContext context, HangmanRound round) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RoundInfoBar(round: round),
              const SizedBox(height: 12),
              _buildDrawing(round, (screenHeight * 0.25).clamp(140.0, 240.0).toDouble()),
              const SizedBox(height: 16),
              ..._buildRoundDetails(round),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context, HangmanRound round) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RoundInfoBar(round: round),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildDrawing(round, 320)),
              const SizedBox(width: 24),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _buildRoundDetails(round),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawing(HangmanRound round, double height) {
    return HangmanDrawing(
      errors: round.errors,
      maxErrors: round.maxErrors,
      isLost: round.status == RoundStatus.lost,
      height: height,
    );
  }

  List<Widget> _buildRoundDetails(HangmanRound round) {
    return [
      AnswerBoard(round: round),
      const SizedBox(height: 16),
      HintSection(round: round, onRequestHint: _controller.useHint),
      const SizedBox(height: 16),
      if (round.isFinished)
        RoundResultPanel(
          round: round,
          onNewRound: _startNextRound,
          onChangeSelection: () => Navigator.of(context).pop(),
        )
      else ...[
        GuessFeedback(outcome: _lastOutcome, letter: _lastLetter),
        const SizedBox(height: 12),
        LetterKeyboard(
          letterStateOf: round.letterState,
          onLetterSelected: _onLetterSelected,
        ),
      ],
    ];
  }
}
