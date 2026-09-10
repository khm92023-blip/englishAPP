import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_theme.dart';
import '../../providers/content_provider.dart';
import '../../providers/grade_provider.dart';
import '../../widgets/grade_card.dart';

class LevelSelectScreen extends ConsumerWidget {
  const LevelSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grades = ref.watch(gradesProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text('🎓', style: TextStyle(fontSize: 60)),
              const SizedBox(height: 16),
              Text(
                'بأي صف أنت؟',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'اختر صفّك الدراسي لنبدأ رحلة تعلّم ممتعة!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 15),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: GridView.builder(
                  itemCount: grades.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.95,
                  ),
                  itemBuilder: (context, index) {
                    final grade = grades[index];
                    return GradeCard(
                      grade: grade,
                      onTap: () async {
                        await ref
                            .read(selectedGradeProvider.notifier)
                            .selectGrade(grade.id);
                        if (context.mounted) context.go('/home');
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
