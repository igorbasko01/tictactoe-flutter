import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tictactoe_flutter/blocs/tictactoe_bloc.dart';
import 'package:tictactoe_flutter/blocs/tictactoe_event.dart';
import 'package:tictactoe_flutter/blocs/tictactoe_state.dart';
import 'package:tictactoe_flutter/models/board.dart';

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
        return _inAspectRatio(_board(state.board));
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

  Widget _board(Board board) {
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
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: TextButton(
            onPressed: () {},
            child: Text(board.cells[index].toString()),
          ),
        );
      },
    );
  }

  Widget _gameOver(
      Board board, BoardCondition boardCondition, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(boardCondition.toString()),
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
