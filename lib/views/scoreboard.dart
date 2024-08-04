import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/provider/room_data_provider.dart';

class Scoreboard extends StatefulWidget {
  const Scoreboard({super.key});

  @override
  State<Scoreboard> createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> {
  @override
  Widget build(BuildContext context) {
    RoomDataProvider roomDataProvider =
        Provider.of<RoomDataProvider>(context, listen: true);

    // Debug prints to verify data
    print('Player1 Nickname: ${roomDataProvider.player1.nickname}');
    print('Player1 Points: ${roomDataProvider.player1.points}');
    print('Player2 Nickname: ${roomDataProvider.player2.nickname}');
    print('Player2 Points: ${roomDataProvider.player2.points}');

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                 roomDataProvider.player1.nickname.isNotEmpty
                    ? roomDataProvider.player1.nickname
                    : 'No Nickname',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                roomDataProvider.player1.points.toDouble().toString(),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                 roomDataProvider.player2.nickname.isNotEmpty
                    ? roomDataProvider.player2.nickname
                    : 'No Nickname',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                roomDataProvider.player2.points.toDouble().toString(),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
