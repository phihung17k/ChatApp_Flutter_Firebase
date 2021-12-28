
import 'package:chat/model/user_model.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable{
  final bool isFirst;
  final UserModel? searchedResult;

  const HomeState({this.isFirst = true, this.searchedResult});

  HomeState copyWith({bool? isFirst, bool? checkState, UserModel? searchedResult}) {
    return HomeState(
      isFirst: isFirst ?? this.isFirst,
      searchedResult: searchedResult,
    );
  }

  @override
  List<Object?> get props => [isFirst, searchedResult];
}