import 'package:flutter_tts/flutter_tts.dart';

/// خدمة بسيطة لنطق الكلمات الإنجليزية بصوت واضح ومناسب للأطفال
class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;

  Future<void> _ensureInit() async {
    if (_initialized) return;
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.4); // بطيء قليلًا ليناسب المتعلمين الصغار
    await _tts.setPitch(1.1); // نبرة أكثر مرحًا
    await _tts.setVolume(1.0);
    _initialized = true;
  }

  Future<void> speak(String text) async {
    await _ensureInit();
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}
