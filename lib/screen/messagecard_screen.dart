import 'package:fb_miner/model/APIs.dart';
import 'package:fb_miner/model/helper/dateformat.dart';
import 'package:flutter/material.dart';
import 'package:fb_miner/model/message_model.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Api.auth.currentUser!.uid == widget.message.fromId
        ? greenMessage()
        : blueMessage();
  }

  Widget blueMessage() {

    if(widget.message.read.isEmpty){
      Api.readmessage(widget.message);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              // color: Colors.blue,
              border: Border.all(color: Colors.lightBlue),
              color: const Color(0xff73B1E8FF),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Text(
              widget.message.msg,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Text(
            MyDateUtils.getdateformat(
                context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        )
      ],
    );
  }

  Widget greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 15,
            ),
            if (widget.message.read.isNotEmpty)
              const Icon(
                Icons.done_all_outlined,
                color: Colors.blue,
                size: 20,
              ),
            const SizedBox(
              width: 3,
            ),
            Text(
              MyDateUtils.getdateformat(
                  context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              // color: Colors.blue,
              border: Border.all(color: Colors.lightGreen),
              // color: Colors.green,
              color: const Color(0xffD0E7D2),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Text(
              widget.message.msg,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
