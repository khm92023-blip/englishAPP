/// يمثّل كلمة إنجليزية ضمن درس مفردات (تُستخدم في البطاقات التفاعلية)
class VocabWordModel {
  final String english;
  final String arabic;
  final String emoji; // رمز تعبيري يمثل الكلمة بصريًا
  final String exampleSentence; // جملة بسيطة توضح الاستخدام

  const VocabWordModel({
    required this.english,
    required this.arabic,
    required this.emoji,
    required this.exampleSentence,
  });
}
