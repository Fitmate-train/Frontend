import 'package:my_project_name/models/trainer_model.dart';

final List<Trainer> dummyTrainers = [
  Trainer(
    name: 'A 트레이너',
    location: '서대문구, 마포구 수업',
    price: 20000,
    type: '크로스핏',
    imageUrls: ['assets/trainer1.jpg', 'assets/trainer2.jpg'],
    reviewCount: 5,
    intro: '전문 크로스핏 트레이너입니다.',
    firstLessonRate: 0.8,
    tags: ['PT', '크로스핏'], // ✅ 추가
  ),
  Trainer(
    name: 'B 트레이너',
    location: '서대문구, 마포구 수업',
    price: 30000,
    type: '크로스핏',
    imageUrls: ['assets/trainer1.jpg', 'assets/trainer2.jpg'],
    reviewCount: 10,
    intro: '10년 경력의 트레이너입니다.',
    firstLessonRate: 0.9,
    tags: ['PT', '크로스핏'],
  ),
  Trainer(
    name: 'C 트레이너',
    location: '서대문구, 마포구 수업',
    price: 30000,
    type: 'PT',
    imageUrls: ['assets/trainer1.jpg', 'assets/trainer2.jpg'],
    reviewCount: 3,
    intro: '근육 증량에 특화된 PT 수업.',
    firstLessonRate: 1.0,
    tags: ['PT'],
  ),
];
