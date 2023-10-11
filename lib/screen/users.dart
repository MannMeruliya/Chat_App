import 'package:cached_network_image/cached_network_image.dart';
import 'package:fb_miner/model/APIs.dart';
import 'package:fb_miner/model/chat_model.dart';
import 'package:fb_miner/model/helper/dateformat.dart';
import 'package:fb_miner/model/message_model.dart';
import 'package:fb_miner/screen/chatscreen.dart';
import 'package:flutter/material.dart';

class chatuser extends StatefulWidget {
  final Chat user;

  const chatuser({super.key, required this.user});

  @override
  State<chatuser> createState() => _chatuserState();
}

class _chatuserState extends State<chatuser> {
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 2),
      color: const Color(0xffE4F1FF),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChatScreen(
                        user: widget.user,
                      )));
        },
        child: StreamBuilder(
          stream: Api.getlastmessage(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
            if (list.isNotEmpty) _message = list[0];

            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * .3),
                child: CachedNetworkImage(
                  height: MediaQuery.of(context).size.height * .055,
                  width: MediaQuery.of(context).size.height * .055,
                  imageUrl: widget.user.image,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      const CircleAvatar(child: Icon(Icons.person)),
                ),
              ),
              title: Text(widget.user.name),
              subtitle: Text(
                _message != null ? _message!.msg : widget.user.about,
                maxLines: 1,
              ),
              trailing: _message == null
                  ? null
                  : _message!.read.isEmpty &&
                          _message!.fromId != Api.auth.currentUser!.uid
                      ? Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20)),
                        )
                      : Text(
                          MyDateUtils.getlastmessage(
                              context: context, time: _message!.sent),
                          style: const TextStyle(color: Colors.black54, fontSize: 15),
                        ),
            );
          },
        ),
      ),
    );
  }
}
