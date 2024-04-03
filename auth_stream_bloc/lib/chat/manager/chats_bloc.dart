import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../model/user_chats.dart';
import '../repository/chat_repository.dart';

part 'chats_event.dart';

part 'chats_state.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  final ChatRepository chatRepository;

  ChatsBloc({
    required this.chatRepository,
  }) : super(const ChatsInitial(userChats: [])) {
    on<FetchUserChats>(
      _fetchChats,
    );
  }

  Future<void> _fetchChats(
      FetchUserChats event, Emitter<ChatsState> emit) async {
    emit(ChatsLoading(userChats: state.userChats));
    final response = await chatRepository.fetchUserChatsFromDb();
    if (response.isNotEmpty) {
      return emit(ChatsLoaded(userChats: response));
    }

    return emit(ChatsFailure(
        userChats: state.userChats, errorMessage: "No Chats Found"));
  }
}
