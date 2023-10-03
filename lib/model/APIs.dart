import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_miner/model/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Api {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

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

}
 