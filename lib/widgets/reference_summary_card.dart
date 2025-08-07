import 'package:flutter/material.dart';

class ReferenceSummaryCard extends StatelessWidget {
  final VoidCallback onEdit;

  const ReferenceSummaryCard({required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('💡 홈트 위주 + 복부비만 체형에게 적합한 트레이너를 찾고 있어요.'),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              Chip(label: Text('여성')),
              Chip(label: Text('20대')),
              Chip(label: Text('홈트 선호')),
              Chip(label: Text('복부비만')),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: onEdit, child: Text('정보 수정하기')),
          ),
        ],
      ),
    );
  }
}
