part of 'chats_bloc.dart';

sealed class ChatsEvent extends Equatable {
  const ChatsEvent();
}

final class FetchUserChats extends ChatsEvent {
  @override
  List<Object?> get props => [];
}
