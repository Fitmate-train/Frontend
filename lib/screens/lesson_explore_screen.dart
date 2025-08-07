import 'package:flutter/material.dart';
import '../models/trainer_model.dart';
import '../widgets/lesson_card.dart';
import '../widgets/trainer_list.dart';
import '../widgets/lesson_filter_bar.dart';

class LessonExploreScreen extends StatefulWidget {
  final List<Trainer> trainers;
  const LessonExploreScreen({required this.trainers, super.key});

  @override
  State<LessonExploreScreen> createState() => _LessonExploreScreenState();
}

class _LessonExploreScreenState extends State<LessonExploreScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => selectedTab = _tabController.index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('수업 찾기'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Row(
            children: [
              Expanded(
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: const [
                    Tab(text: '전체'),
                    Tab(text: '헬스'),
                    Tab(text: '필라테스'),
                  ],
                ),
              ),

              /// ✅ 여기에 넣으세요!
              IconButton(
                icon: Icon(Icons.sort, color: Colors.grey),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LessonFilterBar()),
                  );

                  if (result != null) {
                    print('필터 결과: $result');
                    // TODO: 필터 적용 로직 추가
                  }
                },
              ),
            ],
          ),
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          TrainerList(trainers: widget.trainers), // 전체
          TrainerList(trainers: widget.trainers), // 헬스 필터 적용
          TrainerList(trainers: widget.trainers), // 필라테스 필터 적용
        ],
      ),
    );
  }

  // 🔹 여기 이 함수를 같이 추가해줘!
  Widget _buildCategoryChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 8),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
