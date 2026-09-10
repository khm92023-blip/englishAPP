import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/unit_model.dart';

class UnitCard extends StatelessWidget {
  final UnitModel unit;
  final int completedLessons;
  final VoidCallback onTap;

  const UnitCard({
    super.key,
    required this.unit,
    required this.completedLessons,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final totalLessons = unit.lessons.length;
    final locked = totalLessons == 0;

    return Opacity(
      opacity: locked ? 0.5 : 1,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: locked ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppTheme.primary.withOpacity(0.12),
                  child: Text(unit.emoji, style: const TextStyle(fontSize: 26)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        unit.titleAr,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        locked
                            ? 'قريبًا 🚧'
                            : '$completedLessons من $totalLessons دروس',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.black54,
                            ),
                      ),
                    ],
                  ),
                ),
                if (!locked)
                  const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
