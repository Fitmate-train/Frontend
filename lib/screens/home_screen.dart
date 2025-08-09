import 'package:flutter/material.dart';
import '../data/dummy_trainers.dart';
import '../models/trainer_model.dart';
import '../widgets/TopNav.dart'; // ← TopNav import

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool userLoggedIn = false; // 추후 로그인 상태 연동

    return Scaffold(
      appBar: TopNav(
        isLoggedIn: userLoggedIn,
        onLoginPressed: () {
          Navigator.pushNamed(context, '/login');
        },
        onProfilePressed: () {
          Navigator.pushNamed(context, '/profile');
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 인사 메시지
            Text(
              '홍길동 메이트님, 반갑습니다!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text('믿을 수 있는 트레이너와 함께하는 건강한 운동'),
            SizedBox(height: 16),

            // 동네 정보
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, size: 20),
                    SizedBox(width: 4),
                    Text('영등포구 여의도동', style: TextStyle(fontSize: 16)),
                  ],
                ),
                TextButton(onPressed: () {}, child: Text('동네 수정')),
              ],
            ),
            Divider(height: 32),

            // 주요 CTA 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/lesson_explore');
                  },
                  icon: Icon(Icons.search),
                  label: Text('수업 찾기'),
                  style: ElevatedButton.styleFrom(minimumSize: Size(140, 50)),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/lesson_request');
                  },
                  icon: Icon(Icons.add_circle),
                  label: Text('수업 요청'),
                  style: ElevatedButton.styleFrom(minimumSize: Size(140, 50)),
                ),
              ],
            ),
            SizedBox(height: 24),

            // 이벤트 배너
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.card_giftcard, size: 32),
                  SizedBox(width: 12),
                  Expanded(child: Text('이달의 핏메이트 선정 시 커피 쿠폰 증정!')),
                ],
              ),
            ),
            SizedBox(height: 24),

            // 트레이너 랭킹
            Text(
              '이달의 트레이너 랭킹',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Column(
              children:
                  dummyTrainers.map((trainer) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      padding: EdgeInsets.all(12),
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
                            child: Text(
                              '트레이너\n이미지',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      trainer.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '${trainer.firstLessonRate.toStringAsFixed(0)}원/1시간',
                                      style: TextStyle(color: Colors.purple),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text('📍${trainer.location} 수업'),
                                SizedBox(height: 4),
                                Row(
                                  children:
                                      trainer.tags.map((tag) {
                                        return Container(
                                          margin: EdgeInsets.only(right: 8),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.amber,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
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
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/lesson_detail',
                                    arguments: trainer,
                                  );
                                },
                                child: Row(
                                  children: [
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
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: '채팅'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
        ],
        currentIndex: 0,
        onTap: (index) {
          // 추후: 페이지 전환 처리
        },
      ),
    );
  }
}
