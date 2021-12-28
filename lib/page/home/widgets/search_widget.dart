import 'package:chat/bloc/home/home_bloc.dart';
import 'package:chat/bloc/home/home_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController inputController;
  final GlobalKey<FormState> formKey;
  final String pattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  const SearchWidget({Key? key, required this.inputController, required this.formKey})
      : super(key: key);

  String? getResultValid(String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return "Please input email";
      }
      bool emailValid = RegExp(pattern).hasMatch(value);
      if (emailValid) {
        if(value == FirebaseAuth.instance.currentUser!.email){
          return "This is your email! You can't chat to yourself";
        }
        return null;
      } else {
        return "Email is not exist";
      }
    }
    return "Please input email";
  }

  @override
  Widget build(BuildContext context) {
    HomeBloc bloc = BlocProvider.of<HomeBloc>(context);
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: inputController,
            decoration: InputDecoration(
              hintText: "abc@gmail.com",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            ),
            validator: (value) {
              return getResultValid(value);
            },
            onChanged: (value) {
              if (formKey.currentState!.validate()) {
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                bloc.add(EmailVerificationEvent(value: inputController.text));
              }
            },
            child: const Text("Search"),
          ),
        ],
      ),
    );
  }
}
