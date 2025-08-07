import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_project_name/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // 수정: MyApp → FitMateApp 또는 실제 클래스명
    await tester.pumpWidget(FitMateApp());

    // 아래는 MyApp이 기본으로 제공하던 카운터 예제용 테스트입니다.
    // FitMateApp에 해당 위젯이 없으면 이 테스트는 의미가 없습니다.

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
