// lib/screens/login.dart
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loading = false;

  Future<void> _loginWithKakao() async {
    setState(() => _loading = true);
    try {
      OAuthToken token;

      print("카카오톡 설치 여부 확인 중...");

      if (await isKakaoTalkInstalled()) {
        print("카카오톡 설치됨 → loginWithKakaoTalk 호출");
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        print("카카오톡 미설치 → loginWithKakaoAccount 호출");
        token = await UserApi.instance.loginWithKakaoAccount();
      }
      print("로그인 성공, 토큰: ${token.accessToken}");

      await UserApi.instance.loginWithNewScopes([
        'profile_nickname',
        'profile_image',
      ]);
      print("추가 스코프 요청 성공");

      print("사용자 정보 조회 중...");
      final me = await UserApi.instance.me();
      print("조회된 사용자 정보: ${me.toJson()}");

      final nickname = me.kakaoAccount?.profile?.nickname ?? '사용자';
      print("닉네임: $nickname");
      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$nickname님 환영해요!')));
    } catch (e) {
      print("로그인 중 오류 발생: $e");

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('로그인에 실패했어요: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final kakaoYellow = const Color(0xFFFEE500);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const Text(
                    'FitMate',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  const Text('간편하게 카카오로 로그인하세요'),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _loading ? null : _loginWithKakao,
                      icon: const Icon(
                        Icons.chat_bubble,
                        size: 20,
                        color: Colors.black,
                      ),
                      label: Text(
                        _loading ? '로그인 중...' : '카카오로 시작하기',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kakaoYellow,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  //TextButton(
                  // onPressed: _loading ? null : _logout,
                  // child: const Text('로그아웃 (테스트용)'),
                  // ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
