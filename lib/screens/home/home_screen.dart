import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_theme.dart';
import '../../providers/content_provider.dart';
import '../../providers/grade_provider.dart';
import '../../providers/progress_provider.dart';
import '../../widgets/unit_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gradeId = ref.watch(selectedGradeProvider) ?? 1;
    final grades = ref.watch(gradesProvider);
    final grade = grades.firstWhere((g) => g.id == gradeId, orElse: () => grades.first);
    final units = ref.watch(unitsForGradeProvider(gradeId));
    final progressMap = ref.watch(progressProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('${grade.emoji} ${grade.nameAr}'),
        actions: [
          IconButton(
            tooltip: 'التقدّم',
            icon: const Icon(Icons.emoji_events_rounded),
            onPressed: () => context.push('/progress'),
          ),
          IconButton(
            tooltip: 'تغيير الصف',
            icon: const Icon(Icons.swap_horiz_rounded),
            onPressed: () async {
              await ref.read(selectedGradeProvider.notifier).changeGrade();
              if (context.mounted) context.go('/level-select');
            },
          ),
        ],
      ),
      body: units.isEmpty
          ? const Center(child: Text('لا توجد وحدات بعد لهذا الصف'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: units.length,
              itemBuilder: (context, index) {
                final unit = units[index];
                final completed = unit.lessons
                    .where((l) => progressMap[l.id]?.completed == true)
                    .length;
                return UnitCard(
                  unit: unit,
                  completedLessons: completed,
                  onTap: () => context.push('/unit/${unit.id}', extra: unit),
                );
              },
            ),
      backgroundColor: AppTheme.background,
    );
  }
}
