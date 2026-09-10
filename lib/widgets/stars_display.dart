import 'package:flutter/material.dart';

class StarsDisplay extends StatelessWidget {
  final int stars; // 0-3
  final double size;

  const StarsDisplay({super.key, required this.stars, this.size = 22});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final filled = index < stars;
        return Icon(
          filled ? Icons.star_rounded : Icons.star_border_rounded,
          color: filled ? const Color(0xFFFFC107) : Colors.grey.shade400,
          size: size,
        );
      }),
    );
  }
}
