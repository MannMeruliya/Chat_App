import 'package:fb_miner/model/APIs.dart';
import 'package:fb_miner/model/chat_model.dart';
import 'package:fb_miner/model/helper/dialogs.dart';
import 'package:fb_miner/screen/loginscreen.dart';
import 'package:fb_miner/screen/profile_screen.dart';
import 'package:fb_miner/screen/users.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Chat> _list = [];

  final List<Chat> _searchList = [];

  bool _isSearching = false;

  signOut() async {
    await Api.auth.signOut();
    await GoogleSignIn().signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  void initState() {
    super.initState();
    Api.getselfinfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffAED2FF),
        title: _isSearching
            ? TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Name",
                  contentPadding: EdgeInsets.all(20),
                ),
                style: const TextStyle(fontSize: 18),
                cursorColor: Colors.indigo,
                autofocus: true,
                onChanged: (value) {
                  _searchList.clear();

                  for (var i in _list) {
                    if (i.name.toLowerCase().contains(value.toLowerCase())) {
                      _searchList.add(i);
                    }
                    setState(() {
                      _searchList;
                    });
                  }
                },
              )
            : const Text("Chat App"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
              });
            },
            icon: Icon(_isSearching ? Icons.close : Icons.search),
          ),
          IconButton(
              onPressed: () {
                _addChatUserDialog();
              },
              icon: const Icon(Icons.add)),
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(user: Api.me),
                    ));
              },
              icon: const Icon(Icons.edit)),
        ],
        elevation: 1,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          signOut();
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.logout, color: Colors.red),
      ),
      body: StreamBuilder(
        stream: Api.getuserID(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              // return Center(child: CircularProgressIndicator());

            //if some or all data is loaded then show it
            case ConnectionState.active:
            case ConnectionState.done:
              return StreamBuilder(
                stream: Api.getalluser(
                    snapshot.data?.docs.map((e) => e.id).toList() ?? []),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data?.docs;
                    _list =
                        data?.map((e) => Chat.fromJson(e.data())).toList() ??
                            [];
                  }
                  return ListView.builder(
                    itemCount: _isSearching ? _searchList.length : _list.length,
                    itemBuilder: (context, index) {
                      return chatuser(
                          user:
                              _isSearching ? _searchList[index] : _list[index]);
                    },
                  );
                },
              );
          }
        },
      ),
    );
  }

  void _addChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: const [
                  Icon(
                    Icons.person_add,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text('  Add User')
                ],
              ),
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                    hintText: 'Email Id',
                    prefixIcon: const Icon(Icons.email, color: Colors.blue),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
              actions: [
                MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.blue, fontSize: 16))),
                MaterialButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      if (email.isNotEmpty) {
                        await Api.addChatUser(email).then((value) {
                          if (!value) {
                            Dialogs.showSnackbar(
                                context, 'User does not Exists!');
                          }
                        });
                      }
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}
