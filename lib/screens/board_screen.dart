import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tictactoe_flutter/blocs/tictactoe_bloc.dart';
import 'package:tictactoe_flutter/blocs/tictactoe_event.dart';
import 'package:tictactoe_flutter/blocs/tictactoe_state.dart';
import 'package:tictactoe_flutter/models/board.dart';
import 'package:tictactoe_flutter/models/player.dart';

class BoardScreen extends StatelessWidget {
  const BoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicTacToeBloc, TicTacToeState>(
        builder: (blocContext, state) {
      if (state is TicTacToeInitialState) {
        return Center(
          child: ElevatedButton(
              key: const Key('startGameButton'),
              onPressed: () {
                blocContext
                    .read<TicTacToeBloc>()
                    .add(StartGameTicTacToeEvent());
              },
              child: const Text('Start Game')),
        );
      } else if (state is PlayerTurnTicTacToeState) {
        return _inAspectRatio(_boardWithMessage(state.board,
            currentPlayer: state.player, message: state.errorMessage));
      } else if (state is GameOverTicTacToeState) {
        return _inAspectRatio(
            _gameOver(state.board, state.boardCondition, blocContext));
      } else {
        return const Center(
          child: Text('Something went wrong.'),
        );
      }
    });
  }

  Widget _inAspectRatio(Widget child) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: child,
      ),
    );
  }

  Widget _board(Board board, {Player? currentPlayer}) {
    return GridView.builder(
      key: const Key('boardGrid'),
      itemCount: board.cells.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        return Container(
          key: Key('cell_$index'),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: TextButton(
            onPressed: () {
              if (currentPlayer != null) {
                BlocProvider.of<TicTacToeBloc>(context).add(
                    MakeAMoveTicTacToeEvent(index, currentPlayer.markType));
              }
            },
            child: Text(board.cells[index].toString()),
          ),
        );
      },
    );
  }

  Widget _boardWithMessage(Board board,
      {Player? currentPlayer, String? message}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(message ?? '', key: const Key('message'),),
        Expanded(child: _board(board, currentPlayer: currentPlayer)),
      ],
    );
  }

  Widget _gameOver(
      Board board, BoardCondition boardCondition, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(boardCondition.toString(), key: const Key('message'),),
          ElevatedButton(
            key: const Key('startGameButton'),
            onPressed: () {
              BlocProvider.of<TicTacToeBloc>(context)
                  .add(StartGameTicTacToeEvent());
            },
            child: const Text('Start New Game'),
          ),
          Expanded(child: _board(board)),
        ],
      ),
    );
  }
}
