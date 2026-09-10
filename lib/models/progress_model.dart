/// يمثّل تقدّم الطالب في درس معيّن (عدد النجوم المكتسبة 0-3)
class LessonProgress {
  final String lessonId;
  final int stars; // 0 = لم يُكمل بعد
  final bool completed;

  const LessonProgress({
    required this.lessonId,
    required this.stars,
    required this.completed,
  });

  Map<String, dynamic> toJson() => {
        'lessonId': lessonId,
        'stars': stars,
        'completed': completed,
      };

  factory LessonProgress.fromJson(Map<String, dynamic> json) {
    return LessonProgress(
      lessonId: json['lessonId'] as String,
      stars: json['stars'] as int,
      completed: json['completed'] as bool,
    );
  }
}
