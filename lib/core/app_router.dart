import 'package:go_router/go_router.dart';
import '../models/lesson_model.dart';
import '../models/unit_model.dart';
import '../screens/home/home_screen.dart';
import '../screens/level_select/level_select_screen.dart';
import '../screens/lesson/matching_screen.dart';
import '../screens/lesson/quiz_screen.dart';
import '../screens/lesson/vocabulary_lesson_screen.dart';
import '../screens/progress/progress_screen.dart';
import '../screens/results/results_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/unit/unit_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/level-select',
      builder: (context, state) => const LevelSelectScreen(),
    ),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/unit/:unitId',
      builder: (context, state) {
        final unit = state.extra as UnitModel;
        return UnitScreen(unit: unit);
      },
    ),
    GoRoute(
      path: '/lesson/vocab',
      builder: (context, state) {
        final lesson = state.extra as LessonModel;
        return VocabularyLessonScreen(lesson: lesson);
      },
    ),
    GoRoute(
      path: '/lesson/quiz',
      builder: (context, state) {
        final lesson = state.extra as LessonModel;
        return QuizScreen(lesson: lesson);
      },
    ),
    GoRoute(
      path: '/lesson/matching',
      builder: (context, state) {
        final lesson = state.extra as LessonModel;
        return MatchingScreen(lesson: lesson);
      },
    ),
    GoRoute(
      path: '/results',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return ResultsScreen(
          stars: data['stars'] as int,
          title: data['title'] as String,
          correct: data['correct'] as int?,
          total: data['total'] as int?,
        );
      },
    ),
    GoRoute(
      path: '/progress',
      builder: (context, state) => const ProgressScreen(),
    ),
  ],
);
