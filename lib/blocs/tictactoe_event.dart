import 'package:tictactoe_flutter/models/board.dart';

abstract class TicTacToeEvent {}

class StartGameTicTacToeEvent extends TicTacToeEvent {}

class MakeAMoveTicTacToeEvent extends TicTacToeEvent {
  final int cellIndex;
  final CellState markType;

  MakeAMoveTicTacToeEvent(this.cellIndex, this.markType);
}