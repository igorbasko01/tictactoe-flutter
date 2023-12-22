import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictactoe_flutter/blocs/tictactoe_bloc.dart';
import 'package:tictactoe_flutter/blocs/tictactoe_event.dart';
import 'package:tictactoe_flutter/blocs/tictactoe_state.dart';
import 'package:tictactoe_flutter/models/board.dart';
import 'package:tictactoe_flutter/models/player.dart';
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

  testWidgets('initial state of screen contains a Start Game button',
      (widgetTester) async {
    when(() => mockTicTacToeBloc!.state).thenReturn(TicTacToeInitialState());
    await widgetTester.pumpWidget(MaterialApp(
      home: BlocProvider<TicTacToeBloc>.value(
        value: mockTicTacToeBloc!,
        child: const BoardScreen(),
      ),
    ));
    var startGameButtonFinder = find.byKey(const Key('startGameButton'));
    expect(startGameButtonFinder, findsOneWidget);
  });

  testWidgets('tapping the Start Game button invokes a StartGameTicTacToeEvent',
      (widgetTester) async {
    when(() => mockTicTacToeBloc!.state).thenReturn(TicTacToeInitialState());
    await widgetTester.pumpWidget(MaterialApp(
      home: BlocProvider<TicTacToeBloc>.value(
        value: mockTicTacToeBloc!,
        child: const BoardScreen(),
      ),
    ));
    var startGameButtonFinder = find.byKey(const Key('startGameButton'));
    await widgetTester.tap(startGameButtonFinder);
    verify(() => mockTicTacToeBloc!.add(StartGameTicTacToeEvent()));
  });

  testWidgets('board screen contains a grid when in PlayerTurnTicTacToeEvent',
      (widgetTester) async {
    when(() => mockTicTacToeBloc!.state).thenReturn(
        PlayerTurnTicTacToeState(Board(), HumanPlayer(CellState.x)));
    await widgetTester.pumpWidget(MaterialApp(
        home: BlocProvider<TicTacToeBloc>.value(
      value: mockTicTacToeBloc!,
      child: const BoardScreen(),
    )));
    var gridFinder = find.byKey(const Key('boardGrid'));
    expect(gridFinder, findsOneWidget);
  });

  testWidgets('board screen shows a start new game button on game ending',
      (widgetTester) async {
    when(() => mockTicTacToeBloc!.state)
        .thenReturn(GameOverTicTacToeState(Board(), BoardCondition.xWins));
    await widgetTester.pumpWidget(MaterialApp(
      home: BlocProvider<TicTacToeBloc>.value(
        value: mockTicTacToeBloc!,
        child: const BoardScreen(),
      ),
    ));
    var startNewGameButtonFinder = find.byKey(const Key('startGameButton'));
    expect(startNewGameButtonFinder, findsOneWidget);
  });

  testWidgets(
      'board screen allows tapping on an empty cell and invoke a make a move event',
      (widgetTester) async {
    when(() => mockTicTacToeBloc!.state).thenReturn(
        PlayerTurnTicTacToeState(Board(), HumanPlayer(CellState.x)));
    await widgetTester.pumpWidget(MaterialApp(
      home: BlocProvider<TicTacToeBloc>.value(
          value: mockTicTacToeBloc!, child: const BoardScreen()),
    ));
    var cellFinder = find.byKey(const Key('cell_0'));
    await widgetTester.tap(cellFinder);
    verify(
        () => mockTicTacToeBloc!.add(MakeAMoveTicTacToeEvent(0, CellState.x)));
  });

  testWidgets('board screen disables tapping on the board at game ending state',
      (widgetTester) async {
    when(() => mockTicTacToeBloc!.state)
        .thenReturn(GameOverTicTacToeState(Board(), BoardCondition.xWins));
    await widgetTester.pumpWidget(MaterialApp(
      home: BlocProvider<TicTacToeBloc>.value(
        value: mockTicTacToeBloc!,
        child: const BoardScreen(),
      ),
    ));
    var cellFinder = find.byKey(const Key('cell_0'));
    await widgetTester.tap(cellFinder);
    verifyNever(
        () => mockTicTacToeBloc!.add(MakeAMoveTicTacToeEvent(0, CellState.x)));
  });

  testWidgets('tapping occupied cell should display the error from the bloc',
      (widgetTester) async {
    var board = Board();
    board.setCell(0, CellState.x);
    when(() => mockTicTacToeBloc!.state)
        .thenReturn(PlayerTurnTicTacToeState(board, HumanPlayer(CellState.x)));
    await widgetTester.pumpWidget(MaterialApp(
      home: BlocProvider<TicTacToeBloc>.value(
        value: mockTicTacToeBloc!,
        child: const BoardScreen(),
      ),
    ));

    var cellFinder = find.byKey(const Key('cell_0'));
    await widgetTester.tap(cellFinder);
    await widgetTester.pump();
    var errorFinder = find.byKey(const Key('message'));
    expect(errorFinder, findsOneWidget);
  });

  testWidgets('board screen shows that x won when x wins',
      (widgetTester) async {
    var board = Board();
    board.setCell(0, CellState.x);
    board.setCell(1, CellState.o);
    board.setCell(3, CellState.x);
    board.setCell(2, CellState.o);
    board.setCell(6, CellState.x);
    when(() => mockTicTacToeBloc!.state)
        .thenReturn(GameOverTicTacToeState(board, BoardCondition.xWins));
    await widgetTester.pumpWidget(MaterialApp(
      home: BlocProvider<TicTacToeBloc>.value(
        value: mockTicTacToeBloc!,
        child: const BoardScreen(),
      ),
    ));
    var messageFinder = find.byKey(const Key('message'));
    expect(messageFinder, findsOneWidget);
    var messageTextFinder = find.text('X wins');
    expect(messageTextFinder, findsOneWidget);
  });

  testWidgets('board screen shows that o won when o wins',
      (widgetTester) async {
    var board = Board();
    board.setCell(6, CellState.x);
    board.setCell(0, CellState.o);
    board.setCell(4, CellState.x);
    board.setCell(1, CellState.o);
    board.setCell(5, CellState.x);
    board.setCell(2, CellState.o);
    when(() => mockTicTacToeBloc!.state)
        .thenReturn(GameOverTicTacToeState(board, BoardCondition.oWins));
    await widgetTester.pumpWidget(MaterialApp(
      home: BlocProvider<TicTacToeBloc>.value(
        value: mockTicTacToeBloc!,
        child: const BoardScreen(),
      ),
    ));
    var messageFinder = find.byKey(const Key('message'));
    expect(messageFinder, findsOneWidget);
    var messageTextFinder = find.text('O wins');
    expect(messageTextFinder, findsOneWidget);
  });

  testWidgets('board screen shows that it is a draw when it is a draw',
      (widgetTester) async {
    var board = Board();
    board.setCell(0, CellState.x);
    board.setCell(1, CellState.o);
    board.setCell(3, CellState.x);
    board.setCell(4, CellState.o);
    board.setCell(7, CellState.x);
    board.setCell(6, CellState.o);
    board.setCell(2, CellState.x);
    board.setCell(5, CellState.o);
    board.setCell(8, CellState.x);
    when(() => mockTicTacToeBloc!.state)
        .thenReturn(GameOverTicTacToeState(board, BoardCondition.draw));
    await widgetTester.pumpWidget(MaterialApp(
      home: BlocProvider<TicTacToeBloc>.value(
        value: mockTicTacToeBloc!,
        child: const BoardScreen(),
      ),
    ));
    var messageFinder = find.byKey(const Key('message'));
    expect(messageFinder, findsOneWidget);
    var messageTextFinder = find.text('Draw');
    expect(messageTextFinder, findsOneWidget);
  });
}
