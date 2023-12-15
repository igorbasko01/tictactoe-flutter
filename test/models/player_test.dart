import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_flutter/models/board.dart';
import 'package:tictactoe_flutter/models/play_strategy.dart';
import 'package:tictactoe_flutter/models/player.dart';

void main() {
  group('initialize', () {
    test('human player initialized with CellState.x', () {
      final player = HumanPlayer(CellState.x);
      expect(player.markType, CellState.x);
    });

    test('human player initialized with CellState.o', () {
      final player = HumanPlayer(CellState.o);
      expect(player.markType, CellState.o);
    });

    test(
        'human player throws invalid mark type exception when initialized with CellState.empty',
        () {
      expect(() => HumanPlayer(CellState.empty),
          throwsA(isA<InvalidMarkTypeException>()));
    });

    test('computer player initialized with CellState.x', () {
      final player = ComputerPlayer(CellState.x, RandomPlayStrategy());
      expect(player.markType, CellState.x);
    });

    test('computer player initialized with CellState.o', () {
      final player = ComputerPlayer(CellState.o, RandomPlayStrategy());
      expect(player.markType, CellState.o);
    });

    test(
        'computer player throws invalid mark type exception when initialized with CellState.empty',
        () {
      expect(() => ComputerPlayer(CellState.empty, RandomPlayStrategy()),
          throwsA(isA<InvalidMarkTypeException>()));
    });

    test('computer player initialized with RandomPlayStrategy', () {
      final player = ComputerPlayer(CellState.x, RandomPlayStrategy());
      expect(player.playStrategy, isA<RandomPlayStrategy>());
    });
  });

  group('human player makeAMove', () {
    test('human player makeAMove always returns -1', () {
      final player = HumanPlayer(CellState.x);
      final board = Board();
      final move = player.makeAMove(board);
      expect(move, -1);
    });
  });

  group('computer player makeAMove random strategy', () {
    test('computer player makeAMove returns a random move', () {
      final player = ComputerPlayer(CellState.x, RandomPlayStrategy());
      final board = Board();
      final move = player.makeAMove(board);
      expect(move, inInclusiveRange(0, 8));
    });

    test(
        'computer player makeAMove returns a random move that is not on an occupied cell',
        () {
      final player = ComputerPlayer(CellState.x, RandomPlayStrategy());
      final board = Board();
      board.setCell(0, CellState.x);
      board.setCell(1, CellState.o);
      board.setCell(2, CellState.x);
      board.setCell(3, CellState.o);
      board.setCell(4, CellState.x);
      board.setCell(5, CellState.o);
      board.setCell(6, CellState.x);
      board.setCell(7, CellState.o);
      final move = player.makeAMove(board);
      expect(move, 8);
    });

    test(
        'computer player makeAMove returns a random move that is not on an occupied cell',
        () {
      final player = ComputerPlayer(CellState.x, RandomPlayStrategy());
      final board = Board();
      board.setCell(0, CellState.x);
      board.setCell(1, CellState.o);
      board.setCell(2, CellState.x);
      board.setCell(3, CellState.o);
      board.setCell(4, CellState.x);
      board.setCell(5, CellState.o);
      board.setCell(6, CellState.x);
      final move = player.makeAMove(board);
      expect(move, inInclusiveRange(7, 8));
    });
  });

  group('computer player makeAMove MiniMax strategy', () {
    test('computer player makeAMove returns a move that wins the game', () {
      final player = ComputerPlayer(CellState.x, MinimaxPlayStrategy());
      final board = Board();
      board.setCell(0, CellState.x);
      board.setCell(1, CellState.o);
      board.setCell(2, CellState.x);
      board.setCell(3, CellState.o);
      board.setCell(4, CellState.x);
      board.setCell(5, CellState.o);
      final move = player.makeAMove(board);
      expect(move, 8);
    });

    test(
        'computer player makeAMove returns a move that blocks the opponent from winning',
        () {
      final player = ComputerPlayer(CellState.x, MinimaxPlayStrategy());
      final board = Board();
      board.setCell(0, CellState.x);
      board.setCell(1, CellState.o);
      board.setCell(2, CellState.x);
      board.setCell(3, CellState.o);
      final move = player.makeAMove(board);
      expect(move, 5);
    });

    test(
        'computer player makeAMove returns a move that blocks the opponent from winning',
        () {
      final player = ComputerPlayer(CellState.x, MinimaxPlayStrategy());
      final board = Board();
      board.setCell(0, CellState.x);
      board.setCell(1, CellState.o);
      board.setCell(2, CellState.x);
      board.setCell(3, CellState.o);
      board.setCell(4, CellState.x);
      board.setCell(5, CellState.o);
      board.setCell(6, CellState.x);
      final move = player.makeAMove(board);
      expect(move, 7);
    });

    test(
        'computer player makeAMove returns a move that blocks the opponent from winning',
        () {
      final player = ComputerPlayer(CellState.x, MinimaxPlayStrategy());
      final board = Board();
      board.setCell(0, CellState.x);
      board.setCell(1, CellState.o);
      board.setCell(2, CellState.x);
      board.setCell(3, CellState.o);
      board.setCell(4, CellState.x);
      board.setCell(5, CellState.o);
      board.setCell(6, CellState.x);
      board.setCell(7, CellState.o);
      final move = player.makeAMove(board);
      expect(move, 8);
    });
  });
}
