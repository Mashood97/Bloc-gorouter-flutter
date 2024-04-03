import 'package:auth_stream_bloc/navigation/app_navigations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../authentication/manager/authentication_bloc.dart';
import '../../main.dart';

class UserChatsView extends StatefulWidget {
  const UserChatsView({super.key});

  @override
  State<UserChatsView> createState() => _UserChatsViewState();
}

class _UserChatsViewState extends State<UserChatsView> {
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
              child: ListView.separated(
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
                    "Username",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  subtitle: Text(
                    "Hi, How are you?",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.black54),
                  ),
                  trailing: Text(
                    DateFormat.jm().format(DateTime.now()),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.black45,
                        ),
                  ),
                ),
                itemCount: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
