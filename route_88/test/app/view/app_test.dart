import 'package:flutter_test/flutter_test.dart';
import 'package:route_88/app/app.dart';
import 'package:route_88/features/home/view/home_page.dart';

void main() {
  group('App', () {
    testWidgets('renders HomePage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
