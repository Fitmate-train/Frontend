import 'package:flutter/material.dart';
import '../models/trainer_model.dart';
import 'package:intl/intl.dart';

class LessonChatScreen extends StatefulWidget {
  const LessonChatScreen({Key? key}) : super(key: key);

  @override
  State<LessonChatScreen> createState() => _LessonChatScreenState();
}

class _LessonChatScreenState extends State<LessonChatScreen> {
  final ScrollController _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  String _fmt(DateTime t) => DateFormat('h:mm a').format(t); // 11:24 AM

  @override
  Widget build(BuildContext context) {
    final trainer = ModalRoute.of(context)!.settings.arguments as Trainer;

    final now = DateTime.now();
    final messages = <_Msg>[
      _Msg(
        false,
        '네, 안녕하세요. 어떤 점이 궁금하신가요?',
        now.subtract(const Duration(minutes: 2)),
      ),
      _Msg(
        true,
        '안녕하세요. 수업에 대해 문의드리고 싶어요.',
        now.subtract(const Duration(minutes: 14)),
      ),
      _Msg(
        true,
        '근력 운동으로 수업 받고 싶습니다.',
        now.subtract(const Duration(minutes: 1)),
      ),
    ]..sort((a, b) => a.time.compareTo(b.time));

    return Scaffold(
      appBar: AppBar(title: Text('${trainer.name} 선생님과의 채팅')),
      body: Container(
        color: const Color(0xFFF6F8FF), // 은은한 배경
        child: Column(
          children: [
            Expanded(
              child: Scrollbar(
                controller: _scroll,
                thumbVisibility: true,
                child: ListView(
                  controller: _scroll,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  children: [
                    // 기존 대화
                    ...messages.map(
                      (m) => _Bubble(
                        isUser: m.isUser,
                        text: m.text,
                        time: _fmt(m.time),
                      ),
                    ),

                    // 제안 카드(스샷 하얀 카드)
                    const SizedBox(height: 8),
                    _ProposalCard(
                      title: '트레이닝 제안',
                      dateText: DateFormat(
                        'M월 d일 (E)',
                        'ko_KR',
                      ).format(now.add(const Duration(days: 2))),
                      timeText: '오후 2:00',
                      priceText: '₩45,000',
                      onReject: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('가결 처리되었습니다.')),
                        );
                      },
                      onAccept: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('수락 완료! 예약이 확정되었습니다.')),
                        );
                        // TODO: 예약 확정 API 호출/화면 이동
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 입력창 (선택사항)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '메시지를 입력하세요',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(icon: const Icon(Icons.send), onPressed: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ----- 작은 위젯들 ----- */

class _Msg {
  final bool isUser;
  final String text;
  final DateTime time;
  _Msg(this.isUser, this.text, this.time);
}

class _Bubble extends StatelessWidget {
  final bool isUser;
  final String text;
  final String time;
  const _Bubble({required this.isUser, required this.text, required this.time});

  @override
  Widget build(BuildContext context) {
    final color = isUser ? const Color(0xFFDCE2FF) : Colors.white;
    final align = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
      bottomRight:
          isUser ? const Radius.circular(4) : const Radius.circular(16),
    );

    return Align(
      alignment: align,
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(color: color, borderRadius: radius),
            child: Text(text, style: const TextStyle(fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6, right: 6),
            child: Text(
              time,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProposalCard extends StatelessWidget {
  final String title;
  final String dateText;
  final String timeText;
  final String priceText;
  final VoidCallback onReject;
  final VoidCallback onAccept;

  const _ProposalCard({
    required this.title,
    required this.dateText,
    required this.timeText,
    required this.priceText,
    required this.onReject,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft, // 트레이너 쪽 카드처럼
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(blurRadius: 10, color: Color(0x14000000)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '트레이닝 제안',
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              dateText,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(timeText, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 6),
            Text(
              priceText,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(44),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('가결'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(44),
                      backgroundColor: const Color(0xFF2E6BFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('수락'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
