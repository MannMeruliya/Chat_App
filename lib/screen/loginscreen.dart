import 'package:fb_miner/model/APIs.dart';
import 'package:fb_miner/screen/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  _loginbutton() {
    signInWithGoogle().then((user) async {
      if (await Api.userexists()) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomeScreen(),
            ));
      } else {
        Api.createuser().then((value) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HomeScreen(),
              ));
        });
      }
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Lottie.asset("assets/chat.json"),
          ),
          SizedBox(
            height: 150,
          ),
          SizedBox(
            height: 18,
          ),
          MaterialButton(
            onPressed: () {
              _loginbutton();
            },
            minWidth: 170,
            height: 40,
            color: Colors.indigo,
            child: Text(
              "Login",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
