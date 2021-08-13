import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainPage extends StatefulWidget {
  final bool? isGoogleSignIn;
  const MainPage({Key? key, this.isGoogleSignIn}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final CollectionReference cref =
      FirebaseFirestore.instance.collection("userinfo");

  @override
  void initState() {
    super.initState();
    if (widget.isGoogleSignIn!) {
      fetchdata();
    }
  }

  List data = [];
  bool check = true;

  adddata() {}

  fetchdata() async {
    final loginuser = FirebaseAuth.instance.currentUser!;

    data.clear();
    setState(() {
      check = true;
    });
    await cref.get().then((snapshot) {
      snapshot.docs.forEach((res) {
        setState(() {
          data.add(res.data());
        });
      });
    });
    for (int i = 0; i < data.length; i++) {
      if (data[i]['email'].toString() == loginuser.email.toString()) {
        check = false;
        Fluttertoast.showToast(
          msg: "Welcome!",
          backgroundColor: Colors.grey[800],
          gravity: ToastGravity.BOTTOM,
        );
      }
    }

    if (check) {
      cref.add({
        "name": loginuser.displayName,
        "email": loginuser.email,
        "verification": loginuser.emailVerified,
        "profilepicurl": loginuser.photoURL,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("checkforcallback");
    return Scaffold(
      backgroundColor: Colors.grey[800],
    );
  }
}
