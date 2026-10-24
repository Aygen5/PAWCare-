import 'package:flutter_test/flutter_test.dart';
import 'package:paw_care/main.dart';

void main() {
  testWidgets(
    'PawCare App renders successfully and navigates from welcome to home',
    (WidgetTester tester) async {
      await tester.pumpWidget(const PawCareApp(enableSplash: false));
      await tester.pump();

      // Karşılama ekranının (WelcomeScreen) ilk açılışta geldiğini doğrular
      expect(find.byType(PawCareApp), findsOneWidget);
      expect(find.text('PawCare'), findsWidgets);
      expect(find.text('Köpek Sahibi Olarak Başla'), findsOneWidget);

      // Köpek sahibi demo seçimine tıklar
      final ownerCardFinder = find.text('Köpek Sahibi Olarak Başla');
      await tester.ensureVisible(ownerCardFinder);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(ownerCardFinder);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Ana sayfaya (OwnerHomeScreen) geçildiğini doğrular
      expect(find.textContaining('Aygen'), findsWidgets);
    },
  );
}
