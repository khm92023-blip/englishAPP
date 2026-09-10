/// يمثّل سؤال اختيار من متعدد ضمن لعبة Quiz
class QuizQuestionModel {
  final String questionText; // قد تكون كلمة إنجليزية أو سؤال بسيط
  final String? questionEmoji; // رمز تعبيري اختياري يرافق السؤال
  final List<String> options;
  final int correctIndex;

  const QuizQuestionModel({
    required this.questionText,
    this.questionEmoji,
    required this.options,
    required this.correctIndex,
  });
}

/// يمثّل زوجًا للتوصيل ضمن لعبة Matching (كلمة إنجليزية <-> رمز/معنى)
class MatchingPairModel {
  final String english;
  final String emoji;

  const MatchingPairModel({required this.english, required this.emoji});
}
