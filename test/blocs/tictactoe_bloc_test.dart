import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_flutter/blocs/tictactoe_bloc.dart';
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
  });
}
