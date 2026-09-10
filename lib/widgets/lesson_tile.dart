import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/lesson_model.dart';
import 'stars_display.dart';

class LessonTile extends StatelessWidget {
  final LessonModel lesson;
  final int stars;
  final VoidCallback onTap;

  const LessonTile({
    super.key,
    required this.lesson,
    required this.stars,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppTheme.secondary.withOpacity(0.15),
          child: Text(lesson.icon, style: const TextStyle(fontSize: 20)),
        ),
        title: Text(
          lesson.titleAr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(lesson.titleEn),
        trailing: StarsDisplay(stars: stars, size: 16),
      ),
    );
  }
}
