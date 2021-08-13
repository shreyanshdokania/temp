// @dart=2.9
import 'package:apac/pages/mainpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';
import 'login_signup/google_signin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Googlesigninprov(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: 'MuktaVaani'),
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}

class Mainrun extends StatefulWidget {
  const Mainrun({Key key}) : super(key: key);

  @override
  _MainrunState createState() => _MainrunState();
}

class _MainrunState extends State<Mainrun> {
  LocalAuthentication localauth = new LocalAuthentication();

  bool _checksensoravailability = false;
  List<BiometricType> _authtype = [];
  bool _authstatus = false;

  @override
  void initState() {
    super.initState();
    checksensors();
  }

  //function to check sensors availability
  Future<void> checksensors() async {
    bool checksensor;

    try {
      checksensor = await localauth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;
    setState(() {
      _checksensoravailability = checksensor;
      print(_checksensoravailability);
    });
    getsensors();
  }

  //function to access sensors for authentication
  Future<void> getsensors() async {
    List<BiometricType> available;

    try {
      available = await localauth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    setState(() {
      _authtype = available;
    });
    mainauthentication();
  }

  //function to authenticate local user using the accessible sensors
  Future<void> mainauthentication() async {
    bool authstatus = false;

    try {
      authstatus = await localauth.authenticate(
        localizedReason: "Tap",
        useErrorDialogs: true,
        stickyAuth: false,
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;
    setState(() {
      _authstatus = authstatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!_authstatus && _checksensoravailability) {
            return Container(
              color: Colors.grey[900],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.lightBlue,
              ),
            );
          } else if (snapshot.hasData) {
            return MainPage();
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Some error occured..Please close and restart the application :)",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }
          return HomePage();
        },
      ),
    );
  }
}
