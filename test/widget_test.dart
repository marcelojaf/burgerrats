import 'package:flutter_test/flutter_test.dart';

import 'package:burgerrats/main.dart';

void main() {
  testWidgets('App renders home page', (WidgetTester tester) async {
    await tester.pumpWidget(const BurgerRatsApp());

    expect(find.text('BurgerRats'), findsOneWidget);
    expect(find.text('Welcome to BurgerRats!'), findsOneWidget);
  });
}
