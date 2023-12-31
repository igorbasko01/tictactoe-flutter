import 'dart:math';

import 'package:tictactoe_flutter/models/board.dart';

abstract class PlayStrategy {
  int makeAMove(Board board);
}

class RandomPlayStrategy implements PlayStrategy {
  @override
  int makeAMove(Board board) {
    var emptyIndexedCells = board.cells.indexed
        .where((cell) => cell.$2 == CellState.empty)
        .toList();
    var random = Random();
    var randomIndex = random.nextInt(emptyIndexedCells.length);
    var randomEmptyCell = emptyIndexedCells[randomIndex].$1;
    return randomEmptyCell;
  }
}

class MinimaxPlayStrategy implements PlayStrategy {
  final CellState playerMarkType;
  final int maxDepth;

  MinimaxPlayStrategy({this.playerMarkType = CellState.x, this.maxDepth = 3});

  @override
  int makeAMove(Board board) {
    var movesTree = buildMovesTree(board, playerMarkType, depth: maxDepth);
    var bestMove = chooseBestMove(movesTree.nextMoves);
    if (bestMove == null) {
      throw MoveNotFoundException('No best move found');
    }
    return bestMove.index;
  }

  List<Move> possibleNextMoves(Board board, CellState markType) {
    var emptyIndexedCells = board.cells.indexed
        .where((cell) => cell.$2 == CellState.empty)
        .toList();
    var moves =
        emptyIndexedCells.map((cell) => Move(cell.$1, markType)).toList();
    return moves;
  }

  MovesTree buildMovesTree(Board board, CellState markType,
      {int depth = 0, Move? latestMove}) {
    if (board.isWinner(markType.opposite())) {
      // checking win for previous player, because for current player
      // we will know after calculating its possible moves.
      // If previous player won, then no reason to continue calculating next moves.
      var score = boardScore(board, playerMarkType);
      return MovesTree(board, [], score, score, score, latestMove: latestMove);
    }
    if (depth == 0) {
      var score = boardScore(board, playerMarkType);
      return MovesTree(board, [], score, score, score, latestMove: latestMove);
    } else {
      var moves = possibleNextMoves(board, markType);
      var movesTrees = moves.map((move) {
        var newBoard = board.copy();
        newBoard.setCell(move.index, move.markType);
        return buildMovesTree(newBoard, markType.opposite(),
            depth: depth - 1, latestMove: move);
      }).toList();
      var topScore = _maxScore(movesTrees);
      var worstScore = _minScore(movesTrees);
      var movesTree = MovesTree(board, movesTrees,
          boardScore(board, playerMarkType), topScore, worstScore,
          latestMove: latestMove);
      return movesTree;
    }
  }

  int boardScore(Board board, CellState markType) {
    if (board.isWinner(markType)) {
      return 1;
    } else if (board.isWinner(markType.opposite())) {
      return -1;
    } else {
      return 0;
    }
  }

  Move? chooseBestMove(List<MovesTree> boardStates) {
    if (boardStates.isEmpty) {
      return null;
    }
    var noLoosingBranches = boardStates.where((movesTree) {
      return movesTree.worstMoveScore != -1;
    }).toList();

    if (noLoosingBranches.isEmpty) {
      return boardStates.first.latestMove;
    }

    var maxScore = _maxScore(noLoosingBranches);
    var bestState = noLoosingBranches
        .firstWhere((movesTree) => movesTree.bestMoveScore == maxScore);
    return bestState.latestMove;
  }

  int _maxScore(List<MovesTree> boardStates) {
    if (boardStates.isEmpty) {
      return 0;
    }
    return boardStates
        .map((movesTree) => movesTree.bestMoveScore)
        .reduce((value, element) => max(value, element));
  }

  int _minScore(List<MovesTree> boardStates) {
    if (boardStates.isEmpty) {
      return 0;
    }
    return boardStates
        .map((movesTree) => movesTree.worstMoveScore)
        .reduce((value, element) => min(value, element));
  }
}

class MovesTree {
  final Board currentBoard;
  final List<MovesTree> nextMoves;
  final int currentBoardScore;
  final int bestMoveScore;
  final int worstMoveScore;
  final Move? latestMove;

  MovesTree(this.currentBoard, this.nextMoves, this.currentBoardScore,
      this.bestMoveScore, this.worstMoveScore,
      {this.latestMove});
}

class Move {
  final int index;
  final CellState markType;

  Move(this.index, this.markType) {
    if (index < 0 || index > 8) {
      throw InvalidMoveIndexException(index);
    }
    if (markType == CellState.empty) {
      throw InvalidMoveMarkTypeException(
          'Cannot make a move with empty mark type');
    }
  }
}

class InvalidMoveIndexException implements Exception {
  final int index;

  InvalidMoveIndexException(this.index);

  @override
  String toString() {
    return 'Invalid move index: $index';
  }
}

class InvalidMoveMarkTypeException implements Exception {
  final String message;

  InvalidMoveMarkTypeException(this.message);

  @override
  String toString() {
    return 'Invalid move mark type: $message';
  }
}

class MoveNotFoundException implements Exception {
  final String message;

  MoveNotFoundException(this.message);

  @override
  String toString() {
    return 'Move not found: $message';
  }
}
