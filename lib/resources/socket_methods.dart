import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/src/socket.dart';
import 'package:tictactoe/provider/room_data_provider.dart';
import 'package:tictactoe/resources/game_methods.dart';
import 'package:tictactoe/resources/socket_client.dart';
import 'package:tictactoe/screens/create_room_screen.dart';
import 'package:tictactoe/screens/game_screen.dart';
import 'package:tictactoe/utils/utils.dart';

class SocketMethods {
  final _socketClient = SocketClient.instance.socket!;

  Socket get socketClient => _socketClient;

  // EMITS
  void createRoom(String nickname) {
    if (nickname.isNotEmpty) {
      _socketClient.emit('createRoom', {
        'nickname': nickname,
      });
    }
  }

  void joinRoom(String nickname, String roomID) {
    if (nickname.isNotEmpty || roomID.isNotEmpty) {
      _socketClient.emit('joinRoom', {
        'nickname': nickname,
        'roomID': roomID,
      });
    }
  }

  void tapGrid(int index, String roomID, List<String> displayElements) {
    if (displayElements[index] == '') {
      _socketClient.emit('tap', {
        'index': index,
        'roomID': roomID,
      });
    }
  }

  // LISTNERS
  void createRoomSuccessListner(BuildContext context) {
    _socketClient.on('createRoomSuccess', (room) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateRoomData(room);
      Navigator.pushNamed(context, GameScreen.routeName);
    });
  }

  void joinRoomSuccessListner(BuildContext context) {
    _socketClient.on('joinRoomSuccess', (room) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateRoomData(room);
      Navigator.pushNamed(context, GameScreen.routeName);
    });
  }

  void errorOccurredListner(BuildContext context) {
    _socketClient.on('errorOccurred', (data) {
      showSnackBar(context, data);
    });
  }

  void updatePlayersStateListner(BuildContext context) {
    _socketClient.on('updatePlayers', (playerData) {
      Provider.of<RoomDataProvider>(context, listen: false).updatePlayer1(
        playerData[0],
      );
      Provider.of<RoomDataProvider>(context, listen: false).updatePlayer2(
        playerData[1],
      );
    });
  }

  void updateRoomListner(BuildContext context) {
    _socketClient.on('updateRoom', (data) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateRoomData(data);
    });
  }

  void tappedListner(BuildContext context) {
    _socketClient.on('tapped', (data) {
      RoomDataProvider roomDataProvider =
          Provider.of<RoomDataProvider>(context, listen: false);

      roomDataProvider.updateDisplayElements(
        data['index'],
        data['choice'],
      );
      roomDataProvider.updateRoomData(data['room']);
      GameMethods().checkWinner(context, _socketClient);
    });
  }

  void incrementPointListner(BuildContext context) {
    socketClient.on('incrementPoint', (playerData) {
      RoomDataProvider roomDataProvider =
          Provider.of<RoomDataProvider>(context, listen: false);
      if (playerData['socketID'] ==
          roomDataProvider.player1.socketID) {
        roomDataProvider.updatePlayer1(playerData);
      } else {
        roomDataProvider.updatePlayer2(playerData);
      }
    });
  }

  void endGameListner(BuildContext context){
    socketClient.on('endGame', (playerData) {
      showGameDialogBox(context, '${playerData['nickname']} won the game!');
      Navigator.popUntil(context, (route) => false);
      Navigator.pushNamed(context, CreateRoomScreen.routeName);
    });
  }
}
