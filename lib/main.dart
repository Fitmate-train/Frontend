import 'package:flutter/material.dart' hide CarouselController;
import 'screens/home_screen.dart';
import 'screens/lesson_explore_screen.dart';
import 'screens/lesson_detail_screen.dart';
import 'screens/lesson_request_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/lesson_confirm_screen.dart';

import 'models/user_model.dart';
import 'models/trainer_model.dart';
import './data//dummy_trainers.dart';

final dummyUser = User(
  name: '홍길동',
  gender: '여성',
  age: 28,
  height: 164,
  weight: 60,
  bodyType: '복부비만형',
  goal: '체형교정',
  preferredTime: '오전',
  preferredStyle: '홈트',
);

void main() {
  runApp(FitMateApp());
}

class FitMateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitMate',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/lesson_explore':
            (context) =>
                LessonExploreScreen(trainers: dummyTrainers), // ✅ 여기서 사용
        '/lesson_request': (context) => LessonRequestScreen(),
        '/lesson_detail': (context) => LessonDetailScreen(),
        '/onboarding': (context) => OnboardingScreen(user: dummyUser),
        '/chat': (context) => ChatScreen(),
        '/confirm': (context) => LessonConfirmScreen(),
      },
    );
  }
}
