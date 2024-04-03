import 'package:flutter/material.dart';

import '../../main.dart';

class UserChatDetailsView extends StatefulWidget {
  const UserChatDetailsView({super.key});

  @override
  State<UserChatDetailsView> createState() => _UserChatDetailsViewState();
}

class _UserChatDetailsViewState extends State<UserChatDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Username",
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.call,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.video_call,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        reverse: true,
        itemBuilder: (ctx, index) => Padding(
          padding: index % 2 == 0
              ? const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10)
              : const EdgeInsets.only(
                  right: 10,
                  left: 10,
                  top: 5,
                  bottom: 5,
                ),
          child: Align(
            alignment:
                index % 2 == 0 ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              height: getResponsiveValue(ctx, 75),
              width: getResponsiveValue(ctx, 250),
              decoration: BoxDecoration(
                color: index % 2 == 0
                    ? Colors.grey.shade300
                    : Colors.amber.shade200,
                borderRadius: index % 2 == 0
                    ? const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        left: false,
        top: false,
        right: false,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: InputDecoration(
              isDense: true,
              suffixIcon: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                ),
              ),
              prefixIcon: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.add_box,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
