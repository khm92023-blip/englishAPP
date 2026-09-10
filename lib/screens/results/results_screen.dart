import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_theme.dart';
import '../../widgets/stars_display.dart';

class ResultsScreen extends StatefulWidget {
  final int stars;
  final String title;
  final int? correct;
  final int? total;

  const ResultsScreen({
    super.key,
    required this.stars,
    required this.title,
    this.correct,
    this.total,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 2));

  @override
  void initState() {
    super.initState();
    if (widget.stars > 0) _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  String get _encouragementMessage {
    switch (widget.stars) {
      case 3:
        return 'رائع جدًا! أنت بطل 🌟';
      case 2:
        return 'أحسنت! استمر هكذا 👏';
      case 1:
        return 'جيد! حاول مرة أخرى لتحصل على نجوم أكثر 💪';
      default:
        return 'لا بأس، حاول مرة أخرى! 🙂';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 24,
              maxBlastForce: 20,
              minBlastForce: 8,
              gravity: 0.25,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text(
                    widget.stars >= 2 ? '🎉' : '🙂',
                    style: const TextStyle(fontSize: 70),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  StarsDisplay(stars: widget.stars, size: 52),
                  const SizedBox(height: 16),
                  if (widget.correct != null && widget.total != null)
                    Text(
                      'إجاباتك الصحيحة: ${widget.correct} من ${widget.total}',
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    _encouragementMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primary,
                      ),
                      onPressed: () => context.go('/home'),
                      child: const Text('العودة للرئيسية'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
