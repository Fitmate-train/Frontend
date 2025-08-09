import 'package:flutter/material.dart' hide CarouselController;
import 'package:my_project_name/login.dart';
import 'package:my_project_name/screens/lesson_chat_screen.dart';
import 'screens/home_screen.dart';
import 'screens/lesson_explore_screen.dart';
import 'screens/lesson_detail_screen.dart';
import 'screens/lesson_request_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/lesson_confirm_screen.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

import 'models/user_model.dart';
import 'models/trainer_model.dart';
import './data//dummy_trainers.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(
    nativeAppKey: '725eb3abc1c588429827d5e803c3c6e7',
    javaScriptAppKey: '851d45ff2c4345139b2efe7cbcaa8cf',
  );

  await initializeDateFormatting('ko_KR', null); // 로케일 데이터 로드
  Intl.defaultLocale = 'ko_KR'; // 기본 로케일 지정(선택)
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
        '/lesson_chat': (context) => LessonChatScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
