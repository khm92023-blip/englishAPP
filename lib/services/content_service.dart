import '../core/app_theme.dart';
import '../models/grade_model.dart';
import '../models/lesson_model.dart';
import '../models/quiz_question_model.dart';
import '../models/unit_model.dart';
import '../models/vocab_word_model.dart';

/// خدمة توفّر كل المحتوى التعليمي (الصفوف، الوحدات، الدروس).
///
/// ملاحظة: محتوى الصف الأول مفصّل بالكامل كنموذج عملي.
/// محتوى الصفوف 2-4 مُهيّأ هيكليًا (عناوين الوحدات) ويحتاج تعبئة لاحقة
/// بنفس النمط المستخدم هنا في الصف الأول.
class ContentService {
  ContentService._();

  // ==================== الصفوف الدراسية ====================

  static List<GradeModel> get grades => [
        GradeModel(
          id: 1,
          nameAr: 'الصف الأول',
          descriptionAr: 'أول خطوة في رحلة الإنجليزية',
          color: AppTheme.gradeColors[0],
          emoji: '🌱',
          contentAvailable: true,
        ),
        GradeModel(
          id: 2,
          nameAr: 'الصف الثاني',
          descriptionAr: 'نبني على ما تعلمناه',
          color: AppTheme.gradeColors[1],
          emoji: '🌿',
          contentAvailable: true,
        ),
        GradeModel(
          id: 3,
          nameAr: 'الصف الثالث',
          descriptionAr: 'مفردات وجمل أكثر',
          color: AppTheme.gradeColors[2],
          emoji: '🌳',
          contentAvailable: true,
        ),
        GradeModel(
          id: 4,
          nameAr: 'الصف الرابع',
          descriptionAr: 'انطلاقة نحو الطلاقة',
          color: AppTheme.gradeColors[3],
          emoji: '🚀',
          contentAvailable: true,
        ),
      ];

  // ==================== نقطة الدخول الرئيسية ====================

  static List<UnitModel> unitsForGrade(int gradeId) {
    switch (gradeId) {
      case 1:
        return _grade1Units;
      case 2:
        return _placeholderUnits(2, [
          '🏫 المدرسة والأدوات',
          '🍎 الطعام والفواكه',
          '👕 الملابس',
          '🌤️ الطقس',
          '🏠 غرف المنزل',
          '⚽ الهوايات والألعاب',
        ]);
      case 3:
        return _placeholderUnits(3, [
          '📅 أيام الأسبوع والشهور',
          '⏰ الوقت والساعة',
          '🚗 وسائل المواصلات',
          '🧑‍⚕️ المهن',
          '🏙️ المدينة والأماكن العامة',
          '❤️ المشاعر والأحاسيس',
        ]);
      case 4:
        return _placeholderUnits(4, [
          '📖 القراءة والقصص القصيرة',
          '✍️ الجمل والقواعد البسيطة',
          '🌍 بلدان وجنسيات',
          '🥗 عادات صحية',
          '🎉 المناسبات والاحتفالات',
          '💬 محادثات يومية',
        ]);
      default:
        return [];
    }
  }

  /// وحدات هيكلية (عناوين فقط) للصفوف التي لم تُفصَّل بعد — تُستخدم كنموذج للتوسعة
  static List<UnitModel> _placeholderUnits(int gradeId, List<String> titles) {
    return List.generate(titles.length, (index) {
      final parts = titles[index].split(' ');
      final emoji = parts.first;
      final title = parts.skip(1).join(' ');
      return UnitModel(
        id: 'g${gradeId}_u${index + 1}',
        gradeId: gradeId,
        order: index + 1,
        titleAr: title,
        titleEn: 'Unit ${index + 1}',
        emoji: emoji,
        lessons: const [], // فارغة حاليًا: تُعبّأ لاحقًا بنفس نمط الصف الأول
      );
    });
  }

