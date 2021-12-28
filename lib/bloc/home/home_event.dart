
import 'package:chat/model/user_model.dart';

abstract class HomeEvent{}

class LogoutEvent extends HomeEvent{}

class EmailVerificationEvent extends HomeEvent{
  final String value;

  EmailVerificationEvent({required this.value});
}

class NavigatorRoomEvent extends HomeEvent{
  final UserModel user;

  NavigatorRoomEvent({required this.user});
}