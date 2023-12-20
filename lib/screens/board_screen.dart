import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tictactoe_flutter/blocs/tictactoe_bloc.dart';
import 'package:tictactoe_flutter/blocs/tictactoe_event.dart';
import 'package:tictactoe_flutter/blocs/tictactoe_state.dart';

class BoardScreen extends StatelessWidget {

  const BoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicTacToeBloc, TicTacToeState>(
      builder: (blocContext, state) {
        if (state is TicTacToeInitialState) {
          return Center(
            child: ElevatedButton(key: const Key('startGameButton'), onPressed: () {
              blocContext.read<TicTacToeBloc>().add(StartGameTicTacToeEvent());
            }, child: const Text('Start Game')),
          );
        } else {
          return const Center(
            child: Text('Something went wrong.'),
          );
        }
      }
    );
  }
}