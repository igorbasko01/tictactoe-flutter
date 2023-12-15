import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe_flutter/models/board.dart';
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

    test('human player throws invalid mark type exception when initialized with CellState.empty', () {
      expect(() => HumanPlayer(CellState.empty),
          throwsA(isA<InvalidMarkTypeException>()));
    });

    test('computer player initialized with CellState.x', () {
      final player = ComputerPlayer(CellState.x);
      expect(player.markType, CellState.x);
    });

    test('computer player initialized with CellState.o', () {
      final player = ComputerPlayer(CellState.o);
      expect(player.markType, CellState.o);
    });

    test('computer player throws invalid mark type exception when initialized with CellState.empty', () {
      expect(() => ComputerPlayer(CellState.empty),
          throwsA(isA<InvalidMarkTypeException>()));
    });
  });
}