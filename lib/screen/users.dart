import 'package:cached_network_image/cached_network_image.dart';
import 'package:fb_miner/model/message_model.dart';
import 'package:flutter/material.dart';

class chatuser extends StatefulWidget {

  final Chat user;

  const chatuser({super.key, required this.user});

  @override
  State<chatuser> createState() => _chatuserState();
}

class _chatuserState extends State<chatuser> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 2),
      color: Color(0xffE4F1FF),
      child: InkWell(
        onTap: () {},
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * .3),
            child: CachedNetworkImage(
              height: MediaQuery.of(context).size.height * .055,
              width: MediaQuery.of(context).size.height * .055,
              imageUrl: widget.user.image,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => CircleAvatar(child: Icon(Icons.person)),
            ),
          ),
          title: Text(widget.user.name),
          subtitle: Text(
            widget.user.about,
            maxLines: 1,
          ),
          // trailing: Text(
          //   "12:00 PM",
          //   style: TextStyle(color: Colors.black54, fontSize: 15),
          // ),
          trailing: Container(
            height: 15,
            width: 15,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20)
            ),
          )
        ),
      ),
    );
  }
}
