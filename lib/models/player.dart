import 'package:tictactoe_flutter/models/board.dart';
import 'package:tictactoe_flutter/models/play_strategy.dart';

abstract class Player {
  CellState get markType;

  int makeAMove(Board board);
}

class HumanPlayer extends Player {
  @override
  final CellState markType;

  HumanPlayer(this.markType) {
    if (markType == CellState.empty) {
      throw InvalidMarkTypeException(markType, [CellState.x, CellState.o]);
    }
  }

  @override
  int makeAMove(Board board) {
    return -1;
  }
}

class ComputerPlayer extends Player {
  @override
  final CellState markType;
  final PlayStrategy playStrategy;

  ComputerPlayer(this.markType, this.playStrategy) {
    if (markType == CellState.empty) {
      throw InvalidMarkTypeException(markType, [CellState.x, CellState.o]);
    }
  }

  @override
  int makeAMove(Board board) {
    return playStrategy.makeAMove(board);
  }
}

class InvalidMarkTypeException implements Exception {
  final CellState markType;
  final List<CellState> allowedMarkTypes;

  InvalidMarkTypeException(this.markType, this.allowedMarkTypes);

  @override
  String toString() {
    return 'Invalid mark type was chosen: $markType, allowed: $allowedMarkTypes';
  }
}
