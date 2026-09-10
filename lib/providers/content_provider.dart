import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/grade_model.dart';
import '../models/unit_model.dart';
import '../services/content_service.dart';

/// قائمة كل الصفوف الدراسية المتاحة
final gradesProvider = Provider<List<GradeModel>>((ref) {
  return ContentService.grades;
});

/// قائمة الوحدات التعليمية لصف دراسي معيّن
final unitsForGradeProvider =
    Provider.family<List<UnitModel>, int>((ref, gradeId) {
  return ContentService.unitsForGrade(gradeId);
});
