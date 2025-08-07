import 'package:flutter/material.dart';
import '../models/user_model.dart';

class OnboardingScreen extends StatefulWidget {
  final User user;

  OnboardingScreen({required this.user});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late User editedUser;

  @override
  void initState() {
    super.initState();
    editedUser = widget.user;
  }

  void _saveAndReturn() {
    Navigator.pop(context, editedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('정보 수정하기')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('운동 목표', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: TextEditingController(text: editedUser.goal),
              onChanged: (val) => editedUser.goal = val,
              decoration: InputDecoration(hintText: '예: 체형 교정'),
            ),
            SizedBox(height: 16),
            Text('선호 수업 스타일', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: TextEditingController(
                text: editedUser.preferredStyle,
              ),
              onChanged: (val) => editedUser.preferredStyle = val,
              decoration: InputDecoration(hintText: '예: 홈트'),
            ),
            SizedBox(height: 24),
            ElevatedButton(onPressed: _saveAndReturn, child: Text('저장 및 돌아가기')),
          ],
        ),
      ),
    );
  }
}
