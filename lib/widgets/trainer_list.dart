import 'package:flutter/material.dart';
import '../models/trainer_model.dart';
import 'lesson_card.dart';

class TrainerList extends StatelessWidget {
  final List<Trainer> trainers;

  /// ✅ 강사 클릭 시 실행할 콜백
  final Function(Trainer)? onTapTrainer;

  const TrainerList({Key? key, required this.trainers, this.onTapTrainer})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: trainers.length,
      itemBuilder: (context, index) {
        final trainer = trainers[index];
        return GestureDetector(
          onTap: () {
            if (onTapTrainer != null) {
              onTapTrainer!(trainer);
            }
          },
          child: LessonCard(trainer: trainer),
        );
      },
    );
  }
}
