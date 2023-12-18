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
  });
}
