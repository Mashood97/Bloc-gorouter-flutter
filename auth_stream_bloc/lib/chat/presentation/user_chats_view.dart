import 'package:auth_stream_bloc/chat/manager/chats_bloc.dart';
import 'package:auth_stream_bloc/chat/repository/chat_repository.dart';
import 'package:auth_stream_bloc/di_container.dart';
import 'package:auth_stream_bloc/navigation/app_navigations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../authentication/manager/authentication_bloc.dart';
import '../../main.dart';

class UserChatsView extends StatefulWidget {
  const UserChatsView({super.key});

  @override
  State<UserChatsView> createState() => _UserChatsViewState();
}

class _UserChatsViewState extends State<UserChatsView> {
  late final ChatsBloc chatsBloc;

  @override
  void initState() {
    super.initState();
    chatsBloc = getItInstance.get<ChatsBloc>();
    chatsBloc.add(FetchUserChats());
  }

  @override
  void dispose() {
    chatsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(
          width: 20,
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ),
        title: const Text(
          "MyChats",
        ),
        actions: [
          IconButton(
            onPressed: () {
              authenticationBloc.add(LoggedOut());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Search',
                hintText: "Search user....",
                suffixIcon: Icon(
                  Icons.search,
                ),
                isDense: true,
              ),
            ),
            // const SizedBox(
            //   height: 25,
            // ),
            Expanded(
              child: BlocConsumer<ChatsBloc, ChatsState>(
                bloc: chatsBloc,
                buildWhen: (old, current) => old != current,
                listener: (context, state) {
                  if (state is ChatsFailure) {
                    print(state.errorMessage);
                  }
                },
                builder: (context, state) {
                  if (state is ChatsLoading) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  return state is ChatsFailure || state.userChats.isEmpty
                      ? const Center(
                          child: Text("No Chats Found"),
                        )
                      : ListView.separated(
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (ctx, index) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            onTap: () {
                              AppNavigations()
                                  .navigateFromChatsToChatDetails(context: ctx);
                            },
                            leading: const CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(
                                "https://images.pexels.com/photos/307847/pexels-photo-307847.jpeg?auto=compress&cs=tinysrgb&w=800",
                              ),
                            ),
                            title: Text(
                              state.userChats[index].userInfo.first.userName,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            subtitle: Text(
                              state.userChats[index].currentMessage,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.black54),
                            ),
                            trailing: Text(
                              DateFormat.jm().format(DateTime.parse(
                                  state.userChats[index].createdAt)),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: Colors.black45,
                                  ),
                            ),
                          ),
                          itemCount: state.userChats.length,
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
