import 'package:flutter/material.dart';

class ScorePanel extends StatelessWidget {
  final int score;
  final bool running;
  final VoidCallback onStart;
  final VoidCallback onPause;

  const ScorePanel({
    super.key,
    required this.score,
    required this.running,
    required this.onStart,
    required this.onPause,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Score: $score',
              style: const TextStyle(color: Colors.white, fontSize: 20)),
          Row(
            children: [
              ElevatedButton(
                onPressed: onStart,
                child: Text(running ? 'Restart' : 'Start'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onPause,
                child: const Text('Pause'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
