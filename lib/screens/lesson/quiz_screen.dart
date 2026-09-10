import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_theme.dart';
import '../../models/lesson_model.dart';
import '../../models/quiz_question_model.dart';
import '../../providers/progress_provider.dart';
import '../../providers/tts_provider.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final LessonModel lesson;

  const QuizScreen({super.key, required this.lesson});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int _index = 0;
  int _correctCount = 0;
  int? _selectedOption;
  bool _answered = false;

  List<QuizQuestionModel> get _questions => widget.lesson.quizQuestions;

  void _selectOption(int optionIndex) {
    if (_answered) return;
    final question = _questions[_index];
    final isCorrect = optionIndex == question.correctIndex;
    setState(() {
      _selectedOption = optionIndex;
      _answered = true;
      if (isCorrect) _correctCount++;
    });

    // نطق الكلمة الصحيحة لتعزيز التعلم
    ref.read(ttsServiceProvider).speak(question.questionText);

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      if (_index < _questions.length - 1) {
        setState(() {
          _index++;
          _selectedOption = null;
          _answered = false;
        });
      } else {
        _finish();
      }
    });
  }

  void _finish() {
    final ratio = _correctCount / _questions.length;
    final stars = ratio >= 0.9 ? 3 : (ratio >= 0.6 ? 2 : (ratio > 0 ? 1 : 0));
    ref.read(progressProvider.notifier).saveResult(
          lessonId: widget.lesson.id,
          stars: stars,
          completed: ratio >= 0.6,
        );
    context.pushReplacement('/results', extra: {
      'stars': stars,
      'title': widget.lesson.titleAr,
      'lessonId': widget.lesson.id,
      'correct': _correctCount,
      'total': _questions.length,
    });
  }

  Color _optionColor(int optionIndex, QuizQuestionModel question) {
    if (!_answered) return Colors.white;
    if (optionIndex == question.correctIndex) return AppTheme.success.withOpacity(0.25);
    if (optionIndex == _selectedOption) return AppTheme.error.withOpacity(0.25);
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_index];
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text(widget.lesson.titleAr)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: (_index + 1) / _questions.length,
                minHeight: 8,
                borderRadius: BorderRadius.circular(8),
                backgroundColor: Colors.grey.shade300,
                color: AppTheme.secondary,
              ),
              const SizedBox(height: 24),
              Text(
                'ما معنى هذه الكلمة؟',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              if (question.questionEmoji != null)
                Text(question.questionEmoji!, style: const TextStyle(fontSize: 56)),
              const SizedBox(height: 8),
              Text(
                question.questionText,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 2.4,
                  ),
                  itemCount: question.options.length,
                  itemBuilder: (context, i) {
                    return _OptionButton(
                      text: question.options[i],
                      color: _optionColor(i, question),
                      onTap: () => _selectOption(i),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;

  const _OptionButton({required this.text, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(18),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.black12),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
