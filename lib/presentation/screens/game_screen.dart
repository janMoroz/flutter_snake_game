// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/game_state.dart';
import '../../application/game_controller.dart';
import '../../domain/entities/snake_entities.dart';
import '../widgets/snake_board.dart';
import '../widgets/score_panel.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (mounted) _focusNode.requestFocus();
      },
    );
  }

  void _onKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey;
      final ctrl = ref.read(gameControllerProvider);
      if (key == LogicalKeyboardKey.arrowUp || key == LogicalKeyboardKey.keyW) {
        ctrl.changeDirection(Direction.up);
      } else if (key == LogicalKeyboardKey.arrowDown ||
          key == LogicalKeyboardKey.keyS) {
        ctrl.changeDirection(Direction.down);
      } else if (key == LogicalKeyboardKey.arrowLeft ||
          key == LogicalKeyboardKey.keyA) {
        ctrl.changeDirection(Direction.left);
      } else if (key == LogicalKeyboardKey.arrowRight ||
          key == LogicalKeyboardKey.keyD) {
        ctrl.changeDirection(Direction.right);
      } else if (key == LogicalKeyboardKey.space) {
        final running = ref.read(gameStateNotifierProvider).running;
        if (running) {
          ctrl.pause();
        } else {
          ctrl.resume();
        }
      }
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(gameStateNotifierProvider);
    final controller = ref.read(gameControllerProvider);
    final settings = ref.read(gameSettingsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: _onKey,
        autofocus: true,
        child: GestureDetector(
          onTap: () => _focusNode.requestFocus(),
          onVerticalDragUpdate: (details) {
            if (details.delta.dy > 0) {
              controller.changeDirection(Direction.down);
            } else if (details.delta.dy < 0) {
              controller.changeDirection(Direction.up);
            }
          },
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx > 0) {
              controller.changeDirection(Direction.right);
            } else if (details.delta.dx < 0) {
              controller.changeDirection(Direction.left);
            }
          },
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: settings.cols / settings.rows,
                      child: SnakeBoard(
                        cols: settings.cols,
                        rows: settings.rows,
                        snake: model.snake,
                        food: model.food,
                      ),
                    ),
                  ),
                ),
                ScorePanel(
                  score: model.score,
                  running: model.running,
                  onStart: () => controller.start(),
                  onPause: () => controller.pause(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
