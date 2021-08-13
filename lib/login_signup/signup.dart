import 'package:apac/pages/mainpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../home_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController em = new TextEditingController();
  final TextEditingController pass = new TextEditingController();

  final CollectionReference cref =
      FirebaseFirestore.instance.collection("userinfo");

  // LoginSignUpManagement obj = new LoginSignUpManagement();

  _verifyAndSignUp() async {
    if (em.text.length == 0 || pass.text.length == 0) {
      Fluttertoast.showToast(msg: "Fill email and password both and try again");
      return;
    }
    bool ans = true;
    await cref.where("email", isEqualTo: em.text).get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          ans = false;
        });
      });
    });

    if (!ans) {
      Fluttertoast.showToast(
        msg: "Email Already Exists! Login to Continue",
      );

      setState(() {
        em.clear();
        pass.clear();
        login = !login;
      });
      return;
    }

    await cref.add({
      "email": em.text,
      "password": pass.text,
    });

    setState(() {
      em.clear();
      pass.clear();
    });

    Fluttertoast.showToast(
      msg: "Sign Up Successful",
    );

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => MainPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Sign up with',
          style: TextStyle(
            fontSize: 16,
            color: Colors.deepPurple[300],
            height: 2,
          ),
        ),
        Text(
          'EMAIL',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple[300],
            height: 1,
            letterSpacing: 2,
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
            hintText: "Enter Email",
            hintStyle: TextStyle(
              fontSize: 16,
              color: Colors.deepPurple[300]!.withOpacity(0.3),
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
            fillColor: Colors.grey.withOpacity(0.1),
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
          obscureText: true,
          style: TextStyle(
            color: Colors.white,
          ),
          controller: pass,
          decoration: InputDecoration(
            hintText: "Enter Password",
            hintStyle: TextStyle(
              fontSize: 16,
              color: Colors.deepPurple[300]!.withOpacity(0.3),
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
            fillColor: Colors.grey.withOpacity(0.1),
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
            _verifyAndSignUp();
            // print(obj.checkIfUserExists(em.text));
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(Colors.deepPurple[300]),
          ),
          child: Text(
            'SIGN UP',
            style: TextStyle(
              color: Colors.grey[850],
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
