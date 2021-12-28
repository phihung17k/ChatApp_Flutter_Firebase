import 'package:chat/bloc/home/home_bloc.dart';
import 'package:chat/bloc/home/home_event.dart';
import 'package:chat/bloc/home/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCard extends StatelessWidget {
  const UserCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeBloc bloc = BlocProvider.of<HomeBloc>(context);
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: bloc,
      builder: (context, state) {
        if(state.isFirst){
          return const SizedBox();
        } else {
          if (state.searchedResult != null) {
            return InkWell(
              onTap: (){
                bloc.add(NavigatorRoomEvent(user: state.searchedResult!));
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(state.searchedResult!.photoURL),
                                fit: BoxFit.fill
                            )
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name: ${state.searchedResult!.displayName}"),
                            Text("Email: ${state.searchedResult!.email}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(
            child: Text("User is not found in our system, let invite them"),
          );
        }
      },
    );
  }
}
