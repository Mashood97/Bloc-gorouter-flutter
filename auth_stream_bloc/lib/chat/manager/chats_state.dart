part of 'chats_bloc.dart';

abstract class ChatsState extends Equatable {
  final List<UserChats> userChats;

  const ChatsState({
    required this.userChats,
  });
}

class ChatsInitial extends ChatsState {
  const ChatsInitial({required super.userChats});

  @override
  List<Object> get props => [super.userChats];
}

class ChatsLoading extends ChatsState {
  const ChatsLoading({required super.userChats});

  @override
  List<Object> get props => [super.userChats];
}

class ChatsLoaded extends ChatsState {
  const ChatsLoaded({required super.userChats});

  @override
  List<Object> get props => [super.userChats];
}

class ChatsFailure extends ChatsState {
  final String errorMessage;

  const ChatsFailure({
    required super.userChats,
    required this.errorMessage,
  });

  @override
  List<Object> get props => [
        super.userChats,
        errorMessage,
      ];
}
