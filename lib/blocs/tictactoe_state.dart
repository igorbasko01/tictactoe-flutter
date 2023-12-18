import 'package:tictactoe_flutter/models/board.dart';
import 'package:tictactoe_flutter/models/player.dart';

abstract class TicTacToeState {}

class TicTacToeInitialState extends TicTacToeState {}

class PlayerTurnTicTacToeState extends TicTacToeState {
  final Board board;
  final Player player;

  PlayerTurnTicTacToeState(this.board, this.player);
}