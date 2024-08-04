import 'package:flutter/material.dart';
import 'package:tictactoe/resources/socket_methods.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_textfield.dart';

class JoinRoomScreen extends StatefulWidget {
  static String routeName = '/join-room';
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gameIDController = TextEditingController();
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {
    super.initState();
    _socketMethods.joinRoomSuccessListner(context);
    _socketMethods.errorOccurredListner(context);
    _socketMethods.updatePlayersStateListner(context);
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _gameIDController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomText(
              shadows: [
                Shadow(
                  blurRadius: 15,
                  color: Colors.blue,
                )
              ],
              text: 'Join Room',
              fontSize: 70,
            ),
            SizedBox(height: size * 0.08),
            CustomTextfield(
              controller: _nameController,
              hintText: 'Enter nickName',
            ),
            const SizedBox(height: 20),
            CustomTextfield(
              controller: _gameIDController,
              hintText: 'Enter gameID',
            ),
            SizedBox(height: size * 0.04),
            CustomButton(
              onTap: () => _socketMethods.joinRoom(
                  _nameController.text, _gameIDController.text),
              text: 'Join',
            )
          ],
        ),
      ),
    );
  }
}
