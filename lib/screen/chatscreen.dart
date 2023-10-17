import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fb_miner/model/APIs.dart';
import 'package:fb_miner/model/chat_model.dart';
import 'package:fb_miner/model/message_model.dart';
import 'package:fb_miner/screen/messagecard_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  final Chat user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> list = [];

  final _textcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // flexibleSpace: _appBar(),
        // elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back)),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.height * .3),
              child: CachedNetworkImage(
                height: MediaQuery.of(context).size.height * .05,
                width: MediaQuery.of(context).size.height * .05,
                imageUrl: widget.user.image,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    const CircleAvatar(child: Icon(Icons.person)),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.user.name,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  "Last seen",
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
              ],
            )
          ],
        ),
        // backgroundColor: Colors.cyan,
      ),
      backgroundColor: Color(0xffD2E0FB),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: Api.getallmessage(widget.user),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data?.docs;
                  // print("data : ${jsonEncode(data![0].data())}");
                  list =
                      data?.map((e) => Message.fromJson(e.data())).toList() ??
                          [];
                }
                if (list.isNotEmpty) {
                  return ListView.builder(
                    itemCount: list.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      // return chatuser(user: _isSearching? _searchList[index]: _list[index]);
                      // return Text('message :  ${list[index]}');
                      return MessageCard(
                        message: list[index],
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text(
                      "Say Hii!",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .02,
                vertical: MediaQuery.of(context).size.height * .01),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.emoji_emotions,
                              color: Colors.blueAccent,
                            )),
                        Expanded(
                          child: TextField(
                            controller: _textcontroller,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            onTap: () {},
                            decoration: InputDecoration(
                              hintText: "Type Something...",
                              hintStyle: TextStyle(
                                color: Colors.blueAccent,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              final ImagePicker picker = ImagePicker();

                              final List<XFile> images =
                                  await picker.pickMultiImage();
                              for (var i in images) {
                                print('image path : ${i.path} ');

                                await Api.sendchatimage(
                                    widget.user, File(i.path));
                              }
                            },
                            icon: Icon(
                              Icons.image,
                              color: Colors.blueAccent,
                            )),
                        IconButton(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();

                            final XFile? image = await picker.pickImage(
                                source: ImageSource.camera);
                            if (image != null) {
                              print('image path : ${image.path} ');

                              await Api.sendchatimage(
                                  widget.user, File(image.path));
                            }
                          },
                          icon: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.blueAccent,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .02,
                        ),
                      ],
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    if (_textcontroller.text.isNotEmpty) {
                      Api.sendMessage(
                          widget.user, _textcontroller.text, Type.text);
                      _textcontroller.text = '';
                    }
                  },
                  minWidth: 0,
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 4),
                  color: Colors.green,
                  shape: CircleBorder(),
                  child: Icon(
                    Icons.send,
                    size: 29,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

// Widget _appBar() {
//   return Row(
//     children: [
//       IconButton(onPressed: () {
//         Navigator.pop(context);
//       }, icon: Icon(Icons.arrow_back)),
//       ClipRRect(
//         borderRadius:
//             BorderRadius.circular(MediaQuery.of(context).size.height * .3),
//         child: CachedNetworkImage(
//           height: MediaQuery.of(context).size.height * .05,
//           width: MediaQuery.of(context).size.height * .05,
//           imageUrl: widget.user.image,
//           placeholder: (context, url) => CircularProgressIndicator(),
//           errorWidget: (context, url, error) =>
//               CircleAvatar(child: Icon(Icons.person)),
//         ),
//       ),
//
//       SizedBox(width: 20,),
//
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(widget.user.name,style: TextStyle(fontSize: 18,color: Colors.black54,fontWeight: FontWeight.w500),),
//           Text("Last seen",style: TextStyle(fontSize: 15,color: Colors.black54),),
//         ],
//       )
//     ],
//   );
// }
}
