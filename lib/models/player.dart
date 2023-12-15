import 'package:tictactoe_flutter/models/board.dart';

abstract class Player {
  CellState get markType;
}

class HumanPlayer extends Player {
  @override
  final CellState markType;

  HumanPlayer(this.markType) {
    if (markType == CellState.empty) {
      throw InvalidMarkTypeException(markType, [CellState.x, CellState.o]);
    }
  }
}

class ComputerPlayer extends Player {
  @override
  final CellState markType;

  ComputerPlayer(this.markType) {
    if (markType == CellState.empty) {
      throw InvalidMarkTypeException(markType, [CellState.x, CellState.o]);
    }
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
