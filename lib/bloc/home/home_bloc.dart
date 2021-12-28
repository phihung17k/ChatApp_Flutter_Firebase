import 'package:chat/base_bloc.dart';
import 'package:chat/bloc/home/home_event.dart';
import 'package:chat/bloc/home/home_state.dart';
import 'package:chat/firebase_utils.dart';
import 'package:chat/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeBloc extends BaseBloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on((event, emit) async {
      if (event is LogoutEvent) {
        FirebaseUtils.logout();
        listener.add(LogoutEvent());
      } else if (event is EmailVerificationEvent) {
        String value = event.value;
        QuerySnapshot query = await FirebaseFirestore.instance
            .collection("users")
            .where("email", isEqualTo: value)
            .get();
        if (query.docs.isNotEmpty) {
          QueryDocumentSnapshot result = query.docs.single;
          UserModel searchedResult = UserModel(
            uid: result.get("uid"),
            displayName: result.get("displayName"),
            email: result.get("email"),
            photoURL: result.get("photoURL"),
          );
          emit(state.copyWith(
            searchedResult: searchedResult,
            isFirst: false,
          ));
        } else {
          emit(state.copyWith(
            searchedResult: null,
            isFirst: false,
          ));
        }
      } else if (event is NavigatorRoomEvent){
        listener.add(NavigatorRoomEvent(user: event.user));
      }
    });
  }


}
