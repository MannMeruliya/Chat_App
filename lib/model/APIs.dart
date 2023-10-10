import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_miner/model/chat_model.dart';
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
    await firestore.collection('users').doc(auth.currentUser!.uid).get().then((user) async {
      if(user.exists){
        me = Chat.fromJson(user.data()!);
      }else{
        await createuser().then((value) => getselfinfo());
      }
    });
  }

  static Future<void> createuser() async {
    final time = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();

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

  static Stream<QuerySnapshot<Map<String, dynamic>>> getalluser() {
    return firestore
        .collection('users')
        .where('id',isNotEqualTo: auth.currentUser!.uid)
        .snapshots();
  }

  static Future<void> updateinfo() async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'name': me.name,
      'about':me.about,
    });
  }

  static Future<void> updateprofilephoto(File file) async {
    final ext = file.path.split('.').last;
    print('Extersion : $ext');
    final ref = storage.ref().child('profile_photo/${auth.currentUser!.uid}.$ext');
    ref.putFile(file);
    me.image = await ref.getDownloadURL();
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'image': me.image,
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getallmessage() {
    return firestore
        .collection('message')
        .snapshots();
  }

}
 