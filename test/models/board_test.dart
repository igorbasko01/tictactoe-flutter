import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_flutter/models/board.dart';

void main() {
  group('initialize', () {
    test('board initializes with empty cells', () {
      final board = Board();
      expect(board.cells, List.filled(9, CellState.empty));
    });
  });

  group('set cell', () {
    test('sets cell to x', () {
      final board = Board();
      board.setCell(0, CellState.x);
      expect(board.cells[0], CellState.x);
    });

    test('sets cell to o', () {
      final board = Board();
      board.setCell(0, CellState.o);
      expect(board.cells[0], CellState.o);
    });

    test('throws CellInvalidIndexException when index is out of bounds', () {
      final board = Board();
      expect(() => board.setCell(-1, CellState.x),
          throwsA(isA<CellInvalidIndexException>()));
      expect(() => board.setCell(9, CellState.x),
          throwsA(isA<CellInvalidIndexException>()));
    });

    test('throws CellAlreadySetException if cell is already set', () {
      final board = Board();
      board.setCell(0, CellState.x);
      expect(() => board.setCell(0, CellState.o),
          throwsA(isA<CellAlreadySetException>()));
    });
  });

  group('reset', () {
    test('resets all cells to empty', () {
      final board = Board();
      board.setCell(0, CellState.x);
      board.setCell(1, CellState.o);
      board.setCell(2, CellState.x);
      board.setCell(3, CellState.o);
      board.setCell(4, CellState.x);
      board.setCell(5, CellState.o);
      board.setCell(6, CellState.x);
      board.setCell(7, CellState.o);
      board.setCell(8, CellState.x);
      board.reset();
      expect(board.cells, List.filled(9, CellState.empty));
    });
  });

  group('board condition', () {
    test('returns BoardCondition.StillPlaying when board is empty', () {
      final board = Board();
      expect(board.boardCondition(), BoardCondition.stillPlaying);
    });

    test(
        'returns BoardCondition.StillPlaying when board has empty cells and not end condition is met',
        () {
      final board = Board();
      board.setCell(0, CellState.x);
      board.setCell(1, CellState.o);
      board.setCell(2, CellState.x);
      board.setCell(3, CellState.o);
      board.setCell(4, CellState.x);
      board.setCell(5, CellState.o);
      expect(board.boardCondition(), BoardCondition.stillPlaying);
    });

    test('returns BoardCondition.Draw when board is full and no end condition is met', () {
      final board = Board();
      board.setCell(0, CellState.x);
      board.setCell(1, CellState.o);
      board.setCell(2, CellState.x);
      board.setCell(3, CellState.o);
      board.setCell(4, CellState.x);
      board.setCell(5, CellState.o);
      board.setCell(6, CellState.o);
      board.setCell(7, CellState.x);
      board.setCell(8, CellState.o);
      expect(board.boardCondition(), BoardCondition.draw);
    });

    test('returns BoardCondition.XWins when x wins in a row', () {
      final board = Board();
      board.setCell(0, CellState.x);
      board.setCell(3, CellState.o);
      board.setCell(1, CellState.x);
      board.setCell(4, CellState.o);
      board.setCell(2, CellState.x);
      expect(board.boardCondition(), BoardCondition.xWins);
    });

    test('returns BoardCondition.XWins when x wins in a column', () {
      final board = Board();
      board.setCell(0, CellState.x);
      board.setCell(1, CellState.o);
      board.setCell(3, CellState.x);
      board.setCell(2, CellState.o);
      board.setCell(6, CellState.x);
      expect(board.boardCondition(), BoardCondition.xWins);
    });

    test('returns BoardCondition.XWins when x wins in a diagonal', () {
      final board = Board();
      board.setCell(0, CellState.x);
      board.setCell(1, CellState.o);
      board.setCell(4, CellState.x);
      board.setCell(2, CellState.o);
      board.setCell(8, CellState.x);
      expect(board.boardCondition(), BoardCondition.xWins);
    });

    test('returns BoardCondition.OWins when o wins in a row', () {
      final board = Board();
      board.setCell(6, CellState.x);
      board.setCell(0, CellState.o);
      board.setCell(4, CellState.x);
      board.setCell(1, CellState.o);
      board.setCell(5, CellState.x);
      board.setCell(2, CellState.o);
      expect(board.boardCondition(), BoardCondition.oWins);
    });

    test('returns BoardCondition.OWins when o wins in a column', () {
      final board = Board();
      board.setCell(2, CellState.x);
      board.setCell(1, CellState.o);
      board.setCell(3, CellState.x);
      board.setCell(4, CellState.o);
      board.setCell(6, CellState.x);
      board.setCell(7, CellState.o);
      expect(board.boardCondition(), BoardCondition.oWins);
    });

    test('returns BoardCondition.OWins when o wins in a diagonal', () {
      final board = Board();
      board.setCell(1, CellState.x);
      board.setCell(0, CellState.o);
      board.setCell(2, CellState.x);
      board.setCell(4, CellState.o);
      board.setCell(6, CellState.x);
      board.setCell(8, CellState.o);
      expect(board.boardCondition(), BoardCondition.oWins);
    });
  });
}
