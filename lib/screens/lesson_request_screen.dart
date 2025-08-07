import 'package:flutter/material.dart';
import '../widgets/reference_summary_card.dart';
import '../widgets/question_step.dart';
import '../widgets/message_input_box.dart';

class LessonRequestScreen extends StatefulWidget {
  @override
  _LessonRequestScreenState createState() => _LessonRequestScreenState();
}

class _LessonRequestScreenState extends State<LessonRequestScreen> {
  int currentStep = 0;
  String requestMessage = '';

  List<String> selectedGoals = [];
  String selectedTime = '';

  void _submitRequest() {
    if (requestMessage.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('요청 메시지를 입력해주세요.')));
      return;
    }
    // TODO: 여기에 서버 전송 로직 추가
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('요청 완료'),
            content: Text('트레이너에게 요청이 전송되었습니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('확인'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('수업 요청하기')),
      body: Column(
        children: [
          ReferenceSummaryCard(
            onEdit: () {
              Navigator.pushNamed(context, '/onboarding');
            },
          ),
          Expanded(
            child: Stepper(
              currentStep: currentStep,
              onStepContinue: () {
                if (currentStep < 2) {
                  setState(() => currentStep += 1);
                }
              },
              onStepCancel: () {
                if (currentStep > 0) {
                  setState(() => currentStep -= 1);
                }
              },
              steps: [
                Step(
                  title: Text('PT 목적'),
                  content: QuestionStep(
                    title: 'PT 목적은 무엇인가요?',
                    options: ['근력 강화', '체중 감량', '체형 교정'],
                    selectedOptions: selectedGoals,
                    onChanged:
                        (selected) => setState(() => selectedGoals = selected),
                  ),
                ),
                Step(
                  title: Text('희망 시간대'),
                  content: QuestionStep(
                    title: '수업을 원하는 시간대는?',
                    options: ['오전', '오후', '저녁'],
                    selectedOptions: [selectedTime],
                    onChanged:
                        (selected) =>
                            setState(() => selectedTime = selected.first),
                    isSingleChoice: true,
                  ),
                ),
                Step(
                  title: Text('요청 메시지'),
                  content: MessageInputBox(
                    onChanged: (val) => setState(() => requestMessage = val),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _submitRequest,
              child: Text('수업 요청 보내기'),
              style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
            ),
          ),
        ],
      ),
    );
  }
}
