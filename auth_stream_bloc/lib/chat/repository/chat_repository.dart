import 'dart:developer';

import 'package:auth_stream_bloc/chat/model/user_chats.dart';
import 'package:auth_stream_bloc/main.dart';

abstract class ChatRepository {
  Future<List<UserChats>> fetchUserChatsFromDb();
}

class ChatRepositoryImplementation implements ChatRepository {
  @override
  Future<List<UserChats>> fetchUserChatsFromDb() async {
    try {
      final currentUser = supabaseClient.auth.currentUser;
      if (currentUser != null) {
        final user = await supabaseClient
            .from('users')
            .select()
            .eq("user_uuid", supabaseClient.auth.currentUser?.id ?? "")
            .single();

        final chats = await supabaseClient.from('chats').select().or(
            'chat_first_user_id.eq.${user["id"]},chat_second_user_id.eq.${user["id"]}');
        List<UserChats> chatList = [];

        for (var item in chats) {
          List<UserInfo> userInfo = (item["user_info"] as List<dynamic>)
              .map(
                (user) => UserInfo(
                  userUuid: user["user_uuid"],
                  userName: user["user_name"],
                ),
              )
              .toList();
          userInfo
              .removeWhere((element) => element.userUuid == user["user_uuid"]);
          chatList.add(
            UserChats(
              userChatId: item["id"],
              currentMessage: item["current_msg"],
              firstUserId: item["chat_first_user_id"],
              secondUserId: item["chat_second_user_id"],
              isArchived: item["is_archieved"],
              isDeleted: item["is_deleted"],
              createdAt: item["created_at"],
              userInfo: userInfo,
            ),
          );
        }
        return chatList;
      }

      return [];
    } catch (e) {
      print("$e");
      return [];
    }
  }
}
