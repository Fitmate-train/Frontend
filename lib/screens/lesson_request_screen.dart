import 'package:flutter/material.dart';

class LessonRequestScreen extends StatefulWidget {
  const LessonRequestScreen({Key? key}) : super(key: key);

  @override
  State<LessonRequestScreen> createState() => _LessonRequestScreenState();
}

/* =========================
   모델/타입
========================= */
class ChatItem {
  final bool isUser; // true: 사용자 말풍선, false: 시스템(안내/질문)
  final String text;
  ChatItem({required this.isUser, required this.text});
}

enum QuestionType { single, multi, text, range }

class StepQuestion {
  final String id;
  final String title;
  final QuestionType type;
  final List<String> options; // text/range 타입은 사용 안 함
  final bool required;
  StepQuestion({
    required this.id,
    required this.title,
    required this.type,
    this.options = const [],
    this.required = true,
  });
}

/* =========================
   화면
========================= */
class _LessonRequestScreenState extends State<LessonRequestScreen> {
  // 질문 정의 (원하면 옵션 쉽게 바꿀 수 있게 구성)
  final List<StepQuestion> steps = [
    StepQuestion(
      id: 'category',
      title: '어떤 운동을 원하시나요?',
      type: QuestionType.multi,
      options: ['크로스핏', '웨이트', '필라테스', '요가', '복싱', '러닝/마라톤', '기타'],
    ),
    StepQuestion(
      id: 'region',
      title: '지역을 선택해주세요.',
      type: QuestionType.multi,
      // ★ 필요에 맞게 교체하세요
      options: ['서대문구', '마포구', '강남구', '강서구', '온라인'],
    ),
    StepQuestion(
      id: 'gender',
      title: '트레이너 성별 선호가 있나요?',
      type: QuestionType.single,
      options: ['상관없음', '남성', '여성'],
    ),
    StepQuestion(
      id: 'type',
      title: '수업 유형을 선택해주세요.',
      type: QuestionType.single,
      options: ['개인', '그룹'],
    ),
    StepQuestion(
      id: 'time',
      title: '수업 시간대는 언제가 좋나요?',
      type: QuestionType.single,
      options: ['오전', '오후'], // 요청대로 오전/오후만
    ),
    StepQuestion(
      id: 'price',
      title: '수업료 범위를 입력해주세요. (회당, 원)',
      type: QuestionType.range, // 최소/최대
    ),
    StepQuestion(
      id: 'wish',
      title: '희망사항을 적어주세요. (예: 여성 전용, 주 2회, 홈트 가능 등)',
      type: QuestionType.text,
    ),
    StepQuestion(
      id: 'desc',
      title: '수업 설명을 자유롭게 작성해주세요.',
      type: QuestionType.text,
      required: false,
    ),
  ];

  // 진행 상태
  int stepIndex = 0;
  double get progress => ((stepIndex) / (steps.length)).clamp(0.0, 1.0); // 0~1

  // 채팅(질문/답 전부 남김)
  final List<ChatItem> chat = [];

  // 선택 임시 상태
  final Set<String> _tempMulti = {};
  String _tempSingle = '';
  final TextEditingController _minCtrl = TextEditingController();
  final TextEditingController _maxCtrl = TextEditingController();
  final TextEditingController _textCtrl = TextEditingController();

  // 최종 답변
  final Map<String, dynamic> answers =
      {}; // id -> List<String> / String / {min,max}

