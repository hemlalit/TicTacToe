import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/provider/room_data_provider.dart';
import 'package:tictactoe/resources/socket_methods.dart';
import 'package:tictactoe/views/gameboard.dart';
import 'package:tictactoe/views/scoreboard.dart';
import 'package:tictactoe/views/waiting_lobby.dart';

class GameScreen extends StatefulWidget {
  static String routeName = '/game';
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final SocketMethods _socketMethods = SocketMethods();
  @override
  void initState() {
    super.initState();
    _socketMethods.updateRoomListner(context);
    _socketMethods.updatePlayersStateListner(context);
    _socketMethods.incrementPointListner(context);
    _socketMethods.endGameListner(context);
  }

  @override
  Widget build(BuildContext context) {
    RoomDataProvider roomDataProvider = Provider.of<RoomDataProvider>(context);

    return Scaffold(
        body: roomDataProvider.roomData['isJoin']
            ? const WaitingLobby()
            : SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Scoreboard(),
                    const Gameboard(),
                    Text(
                      '${roomDataProvider.roomData['turn']['nickname']}\'s turn',
                      style: const TextStyle(fontSize: 30),
                    )
                  ],
                ),
              ));
  }
}
