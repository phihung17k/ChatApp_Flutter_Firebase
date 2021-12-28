import 'package:chat/argument/room_argument.dart';
import 'package:chat/bloc/room/room_bloc.dart';
import 'package:chat/bloc/room/room_event.dart';
import 'package:chat/bloc/room/room_state.dart';
import 'package:chat/enum.dart';
import 'package:chat/model/message_model.dart';
import 'package:chat/page/room/widgets/input_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoomPage extends StatefulWidget {
  final RoomBloc bloc;

  const RoomPage(this.bloc, {Key? key}) : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  RoomBloc get bloc => widget.bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      RoomArgument argument =
          ModalRoute.of(context)!.settings.arguments as RoomArgument;
      bloc.add(GettingArgumentEvent(argument));
    });

    bloc.listenerStream.listen((event) {
      if (event is ScrollEndEvent) {
        scrollController.animateTo(
          0.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<RoomBloc, RoomState>(
            bloc: bloc,
            builder: (context, state) {
              return state.roomName != null
                  ? Text(state.roomName!)
                  : const SizedBox();
            },
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: bloc.chatStream,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return ListView.builder(
                    itemCount: snapshot.data!.size,
                    reverse: true,
                    controller: scrollController,
                    itemBuilder: (context, index) {
                      List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
                      Map<String, dynamic>? mess =
                          docs[index].data() as Map<String, dynamic>?;
                      String currentUid =
                          FirebaseAuth.instance.currentUser!.uid;

                      bool isRightMess = true;

                      bool isTopRightCurve = true;
                      bool isBottomRightCurve = true;

                      bool isTopLeftCurve = true;
                      bool isBottomLeftCurve = true;

                      //top, left, right, bottom
                      //true: curve 18, false: curve 5
                      MessPosition currentMess = MessPosition.right;

                      if (docs.isNotEmpty) {
                        //from : right
                        //to : left
                        currentMess = currentUid == (mess!['uidFrom'] as String)
                            ? MessPosition.right
                            : MessPosition.left;
                        print("currentMess $currentMess, index $index");
                        if (index == 0) {
                          if (currentMess == MessPosition.left) {
                            isBottomLeftCurve = true;
                            //check the next mess whether draw curve
                            if (docs.length - index - 1 == 0) {
                              isTopLeftCurve = true;
                            } else if (docs.length - index - 1 > 0) {
                              Map<String, dynamic> nextMess = docs[index + 1]
                                  .data() as Map<String, dynamic>;
                              if (currentUid == (nextMess['uidTo'] as String)) {
                                isTopLeftCurve = false;
                              }
                            }
                          } else {
                            //mess is right
                            isBottomRightCurve = true;
                            if (docs.length - index - 1 == 0) {
                              isTopRightCurve = true;
                            } else if (docs.length - index - 1 > 0) {
                              Map<String, dynamic> nextMess = docs[index + 1]
                                  .data() as Map<String, dynamic>;
                              if (currentUid ==
                                  (nextMess['uidFrom'] as String)) {
                                isTopRightCurve = false;
                              }
                            }
                          }
                        } else if (index > 0) {
                          if (currentMess == MessPosition.left) {
                            //check the next mess whether draw curve
                            if (docs.length - index - 1 == 0) {
                              isTopLeftCurve = true;
                            } else if (docs.length - index - 1 > 0) {
                              Map<String, dynamic> previousMess =
                                  docs[index - 1].data()
                                      as Map<String, dynamic>;
                              if (currentUid ==
                                  (previousMess['uidTo'] as String)) {
                                isBottomLeftCurve = false;
                              }

                              Map<String, dynamic> nextMess = docs[index + 1]
                                  .data() as Map<String, dynamic>;
                              if (currentUid == (nextMess['uidTo'] as String)) {
                                isTopLeftCurve = false;
                              }
                            }
                          } else {
                            //mess is right
                            if (docs.length - index - 1 == 0) {
                              isTopRightCurve = true;
                            } else if (docs.length - index - 1 > 0) {
                              Map<String, dynamic> previousMess =
                                  docs[index - 1].data()
                                      as Map<String, dynamic>;
                              if (currentUid ==
                                  (previousMess['uidFrom'] as String)) {
                                isBottomRightCurve = false;
                              }

                              Map<String, dynamic> nextMess = docs[index + 1]
                                  .data() as Map<String, dynamic>;
                              if (currentUid ==
                                  (nextMess['uidFrom'] as String)) {
                                isTopRightCurve = false;
                              }
                            }
                          }
                        }

                        // isRightMess =
                        //     currentUid == (mess!['uidFrom'] as String);
                        // if (index == 0) {
                        //   if (docs.length - index - 1 > 0) {
                        //     Map<String, dynamic> messUnder =
                        //         docs[index + 1].data() as Map<String, dynamic>;
                        //     if (isRightMess) {
                        //       isBottomRightCurve = currentUid ==
                        //           (messUnder['uidFrom'] as String);
                        //     } else {
                        //       isBottomLeftCurve =
                        //           currentUid == (messUnder['uidTo'] as String);
                        //     }
                        //   }
                        // } else if (index > 0) {
                        //   Map<String, dynamic> messAbove =
                        //       docs[index - 1].data() as Map<String, dynamic>;
                        //   if (isRightMess) {
                        //     isTopRightCurve =
                        //         currentUid == (messAbove['uidFrom'] as String);
                        //   } else {
                        //     isTopLeftCurve =
                        //         currentUid == (messAbove['uidTo'] as String);
                        //   }
                        //   if (docs.length - index - 1 > 0) {
                        //     Map<String, dynamic> messUnder =
                        //         docs[index + 1].data() as Map<String, dynamic>;
                        //     if (isRightMess) {
                        //       isBottomRightCurve = currentUid ==
                        //           (messUnder['uidFrom'] as String);
                        //     } else {
                        //       isBottomLeftCurve =
                        //           currentUid == (messUnder['uidTo'] as String);
                        //     }
                        //   }
                        // }
                      }
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: currentMess == MessPosition.right
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          currentMess == MessPosition.right ? SizedBox(width: 100,) : SizedBox(),
                          Flexible(
                            child: Container(
                              child: Text(
                                "${mess!['content']}",
                                style: TextStyle(
                                  color: currentMess == MessPosition.right ? Colors.white : Colors.black,
                                ),
                              ),
                              padding: const EdgeInsets.fromLTRB(
                                  15.0, 10.0, 15.0, 10.0),
                              decoration: BoxDecoration(
                                color: currentMess == MessPosition.right
                                    ? Colors.blue
                                    : const Color.fromARGB(255, 228, 230, 235),
                                borderRadius: currentMess == MessPosition.right
                                    ? BorderRadius.only(
                                        topLeft: const Radius.circular(18),
                                        bottomLeft: const Radius.circular(18),
                                        topRight: Radius.circular(
                                            isTopRightCurve ? 18 : 5),
                                        bottomRight: Radius.circular(
                                            isBottomRightCurve ? 18 : 5),
                                      )
                                    : BorderRadius.only(
                                        topLeft: Radius.circular(
                                            isTopLeftCurve ? 18 : 5),
                                        bottomLeft: Radius.circular(
                                            isBottomLeftCurve ? 18 : 5),
                                        topRight: const Radius.circular(18),
                                        bottomRight: const Radius.circular(18),
                                      ),
                              ),
                              margin: const EdgeInsets.only(
                                bottom: 5,
                                right: 10,
                                left: 10,
                                top: 0,
                              ),
                            ),
                          ),
                          currentMess == MessPosition.right ? SizedBox() : SizedBox(width: 100,),
                        ],
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            )),
            InputWidget(controller: inputController),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    inputController.dispose();
    super.dispose();
  }
}
