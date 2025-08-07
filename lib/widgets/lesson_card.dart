import 'package:flutter/material.dart';
import '../models/trainer_model.dart';

class LessonCard extends StatelessWidget {
  final Trainer trainer;

  const LessonCard({required this.trainer, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading:
            trainer.imageUrls.isNotEmpty
                ? Image.network(
                  trainer.imageUrls[0],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
                : Icon(Icons.person),
        title: Text(trainer.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(trainer.location), Text('${trainer.price}원/1시간')],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(trainer.type, style: TextStyle(fontWeight: FontWeight.bold)),
            Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
