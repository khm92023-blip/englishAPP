import 'lesson_model.dart';

/// يمثّل وحدة تعليمية ضمن صف دراسي معيّن، وتحتوي على مجموعة دروس
class UnitModel {
  final String id; // معرف فريد مثل g1_u1
  final int gradeId;
  final int order;
  final String titleAr;
  final String titleEn;
  final String emoji;
  final List<LessonModel> lessons;

  const UnitModel({
    required this.id,
    required this.gradeId,
    required this.order,
    required this.titleAr,
    required this.titleEn,
    required this.emoji,
    required this.lessons,
  });
}
