
import 'package:chat/model/user_model.dart';
import 'package:equatable/equatable.dart';

class RoomState extends Equatable{
  final String? roomId;
  final UserModel? userTo;
  final String? roomName;
  final bool isUserFrom; //current User is user from

  const RoomState({this.roomId, this.userTo, this.roomName, this.isUserFrom = true});

  RoomState copyWith({String? roomId, UserModel? userTo, String? roomName, bool? isUserFrom}){
    return RoomState(
      roomId: roomId ?? this.roomId,
      userTo: userTo ?? this.userTo,
      roomName: roomName ?? this.roomName,
      isUserFrom: isUserFrom ?? this.isUserFrom,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [roomId, userTo, roomName, isUserFrom];
}