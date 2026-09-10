import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'storage_provider.dart';

/// يحمل معرّف الصف الدراسي المختار حاليًا (null = لم يُختر بعد)
class SelectedGradeNotifier extends StateNotifier<int?> {
  final Ref ref;

  SelectedGradeNotifier(this.ref) : super(null) {
    // تحميل القيمة المحفوظة محليًا عند بدء التطبيق
    state = ref.read(storageServiceProvider).getSelectedGrade();
  }

  Future<void> selectGrade(int gradeId) async {
    state = gradeId;
    await ref.read(storageServiceProvider).setSelectedGrade(gradeId);
  }

  Future<void> changeGrade() async {
    // للسماح بالرجوع لشاشة اختيار الصف لتغييره لاحقًا
    state = null;
    await ref.read(storageServiceProvider).resetGradeSelection();
  }
}

final selectedGradeProvider =
    StateNotifierProvider<SelectedGradeNotifier, int?>(
  (ref) => SelectedGradeNotifier(ref),
);
