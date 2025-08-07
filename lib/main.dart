import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fit Mate',
      home: MainPage(),
      theme: ThemeData(primaryColor: Colors.teal),
    );
  }
}

class MainPage extends StatelessWidget {
  final List<Map<String, dynamic>> trainers = [
    {
      'name': 'A 트레이너',
      'price': '20000원/1시간',
      'area': '서대문구, 마포구 수업',
      'tags': ['PT', '크로스핏'],
    },
    {
      'name': 'B 트레이너',
      'price': '30000원/1시간',
      'area': '서대문구, 마포구 수업',
      'tags': ['PT', '크로스핏'],
    },
    {
      'name': 'C 트레이너',
      'price': '30000원/1시간',
      'area': '서대문구, 마포구 수업',
      'tags': ['PT'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0, // 상태바 영역만
        backgroundColor: Colors.grey[200],
        elevation: 0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.forum), label: '게시판'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: '수업 요청'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
        ],
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    color: Colors.teal[100],
                    child: Center(
                      child: Text(
                        'Fit\nmate',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '홍길동 메이트님, 반갑습니다!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('믿을 수 있는 트레이너와 함께하는 건강한 운동'),
                        Text(
                          'No Gym? No Trainer? NoPoblem!',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on),
                      SizedBox(width: 4),
                      Text('영등포구 여의도동', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  TextButton(onPressed: () {}, child: Text('동네 수정')),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(onPressed: () {}, child: Text('수업 찾기 바로가기')),
                  ElevatedButton(onPressed: () {}, child: Text('수업 요청하기')),
                ],
              ),
              SizedBox(height: 16),
              Text(
                '이달의 트레이너 랭킹',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: trainers.length,
                  itemBuilder: (context, index) {
                    final t = trainers[index];
                    return Card(
                      color: Colors.grey[200],
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey,
                        ),
                        title: Text(t['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t['area']),
                            Wrap(
                              spacing: 4,
                              children:
                                  t['tags']
                                      .map<Widget>(
                                        (tag) => Chip(
                                          label: Text(tag),
                                          backgroundColor: Colors.amber,
                                        ),
                                      )
                                      .toList(),
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              t['price'],
                              style: TextStyle(
                                color: index == 0 ? Colors.blue : Colors.purple,
                              ),
                            ),
                            SizedBox(height: 4),
                            Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(width: 50, height: 50, color: Colors.grey[300]),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '이달의 핏메이트 선정 시 커피 쿠폰 증정',
                        style: TextStyle(color: Colors.purple),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
