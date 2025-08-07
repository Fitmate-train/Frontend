import 'package:flutter/material.dart';
import '../models/trainer_model.dart';

class LessonCard extends StatelessWidget {
  final Trainer trainer;

  const LessonCard({required this.trainer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            _buildTrainerImage(trainer.imageUrls.first),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trainer.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(trainer.intro),
                  Text('${trainer.price}원'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainerImage(String imagePath) {
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(imagePath, width: 100, height: 100, fit: BoxFit.cover);
    }
  }
}
