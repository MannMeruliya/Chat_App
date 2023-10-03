// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fb_miner/model/message_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
//
// class ChatProvider extends ChangeNotifier {
//   final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//   final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
//
//   Future<void> sendMessage(String resiverID, String message) async {
//     final String currentId = firebaseAuth.currentUser!.uid;
//     final String currentEmail = firebaseAuth.currentUser!.email.toString();
//     final Timestamp timestamp = Timestamp.now();
//
//     messageModel newmessage = messageModel(
//         senderID: currentId,
//         senderName: currentEmail,
//         resiverID: resiverID,
//         message: message,
//         timestamp: timestamp);
//
//     List<String> ids = [currentId, resiverID];
//     ids.sort();
//     String chatRoomId = ids.join("_");
//
//     print("chat_rooms :: senmessage :: $chatRoomId");
//
//     await firebaseFirestore
//         .collection("chat_rooms")
//         .doc(chatRoomId)
//         .collection('message')
//         .add(newmessage.toMap());
//     notifyListeners();
//   }
//
//   Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
//     List<String> ids = [userId, otherUserId];
//     ids.sort();
//     String chatRoomId = ids.join("_");
//     notifyListeners();
//     print("chat_rooms :: getMessages:: $chatRoomId");
//     return firebaseFirestore
//         .collection("chat_rooms")
//         .doc(chatRoomId)
//         .collection('message')
//         .orderBy('timestamp', descending: false)
//         .snapshots();
//   }
// }
