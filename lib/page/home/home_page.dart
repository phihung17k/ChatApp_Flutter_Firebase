import 'package:chat/argument/room_argument.dart';
import 'package:chat/bloc/home/home_bloc.dart';
import 'package:chat/bloc/home/home_event.dart';
import 'package:chat/bloc/home/home_state.dart';
import 'package:chat/page/home/widgets/search_widget.dart';
import 'package:chat/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/user_card.dart';

class HomePage extends StatefulWidget {
  final HomeBloc bloc;

  const HomePage(this.bloc, {Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController inputController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  HomeBloc get bloc => widget.bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.listenerStream.listen((event) {
      if (event is LogoutEvent) {
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.login, (route) => false);
      } else if (event is NavigatorRoomEvent) {
        Navigator.pushNamed(context, Routes.room,
            arguments: RoomArgument(userTo: event.user));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Chat Room"),
          centerTitle: true,
          actions: [
            InkWell(
              onTap: () => bloc.add(LogoutEvent()),
              child: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(top: 10, right: 10, bottom: 0, left: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Input email to create chat room",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SearchWidget(inputController: inputController, formKey: _formKey),
              const SizedBox(
                height: 10,
              ),
              const UserCard(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }
}
