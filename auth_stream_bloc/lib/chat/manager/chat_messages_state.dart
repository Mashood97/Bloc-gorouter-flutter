part of 'chat_messages_bloc.dart';

abstract class ChatMessagesState extends Equatable {
  const ChatMessagesState();
}

class ChatMessagesInitial extends ChatMessagesState {
  @override
  List<Object> get props => [];
}
