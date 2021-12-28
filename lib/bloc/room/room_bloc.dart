import 'package:chat/base_bloc.dart';
import 'package:chat/bloc/room/room_event.dart';
import 'package:chat/bloc/room/room_state.dart';
import 'package:chat/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class RoomBloc extends BaseBloc<RoomEvent, RoomState> {
  BehaviorSubject chatController = BehaviorSubject();

  Stream<QuerySnapshot> get chatStream =>
      chatController.map((event) => event as QuerySnapshot);

  RoomBloc() : super(const RoomState()) {
    on((event, emit) async {
      if (event is GettingArgumentEvent) {
        // emit(state.copyWith(
        //   roomName: event.argument.userTo.displayName,
        //   userTo: event.argument.userTo,
        // ));
        String uidTo = event.argument.userTo.uid;
        String uidFrom = FirebaseAuth.instance.currentUser!.uid;
        String roomId = "$uidFrom-$uidTo";

        String tempRoomId = "$uidTo-$uidFrom";
        bool isChangeRoomId = false;
        //
        QuerySnapshot query = await FirebaseFirestore.instance
            .collection("messages")
            .doc(roomId)
            .collection(roomId).get();
        print("query.size ${query.size}");
        if(query.size == 0){
          QuerySnapshot query2 = await FirebaseFirestore.instance
              .collection("messages")
              .doc(tempRoomId)
              .collection(tempRoomId).get();
          print("query2.size ${query2.size}");
          if(query2.size > 0){
            roomId = tempRoomId;
            isChangeRoomId = true;
          }
        }
        emit(state.copyWith(
          roomId: roomId,
          isUserFrom: isChangeRoomId ? false : true,
          roomName: event.argument.userTo.displayName,
          userTo: event.argument.userTo,
        ));
        //
        Stream<QuerySnapshot> messStream = FirebaseFirestore.instance
            .collection("messages")
            .doc(roomId)
            .collection(roomId)
            .orderBy("timestamp", descending: true)
            .snapshots();
        chatController.addStream(messStream);
      } else if (event is SendingMessageEvent) {
        //check the room is exist or not
        //if not, create room. else, get room
        DateTime time = DateTime.now();
        int timestamp = time.millisecondsSinceEpoch;
        String uidTo = state.userTo!.uid;
        String uidFrom = FirebaseAuth.instance.currentUser!.uid;
        String roomId = state.isUserFrom ? "$uidFrom-$uidTo" : "$uidTo-$uidFrom";
        CollectionReference messageCollection =
            FirebaseFirestore.instance.collection("messages");
        //collection  doc       collection   doc          field
        //message     roomId    roomId       timestamp    MessageModel

        CollectionReference? snapshotMessage = messageCollection
            .doc(roomId)
            .collection(roomId)
            .withConverter<MessageModel>(
              fromFirestore: (snapshot, _) =>
                  MessageModel.fromJson(snapshot.data()!),
              toFirestore: (messageModel, _) => messageModel.toJson(),
            );
        await snapshotMessage.doc("$timestamp").set(MessageModel(
            content: event.mess,
            uidFrom: uidFrom,
            uidTo: uidTo,
            timestamp: timestamp));
        // CollectionReference room = messageCollection.doc(roomId).collection(roomId);
        // DateTime time = DateTime.now();
        // String timestamp = "${time.millisecondsSinceEpoch}";
        // await room.doc(timestamp).set({
        //   "content": mess,
        //   "uidFrom": uidFrom,
        //   "uidTo": uidTo,
        //   "timestamp": timestamp,
        // });
        emit(state.copyWith(
          roomId: roomId,
        ));
        listener.add(ScrollEndEvent());
      }
    });
  }

// phihung17k@gmail.com
//hungnpse140205@fpt.edu.vn

}
