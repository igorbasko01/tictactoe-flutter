class Board {
  final List<CellState> cells = List.filled(9, CellState.empty);

  void setCell(int index, CellState state) {
    if (index < 0 || index > 8) {
      throw CellInvalidIndexException(index);
    }
    if (cells[index] != CellState.empty) {
      throw CellAlreadySetException(index, cells[index]);
    }
    cells[index] = state;
  }

  void reset() {
    for (var i = 0; i < cells.length; i++) {
      cells[i] = CellState.empty;
    }
  }

  BoardCondition boardCondition() {
    if (_xWins()) {
      return BoardCondition.xWins;
    } else if (_oWins()) {
      return BoardCondition.oWins;
    } else if (_stillPlaying()) {
      return BoardCondition.stillPlaying;
    } else {
      return BoardCondition.draw;
    }
  }

  Board copy() {
    var newBoard = Board();
    for (var i = 0; i < cells.length; i++) {
      newBoard.setCell(i, cells[i]);
    }
    return newBoard;
  }

  bool _stillPlaying() {
    return cells.contains(CellState.empty);
  }

  bool _xWins() {
    return _checkRows(CellState.x) || _checkColumns(CellState.x) || _checkDiagonals(CellState.x);
  }

  bool _oWins() {
    return _checkRows(CellState.o) || _checkColumns(CellState.o) || _checkDiagonals(CellState.o);
  }

  bool _checkRows(CellState state) {
    return _checkRow(0, state) || _checkRow(3, state) || _checkRow(6, state);
  }

  bool _checkRow(int index, CellState state) {
    return cells[index] == state && cells[index + 1] == state && cells[index + 2] == state;
  }

  bool _checkColumns(CellState state) {
    return _checkColumn(0, state) || _checkColumn(1, state) || _checkColumn(2, state);
  }

  bool _checkColumn(int index, CellState state) {
    return cells[index] == state && cells[index + 3] == state && cells[index + 6] == state;
  }

  bool _checkDiagonals(CellState state) {
    return _checkLeftDiagonal(state) || _checkRightDiagonal(state);
  }

  bool _checkLeftDiagonal(CellState state) {
    return cells[0] == state && cells[4] == state && cells[8] == state;
  }

  bool _checkRightDiagonal(CellState state) {
    return cells[2] == state && cells[4] == state && cells[6] == state;
  }
}

class CellAlreadySetException implements Exception {
  final String message;

  CellAlreadySetException(int index, CellState state)
      : message = 'Cell at index $index is already set to $state';
}

class CellInvalidIndexException implements Exception {
  final String message;

  CellInvalidIndexException(int index)
      : message = 'Cell index $index is invalid';
}

enum CellState { empty, x, o }

enum BoardCondition { stillPlaying, xWins, oWins, draw }