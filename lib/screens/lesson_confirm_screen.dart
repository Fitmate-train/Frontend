import 'package:flutter/material.dart';

class LessonConfirmScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('예약 확정')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, size: 100, color: Colors.teal),
            SizedBox(height: 16),
            Text(
              '예약이 확정되었습니다!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('트레이너와 채팅을 통해 수업 장소·시간을 최종 조율하세요.'),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed:
                  () =>
                      Navigator.popUntil(context, ModalRoute.withName('/home')),
              child: Text('홈으로 이동'),
            ),
          ],
        ),
      ),
    );
  }
}
