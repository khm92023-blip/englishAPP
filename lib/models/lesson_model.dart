import 'vocab_word_model.dart';
import 'quiz_question_model.dart';

/// أنواع الدروس المدعومة في التطبيق
enum LessonType { vocabulary, quiz, matching }

/// يمثّل درسًا واحدًا ضمن وحدة تعليمية
class LessonModel {
  final String id; // معرف فريد مثل g1_u1_l1
  final String titleAr;
  final String titleEn;
  final LessonType type;
  final String icon; // رمز تعبيري يظهر في قائمة الدروس

  // محتوى درس المفردات (Flashcards)
  final List<VocabWordModel> vocabWords;

  // محتوى درس الاختبار (Quiz)
  final List<QuizQuestionModel> quizQuestions;

  // محتوى درس التوصيل (Matching)
  final List<MatchingPairModel> matchingPairs;

  const LessonModel({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.type,
    required this.icon,
    this.vocabWords = const [],
    this.quizQuestions = const [],
    this.matchingPairs = const [],
  });
}
