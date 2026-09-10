import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/lesson_model.dart';
import '../../models/unit_model.dart';
import '../../providers/progress_provider.dart';
import '../../widgets/lesson_tile.dart';

class UnitScreen extends ConsumerWidget {
  final UnitModel unit;

  const UnitScreen({super.key, required this.unit});

  String _routeForLesson(LessonModel lesson) {
    switch (lesson.type) {
      case LessonType.vocabulary:
        return '/lesson/vocab';
      case LessonType.matching:
        return '/lesson/matching';
      case LessonType.quiz:
        return '/lesson/quiz';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressMap = ref.watch(progressProvider);

    return Scaffold(
      appBar: AppBar(title: Text('${unit.emoji} ${unit.titleAr}')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: unit.lessons.length,
        itemBuilder: (context, index) {
          final lesson = unit.lessons[index];
          final stars = progressMap[lesson.id]?.stars ?? 0;
          return LessonTile(
            lesson: lesson,
            stars: stars,
            onTap: () => context.push(_routeForLesson(lesson), extra: lesson),
          );
        },
      ),
    );
  }
}
