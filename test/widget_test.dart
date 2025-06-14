import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:register_login/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('LoginScreen hiển thị đúng', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(MyApp(prefs: prefs));

    await tester.pumpAndSettle();

    expect(find.text('Đăng nhập'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
