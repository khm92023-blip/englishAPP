import 'dart:math';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/vocab_word_model.dart';

/// بطاقة تفاعلية: الوجه الأول (الرمز + الإنجليزية)، والوجه الثاني (المعنى + الجملة)
/// اضغط على البطاقة لقلبها، وعلى أيقونة الصوت للاستماع للنطق
class FlipFlashcard extends StatefulWidget {
  final VocabWordModel word;
  final VoidCallback onSpeak;

  const FlipFlashcard({super.key, required this.word, required this.onSpeak});

  @override
  State<FlipFlashcard> createState() => _FlipFlashcardState();
}

class _FlipFlashcardState extends State<FlipFlashcard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );
  bool _showFront = true;

  void _flip() {
    if (_showFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() => _showFront = !_showFront);
  }

  @override
  void didUpdateWidget(covariant FlipFlashcard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.word.english != widget.word.english) {
      _controller.value = 0;
      _showFront = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final angle = _controller.value * pi;
          final isBack = angle > pi / 2;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isBack
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: _buildBack(),
                  )
                : _buildFront(),
          );
        },
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      height: 260,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, Color(0xFF8E7CFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildFront() {
    return _card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.word.emoji, style: const TextStyle(fontSize: 70)),
          const SizedBox(height: 16),
          Text(
            widget.word.english,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          IconButton(
            onPressed: widget.onSpeak,
            icon: const Icon(Icons.volume_up_rounded, color: Colors.white, size: 30),
            style: IconButton.styleFrom(backgroundColor: Colors.white24),
          ),
          const SizedBox(height: 8),
          const Text(
            'اضغط للانقلاب',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildBack() {
    return _card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.word.arabic,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              widget.word.exampleSentence,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'اضغط للرجوع',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
