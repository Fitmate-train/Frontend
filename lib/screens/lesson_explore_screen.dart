import 'package:flutter/material.dart';
import '../models/trainer_model.dart';
import '../widgets/lesson_card.dart';

class LessonExploreScreen extends StatelessWidget {
  final List<Trainer> trainers;

  LessonExploreScreen({required this.trainers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('수업 찾기'), centerTitle: true),
      body: Column(
        children: [
          // 🔍 검색창
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '지역, 지하철역, 센터, 선생님 검색',
                prefixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // 🏷️ 필터 탭
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildCategoryChip('전체'),
                _buildCategoryChip('헬스'),
                _buildCategoryChip('필라테스'),
                _buildCategoryChip('요가'),
                _buildCategoryChip('PT'),
              ],
            ),
          ),

          Divider(),

          // 📋 트레이너 리스트
          Expanded(
            child: ListView.builder(
              itemCount: trainers.length,
              itemBuilder: (context, index) {
                final trainer = trainers[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/lesson_detail',
                      arguments: trainer,
                    );
                  },
                  child: LessonCard(trainer: trainer),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.grey[200],
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
    );
  }
}
