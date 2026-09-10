import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/app_constants.dart';
import '../models/progress_model.dart';

/// خدمة مسؤولة عن كل عمليات التخزين المحلي:
/// - الصف الدراسي المختار
/// - تقدّم الطالب (النجوم) في كل درس
/// - إعدادات الصوت
class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // ---------- الصف الدراسي ----------

  int? getSelectedGrade() {
    return _prefs.getInt(AppConstants.keySelectedGrade);
  }

  Future<void> setSelectedGrade(int gradeId) async {
    await _prefs.setInt(AppConstants.keySelectedGrade, gradeId);
  }

  // ---------- تقدّم الدروس ----------

  LessonProgress? getLessonProgress(String lessonId) {
    final raw = _prefs.getString('${AppConstants.keyProgressPrefix}$lessonId');
    if (raw == null) return null;
    return LessonProgress.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveLessonProgress(LessonProgress progress) async {
    // لا نُنقص عدد النجوم إن كانت المحاولة الجديدة أقل من محاولة سابقة أفضل
    final existing = getLessonProgress(progress.lessonId);
    final bestStars = existing == null
        ? progress.stars
        : (existing.stars > progress.stars ? existing.stars : progress.stars);

    final finalProgress = LessonProgress(
      lessonId: progress.lessonId,
      stars: bestStars,
      completed: progress.completed || (existing?.completed ?? false),
    );

    await _prefs.setString(
      '${AppConstants.keyProgressPrefix}${progress.lessonId}',
      jsonEncode(finalProgress.toJson()),
    );
  }

  // ---------- إعدادات الصوت ----------

  bool isSoundEnabled() {
    return _prefs.getBool(AppConstants.keySoundEnabled) ?? true;
  }

  Future<void> setSoundEnabled(bool enabled) async {
    await _prefs.setBool(AppConstants.keySoundEnabled, enabled);
  }

  // ---------- إعادة تعيين كاملة (للاختبار أو تغيير الصف) ----------

  Future<void> resetGradeSelection() async {
    await _prefs.remove(AppConstants.keySelectedGrade);
  }
}
