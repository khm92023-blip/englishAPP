import 'package:flutter/material.dart';

/// يمثّل صفًا دراسيًا (من الأول إلى الرابع)
class GradeModel {
  final int id; // 1, 2, 3, 4
  final String nameAr;
  final String descriptionAr;
  final Color color;
  final String emoji;
  final bool contentAvailable; // هل المحتوى التفصيلي جاهز حاليًا؟

  const GradeModel({
    required this.id,
    required this.nameAr,
    required this.descriptionAr,
    required this.color,
    required this.emoji,
    this.contentAvailable = false,
  });
}
