// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class FirebaseHelper{
//   static FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//
//   static Future<void> signup(String email, String password) async {
//     try {
//       final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       firestore.collection('users').doc(credential.user!.uid).set({
//         'uid': credential.user!.uid,
//         'email': credential.user!.email,
//       });
//
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         print('The password provided is too weak.');
//       } else if (e.code == 'email-already-in-use') {
//         print('The account already exists for that email.');
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   static Future<UserCredential> login(String email, String password) async{
//     try {
//       UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: email,
//           password: password
//       );
//
//       firestore.collection('users').doc(credential.user!.uid).set({
//         'uid': credential.user!.uid,
//         'email': credential.user!.email,
//       }, SetOptions(merge: true));
//
//       return credential;
//
//     } on FirebaseAuthException catch (e) {
//       throw Exception(e.code);
//     }
//   }
//
//   static Future<void> signOut()async {
//     FirebaseAuth.instance.signOut();
//   }
// }