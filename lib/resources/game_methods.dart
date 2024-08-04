import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/provider/room_data_provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:tictactoe/utils/utils.dart';

class GameMethods {
  void checkWinner(BuildContext context, Socket socketClient) {
    RoomDataProvider roomDataProvider =
        Provider.of<RoomDataProvider>(context, listen: false);

    String winnner = '';

    //checking rows
    if (roomDataProvider.displayElements[0] ==
            roomDataProvider.displayElements[1] &&
        roomDataProvider.displayElements[0] ==
            roomDataProvider.displayElements[2] &&
        roomDataProvider.displayElements[0] != '') {
      winnner = roomDataProvider.displayElements[0];
    }
    if (roomDataProvider.displayElements[3] ==
            roomDataProvider.displayElements[4] &&
        roomDataProvider.displayElements[3] ==
            roomDataProvider.displayElements[5] &&
        roomDataProvider.displayElements[3] != '') {
      winnner = roomDataProvider.displayElements[3];
    }
    if (roomDataProvider.displayElements[6] ==
            roomDataProvider.displayElements[7] &&
        roomDataProvider.displayElements[6] ==
            roomDataProvider.displayElements[8] &&
        roomDataProvider.displayElements[6] != '') {
      winnner = roomDataProvider.displayElements[6];
    }
    // checking coloumn
    if (roomDataProvider.displayElements[0] ==
            roomDataProvider.displayElements[3] &&
        roomDataProvider.displayElements[0] ==
            roomDataProvider.displayElements[6] &&
        roomDataProvider.displayElements[0] != '') {
      winnner = roomDataProvider.displayElements[0];
    }
    if (roomDataProvider.displayElements[1] ==
            roomDataProvider.displayElements[4] &&
        roomDataProvider.displayElements[1] ==
            roomDataProvider.displayElements[7] &&
        roomDataProvider.displayElements[1] != '') {
      winnner = roomDataProvider.displayElements[1];
    }
    if (roomDataProvider.displayElements[2] ==
            roomDataProvider.displayElements[5] &&
        roomDataProvider.displayElements[2] ==
            roomDataProvider.displayElements[8] &&
        roomDataProvider.displayElements[2] != '') {
      winnner = roomDataProvider.displayElements[2];
    }
    // checking diagonals
    if (roomDataProvider.displayElements[0] ==
            roomDataProvider.displayElements[4] &&
        roomDataProvider.displayElements[0] ==
            roomDataProvider.displayElements[8] &&
        roomDataProvider.displayElements[0] != '') {
      winnner = roomDataProvider.displayElements[0];
    }
    if (roomDataProvider.displayElements[2] ==
            roomDataProvider.displayElements[4] &&
        roomDataProvider.displayElements[2] ==
            roomDataProvider.displayElements[6] &&
        roomDataProvider.displayElements[2] != '') {
      winnner = roomDataProvider.displayElements[2];
    } else if (roomDataProvider.filledBoxes == 9) {
      winnner = '';
      showGameDialogBox(context, 'Draw');
    }

    if (winnner != '') {
      if (roomDataProvider.player1.playerType == winnner) {
        showGameDialogBox(context, '${roomDataProvider.player1.nickname} won!');
        socketClient.emit('winner', {
          'winnerSocketID': roomDataProvider.player1.socketID,
          'roomID': roomDataProvider.roomData['_id'],
        });
      } else {
        showGameDialogBox(context, '${roomDataProvider.player2.nickname} won!');
        socketClient.emit('winner', {
          'winnerSocketID': roomDataProvider.player2.socketID,
          'roomID': roomDataProvider.roomData['_id'],
        });
      }
    }
  }

  void clearBoard(BuildContext context) {
    RoomDataProvider roomDataProvider =
        Provider.of<RoomDataProvider>(context, listen: false);
    for(int i = 0; i < roomDataProvider.displayElements.length; i++ ){
      roomDataProvider.updateDisplayElements(i, '');
    }
    roomDataProvider.setFilledboxesToZero();
  }
}
