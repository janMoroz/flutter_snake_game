import '../entities/snake_entities.dart';

class MoveResult {
  final GameModel model;
  final bool gameOver;
  MoveResult(this.model, {this.gameOver = false});
}

/// Логика перемещения змейки вынесена в usecase:
/// - рассчитывает новую голову
/// - проверяет выход за границы
/// - проверяет поедание еды
/// - проверяет столкновение с телом
class MoveSnakeUseCase {
  MoveResult move({
    required GameModel model,
    required GameSettings settings,
  }) {
    final int cols = settings.cols;
    final int rows = settings.rows;
    final int numberOfSquares = cols * rows;

    final int head = model.snake.last;
    int newHead = head;

    switch (model.direction) {
      case Direction.down:
        newHead = head + cols;
        if (newHead >= numberOfSquares) {
          return MoveResult(model, gameOver: true);
        }
        break;
      case Direction.up:
        newHead = head - cols;
        if (newHead < 0) {
          return MoveResult(model, gameOver: true);
        }
        break;
      case Direction.left:
        if (head % cols == 0) {
          return MoveResult(model, gameOver: true);
        }
        newHead = head - 1;
        break;
      case Direction.right:
        if ((head + 1) % cols == 0) {
          return MoveResult(model, gameOver: true);
        }
        newHead = head + 1;
        break;
    }

    final newSnake = List<int>.from(model.snake)..add(newHead);

    // Поел ли
    if (newHead == model.food) {
      final newScore = model.score + 10;
      final int newFood = _generateFood(newSnake, numberOfSquares);
      return MoveResult(model.copyWith(snake: newSnake, food: newFood, score: newScore));
    } else {
      // Обычное движение — удаляем хвост
      newSnake.removeAt(0);
      // Проверка столкновения с собой
      final body = newSnake.sublist(0, newSnake.length - 1);
      if (body.contains(newSnake.last)) {
        return MoveResult(model, gameOver: true);
      }
      return MoveResult(model.copyWith(snake: newSnake));
    }
  }

  int _generateFood(List<int> snake, int numberOfSquares) {
    final rand = DateTime.now().microsecondsSinceEpoch;
    var r = (rand % numberOfSquares);
    // Простейший re-roll: если попал в змейку — шаг вниз по модулю
    while (snake.contains(r)) {
      r = (r + 1) % numberOfSquares;
    }
    return r;
  }
}
