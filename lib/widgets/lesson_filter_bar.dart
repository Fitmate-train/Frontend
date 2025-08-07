import 'package:flutter/material.dart';

class LessonFilterBar extends StatefulWidget {
  const LessonFilterBar({super.key});

  @override
  State<LessonFilterBar> createState() => _LessonFilterBarState();
}

class _LessonFilterBarState extends State<LessonFilterBar> {
  String sortOption = '기본순';
  String distance = '1km 이내';
  String gender = '전체';
  Set<String> conveniences = {};

  final List<String> distances = ['500m 이내', '1km 이내', '3km 이내'];
  final List<String> genders = ['전체', '남성', '여성'];

  void resetAll() {
    setState(() {
      sortOption = '기본순';
      distance = '1km 이내';
      gender = '전체';
      conveniences.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('정렬 / 필터'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [TextButton(onPressed: resetAll, child: const Text('초기화'))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text('정렬', style: TextStyle(fontWeight: FontWeight.bold)),
            RadioListTile<String>(
              value: '기본순',
              groupValue: sortOption,
              title: const Text('기본순'),
              onChanged: (v) => setState(() => sortOption = v!),
            ),
            RadioListTile<String>(
              value: '거리순',
              groupValue: sortOption,
              title: const Text('거리순'),
              onChanged: (v) => setState(() => sortOption = v!),
            ),
            const SizedBox(height: 20),

            const Text('검색 반경', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: distance,
              isExpanded: true,
              onChanged: (v) => setState(() => distance = v!),
              items:
                  distances
                      .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                      .toList(),
            ),
            const SizedBox(height: 20),

            const Text('선생님 성별', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: gender,
              isExpanded: true,
              onChanged: (v) => setState(() => gender = v!),
              items:
                  genders
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
            ),
            const SizedBox(height: 20),

            const Text('이용 편의', style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children:
                  ['운동복 대여', '무료 주차', '개인락커'].map((option) {
                    final isSelected = conveniences.contains(option);
                    return ChoiceChip(
                      label: Text(option),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(
                          () =>
                              isSelected
                                  ? conveniences.remove(option)
                                  : conveniences.add(option),
                        );
                      },
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'sort': sortOption,
              'distance': distance,
              'gender': gender,
              'conveniences': conveniences,
            });
          },
          child: const Text('결과 보기'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
        ),
      ),
    );
  }
}
