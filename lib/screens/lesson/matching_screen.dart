import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_theme.dart';
import '../../models/lesson_model.dart';
import '../../models/quiz_question_model.dart';
import '../../providers/progress_provider.dart';
import '../../providers/tts_provider.dart';

/// عنصر قابل للعرض في شبكة التوصيل (إما كلمة إنجليزية أو رمز تعبيري)
class _MatchTile {
  final String id; // معرف الزوج (نفسه للكلمة والرمز المطابقين)
  final String label;
  final bool isEmoji;

  _MatchTile({required this.id, required this.label, required this.isEmoji});
}

class MatchingScreen extends ConsumerStatefulWidget {
  final LessonModel lesson;

  const MatchingScreen({super.key, required this.lesson});

  @override
  ConsumerState<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends ConsumerState<MatchingScreen> {
  late List<_MatchTile> _wordTiles;
  late List<_MatchTile> _emojiTiles;
  final Set<String> _matchedIds = {};
  String? _selectedWordId;
  String? _selectedEmojiId;
  int _wrongAttempts = 0;

  @override
  void initState() {
    super.initState();
    final pairs = widget.lesson.matchingPairs;
    _wordTiles = pairs
        .map((p) => _MatchTile(id: p.english, label: p.english, isEmoji: false))
        .toList()
      ..shuffle();
    _emojiTiles = pairs
        .map((p) => _MatchTile(id: p.english, label: p.emoji, isEmoji: true))
        .toList()
      ..shuffle();
  }

  List<MatchingPairModel> get _pairs => widget.lesson.matchingPairs;

  void _onSelectWord(String id) {
    if (_matchedIds.contains(id)) return;
    setState(() => _selectedWordId = id);
    ref.read(ttsServiceProvider).speak(id);
    _checkMatch();
  }

  void _onSelectEmoji(String id) {
    if (_matchedIds.contains(id)) return;
    setState(() => _selectedEmojiId = id);
    _checkMatch();
  }

  void _checkMatch() {
    if (_selectedWordId == null || _selectedEmojiId == null) return;
    if (_selectedWordId == _selectedEmojiId) {
      setState(() {
        _matchedIds.add(_selectedWordId!);
        _selectedWordId = null;
        _selectedEmojiId = null;
      });
      if (_matchedIds.length == _pairs.length) {
        Future.delayed(const Duration(milliseconds: 400), _finish);
      }
    } else {
      _wrongAttempts++;
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        setState(() {
          _selectedWordId = null;
          _selectedEmojiId = null;
        });
      });
    }
  }

  void _finish() {
    final stars = _wrongAttempts == 0 ? 3 : (_wrongAttempts <= 2 ? 2 : 1);
    ref.read(progressProvider.notifier).saveResult(
          lessonId: widget.lesson.id,
          stars: stars,
          completed: true,
        );
    context.pushReplacement('/results', extra: {
      'stars': stars,
      'title': widget.lesson.titleAr,
      'lessonId': widget.lesson.id,
    });
  }

  Color _tileColor(String id, {required bool isSelected}) {
    if (_matchedIds.contains(id)) return AppTheme.success.withOpacity(0.25);
    if (isSelected) return AppTheme.secondary.withOpacity(0.3);
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text(widget.lesson.titleAr)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'وصّل الكلمة بالرمز الصحيح 🧩',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildColumn(_wordTiles, isWordColumn: true)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildColumn(_emojiTiles, isWordColumn: false)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColumn(List<_MatchTile> tiles, {required bool isWordColumn}) {
    return ListView.separated(
      itemCount: tiles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final tile = tiles[index];
        final isSelected = isWordColumn
            ? _selectedWordId == tile.id
            : _selectedEmojiId == tile.id;
        final matched = _matchedIds.contains(tile.id);
        return GestureDetector(
          onTap: matched
              ? null
              : () => isWordColumn ? _onSelectWord(tile.id) : _onSelectEmoji(tile.id),
          child: Container(
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _tileColor(tile.id, isSelected: isSelected),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: matched ? AppTheme.success : Colors.black12,
                width: 2,
              ),
            ),
            child: Text(
              tile.label,
              style: TextStyle(
                fontSize: tile.isEmoji ? 30 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
