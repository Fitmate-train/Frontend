import 'package:flutter/material.dart';

class MessageInputBox extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const MessageInputBox({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 4,
      maxLength: 100,
      decoration: InputDecoration(
        hintText: '예: 복부 중심 운동과 체형 교정을 도와주실 트레이너님을 찾고 있어요.',
        border: OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }
}
