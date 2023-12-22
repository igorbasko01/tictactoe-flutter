import 'package:tictactoe_flutter/models/board.dart';

abstract class TicTacToeEvent {}

class StartGameTicTacToeEvent extends TicTacToeEvent {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StartGameTicTacToeEvent && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class MakeAMoveTicTacToeEvent extends TicTacToeEvent {
  final int cellIndex;
  final CellState markType;

  MakeAMoveTicTacToeEvent(this.cellIndex, this.markType);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MakeAMoveTicTacToeEvent &&
          runtimeType == other.runtimeType &&
          cellIndex == other.cellIndex &&
          markType == other.markType;

  @override
  int get hashCode => cellIndex.hashCode ^ markType.hashCode;
}