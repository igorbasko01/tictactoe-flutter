import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_flutter/models/board.dart';
import 'package:tictactoe_flutter/models/play_strategy.dart';

void main() {
  group('minimax initialize', () {
    test('minimax strategy initialized with player mark type', () {
      final strategy = MinimaxPlayStrategy(playerMarkType: CellState.x);
      expect(strategy.playerMarkType, CellState.x);
    });

    test('minimax strategy initialized with max depth', () {
      final strategy = MinimaxPlayStrategy(maxDepth: 3);
      expect(strategy.maxDepth, 3);
    });
  });

  group('minimax possibleNextMoves', () {
    test('minimax strategy possible moves of empty board, returns 9 options',
        () {
      final strategy = MinimaxPlayStrategy();
      final board = Board();
      final moves = strategy.possibleNextMoves(board, CellState.x);
      expect(moves.length, 9);
      expect(moves[0].index, 0);
      expect(moves[0].markType, CellState.x);
      expect(moves[1].index, 1);
      expect(moves[1].markType, CellState.x);
      expect(moves[2].index, 2);
      expect(moves[2].markType, CellState.x);
      expect(moves[3].index, 3);
      expect(moves[3].markType, CellState.x);
      expect(moves[4].index, 4);
      expect(moves[4].markType, CellState.x);
      expect(moves[5].index, 5);
      expect(moves[5].markType, CellState.x);
      expect(moves[6].index, 6);
      expect(moves[6].markType, CellState.x);
      expect(moves[7].index, 7);
      expect(moves[7].markType, CellState.x);
      expect(moves[8].index, 8);
      expect(moves[8].markType, CellState.x);
    });

    test(
        'minimax strategy possible moves of a board with two moves, returns 7 options',
        () {
      final strategy = MinimaxPlayStrategy();
      final board = Board();
      board.setCell(0, CellState.x);
      board.setCell(1, CellState.o);
      final moves = strategy.possibleNextMoves(board, CellState.x);
      expect(moves.length, 7);
      expect(moves[0].index, 2);
      expect(moves[0].markType, CellState.x);
      expect(moves[1].index, 3);
      expect(moves[1].markType, CellState.x);
      expect(moves[2].index, 4);
      expect(moves[2].markType, CellState.x);
      expect(moves[3].index, 5);
      expect(moves[3].markType, CellState.x);
      expect(moves[4].index, 6);
      expect(moves[4].markType, CellState.x);
      expect(moves[5].index, 7);
      expect(moves[5].markType, CellState.x);
      expect(moves[6].index, 8);
      expect(moves[6].markType, CellState.x);
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

    test('return empty tree if the root board is full', () {
      final strategy = MinimaxPlayStrategy();
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
      final movesTree = strategy.buildMovesTree(board, CellState.o, depth: 3);
      expect(movesTree.currentBoard.cells, board.cells);
      expect(movesTree.nextMoves.length, 0);
    });

    test('score a tree with a single level starting from one step from winning',
        () {
      final strategy = MinimaxPlayStrategy();
      final board = Board();
      board.setCell(0, CellState.x);
      board.setCell(3, CellState.o);
      board.setCell(1, CellState.x);
      board.setCell(4, CellState.o);
      final movesTree = strategy.buildMovesTree(board, CellState.x, depth: 1);
      expect(movesTree.currentBoard.cells, board.cells);
      expect(movesTree.nextMoves.length, 5);
      expect(movesTree.currentBoardScore, 0);
      expect(movesTree.nextMoves[0].currentBoardScore, 1);
      expect(movesTree.nextMoves[1].currentBoardScore, 0);
      expect(movesTree.nextMoves[2].currentBoardScore, 0);
      expect(movesTree.nextMoves[3].currentBoardScore, 0);
      expect(movesTree.nextMoves[4].currentBoardScore, 0);
    });

    test('score a tree with a single level starting from one step from losing',
        () {
      final strategy = MinimaxPlayStrategy(playerMarkType: CellState.o);
      final board = Board();
      board.setCell(0, CellState.x);
      board.setCell(3, CellState.o);
      board.setCell(1, CellState.x);
      board.setCell(4, CellState.o);
      final movesTree = strategy.buildMovesTree(board, CellState.x, depth: 1);
      expect(movesTree.currentBoard.cells, board.cells);
      expect(movesTree.nextMoves.length, 5);
      expect(movesTree.currentBoardScore, 0);
      expect(movesTree.nextMoves[0].currentBoardScore, -1);
      expect(movesTree.nextMoves[1].currentBoardScore, 0);
      expect(movesTree.nextMoves[2].currentBoardScore, 0);
      expect(movesTree.nextMoves[3].currentBoardScore, 0);
      expect(movesTree.nextMoves[4].currentBoardScore, 0);
    });

    test('return empty tree if the root board is winning', () {
      final strategy = MinimaxPlayStrategy();
      final board = Board();
      board.setCell(0, CellState.x);
      board.setCell(3, CellState.o);
      board.setCell(1, CellState.x);
      board.setCell(4, CellState.o);
      board.setCell(2, CellState.x);
      final movesTree = strategy.buildMovesTree(board, CellState.o, depth: 3);
      expect(movesTree.currentBoard.cells, board.cells);
      expect(movesTree.nextMoves.length, 0);
    });

    test('return empty tree if the root board is losing', () {
      final strategy = MinimaxPlayStrategy(playerMarkType: CellState.o);
      final board = Board();
      board.setCell(0, CellState.x);
      board.setCell(3, CellState.o);
      board.setCell(1, CellState.x);
      board.setCell(4, CellState.o);
      board.setCell(2, CellState.x);
      final movesTree = strategy.buildMovesTree(board, CellState.o, depth: 3);
      expect(movesTree.currentBoard.cells, board.cells);
      expect(movesTree.nextMoves.length, 0);
    });

    test('root best board score is best of its children', () {
      final strategy = MinimaxPlayStrategy();
      final board = Board();
      board.setCell(0, CellState.x);
      board.setCell(3, CellState.o);
      board.setCell(1, CellState.x);
      board.setCell(4, CellState.o);
      final movesTree = strategy.buildMovesTree(board, CellState.x, depth: 1);
      expect(movesTree.currentBoard.cells, board.cells);
      expect(movesTree.nextMoves.length, 5);
      expect(movesTree.currentBoardScore, 0);
      expect(movesTree.nextMoves[0].currentBoardScore, 1);
      expect(movesTree.nextMoves[1].currentBoardScore, 0);
      expect(movesTree.nextMoves[2].currentBoardScore, 0);
      expect(movesTree.nextMoves[3].currentBoardScore, 0);
      expect(movesTree.nextMoves[4].currentBoardScore, 0);
      expect(movesTree.bestMoveScore, 1);
    });

    test('root best board score is best of its children, when loosing', () {
      final strategy = MinimaxPlayStrategy(playerMarkType: CellState.o);
      final board = Board();
      board.setCell(0, CellState.x);
      board.setCell(3, CellState.o);
      board.setCell(1, CellState.x);
      board.setCell(4, CellState.o);
      final movesTree = strategy.buildMovesTree(board, CellState.x, depth: 1);
      expect(movesTree.currentBoard.cells, board.cells);
      expect(movesTree.nextMoves.length, 5);
      expect(movesTree.currentBoardScore, 0);
      expect(movesTree.nextMoves[0].currentBoardScore, -1);
      expect(movesTree.nextMoves[1].currentBoardScore, 0);
      expect(movesTree.nextMoves[2].currentBoardScore, 0);
      expect(movesTree.nextMoves[3].currentBoardScore, 0);
      expect(movesTree.nextMoves[4].currentBoardScore, 0);
      expect(movesTree.bestMoveScore, 0);
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

  group('move data structure', () {
    test('initialized with index and mark type', () {
      final move = Move(0, CellState.x);
      expect(move.index, 0);
      expect(move.markType, CellState.x);
    });

    test('throws exception if initialized with invalid index', () {
      expect(() => Move(-1, CellState.x),
          throwsA(isA<InvalidMoveIndexException>()));
      expect(() => Move(9, CellState.x),
          throwsA(isA<InvalidMoveIndexException>()));
    });

    test('throws exception if initialized with empty mark type', () {
      expect(() => Move(0, CellState.empty),
          throwsA(isA<InvalidMoveMarkTypeException>()));
    });
  });

  group('latest move in MovesTree', () {
    test(
        'latest move in a node in MovesTree is the move that was made on the current board',
        () {
      final strategy = MinimaxPlayStrategy();
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
      final movesTree = strategy.buildMovesTree(board, CellState.o, depth: 3, latestMove: Move(8, CellState.x));
      expect(movesTree.currentBoard.cells, board.cells);
      expect(movesTree.nextMoves.length, 0);
      expect(movesTree.latestMove?.index, 8);
      expect(movesTree.latestMove?.markType, CellState.x);
    });

    test('latest move in root MovesTree is null', () {
      final strategy = MinimaxPlayStrategy();
      final board = Board();
      final movesTree = strategy.buildMovesTree(board, CellState.x, depth: 3);
      expect(movesTree.currentBoard.cells, board.cells);
      expect(movesTree.nextMoves.length, 9);
      expect(movesTree.latestMove, null);
    });

    test('latest move in a node in MovesTree in the next level moves are the moves that were made between the root and the next move', () {
      final strategy = MinimaxPlayStrategy();
      final board = Board();
      final movesTree = strategy.buildMovesTree(board, CellState.x, depth: 3);
      expect(movesTree.currentBoard.cells, board.cells);
      expect(movesTree.nextMoves.length, 9);
      expect(movesTree.nextMoves[0].latestMove?.index, 0);
      expect(movesTree.nextMoves[0].latestMove?.markType, CellState.x);
      expect(movesTree.nextMoves[1].latestMove?.index, 1);
      expect(movesTree.nextMoves[1].latestMove?.markType, CellState.x);
      expect(movesTree.nextMoves[2].latestMove?.index, 2);
      expect(movesTree.nextMoves[2].latestMove?.markType, CellState.x);
      expect(movesTree.nextMoves[3].latestMove?.index, 3);
      expect(movesTree.nextMoves[3].latestMove?.markType, CellState.x);
      expect(movesTree.nextMoves[4].latestMove?.index, 4);
      expect(movesTree.nextMoves[4].latestMove?.markType, CellState.x);
      expect(movesTree.nextMoves[5].latestMove?.index, 5);
      expect(movesTree.nextMoves[5].latestMove?.markType, CellState.x);
      expect(movesTree.nextMoves[6].latestMove?.index, 6);
      expect(movesTree.nextMoves[6].latestMove?.markType, CellState.x);
      expect(movesTree.nextMoves[7].latestMove?.index, 7);
      expect(movesTree.nextMoves[7].latestMove?.markType, CellState.x);
      expect(movesTree.nextMoves[8].latestMove?.index, 8);
      expect(movesTree.nextMoves[8].latestMove?.markType, CellState.x);
    });

    test('starting from first move latestMove of next moves is the difference move between the root and its nextMoves', () {
      final strategy = MinimaxPlayStrategy();
      final board = Board();
      board.setCell(0, CellState.x);
      final movesTree = strategy.buildMovesTree(board, CellState.o, depth: 3);
      expect(movesTree.currentBoard.cells, board.cells);
      expect(movesTree.nextMoves.length, 8);
      expect(movesTree.nextMoves[0].latestMove?.index, 1);
      expect(movesTree.nextMoves[0].latestMove?.markType, CellState.o);
      expect(movesTree.nextMoves[1].latestMove?.index, 2);
      expect(movesTree.nextMoves[1].latestMove?.markType, CellState.o);
      expect(movesTree.nextMoves[2].latestMove?.index, 3);
      expect(movesTree.nextMoves[2].latestMove?.markType, CellState.o);
      expect(movesTree.nextMoves[3].latestMove?.index, 4);
      expect(movesTree.nextMoves[3].latestMove?.markType, CellState.o);
      expect(movesTree.nextMoves[4].latestMove?.index, 5);
      expect(movesTree.nextMoves[4].latestMove?.markType, CellState.o);
      expect(movesTree.nextMoves[5].latestMove?.index, 6);
      expect(movesTree.nextMoves[5].latestMove?.markType, CellState.o);
      expect(movesTree.nextMoves[6].latestMove?.index, 7);
      expect(movesTree.nextMoves[6].latestMove?.markType, CellState.o);
      expect(movesTree.nextMoves[7].latestMove?.index, 8);
      expect(movesTree.nextMoves[7].latestMove?.markType, CellState.o);
    });
  });

  group('chooseBestMove', () {
    test('select the move when it is the highest score', () {
      final strategy = MinimaxPlayStrategy();
      final board = Board();
      board.setCell(0, CellState.x);
      board.setCell(1, CellState.o);
      board.setCell(4, CellState.x);
      board.setCell(2, CellState.o);
      final movesTree = strategy.buildMovesTree(board, CellState.x, depth: 1);
      final bestMove = strategy.chooseBestMove(movesTree.nextMoves);
      expect(bestMove?.index, 8);
      expect(bestMove?.markType, CellState.x);
    });

    test('return null when provided with empty list', () {
      final strategy = MinimaxPlayStrategy();
      final bestMove = strategy.chooseBestMove([]);
      expect(bestMove, null);
    });

    test('select the first move if all the moves have the same score', () {
      final strategy = MinimaxPlayStrategy();
      final board = Board();
      board.setCell(0, CellState.x);
      board.setCell(1, CellState.o);
      final movesTree = strategy.buildMovesTree(board, CellState.x, depth: 1);
      final bestMove = strategy.chooseBestMove(movesTree.nextMoves);
      expect(bestMove?.index, 2);
      expect(bestMove?.markType, CellState.x);
    });
  });

  group('makeAMove', () {
    test('makeAMove returns a move that wins the game', () {
      final strategy = MinimaxPlayStrategy();
      final board = Board();
      board.setCell(0, CellState.x);
      board.setCell(1, CellState.o);
      board.setCell(2, CellState.x);
      board.setCell(3, CellState.o);
      board.setCell(4, CellState.x);
      board.setCell(5, CellState.o);
      final move = strategy.makeAMove(board);
      expect(move, 6);
    });

    test('makeAMove throws a MoveNotFoundException if no move found', () {
      final strategy = MinimaxPlayStrategy();
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
      expect(() => strategy.makeAMove(board), throwsA(isA<MoveNotFoundException>()));
    });
  });
}
