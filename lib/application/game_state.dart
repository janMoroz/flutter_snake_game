import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/snake_entities.dart';
import '../domain/usecases/move_snake_usecase.dart';

final gameSettingsProvider = Provider((_) => const GameSettings(cols: 20, rows: 38, tickMs: 200));
final moveUseCaseProvider = Provider((_) => MoveSnakeUseCase());

final gameStateNotifierProvider = StateNotifierProvider<GameStateNotifier, GameModel>((ref) {
  final settings = ref.read(gameSettingsProvider);
  // стартовое состояние
  final initialSnake = [
    (settings.cols ~/ 2) + (settings.rows ~/ 2 - 2) * settings.cols,
    (settings.cols ~/ 2) + (settings.rows ~/ 2 - 1) * settings.cols,
    (settings.cols ~/ 2) + (settings.rows ~/ 2) * settings.cols,
  ];
  final initialFood = (settings.cols * settings.rows) ~/ 4; // placeholder
  return GameStateNotifier(ref, GameModel(
    snake: initialSnake,
    food: initialFood,
    direction: Direction.down,
    running: false,
    score: 0,
  ),);
},);

class GameStateNotifier extends StateNotifier<GameModel> {
  final Ref _read;
  Timer? _timer;

  GameStateNotifier(this._read, GameModel state) : super(state);

  void start() {
    final settings = _read.read(gameSettingsProvider);
    final cols = settings.cols;
    final rows = settings.rows;
    final List<int> initialSnake = [
      (cols ~/ 2) + (rows ~/ 2 - 2) * cols,
      (cols ~/ 2) + (rows ~/ 2 - 1) * cols,
      (cols ~/ 2) + (rows ~/ 2) * cols,
    ];
    state = GameModel(
      snake: initialSnake,
      food: _generateFood(initialSnake, cols * rows),
      direction: Direction.down,
      running: true,
      score: 0,
    );

    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: settings.tickMs), (_) => tick());
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(running: false);
  }

  void resume() {
    final settings = _read.read(gameSettingsProvider);
    if (state.running) return;
    state = state.copyWith(running: true);
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: settings.tickMs), (_) => tick());
  }

  void stop() {
    _timer?.cancel();
    state = state.copyWith(running: false);
  }

  void disposeTimer() {
    _timer?.cancel();
  }

  void changeDirection(Direction newDir) {
    if (_isOpposite(newDir, state.direction)) return;
    state = state.copyWith(direction: newDir);
  }

  void tick() {
    final usecase = _read.read(moveUseCaseProvider);
    final settings = _read.read(gameSettingsProvider);
    final result = usecase.move(model: state, settings: settings);
    if (result.gameOver) {
      _timer?.cancel();
      state = state.copyWith(running: false);
    } else {
      state = result.model;
    }
  }

  bool _isOpposite(Direction a, Direction b) {
    return (a == Direction.left && b == Direction.right) ||
        (a == Direction.right && b == Direction.left) ||
        (a == Direction.up && b == Direction.down) ||
        (a == Direction.down && b == Direction.up);
  }

  int _generateFood(List<int> snake, int numberOfSquares) {
    int r = DateTime.now().microsecondsSinceEpoch % numberOfSquares;
    while (snake.contains(r)) {
      r = (r + 1) % numberOfSquares;
    }
    return r;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
