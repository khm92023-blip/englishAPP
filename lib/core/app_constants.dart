/// ثوابت عامة يستخدمها التطبيق في أكثر من مكان
class AppConstants {
  AppConstants._();

  // مفاتيح التخزين المحلي (SharedPreferences)
  static const String keySelectedGrade = 'selected_grade_id';
  static const String keyOnboardingDone = 'onboarding_done';
  static const String keyProgressPrefix = 'progress_'; // + lessonId
  static const String keySoundEnabled = 'sound_enabled';

  // عدد النجوم القصوى لكل درس
  static const int maxStarsPerLesson = 3;

  // نسبة النجاح لاعتبار الدرس "مكتملًا"
  static const double passThreshold = 0.6;
}
