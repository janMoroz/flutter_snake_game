import 'package:flutter/material.dart';

class SnakeBoard extends StatelessWidget {
  final int cols;
  final int rows;
  final List<int> snake;
  final int food;

  const SnakeBoard({
    super.key,
    required this.cols,
    required this.rows,
    required this.snake,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    final int total = cols * rows;
    return Container(
      color: Colors.black,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: total,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          if (snake.contains(index)) {
            return Padding(
              padding: const EdgeInsets.all(2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(color: Colors.white),
              ),
            );
          } else if (index == food) {
            return Padding(
              padding: const EdgeInsets.all(2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(color: Colors.red),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(color: Colors.grey[900]),
              ),
            );
          }
        },
      ),
    );
  }
}
