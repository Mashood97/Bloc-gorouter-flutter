import 'package:equatable/equatable.dart';

class UserChats extends Equatable {
  final int userChatId;
  final int firstUserId;
  final int secondUserId;
  final bool isDeleted;
  final bool isArchived;
  final String currentMessage;
  final String createdAt;
  final List<UserInfo> userInfo;

  const UserChats({
    required this.userChatId,
    required this.firstUserId,
    required this.secondUserId,
    required this.isDeleted,
    required this.isArchived,
    required this.currentMessage,
    required this.createdAt,
    required this.userInfo,
  });

  @override
  List<Object?> get props => [
        userChatId,
        firstUserId,
        secondUserId,
        isDeleted,
        isArchived,
        currentMessage,
        createdAt,
        userInfo,
      ];
}

class UserInfo extends Equatable {
  final String userUuid;
  final String userName;

  const UserInfo({required this.userUuid, required this.userName});

  @override
  List<Object?> get props => [
        userName,
        userUuid,
      ];
}
