

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'game_state.dart';
import '../domain/entities/snake_entities.dart';

// Контроллер игры
final gameControllerProvider = Provider<GameController>((ref) {
  return GameController(ref);
},);

class GameController {
  final Ref _ref;

  GameController(this._ref);

  void start() => _ref.read(gameStateNotifierProvider.notifier).start();
  void pause() => _ref.read(gameStateNotifierProvider.notifier).pause();
  void resume() => _ref.read(gameStateNotifierProvider.notifier).resume();
  void stop() => _ref.read(gameStateNotifierProvider.notifier).stop();
  void changeDirection(Direction dir) =>
      _ref.read(gameStateNotifierProvider.notifier).changeDirection(dir);
}

