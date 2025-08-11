enum Direction { up, down, left, right }

class GameSettings {
  final int cols;
  final int rows;
  final int tickMs; // базовый интервал (можно менять для speed modes)
  const GameSettings({this.cols = 20, this.rows = 38, this.tickMs = 200});
}

class GameModel {
  final List<int> snake; // список индексов, голова = last
  final int food;
  final Direction direction;
  final bool running;
  final int score;

  GameModel({
    required this.snake,
    required this.food,
    required this.direction,
    required this.running,
    required this.score,
  });

  GameModel copyWith({
    List<int>? snake,
    int? food,
    Direction? direction,
    bool? running,
    int? score,
  }) {
    return GameModel(
      snake: snake ?? List<int>.from(this.snake),
      food: food ?? this.food,
      direction: direction ?? this.direction,
      running: running ?? this.running,
      score: score ?? this.score,
    );
  }
}
