import 'package:apac/pages/mainpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../home_page.dart';
import 'google_signin.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController em = new TextEditingController();
  final TextEditingController pass = new TextEditingController();

  final CollectionReference cref =
      FirebaseFirestore.instance.collection("userinfo");

  _verifyAndLogin() async {
    if (em.text.length == 0 || pass.text.length == 0) {
      Fluttertoast.showToast(msg: "Fill email and password both and try again");
      return;
    }
    bool ans = true;
    String? temp_pass;
    await cref.where("email", isEqualTo: em.text).get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          temp_pass = element["password"];
          ans = false;
        });
      });
    });

    if (ans) {
      Fluttertoast.showToast(
        msg: "Email doesn't Exists ! SignUp to Continue",
      );

      setState(() {
        em.clear();
        pass.clear();
        login = !login;
      });
      return;
    }

    if (temp_pass != pass.text) {
      Fluttertoast.showToast(
        msg: "Incorrect Password",
      );
      setState(() {
        pass.clear();
      });
      return;
    }

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => MainPage(
          isGoogleSignIn: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Welcome to',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF1C1C1C),
            height: 2,
          ),
        ),
        Text(
          'EMAIL',
          style: TextStyle(
            fontSize: 36,
            color: Color(0xFF1C1C1C),
            height: 1,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        Text(
          'Login to continue',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF1C1C1C),
            height: 1,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        TextField(
          style: TextStyle(
            color: Colors.white,
          ),
          controller: em,
          decoration: InputDecoration(
            hintText: "Email",
            hintStyle: TextStyle(
              fontSize: 16,
              color: Colors.grey[850]!.withOpacity(0.3),
              //fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: Colors.deepPurple[400],
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 0,
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        TextField(
          style: TextStyle(
            color: Colors.white,
          ),
          controller: pass,
          obscureText: true,
          decoration: InputDecoration(
            hintText: "Password",
            hintStyle: TextStyle(
              fontSize: 16,
              color: Colors.grey[850]!.withOpacity(0.3),
              //fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: Colors.deepPurple[400],
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 0,
            ),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        ElevatedButton(
          onPressed: () {
            _verifyAndLogin();
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(Colors.grey[850]),
          ),
          child: Text(
            'LOGIN',
            style: TextStyle(
              color: Colors.deepPurple[300],
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final provider = Provider.of<Googlesigninprov>(
              context,
              listen: false,
            );
            provider.glogin();
            Navigator.pop(context);
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(Colors.grey[850]),
          ),
          child: Text(
            'GOOGLE LOGIN',
            style: TextStyle(
              color: Colors.deepPurple[300],
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                print("forgot");
              },
              style: TextButton.styleFrom(
                primary: Colors.deepPurple[300],
              ),
              child: Text(
                'FORGOT PASSWORD?',
                style: TextStyle(
                  color: Color(0xFF1C1C1C),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
