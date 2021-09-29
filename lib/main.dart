import 'package:crime_watch/services/local_db.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sqflite/sqflite.dart';
import 'package:crime_watch/services/user_model.dart';
import 'screens/sign_in.dart';
import 'package:crime_watch/screens/submission_map.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crime_watch/screens/send_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  //await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  DatabaseHandler handler = DatabaseHandler();
  bool userExists = false;
  List<UserModel> user = await handler.retrieveUsers();
  if (user.length == 0)
    userExists = false;
  else
    userExists = true;
  dynamic Home;
  if (userExists)
    Home = MyApp();
  else
    Home = SignIn();
  runApp(MaterialApp(
      theme: ThemeData(
        fontFamily: 'HelveticaNow',
      ),
      home: Home));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Welcome Screen'),
      ),
    );
  }
}
