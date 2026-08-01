import 'package:encore2_gamesheet/pages/game_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Logical landscape sizes that matter for [GamePage] layout.
///
/// - [shortWithCutout]: ~OnePlus Nord 2 class (20:9, punch-hole eats left width)
/// - [shortTight]: minimum practical phone height in landscape
/// - [typicalPhone]: common ~16:9 landscape logical size
/// - [tallerPhone]: more vertical room; scoreboard should not rely on scaling
const _landscapeViewports = <({String name, Size size, EdgeInsets padding})>[
  (
    name: 'short with cutout (Nord 2 class)',
    size: Size(800, 360),
    padding: EdgeInsets.fromLTRB(48, 16, 8, 16),
  ),
  (
    name: 'short tight height',
    size: Size(780, 340),
    padding: EdgeInsets.fromLTRB(32, 16, 8, 16),
  ),
  (
    name: 'typical phone landscape',
    size: Size(844, 390),
    padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
  ),
  (
    name: 'taller phone landscape',
    size: Size(800, 500),
    padding: EdgeInsets.fromLTRB(48, 16, 8, 16),
  ),
];

void main() {
  for (final viewport in _landscapeViewports) {
    testWidgets('score and settings visible: ${viewport.name}',
        (WidgetTester tester) async {
      await _pumpGamePage(
        tester,
        size: viewport.size,
        padding: viewport.padding,
      );

      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.text('='), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}

Future<void> _pumpGamePage(
  WidgetTester tester, {
  required Size size,
  required EdgeInsets padding,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(size: size, padding: padding),
      child: MaterialApp(
        theme: ThemeData.dark(),
        home: const GamePage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
