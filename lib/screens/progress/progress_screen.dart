import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_theme.dart';
import '../../providers/content_provider.dart';
import '../../providers/grade_provider.dart';
import '../../providers/progress_provider.dart';
import '../../widgets/stars_display.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gradeId = ref.watch(selectedGradeProvider) ?? 1;
    final units = ref.watch(unitsForGradeProvider(gradeId));
    final progressMap = ref.watch(progressProvider);

    final allLessons = units.expand((u) => u.lessons).toList();
    final totalStars = allLessons.fold<int>(
      0,
      (sum, l) => sum + (progressMap[l.id]?.stars ?? 0),
    );
    final maxStars = allLessons.length * 3;
    final completedCount =
        allLessons.where((l) => progressMap[l.id]?.completed == true).length;

    return Scaffold(
      appBar: AppBar(title: const Text('تقدّمي 🏆')),
      backgroundColor: AppTheme.background,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('⭐', style: TextStyle(fontSize: 40)),
                  const SizedBox(height: 8),
                  Text(
                    '$totalStars من $maxStars نجمة',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text('$completedCount من ${allLessons.length} درسًا مكتملًا'),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: maxStars == 0 ? 0 : totalStars / maxStars,
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade300,
                      color: AppTheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...units.map((unit) {
            if (unit.lessons.isEmpty) return const SizedBox.shrink();
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ExpansionTile(
                title: Text('${unit.emoji} ${unit.titleAr}'),
                children: unit.lessons.map((lesson) {
                  final stars = progressMap[lesson.id]?.stars ?? 0;
                  return ListTile(
                    title: Text(lesson.titleAr),
                    subtitle: Text(lesson.titleEn),
                    trailing: StarsDisplay(stars: stars, size: 16),
                  );
                }).toList(),
              ),
            );
          }),
        ],
      ),
    );
  }
}
