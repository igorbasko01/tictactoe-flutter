import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_flutter/models/board.dart';
import 'package:tictactoe_flutter/models/play_strategy.dart';

void main() {
  group('minimax possibleMoves', () {
    test('minimax strategy possible moves of empty board, returns 9 options', () {
      final strategy = MinimaxPlayStrategy();
      final board = Board();
      final moves = strategy.possibleMoves(board, CellState.x);
      expect(moves.length, 9);
      expect(moves[0].cells[0], CellState.x);
      expect(moves[1].cells[1], CellState.x);
      expect(moves[2].cells[2], CellState.x);
      expect(moves[3].cells[3], CellState.x);
      expect(moves[4].cells[4], CellState.x);
      expect(moves[5].cells[5], CellState.x);
      expect(moves[6].cells[6], CellState.x);
      expect(moves[7].cells[7], CellState.x);
      expect(moves[8].cells[8], CellState.x);
    });

    test('minimax strategy possible moves of a board with two moves, returns 7 options', () {
      final strategy = MinimaxPlayStrategy();
      final board = Board();
      board.setCell(0, CellState.x);
      board.setCell(1, CellState.o);
      final moves = strategy.possibleMoves(board, CellState.x);
      expect(moves.length, 7);
      expect(moves[0].cells[0], CellState.x);
      expect(moves[0].cells[1], CellState.o);
      expect(moves[0].cells[2], CellState.x);
      expect(moves[1].cells[3], CellState.x);
      expect(moves[2].cells[4], CellState.x);
      expect(moves[3].cells[5], CellState.x);
      expect(moves[4].cells[6], CellState.x);
      expect(moves[5].cells[7], CellState.x);
      expect(moves[6].cells[8], CellState.x);
    });
  });

  group('build moves tree solution', () {
    test('build tree with single level for empty board', () {
      final strategy = MinimaxPlayStrategy();
      final board = Board();
      final movesTree = strategy.buildMovesTree(board, CellState.x, depth: 1);
      expect(movesTree.currentBoard.cells, board.cells);
      expect(movesTree.nextMoves.length, 9);
      expect(movesTree.nextMoves[0].currentBoard.cells[0], CellState.x);
      expect(movesTree.nextMoves[1].currentBoard.cells[1], CellState.x);
      expect(movesTree.nextMoves[2].currentBoard.cells[2], CellState.x);
      expect(movesTree.nextMoves[3].currentBoard.cells[3], CellState.x);
      expect(movesTree.nextMoves[4].currentBoard.cells[4], CellState.x);
      expect(movesTree.nextMoves[5].currentBoard.cells[5], CellState.x);
      expect(movesTree.nextMoves[6].currentBoard.cells[6], CellState.x);
      expect(movesTree.nextMoves[7].currentBoard.cells[7], CellState.x);
      expect(movesTree.nextMoves[8].currentBoard.cells[8], CellState.x);
    });

    test('build tree with single level for first single move board', () {
      final strategy = MinimaxPlayStrategy();
      final board = Board();
      board.setCell(0, CellState.x);
      board.setCell(1, CellState.o);
      final movesTree = strategy.buildMovesTree(board, CellState.x, depth: 1);
      expect(movesTree.currentBoard.cells, board.cells);
      expect(movesTree.nextMoves.length, 7);
      expect(movesTree.nextMoves[0].currentBoard.cells[0], CellState.x);
      expect(movesTree.nextMoves[0].currentBoard.cells[1], CellState.o);
      expect(movesTree.nextMoves[0].currentBoard.cells[2], CellState.x);
      expect(movesTree.nextMoves[1].currentBoard.cells[3], CellState.x);
      expect(movesTree.nextMoves[2].currentBoard.cells[4], CellState.x);
      expect(movesTree.nextMoves[3].currentBoard.cells[5], CellState.x);
      expect(movesTree.nextMoves[4].currentBoard.cells[6], CellState.x);
      expect(movesTree.nextMoves[5].currentBoard.cells[7], CellState.x);
      expect(movesTree.nextMoves[6].currentBoard.cells[8], CellState.x);
    });

    test('build tree with 3 levels of moves starting from empty board', () {
      final strategy = MinimaxPlayStrategy();
      final board = Board();
      final movesTree = strategy.buildMovesTree(board, CellState.x, depth: 3);
      expect(movesTree.currentBoard.cells, board.cells);
      expect(movesTree.nextMoves.length, 9);
      expect(movesTree.nextMoves[0].nextMoves.length, 8);
      expect(movesTree.nextMoves[0].nextMoves[0].nextMoves.length, 7);
    });
  });

  group('board score', () {
    test('board score for empty board is 0', () {
      final strategy = MinimaxPlayStrategy();
      final board = Board();
      final score = strategy.boardScore(board, CellState.x);
      expect(score, 0);
    });

    test('board score for board with x winning row is 1', () {
      final strategy = MinimaxPlayStrategy();
      final board = Board();
      board.setCell(0, CellState.x);
      board.setCell(1, CellState.x);
      board.setCell(2, CellState.x);
      final score = strategy.boardScore(board, CellState.x);
      expect(score, 1);
    });

    test('board score for board with o winning row is -1', () {
      final strategy = MinimaxPlayStrategy();
      final board = Board();
      board.setCell(0, CellState.o);
      board.setCell(1, CellState.o);
      board.setCell(2, CellState.o);
      final score = strategy.boardScore(board, CellState.x);
      expect(score, -1);
    });

    test('board score for board that is still in play is 0', () {
      final strategy = MinimaxPlayStrategy();
      final board = Board();
      board.setCell(0, CellState.x);
      board.setCell(1, CellState.o);
      board.setCell(2, CellState.x);
      final score = strategy.boardScore(board, CellState.x);
      expect(score, 0);
    });

    test('board score for a draw is 0', () {
      final strategy = MinimaxPlayStrategy();
      final board = Board();
      board.setCell(0, CellState.x);
      board.setCell(1, CellState.o);
      board.setCell(2, CellState.x);
      board.setCell(3, CellState.x);
      board.setCell(4, CellState.o);
      board.setCell(5, CellState.o);
      board.setCell(6, CellState.o);
      board.setCell(7, CellState.x);
      board.setCell(8, CellState.x);
      final score = strategy.boardScore(board, CellState.x);
      expect(score, 0);
    });
  });
}