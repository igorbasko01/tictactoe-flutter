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

  TicTacToeBloc({Board? board, HumanPlayer? uiPlayer, ComputerPlayer? computerPlayer})
      : board = board ?? Board(),
        uiPlayer = uiPlayer ?? HumanPlayer(CellState.x),
        computerPlayer = computerPlayer ?? ComputerPlayer(CellState.o, RandomPlayStrategy()),
        super(TicTacToeInitialState());
}