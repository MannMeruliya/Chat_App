import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_miner/model/chat_model.dart';
import 'package:fb_miner/model/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Api {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseStorage storage = FirebaseStorage.instance;

  static late Chat me;

  static Future<bool> userexists() async {
    return (await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  static Future<void> getselfinfo() async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = Chat.fromJson(user.data()!);
      } else {
        await createuser().then((value) => getselfinfo());
      }
    });
  }

  static Future<void> createuser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final user = Chat(
      id: auth.currentUser!.uid,
      name: auth.currentUser!.displayName.toString(),
      email: auth.currentUser!.email.toString(),
      about: "I am Chating right now",
      image: auth.currentUser!.photoURL.toString(),
      createAt: time,
      isOnline: false.toString(),
      lastActive: time,
      pushToken: "",
    );

    return await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .set(user.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getuserID() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('my_users')
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getalluser(
      List<String> userId) {
    print('userid : $userId');

    return firestore
        .collection('users')
        .where('id', whereIn: userId)
        // .where('id', isNotEqualTo: auth.currentUser!.uid)
        .snapshots();
  }

  static Future<void> sendfirstmessage(
      Chat chatuser, String msg, Type type) async {
    await firestore
        .collection('users')
        .doc(chatuser.id)
        .collection('my_users')
        .doc(auth.currentUser!.uid)
        .set({}).then((value) => sendMessage(chatuser, msg, type));
  }

  static Future<void> updateinfo() async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

  static Future<void> updateprofilephoto(File file) async {
    final ext = file.path.split('.').last;
    // print('Extersion : $ext');
    final ref =
        storage.ref().child('profile_photo/${auth.currentUser!.uid}.$ext');
    ref.putFile(file);
    me.image = await ref.getDownloadURL();
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'image': me.image,
    });
  }

  static String getConversation(String id) =>
      auth.currentUser!.uid.hashCode <= id.hashCode
          ? '${auth.currentUser!.uid}_$id'
          : '${id}_${auth.currentUser!.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getallmessage(Chat user) {
    return firestore
        .collection('chats/${getConversation(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(Chat chatuser, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final Message message = Message(
        msg: msg,
        read: '',
        fromId: auth.currentUser!.uid,
        toId: chatuser.id,
        type: type,
        sent: time);

    final ref =
        firestore.collection('chats/${getConversation(chatuser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  static Future<void> readmessage(Message message) async {
    firestore
        .collection('chats/${getConversation(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getlastmessage(Chat user) {
    return firestore
        .collection('chats/${getConversation(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sendchatimage(Chat user, File file) async {
    final ext = file.path.split('.').last;

    final ref = storage.ref().child(
        'chat_image/${getConversation(user.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print('Data Transferred : ${p0.bytesTransferred / 1000} kb');
    });

    ref.putFile(file);
    final imageurl = await ref.getDownloadURL();
    await sendMessage(user, imageurl, Type.image);
  }

  static Future<bool> addChatUser(String email) async {
    final data = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    print('data: ${data.docs}');

    if (data.docs.isNotEmpty && data.docs.first.id != auth.currentUser!.uid) {
      print('user exists: ${data.docs.first.data()}');

      firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({});

      return true;
    } else {
      return false;
    }
  }
}
