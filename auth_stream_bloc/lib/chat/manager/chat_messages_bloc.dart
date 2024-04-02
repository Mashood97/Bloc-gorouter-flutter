import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_messages_event.dart';
part 'chat_messages_state.dart';

class ChatMessagesBloc extends Bloc<ChatMessagesEvent, ChatMessagesState> {
  ChatMessagesBloc() : super(ChatMessagesInitial()) {
    on<ChatMessagesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