  // 스크롤
  final ScrollController _scroll = ScrollController();
  void _autoScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOut,
      );
    });
  }

  /* ============ 초기 ============ */
  @override
  void initState() {
    super.initState();
    // 상단 안내 + 첫 질문을 채팅에 추가
    chat.add(
      ChatItem(isUser: false, text: '몇 가지 정보만 알려주시면\n평균 4개 이상의 견적을 받을 수 있어요.'),
    );
    _pushQuestionToChat();

    _minCtrl.addListener(_onRangeChanged);
    _maxCtrl.addListener(_onRangeChanged);
    _textCtrl.addListener(_onTextChanged); // ← 추가
  }

  void _onTextChanged() {
    if (mounted) setState(() {}); // ← 텍스트 바뀔 때마다 버튼 상태 갱신
  }

  void _onRangeChanged() {
    // 금액 입력 시마다 버튼 활성화 여부 재계산을 위한 리빌드
    if (mounted) setState(() {});
  }

  bool get _rangeValid {
    final min = int.tryParse(_minCtrl.text.trim());
    final max = int.tryParse(_maxCtrl.text.trim());
    return min != null && max != null && min > 0 && max > 0 && min <= max;
  }

  @override
  void dispose() {
    _minCtrl.removeListener(_onRangeChanged);
    _maxCtrl.removeListener(_onRangeChanged);
    _textCtrl.removeListener(_onTextChanged);

    _minCtrl.dispose();
    _maxCtrl.dispose();
    _textCtrl.dispose();
    _scroll.dispose();
    super.dispose();
    // 안전 차원에서 컨트롤러 정리
  }

  /* ============ 채팅/단계 진행 ============ */
  void _pushQuestionToChat() {
    // 현재 질문을 시스템 말풍선으로 남김
    if (stepIndex < steps.length) {
      chat.add(ChatItem(isUser: false, text: steps[stepIndex].title));
      _autoScroll();
    }
  }

  void _sendUserAnswerAndNext(String userText, dynamic valueToSave) {
    // 사용자 답변 말풍선 + 저장 + 다음 질문
    setState(() {
      chat.add(ChatItem(isUser: true, text: userText));
      final id = steps[stepIndex].id;
      answers[id] = valueToSave;

      // 다음 단계로
      stepIndex += 1;

      // 다음 질문(있으면) 채팅에 추가
      if (stepIndex < steps.length) {
        chat.add(ChatItem(isUser: false, text: steps[stepIndex].title));
      }
      // 임시 상태 클리어
      _tempMulti.clear();
      _tempSingle = '';
      _textCtrl.clear();
      _minCtrl.clear();
      _maxCtrl.clear();
    });
    _autoScroll();
  }

  /* ============ 제출 ============ */
  void _submitAll() {
    // 여기서 서버로 보낼 answers를 확인/전송
    // print(answers);
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('요청 완료'),
            content: const Text('트레이너에게 요청이 전송되었습니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ],
          ),
    );
  }

  /* ============ 하단 패널 - 질문별 렌더링 ============ */
  Widget _buildBottomPanel() {
    if (stepIndex >= steps.length) {
      // 모든 단계 끝 → 요약 + 전송 버튼
      return _SummaryPanel(answers: answers, onSubmit: _submitAll);
    }

    final q = steps[stepIndex];

    // 공통 카드 컨테이너 (오버플로우 방지: 높이 제한 + 내부 스크롤)
    Widget wrapCard(Widget child) {
      final maxHeight = MediaQuery.of(context).size.height * 0.60; // 카드 최대높이
      return SafeArea(
        top: false,
        child: Container(
          constraints: BoxConstraints(maxHeight: maxHeight),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12)],
          ),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: child,
        ),
      );
    }

    switch (q.type) {
      case QuestionType.single:
        return wrapCard(
          _SingleSelectCard(
            title: q.title,
            options: q.options,
            value: _tempSingle,
            onChanged: (v) => setState(() => _tempSingle = v),
            onNext:
                _tempSingle.isEmpty
                    ? null
                    : () => _sendUserAnswerAndNext(_tempSingle, _tempSingle),
          ),
        );
      case QuestionType.multi:
        return wrapCard(
          _MultiSelectCard(
            title: q.title,
            options: q.options,
            values: _tempMulti,
            onToggle:
                (opt) => setState(() {
                  _tempMulti.contains(opt)
                      ? _tempMulti.remove(opt)
                      : _tempMulti.add(opt);
                }),
            onNext:
                _tempMulti.isEmpty
                    ? null
                    : () => _sendUserAnswerAndNext(
                      _tempMulti.join(', '),
                      _tempMulti.toList(),
                    ),
          ),
        );
      case QuestionType.text:
        return wrapCard(
          _TextInputCard(
            title: q.title,
            controller: _textCtrl,
            onNext:
                q.required && _textCtrl.text.trim().isEmpty
                    ? null
                    : () => _sendUserAnswerAndNext(
                      _textCtrl.text.trim(),
                      _textCtrl.text.trim(),
                    ),
          ),
        );
      case QuestionType.range:
        return wrapCard(
          _RangeInputCard(
            title: q.title,
            minCtrl: _minCtrl,
            maxCtrl: _maxCtrl,
            onNext: () {
              final min = int.parse(_minCtrl.text.trim());
              final max = int.parse(_maxCtrl.text.trim());
              _sendUserAnswerAndNext('${min} ~ ${max}원', {
                'min': min,
                'max': max,
              });
            },
            isEnabled: _rangeValid,
          ),
        );
    }
  }

  /* ============ 빌드 ============ */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('퍼스널트레이닝(PT)'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(value: progress),
        ),
      ),
      body: Column(
        children: [
          // 채팅 영역 (질문/답 전부 남음) + 스크롤바
          Expanded(
            child: Scrollbar(
              controller: _scroll,
              thumbVisibility: true,
              child: ListView.builder(
                controller: _scroll,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: chat.length,
                itemBuilder: (context, index) {
                  final item = chat[index];
                  return Align(
                    alignment:
                        item.isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color:
                            item.isUser
                                ? const Color(0xFF6C47FF)
                                : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        item.text,
                        style: TextStyle(
                          color: item.isUser ? Colors.white : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // 하단 질문 카드 / 요약+전송
          _buildBottomPanel(),
        ],
      ),
    );
  }
}

/* =========================
   카드 위젯들
========================= */

class _SingleSelectCard extends StatelessWidget {
  final String title;
  final List<String> options;
  final String value;
  final ValueChanged<String> onChanged;
  final VoidCallback? onNext;

  const _SingleSelectCard({
    Key? key,
    required this.title,
    required this.options,
    required this.value,
    required this.onChanged,
    required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _QuestionTitle(title: title),
        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (context, i) {
                final opt = options[i];
                final selected = value == opt;
                return InkWell(
                  onTap: () => onChanged(opt),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            selected
                                ? const Color(0xFF6C47FF)
                                : Colors.grey[300]!,
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: selected ? const Color(0xFFF3EEFF) : Colors.white,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          size: 22,
                          color:
                              selected ? const Color(0xFF6C47FF) : Colors.grey,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            opt,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        _NextButton(onNext: onNext),
      ],
    );
  }
}

class _MultiSelectCard extends StatelessWidget {
  final String title;
  final List<String> options;
  final Set<String> values;
  final ValueChanged<String> onToggle;
  final VoidCallback? onNext;

  const _MultiSelectCard({
    Key? key,
    required this.title,
    required this.options,
    required this.values,
    required this.onToggle,
    required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _QuestionTitle(title: title),
        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (context, i) {
                final opt = options[i];
                final selected = values.contains(opt);
                return InkWell(
                  onTap: () => onToggle(opt),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            selected
                                ? const Color(0xFF6C47FF)
                                : Colors.grey[300]!,
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: selected ? const Color(0xFFF3EEFF) : Colors.white,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selected
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          size: 22,
                          color:
                              selected ? const Color(0xFF6C47FF) : Colors.grey,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            opt,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        _NextButton(onNext: onNext),
      ],
    );
  }
}

class _TextInputCard extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final VoidCallback? onNext;

  const _TextInputCard({
    Key? key,
    required this.title,
    required this.controller,
    required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _QuestionTitle(title: title),
        Expanded(
          child: SingleChildScrollView(
            child: TextField(
              controller: controller,
              minLines: 3,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: '자유롭게 입력해주세요',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _NextButton(onNext: onNext),
      ],
    );
  }
}

class _RangeInputCard extends StatelessWidget {
  final String title;
  final TextEditingController minCtrl;
  final TextEditingController maxCtrl;
  final VoidCallback onNext;
  final bool isEnabled;

  const _RangeInputCard({
    Key? key,
    required this.title,
    required this.minCtrl,
    required this.maxCtrl,
    required this.onNext,
    required this.isEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _QuestionTitle(title: title),
        Expanded(
          child: ListView(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: minCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: '최소 금액',
                        hintText: '예) 30000',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: maxCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: '최대 금액',
                        hintText: '예) 60000',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text('숫자만 입력해 주세요. (예: 35000)'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _NextButton(onNext: isEnabled ? onNext : null),
      ],
    );
  }
}

/* =========================
   요약 + 제출
========================= */
class _SummaryPanel extends StatelessWidget {
  final Map<String, dynamic> answers;
  final VoidCallback onSubmit;
  const _SummaryPanel({Key? key, required this.answers, required this.onSubmit})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    String pretty(dynamic v) {
      if (v is List) return v.join(', ');
      if (v is Map && v.containsKey('min')) {
        return '${v['min']} ~ ${v['max']}원';
      }
      return '$v';
    }

    final items = [
      ['운동종류', answers['category']],
      ['지역', answers['region']],
      ['트레이너 성별', answers['gender']],
      ['수업유형', answers['type']],
      ['수업시간대', answers['time']],
      ['수업료 범위', answers['price']],
      ['희망사항', answers['wish']],
      ['수업설명', answers['desc']],
    ];

    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12)],
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '요청 내용 확인',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 8),
                  itemBuilder: (context, i) {
                    final label = items[i][0] as String;
                    final value = items[i][1];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 90,
                          child: Text(
                            label,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            value == null ? '-' : pretty(value),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onSubmit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: const Color(0xFF6C47FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('수업 요청 보내기', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* =========================
   공통 위젯
========================= */

class _QuestionTitle extends StatelessWidget {
  final String title;
  const _QuestionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  final VoidCallback? onNext;
  const _NextButton({Key? key, required this.onNext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onNext,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          backgroundColor: const Color(0xFF6C47FF),
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('다음', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
