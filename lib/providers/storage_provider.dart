import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

/// يُهيَّأ فعليًا (override) في main.dart بعد أن يصبح StorageService جاهزًا
final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('يجب تهيئة storageServiceProvider في main.dart');
});
