import 'package:fb_miner/model/APIs.dart';
import 'package:fb_miner/model/chat_model.dart';
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
            ?TextField(
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

            for(var i in _list){
              if(i.name.toLowerCase().contains(value.toLowerCase())){
                _searchList.add(i);
              }
              setState(() {
                _searchList;
              });
            }
        },
        )
            :const Text("Chat App"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              }, icon: Icon(_isSearching
          ?Icons.close
          :Icons.search),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
          IconButton(onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen(user: Api.me),));
          }, icon: const Icon(Icons.edit)),
        ],
        elevation: 1,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          signOut();
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.logout,color: Colors.red),
      ),
      body: StreamBuilder(
          stream: Api.getalluser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data?.docs;
              _list = data?.map((e) => Chat.fromJson(e.data())).toList() ?? [];
            }
            return ListView.builder(
              itemCount: _isSearching ? _searchList.length: _list.length,
              itemBuilder: (context, index) {
                return chatuser(user: _isSearching? _searchList[index]: _list[index]);
              },
            );
          },
      ),
    );
  }
}
