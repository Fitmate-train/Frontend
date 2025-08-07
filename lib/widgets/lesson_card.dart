import 'package:flutter/material.dart';
import '../models/trainer_model.dart';

class LessonCard extends StatelessWidget {
  final Trainer trainer;

  const LessonCard({required this.trainer, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 썸네일 이미지 3장
            Row(
              children:
                  trainer.imageUrls.take(3).map((url) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child:
                              url.startsWith('http')
                                  ? Image.network(
                                    url,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  )
                                  : Image.asset(
                                    url,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 12),

            // 🔹 트레이너 이름 + 리뷰 수
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${trainer.name} 선생님',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    Text(
                      ' 후기 ${trainer.reviewCount}개',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 4),

            // 🔹 소개
            Text(trainer.intro, style: const TextStyle(fontSize: 14)),

            const SizedBox(height: 8),

            // 🔹 혜택
            Row(
              children: const [
                Chip(
                  label: Text('1회 체험'),
                  labelStyle: TextStyle(color: Colors.pink),
                  backgroundColor: Color(0xFFFFEBEE),
                  visualDensity: VisualDensity.compact,
                ),
                SizedBox(width: 4),
                Text(
                  '무료',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // 🔹 가격 + 추가 혜택
            Row(
              children: [
                Text(
                  '30회 기준 회당 ',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                Text(
                  '${trainer.price}원',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: const Color(0xFFFFF3E0),
                  ),
                  child: const Text(
                    '+추가혜택',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // 🔹 위치
            Row(
              children: const [
                Icon(Icons.location_on, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  'KT&G 스포테라 | 삼성역 도보 4분',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
