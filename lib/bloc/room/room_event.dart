
import 'package:chat/argument/room_argument.dart';

abstract class RoomEvent{}

class GettingArgumentEvent extends RoomEvent{
  final RoomArgument argument;

  GettingArgumentEvent(this.argument);
}

class SendingMessageEvent extends RoomEvent{
  final String mess;

  SendingMessageEvent(this.mess);
}

class ScrollEndEvent extends RoomEvent{}