  // ==================== أدوات توليد الدروس من المفردات ====================

  static List<QuizQuestionModel> _quizFromVocab(List<VocabWordModel> vocab) {
    final questions = <QuizQuestionModel>[];
    for (final word in vocab) {
      final distractors = vocab.where((w) => w.arabic != word.arabic).toList()
        ..shuffle();
      final wrongOptions = distractors.take(3).map((w) => w.arabic).toList();
      final options = [word.arabic, ...wrongOptions]..shuffle();
      questions.add(
        QuizQuestionModel(
          questionText: word.english,
          questionEmoji: word.emoji,
          options: options,
          correctIndex: options.indexOf(word.arabic),
        ),
      );
    }
    return questions;
  }

  static List<MatchingPairModel> _matchingFromVocab(
    List<VocabWordModel> vocab, {
    int pairsCount = 6,
  }) {
    final selected = List<VocabWordModel>.from(vocab)..shuffle();
    return selected
        .take(pairsCount)
        .map((w) => MatchingPairModel(english: w.english, emoji: w.emoji))
        .toList();
  }

  static List<LessonModel> _buildStandardLessons({
    required String unitId,
    required List<VocabWordModel> vocab,
  }) {
    return [
      LessonModel(
        id: '${unitId}_l1',
        titleAr: 'تعلّم الكلمات',
        titleEn: 'Learn the Words',
        type: LessonType.vocabulary,
        icon: '📇',
        vocabWords: vocab,
      ),
      LessonModel(
        id: '${unitId}_l2',
        titleAr: 'لعبة التوصيل',
        titleEn: 'Matching Game',
        type: LessonType.matching,
        icon: '🧩',
        matchingPairs: _matchingFromVocab(vocab),
      ),
      LessonModel(
        id: '${unitId}_l3',
        titleAr: 'اختبار سريع',
        titleEn: 'Quick Quiz',
        type: LessonType.quiz,
        icon: '🎯',
        quizQuestions: _quizFromVocab(vocab),
      ),
    ];
  }

  // ==================== محتوى الصف الأول (تفصيلي بالكامل) ====================

