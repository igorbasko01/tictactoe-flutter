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

  MinimaxPlayStrategy({this.playerMarkType = CellState.x});

  @override
  int makeAMove(Board board) {
    return 0;
  }

  List<Board> possibleMoves(Board board, CellState markType) {
    var emptyIndexedCells = board.cells.indexed
        .where((cell) => cell.$2 == CellState.empty)
        .toList();
    var moves = emptyIndexedCells.map((cell) {
      var newBoard = board.copy();
      newBoard.setCell(cell.$1, markType);
      return newBoard;
    }).toList();
    return moves;
  }

  MovesTree buildMovesTree(Board board, CellState markType, {int depth = 0}) {
    if (board.isWinner(markType.opposite())) {
      // checking win for previous player, because for current player
      // we will know after calculating its possible moves.
      // If previous player won, then no reason to continue calculating next moves.
      return MovesTree(board, [], boardScore(board, playerMarkType));
    }
    if (depth == 0) {
      return MovesTree(board, [], boardScore(board, playerMarkType));
    } else {
      var moves = possibleMoves(board, markType);
      var movesTrees = moves
          .map((move) =>
              buildMovesTree(move, markType.opposite(), depth: depth - 1))
          .toList();
      var movesTree =
          MovesTree(board, movesTrees, boardScore(board, playerMarkType));
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
}

class MovesTree {
  final Board currentBoard;
  final List<MovesTree> nextMoves;
  final int currentBoardScore;

  MovesTree(this.currentBoard, this.nextMoves, this.currentBoardScore);
}
