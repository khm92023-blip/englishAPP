import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/progress_model.dart';
import '../services/content_service.dart';
import 'storage_provider.dart';

/// يدير تقدّم الطالب في كل الدروس عبر خريطة (lessonId -> LessonProgress)
class ProgressNotifier extends StateNotifier<Map<String, LessonProgress>> {
  final Ref ref;

  ProgressNotifier(this.ref) : super({}) {
    _hydrateFromStorage();
  }

  /// عند بدء التطبيق: نحمّل من التخزين المحلي أي تقدّم محفوظ سابقًا
  /// لكل الدروس المعروفة في كل الصفوف، حتى تظهر النتائج فورًا بعد إعادة فتح التطبيق
  void _hydrateFromStorage() {
    final storage = ref.read(storageServiceProvider);
    final loaded = <String, LessonProgress>{};
    for (final grade in ContentService.grades) {
      for (final unit in ContentService.unitsForGrade(grade.id)) {
        for (final lesson in unit.lessons) {
          final saved = storage.getLessonProgress(lesson.id);
          if (saved != null) {
            loaded[lesson.id] = saved;
          }
        }
      }
    }
    state = loaded;
  }

  LessonProgress? progressFor(String lessonId) {
    // أولوية للحالة المحمّلة في الذاكرة، ثم التخزين المحلي
    return state[lessonId] ?? ref.read(storageServiceProvider).getLessonProgress(lessonId);
  }

  Future<void> saveResult({
    required String lessonId,
    required int stars,
    required bool completed,
  }) async {
    final progress = LessonProgress(
      lessonId: lessonId,
      stars: stars,
      completed: completed,
    );
    await ref.read(storageServiceProvider).saveLessonProgress(progress);

    // أفضل نتيجة محفوظة (لا تنقص عن محاولة سابقة أفضل)
    final saved = ref.read(storageServiceProvider).getLessonProgress(lessonId);
    if (saved != null) {
      state = {...state, lessonId: saved};
    }
  }
}

final progressProvider =
    StateNotifierProvider<ProgressNotifier, Map<String, LessonProgress>>(
  (ref) => ProgressNotifier(ref),
);
