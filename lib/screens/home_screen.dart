// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/dummy_trainers.dart';
import '../models/trainer_model.dart';
import '../widgets/TopNav.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

Future<String?> _getSavedNickname() async {
  final prefs = await SharedPreferences.getInstance();
  final name = prefs.getString('nickname');
  if (name == null || name.trim().isEmpty) return null;
  return name.trim();
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _goLogin() async {
    await Navigator.pushNamed(context, '/login');
    setState(() {}); // 로그인 후 돌아오면 닉네임 다시 로드
  }

  Future<void> _logout() async {
    try {
      await UserApi.instance.logout(); // ✅ 카카오 토큰 로그아웃(옵션이지만 권장)
    } catch (e) {
      debugPrint('Kakao logout error: $e'); // 실패해도 로컬은 지움
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('nickname'); // ✅ 로컬 닉네임 삭제
    if (!mounted) return;
    setState(() {}); // UI 갱신
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('로그아웃 되었어요.')));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getSavedNickname(),
      builder: (context, snap) {
        final nickname = snap.data;
        final isLoggedIn = (nickname != null && nickname.isNotEmpty);

        final greeting = () {
          if (snap.connectionState == ConnectionState.waiting) {
            return '메이트님, 반갑습니다!';
          }
          return (nickname == null || nickname.isEmpty)
              ? '메이트님, 반갑습니다!'
              : '$nickname 메이트님, 반갑습니다!';
        }();

        return Scaffold(
          appBar: TopNav(
            isLoggedIn: isLoggedIn,
            onLoginPressed: _goLogin,
            onLogoutPressed: _logout,
            onProfilePressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ 인사 메시지 (닉네임 반영)
                Text(
                  greeting,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text('믿을 수 있는 트레이너와 함께하는 건강한 운동'),
                const SizedBox(height: 16),

                // 동네 정보
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.location_on, size: 20),
                        SizedBox(width: 4),
                        Text('영등포구 여의도동', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    TextButton(
                      onPressed:
                          () => Navigator.pushNamed(context, '/location_edit'),
                      child: const Text('동네 수정'),
                    ),
                  ],
                ),
                const Divider(height: 32),

                // 주요 CTA 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed:
                          () => Navigator.pushNamed(context, '/lesson_explore'),
                      icon: const Icon(Icons.search),
                      label: const Text('수업 찾기'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(140, 50),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed:
                          () => Navigator.pushNamed(context, '/lesson_request'),
                      icon: const Icon(Icons.add_circle),
                      label: const Text('수업 요청'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(140, 50),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 이벤트 배너
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.card_giftcard, size: 32),
                      SizedBox(width: 12),
                      Expanded(child: Text('이달의 핏메이트 선정 시 커피 쿠폰 증정!')),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 트레이너 랭킹
                const Text(
                  '이달의 트레이너 랭킹',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Column(
                  children:
                      dummyTrainers.map((trainer) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey,
                                alignment: Alignment.center,
                                child: const Text(
                                  '트레이너\n이미지',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          trainer.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${trainer.firstLessonRate.toStringAsFixed(0)}원/1시간',
                                          style: const TextStyle(
                                            color: Colors.purple,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text('📍${trainer.location} 수업'),
                                    const SizedBox(height: 4),
                                    Row(
                                      children:
                                          trainer.tags.map((tag) {
                                            return Container(
                                              margin: const EdgeInsets.only(
                                                right: 8,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.amber,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(tag),
                                            );
                                          }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pushNamed(
                                          context,
                                          '/lesson_detail',
                                          arguments: trainer,
                                        ),
                                    child: Row(
                                      children: const [
                                        Text('상세보기'),
                                        Icon(Icons.chevron_right),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
              BottomNavigationBarItem(icon: Icon(Icons.chat), label: '채팅'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
            ],
            currentIndex: 0,
            onTap: (index) {
              // TODO: 페이지 전환
            },
          ),
        );
      },
    );
  }
}
