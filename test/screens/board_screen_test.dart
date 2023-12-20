import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictactoe_flutter/blocs/tictactoe_bloc.dart';
import 'package:tictactoe_flutter/blocs/tictactoe_event.dart';
import 'package:tictactoe_flutter/blocs/tictactoe_state.dart';
import 'package:tictactoe_flutter/models/board.dart';
import 'package:tictactoe_flutter/screens/board_screen.dart';

class MockTicTacToeBloc extends MockBloc<TicTacToeEvent, TicTacToeState>
    implements TicTacToeBloc {}

void main() {
  MockTicTacToeBloc? mockTicTacToeBloc;

  setUp(() {
    mockTicTacToeBloc = MockTicTacToeBloc();
  });

  tearDown(() {
    mockTicTacToeBloc?.close();
  });

  group('first time tests, should be moved out of the group when correctly implemented', () {
    testWidgets('board screen contains a grid of 3x3', (widgetTester) async {
      await widgetTester.pumpWidget(const MaterialApp(
        home: BoardScreen(),
      ));
      var gridFinder = find.byKey(const Key('boardGrid'));
      expect(gridFinder, findsOneWidget);
    });

    testWidgets('board screen shows a start new game button on game ending',
            (widgetTester) async {
          await widgetTester.pumpWidget(const MaterialApp(
            home: BoardScreen(),
          ));
          var startNewGameButtonFinder = find.byKey(const Key('startNewGameButton'));
          expect(startNewGameButtonFinder, findsOneWidget);
        });

    testWidgets(
        'board screen allows tapping on an empty cell and invoke a make a move event',
            (widgetTester) async {
          await widgetTester.pumpWidget(const MaterialApp(
            home: BoardScreen(),
          ));
          var cellFinder = find.byKey(const Key('cell_0'));
          await widgetTester.tap(cellFinder);
          verify(() => mockTicTacToeBloc!.add(MakeAMoveTicTacToeEvent(0, CellState.x)));
        });

    testWidgets('board screen disables tapping on the board at game ending state',
            (widgetTester) async {
          await widgetTester.pumpWidget(const MaterialApp(
            home: BoardScreen(),
          ));
          var cellFinder = find.byKey(const Key('cell_0'));
          await widgetTester.tap(cellFinder);
          verify(() => mockTicTacToeBloc!.add(MakeAMoveTicTacToeEvent(0, CellState.x)));
        });

    testWidgets('board screen shows that x won when x wins',
            (widgetTester) async {
        });

    testWidgets('board screen shows that o won when o wins',
            (widgetTester) async {
        });

    testWidgets('board screen shows that it is a draw when it is a draw',
            (widgetTester) async {
        });
  }, skip: true);
}
