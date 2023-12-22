import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_flutter/blocs/tictactoe_bloc.dart';
import 'package:tictactoe_flutter/blocs/tictactoe_event.dart';
import 'package:tictactoe_flutter/blocs/tictactoe_state.dart';
import 'package:tictactoe_flutter/models/board.dart';
import 'package:tictactoe_flutter/models/play_strategy.dart';
import 'package:tictactoe_flutter/models/player.dart';

void main() {
  group('initialize', () {
    blocTest('initialized with a board with empty cells',
        build: () => TicTacToeBloc(),
        verify: (bloc) =>
            expect(bloc.board.cells, List.filled(9, CellState.empty)));

    blocTest('accepts a UI Player during initialization',
        build: () => TicTacToeBloc(uiPlayer: HumanPlayer(CellState.x)),
        verify: (bloc) => expect(bloc.uiPlayer, isA<HumanPlayer>()));

    blocTest('accepts a Computer Player during initialization',
        build: () => TicTacToeBloc(
            computerPlayer: ComputerPlayer(CellState.o, RandomPlayStrategy())),
        verify: (bloc) => expect(bloc.computerPlayer, isA<ComputerPlayer>()));

    blocTest('empty initialization creates a HumanPlayer with CellState.x',
        build: () => TicTacToeBloc(),
        verify: (bloc) {
          expect(bloc.uiPlayer, isA<HumanPlayer>());
          expect(bloc.uiPlayer.markType, CellState.x);
        });

    blocTest('empty initialization creates a ComputerPlayer with CellState.o',
        build: () => TicTacToeBloc(),
        verify: (bloc) {
          expect(bloc.computerPlayer, isA<ComputerPlayer>());
          expect(bloc.computerPlayer.markType, CellState.o);
        });

    test(
        'throws MarkTypeAlreadyUsedException when both players have the same mark type',
        () {
      expect(
          () => TicTacToeBloc(
              uiPlayer: HumanPlayer(CellState.x),
              computerPlayer:
                  ComputerPlayer(CellState.x, RandomPlayStrategy())),
          throwsA(isA<MarkTypeAlreadyUsedException>()));
    });

    blocTest(
        'initialization with a human player sets the computer mark type to opposite',
        build: () => TicTacToeBloc(uiPlayer: HumanPlayer(CellState.x)),
        verify: (bloc) => expect(bloc.computerPlayer.markType, CellState.o));

    blocTest(
        'initialization with a computer player sets the human mark type to opposite',
        build: () => TicTacToeBloc(
            computerPlayer: ComputerPlayer(CellState.x, RandomPlayStrategy())),
        verify: (bloc) => expect(bloc.uiPlayer.markType, CellState.o));
  });

  group('on start game event', () {
    blocTest('sends human player turn event when UI player is X',
        build: () => TicTacToeBloc(uiPlayer: HumanPlayer(CellState.x)),
        act: (bloc) => bloc.add(StartGameTicTacToeEvent()),
        expect: () => [
              predicate<PlayerTurnTicTacToeState>((state) =>
                  state.board.cells.every((cell) => cell == CellState.empty) &&
                  state.player is HumanPlayer &&
                  state.player.markType == CellState.x)
            ]);

    blocTest(
        'sends human player turn event when UI player is O after computer player makes a move',
        build: () => TicTacToeBloc(uiPlayer: HumanPlayer(CellState.o)),
        act: (bloc) => bloc.add(StartGameTicTacToeEvent()),
        expect: () => [
              predicate<PlayerTurnTicTacToeState>((state) {
                // Computer made a move
                int numberOfEmptyCells = state.board.cells
                    .where((cell) => cell == CellState.empty)
                    .length;
                return numberOfEmptyCells == 8 &&
                    state.player is HumanPlayer &&
                    state.player.markType == CellState.o;
              })
            ]);

    blocTest('Clears the board when a new game starts',
        build: () {
          var board = Board();
          board.setCell(0, CellState.x);
          board.setCell(1, CellState.o);
          board.setCell(2, CellState.x);
          return TicTacToeBloc(board: board, uiPlayer: HumanPlayer(CellState.x));
        },
        act: (bloc) => bloc.add(StartGameTicTacToeEvent()),
        verify: (bloc) =>
            expect(bloc.board.cells, List.filled(9, CellState.empty)));
  });

  group('on ui player makes a move', () {
    blocTest('ui player makes the first move',
        build: () => TicTacToeBloc(uiPlayer: HumanPlayer(CellState.x)),
        act: (bloc) {
          bloc.add(MakeAMoveTicTacToeEvent(0, CellState.x));
        },
        expect: () => [
              predicate<PlayerTurnTicTacToeState>((state) {
                return state.board.cells[0] == CellState.x &&
                    // It should be the ui player, as the computer move is done inside the bloc
                    state.player is HumanPlayer &&
                    state.player.markType == CellState.x;
              })
            ]);

    blocTest('ui player is the second to start and make a move',
        build: () {
          var board = Board();
          // computer's move
          board.setCell(0, CellState.x);
          return TicTacToeBloc(
              board: board, uiPlayer: HumanPlayer(CellState.o));
        },
        act: (bloc) {
          bloc.add(MakeAMoveTicTacToeEvent(1, CellState.o));
        },
        expect: () => [
              predicate<PlayerTurnTicTacToeState>((state) {
                var numberOfEmptyCells = state.board.cells
                    .where((cell) => cell == CellState.empty)
                    .length;
                // Expected number of move is 6 because computer should have made two moves:
                // 1. First move is the one in the setup (computer)
                // 2. Second move is the one in the act (player)
                // 3. Third move is the one happens as part of the MakeAMove event (computer)
                return numberOfEmptyCells == 6 &&
                    state.player is HumanPlayer &&
                    state.player.markType == CellState.o;
              })
            ]);

    blocTest(
        'get an error state when the ui player tries to make a move on an occupied cell',
        build: () {
          var board = Board();
          board.setCell(0, CellState.x);
          board.setCell(1, CellState.o);
          return TicTacToeBloc(
              board: board, uiPlayer: HumanPlayer(CellState.x));
        },
        act: (bloc) {
          bloc.add(MakeAMoveTicTacToeEvent(0, CellState.x));
        },
        expect: () => [
              predicate<ErrorTicTacToeState>((state) {
                return state.message == 'Cell is already taken';
              })
            ]);

    blocTest('return win state when ui player makes a winning move',
        build: () {
          var board = Board();
          board.setCell(0, CellState.x);
          board.setCell(3, CellState.o);
          board.setCell(1, CellState.x);
          board.setCell(4, CellState.o);
          return TicTacToeBloc(
              board: board, uiPlayer: HumanPlayer(CellState.x));
        },
        act: (bloc) {
          bloc.add(MakeAMoveTicTacToeEvent(2, CellState.x));
        },
        expect: () => [
              predicate<GameOverTicTacToeState>((state) {
                return state.board.cells[2] == CellState.x &&
                    state.boardCondition == BoardCondition.xWins;
              })
            ]);

    blocTest('return draw state when ui player makes a draw move',
        build: () {
          var board = Board();
          board.setCell(0, CellState.x);
          board.setCell(1, CellState.o);
          board.setCell(3, CellState.x);
          board.setCell(4, CellState.o);
          board.setCell(7, CellState.x);
          board.setCell(6, CellState.o);
          board.setCell(2, CellState.x);
          board.setCell(5, CellState.o);
          return TicTacToeBloc(
              board: board, uiPlayer: HumanPlayer(CellState.x));
        },
        act: (bloc) {
          bloc.add(MakeAMoveTicTacToeEvent(8, CellState.x));
        },
        expect: () => [
              predicate<GameOverTicTacToeState>((state) {
                return state.board.cells[8] == CellState.x &&
                    state.boardCondition == BoardCondition.draw;
              })
            ]);

    blocTest('return win state when computer player makes a winning move',
        build: () {
          var board = Board();
          board.setCell(0, CellState.x);
          board.setCell(3, CellState.o);
          board.setCell(8, CellState.x);
          board.setCell(4, CellState.o);
          board.setCell(2, CellState.x);
          return TicTacToeBloc(
              board: board, uiPlayer: HumanPlayer(CellState.x));
        },
        act: (bloc) {
          bloc.add(MakeAMoveTicTacToeEvent(5, CellState.o));
        },
        expect: () => [
              predicate<GameOverTicTacToeState>((state) {
                return state.board.cells[5] == CellState.o &&
                    state.boardCondition == BoardCondition.oWins;
              })
            ]);
  });
}
