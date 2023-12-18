import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tictactoe_flutter/blocs/tictactoe_event.dart';
import 'package:tictactoe_flutter/blocs/tictactoe_state.dart';
import 'package:tictactoe_flutter/models/board.dart';
import 'package:tictactoe_flutter/models/play_strategy.dart';
import 'package:tictactoe_flutter/models/player.dart';

class TicTacToeBloc extends Bloc<TicTacToeEvent, TicTacToeState> {
  final Board board;
  final HumanPlayer uiPlayer;
  final ComputerPlayer computerPlayer;

  TicTacToeBloc(
      {Board? board, HumanPlayer? uiPlayer, ComputerPlayer? computerPlayer})
      : board = board ?? Board(),
        uiPlayer = uiPlayer ??
            HumanPlayer(computerPlayer == null
                ? CellState.x
                : computerPlayer.markType.opposite()),
        computerPlayer = computerPlayer ??
            ComputerPlayer(
                uiPlayer == null ? CellState.o : uiPlayer.markType.opposite(),
                RandomPlayStrategy()),
        super(TicTacToeInitialState()) {
    if (this.uiPlayer.markType == this.computerPlayer.markType) {
      throw MarkTypeAlreadyUsedException();
    }
    on<StartGameTicTacToeEvent>(_onStartGame);
  }

  void _onStartGame(StartGameTicTacToeEvent event, Emitter<TicTacToeState> emit) {
    if (uiPlayer.markType == CellState.x) {
      emit(PlayerTurnTicTacToeState(board, uiPlayer));
    } else {
      var move = computerPlayer.makeAMove(board);
      board.setCell(move, computerPlayer.markType);
      emit(PlayerTurnTicTacToeState(board, uiPlayer));
    }
  }
}

class MarkTypeAlreadyUsedException implements Exception {
  final String message;

  MarkTypeAlreadyUsedException({this.message = 'Mark type already used'});

  @override
  String toString() {
    return message;
  }
}
