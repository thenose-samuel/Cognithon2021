import 'package:crime_watch/screens/add_contacts.dart';
import 'package:crime_watch/services/local_db.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:crime_watch/services/user_model.dart';
import 'screens/sign_in.dart';
import 'package:crime_watch/screens/submission_map.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crime_watch/screens/home.dart';
import 'package:crime_watch/screens/send_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  DatabaseHandler handler = DatabaseHandler();
  bool userExists = false;
  List<UserModel> user = await handler.retrieveUsers();
  if (user.length == 0)
    userExists = false;
  else {
    userExists = true;
  }
  dynamic first;
  //first = SubmissionMap();
  if (user.length != 0)
    first = Home( name: '${user[0].name}', image: '${user[0].image}');
  else
    first = SignIn();
  runApp(MaterialApp(
      theme: ThemeData(
        fontFamily: 'HelveticaNow',
      ),
      home: EditContacts()));
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
        child: TextButton(child: Text('Welcome Screen'), onPressed: (){
          Navigator.push(context,MaterialPageRoute(
            builder: (context) => SubmissionMap(),
          ));
        },),
      ),
    );
  }
}
