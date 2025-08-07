import 'package:flutter/material.dart';
import '../models/trainer_model.dart';
import 'lesson_card.dart';

class TrainerList extends StatelessWidget {
  final List<Trainer> trainers;

  const TrainerList({super.key, required this.trainers});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: trainers.length,
      itemBuilder: (context, index) {
        return LessonCard(trainer: trainers[index]);
      },
    );
  }
}