  static final List<UnitModel> _grade1Units = [
    UnitModel(
      id: 'g1_u1',
      gradeId: 1,
      order: 1,
      titleAr: 'التحية والتعارف',
      titleEn: 'Greetings',
      emoji: '👋',
      lessons: _buildStandardLessons(
        unitId: 'g1_u1',
        vocab: const [
          VocabWordModel(
            english: 'Hello',
            arabic: 'مرحبًا',
            emoji: '👋',
            exampleSentence: 'Hello! How are you?',
          ),
          VocabWordModel(
            english: 'Bye',
            arabic: 'مع السلامة',
            emoji: '🙋',
            exampleSentence: 'Bye! See you tomorrow.',
          ),
          VocabWordModel(
            english: 'Yes',
            arabic: 'نعم',
            emoji: '✅',
            exampleSentence: 'Yes, I am happy.',
          ),
          VocabWordModel(
            english: 'No',
            arabic: 'لا',
            emoji: '❌',
            exampleSentence: 'No, thank you.',
          ),
          VocabWordModel(
            english: 'Please',
            arabic: 'من فضلك',
            emoji: '🙏',
            exampleSentence: 'Water, please.',
          ),
          VocabWordModel(
            english: 'Thank you',
            arabic: 'شكرًا لك',
            emoji: '😊',
            exampleSentence: 'Thank you very much.',
          ),
          VocabWordModel(
            english: 'Sorry',
            arabic: 'آسف',
            emoji: '😔',
            exampleSentence: 'Sorry, I am late.',
          ),
        ],
      ),
    ),
    UnitModel(
      id: 'g1_u2',
      gradeId: 1,
      order: 2,
      titleAr: 'عائلتي',
      titleEn: 'My Family',
      emoji: '👨‍👩‍👧‍👦',
      lessons: _buildStandardLessons(
        unitId: 'g1_u2',
        vocab: const [
          VocabWordModel(
            english: 'Mother',
            arabic: 'أمي',
            emoji: '👩',
            exampleSentence: 'This is my mother.',
          ),
          VocabWordModel(
            english: 'Father',
            arabic: 'أبي',
            emoji: '👨',
            exampleSentence: 'This is my father.',
          ),
          VocabWordModel(
            english: 'Sister',
            arabic: 'أختي',
            emoji: '👧',
            exampleSentence: 'My sister is happy.',
          ),
          VocabWordModel(
            english: 'Brother',
            arabic: 'أخي',
            emoji: '👦',
            exampleSentence: 'My brother is playing.',
          ),
          VocabWordModel(
            english: 'Baby',
            arabic: 'طفل رضيع',
            emoji: '👶',
            exampleSentence: 'The baby is sleeping.',
          ),
          VocabWordModel(
            english: 'Grandmother',
            arabic: 'جدتي',
            emoji: '👵',
            exampleSentence: 'I love my grandmother.',
          ),
          VocabWordModel(
            english: 'Grandfather',
            arabic: 'جدي',
            emoji: '👴',
            exampleSentence: 'My grandfather is kind.',
          ),
        ],
      ),
    ),
    UnitModel(
      id: 'g1_u3',
      gradeId: 1,
      order: 3,
      titleAr: 'الألوان',
      titleEn: 'Colours',
      emoji: '🎨',
      lessons: _buildStandardLessons(
        unitId: 'g1_u3',
        vocab: const [
          VocabWordModel(
            english: 'Red',
            arabic: 'أحمر',
            emoji: '🔴',
            exampleSentence: 'The apple is red.',
          ),
          VocabWordModel(
            english: 'Blue',
            arabic: 'أزرق',
            emoji: '🔵',
            exampleSentence: 'The sky is blue.',
          ),
          VocabWordModel(
            english: 'Yellow',
            arabic: 'أصفر',
            emoji: '🟡',
            exampleSentence: 'The sun is yellow.',
          ),
          VocabWordModel(
            english: 'Green',
            arabic: 'أخضر',
            emoji: '🟢',
            exampleSentence: 'The grass is green.',
          ),
          VocabWordModel(
            english: 'Black',
            arabic: 'أسود',
            emoji: '⚫',
            exampleSentence: 'My hair is black.',
          ),
          VocabWordModel(
            english: 'White',
            arabic: 'أبيض',
            emoji: '⚪',
            exampleSentence: 'The cloud is white.',
          ),
          VocabWordModel(
            english: 'Orange',
            arabic: 'برتقالي',
            emoji: '🟠',
            exampleSentence: 'I like orange juice.',
          ),
        ],
      ),
    ),
    UnitModel(
      id: 'g1_u4',
      gradeId: 1,
      order: 4,
      titleAr: 'الأرقام 1-10',
      titleEn: 'Numbers 1-10',
      emoji: '🔢',
      lessons: _buildStandardLessons(
        unitId: 'g1_u4',
        vocab: const [
          VocabWordModel(
              english: 'One',
              arabic: 'واحد',
              emoji: '1️⃣',
              exampleSentence: 'I have one book.'),
          VocabWordModel(
              english: 'Two',
              arabic: 'اثنان',
              emoji: '2️⃣',
              exampleSentence: 'I have two eyes.'),
          VocabWordModel(
              english: 'Three',
              arabic: 'ثلاثة',
              emoji: '3️⃣',
              exampleSentence: 'Three cats are playing.'),
          VocabWordModel(
              english: 'Four',
              arabic: 'أربعة',
              emoji: '4️⃣',
              exampleSentence: 'I see four birds.'),
          VocabWordModel(
              english: 'Five',
              arabic: 'خمسة',
              emoji: '5️⃣',
              exampleSentence: 'Five fingers on my hand.'),
          VocabWordModel(
              english: 'Six',
              arabic: 'ستة',
              emoji: '6️⃣',
              exampleSentence: 'Six apples on the table.'),
          VocabWordModel(
              english: 'Seven',
              arabic: 'سبعة',
              emoji: '7️⃣',
              exampleSentence: 'Seven days in a week.'),
          VocabWordModel(
              english: 'Eight',
              arabic: 'ثمانية',
              emoji: '8️⃣',
              exampleSentence: 'Eight stars in the sky.'),
          VocabWordModel(
              english: 'Nine',
              arabic: 'تسعة',
              emoji: '9️⃣',
              exampleSentence: 'Nine balloons are flying.'),
          VocabWordModel(
              english: 'Ten',
              arabic: 'عشرة',
              emoji: '🔟',
              exampleSentence: 'Ten fingers and ten toes.'),
        ],
      ),
    ),
    UnitModel(
      id: 'g1_u5',
      gradeId: 1,
      order: 5,
      titleAr: 'الحيوانات',
      titleEn: 'Animals',
      emoji: '🐾',
      lessons: _buildStandardLessons(
        unitId: 'g1_u5',
        vocab: const [
          VocabWordModel(
            english: 'Cat',
            arabic: 'قطة',
            emoji: '🐱',
            exampleSentence: 'The cat says meow.',
          ),
          VocabWordModel(
            english: 'Dog',
            arabic: 'كلب',
            emoji: '🐶',
            exampleSentence: 'The dog says woof.',
          ),
          VocabWordModel(
            english: 'Bird',
            arabic: 'عصفور',
            emoji: '🐦',
            exampleSentence: 'The bird can fly.',
          ),
          VocabWordModel(
            english: 'Fish',
            arabic: 'سمكة',
            emoji: '🐟',
            exampleSentence: 'The fish swims in water.',
          ),
          VocabWordModel(
            english: 'Cow',
            arabic: 'بقرة',
            emoji: '🐄',
            exampleSentence: 'The cow gives milk.',
          ),
          VocabWordModel(
            english: 'Sheep',
            arabic: 'خروف',
            emoji: '🐑',
            exampleSentence: 'The sheep is white.',
          ),
          VocabWordModel(
            english: 'Rabbit',
            arabic: 'أرنب',
            emoji: '🐰',
            exampleSentence: 'The rabbit jumps high.',
          ),
        ],
      ),
    ),
    UnitModel(
      id: 'g1_u6',
      gradeId: 1,
      order: 6,
      titleAr: 'جسمي',
      titleEn: 'My Body',
      emoji: '🧍',
      lessons: _buildStandardLessons(
        unitId: 'g1_u6',
        vocab: const [
          VocabWordModel(
            english: 'Head',
            arabic: 'رأس',
            emoji: '🗣️',
            exampleSentence: 'Touch your head.',
          ),
          VocabWordModel(
            english: 'Hand',
            arabic: 'يد',
            emoji: '✋',
            exampleSentence: 'Wave your hand.',
          ),
          VocabWordModel(
            english: 'Eye',
            arabic: 'عين',
            emoji: '👁️',
            exampleSentence: 'I have two eyes.',
          ),
          VocabWordModel(
            english: 'Ear',
            arabic: 'أذن',
            emoji: '👂',
            exampleSentence: 'Listen with your ear.',
          ),
          VocabWordModel(
            english: 'Nose',
            arabic: 'أنف',
            emoji: '👃',
            exampleSentence: 'Smell with your nose.',
          ),
          VocabWordModel(
            english: 'Mouth',
            arabic: 'فم',
            emoji: '👄',
            exampleSentence: 'Open your mouth.',
          ),
          VocabWordModel(
            english: 'Leg',
            arabic: 'ساق',
            emoji: '🦵',
            exampleSentence: 'I have two legs.',
          ),
        ],
      ),
    ),
  ];
}
