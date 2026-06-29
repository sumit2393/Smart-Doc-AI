import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_doc_ai/main.dart';

void main() {
  testWidgets('app shows the splash screen branding on launch', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Smart Doc AI'), findsOneWidget);
    expect(find.text('Scan • Extract • Analyze'), findsOneWidget);
  });
}
