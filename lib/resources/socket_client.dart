import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketClient{
  io.Socket? socket;
  static SocketClient? _instance;

  SocketClient._internal(){ // http://192.168.43.39:3000
    socket = io.io("http://192.168.30.39:3000", <String, dynamic> {
    'transports' : ['websocket'],
    'autoConnect' : false,
    });
    socket!.connect();
  }

  static SocketClient get instance{
    _instance ??= SocketClient._internal();
    return _instance!;
  }
}