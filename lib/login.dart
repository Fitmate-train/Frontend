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

      // 1) 로그인 (스코프 인자 없이)
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      // 2) 필요한 권한 추가 동의 요청
      await UserApi.instance.loginWithNewScopes([
        'profile_nickname',
        'profile_image',
      ]);

      // 3) 프로필 조회
      final me = await UserApi.instance.me();
      final nickname = me.kakaoAccount?.profile?.nickname ?? '사용자';

      if (!mounted) return;

      // 예시: 홈으로 이동 + 환영 스낵바
      Navigator.pushReplacementNamed(context, '/');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$nickname님 환영해요!')));
    } catch (e) {
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
