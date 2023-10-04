import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fb_miner/model/APIs.dart';
import 'package:fb_miner/model/message_model.dart';
import 'package:fb_miner/screen/homescreen.dart';
import 'package:fb_miner/screen/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final Chat user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  signOut() async {
    await Api.auth.signOut();
    await GoogleSignIn().signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  final _formkey = GlobalKey<FormState>();

  String? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        backgroundColor: Color(0xffAED2FF).withOpacity(0.4),
        title: Text("Profile Screen"),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ));
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          signOut();
        },
        child: Icon(Icons.logout, color: Colors.red),
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .02,
                ),
                Stack(children: [
                  _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.height * .1),
                          child: Image.file(
                            File(_image!),
                            height: MediaQuery.of(context).size.height * .2,
                            width: MediaQuery.of(context).size.height * .2,
                            fit: BoxFit.fill,
                        )):

                       ClipRRect(
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.height * .1),
                          child: CachedNetworkImage(
                            height: MediaQuery.of(context).size.height * .2,
                            width: MediaQuery.of(context).size.height * .2,
                            fit: BoxFit.fill,
                            imageUrl: widget.user.image,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                CircleAvatar(child: Icon(Icons.person)),
                          ),
                        ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: MaterialButton(
                      onPressed: () {
                        _showSheet();
                      },
                      shape: CircleBorder(),
                      color: Colors.white,
                      child: Icon(Icons.edit),
                    ),
                  )
                ]),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .03,
                ),
                Text(
                  widget.user.email,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .06,
                ),
                TextFormField(
                  initialValue: widget.user.name,
                  onSaved: (value) => Api.me.name = value ?? "",
                  validator: (value) => value != null && value.isNotEmpty
                      ? null
                      : 'Required Field',
                  decoration: InputDecoration(
                    hintText: "Enter Name",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    label: Text("Name"),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .03,
                ),
                TextFormField(
                  initialValue: widget.user.about,
                  onSaved: (value) => Api.me.about = value ?? "",
                  validator: (value) => value != null && value.isNotEmpty
                      ? null
                      : 'Required Field',
                  decoration: InputDecoration(
                    hintText: "About",
                    prefixIcon: Icon(Icons.info_outline),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    label: Text("About"),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .06,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      _formkey.currentState!.save();
                      Api.updateinfo();
                    }
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size(150, 50)),
                    backgroundColor: MaterialStateProperty.all(
                      Color(0xffAED2FF).withOpacity(0.4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(20),
          children: [
            Text(
              "Pick a Profile Picture",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      print(
                          'image path : ${image.path} ');

                     setState(() {
                       _image = image.path;
                     });

                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    "Gallery",
                    style: TextStyle(color: Colors.blue, fontSize: 17),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      print(
                          'image path : ${image.path} ');

                      setState(() {
                        _image = image.path;
                      });

                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    "Camera",
                    style: TextStyle(color: Colors.blue, fontSize: 17),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .02,
            ),
          ],
        );
      },
    );
  }
}
