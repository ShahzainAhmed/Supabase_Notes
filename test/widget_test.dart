import 'package:flutter_test/flutter_test.dart';

import 'package:supabase_project/main.dart';

void main() {
  testWidgets('Auth screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Supabase Auth'), findsOneWidget);
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Login'), findsWidgets);
    expect(find.text('Sign Up'), findsOneWidget);
  });
}
