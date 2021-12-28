import 'package:chat/bloc/room/room_bloc.dart';
import 'package:chat/bloc/room/room_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InputWidget extends StatelessWidget {
  final TextEditingController controller;

  const InputWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RoomBloc bloc = BlocProvider.of<RoomBloc>(context);
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 10),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if(controller.text.trim().isNotEmpty){
                bloc.add(SendingMessageEvent(controller.text));
                controller.text = "";
              }
            },
          ),
          hintText: "Type message",
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
        ),
        keyboardType: TextInputType.multiline,
        maxLines: null,
      ),
    );
  }
}
