import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_theme.dart';
import '../../models/lesson_model.dart';
import '../../models/vocab_word_model.dart';
import '../../providers/progress_provider.dart';
import '../../providers/tts_provider.dart';
import '../../widgets/flip_flashcard.dart';

class VocabularyLessonScreen extends ConsumerStatefulWidget {
  final LessonModel lesson;

  const VocabularyLessonScreen({super.key, required this.lesson});

  @override
  ConsumerState<VocabularyLessonScreen> createState() =>
      _VocabularyLessonScreenState();
}

class _VocabularyLessonScreenState extends ConsumerState<VocabularyLessonScreen> {
  int _index = 0;

  List<VocabWordModel> get _words => widget.lesson.vocabWords;

  void _next() {
    if (_index < _words.length - 1) {
      setState(() => _index++);
    } else {
      // أنهى مراجعة كل الكلمات: يُحتسب هذا الدرس كمكتمل بثلاث نجوم كاملة (درس تعرّف وليس اختبار)
      ref.read(progressProvider.notifier).saveResult(
            lessonId: widget.lesson.id,
            stars: 3,
            completed: true,
          );
      context.push('/results', extra: {
        'stars': 3,
        'title': widget.lesson.titleAr,
        'lessonId': widget.lesson.id,
      });
    }
  }

  void _prev() {
    if (_index > 0) setState(() => _index--);
  }

  @override
  Widget build(BuildContext context) {
    final word = _words[_index];
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text(widget.lesson.titleAr)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: (_index + 1) / _words.length,
                minHeight: 8,
                borderRadius: BorderRadius.circular(8),
                backgroundColor: Colors.grey.shade300,
                color: AppTheme.secondary,
              ),
              const SizedBox(height: 8),
              Text('${_index + 1} / ${_words.length}',
                  style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: FlipFlashcard(
                    key: ValueKey(word.english),
                    word: word,
                    onSpeak: () => ref.read(ttsServiceProvider).speak(word.english),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  if (_index > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _prev,
                        child: const Text('السابق'),
                      ),
                    ),
                  if (_index > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _next,
                      child: Text(_index == _words.length - 1 ? 'إنهاء 🎉' : 'التالي'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
