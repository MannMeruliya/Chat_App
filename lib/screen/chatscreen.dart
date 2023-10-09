import 'package:cached_network_image/cached_network_image.dart';
import 'package:fb_miner/model/message_model.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final Chat user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // flexibleSpace: _appBar(),
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back)),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.height * .3),
              child: CachedNetworkImage(
                height: MediaQuery.of(context).size.height * .05,
                width: MediaQuery.of(context).size.height * .05,
                imageUrl: widget.user.image,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    CircleAvatar(child: Icon(Icons.person)),
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
      body: Column(
        children: [
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
                            onPressed: () {},
                            icon: Icon(
                              Icons.emoji_emotions,
                              color: Colors.blueAccent,
                            )),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
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
                            onPressed: () {},
                            icon: Icon(
                              Icons.image,
                              color: Colors.blueAccent,
                            )),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.blueAccent,
                          ),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * .02 ,),
                      ],
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {},
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
