import 'package:flutter/material.dart';
import 'package:tictactoe/resources/socket_methods.dart';
import 'package:tictactoe/widgets/custom_button.dart';
import 'package:tictactoe/widgets/custom_text.dart';
import 'package:tictactoe/widgets/custom_textfield.dart';

class CreateRoomScreen extends StatefulWidget {
  static String routeName = '/create-room';
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {
    super.initState();
    _socketMethods.createRoomSuccessListner(context);
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
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
              text: 'Create Room',
              fontSize: 70,
            ),
            SizedBox(height: size * 0.08),
            CustomTextfield(
              controller: _nameController,
              hintText: 'Enter nickName',
            ),
            SizedBox(height: size * 0.04),
            CustomButton(
              onTap: () => _socketMethods.createRoom(
                _nameController.text,
              ),
              text: 'Create',
            )
          ],
        ),
      ),
    );
  }
}
