import 'package:flutter/material.dart';
import '../models/trainer_model.dart';
import '../widgets/lesson_card.dart';

class LessonExploreScreen extends StatelessWidget {
  final List<Trainer> trainers;

  LessonExploreScreen({required this.trainers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('수업 찾기'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: '지역, 헬스장, 선생님 검색',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: trainers.length,
        itemBuilder: (context, index) {
          final trainer = trainers[index];
          return GestureDetector(
            onTap:
                () => Navigator.pushNamed(
                  context,
                  '/lesson_detail',
                  arguments: trainer,
                ),
            child: LessonCard(trainer: trainer),
          );
        },
      ),
    );
  }
}
