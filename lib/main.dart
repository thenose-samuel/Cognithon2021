import 'package:crime_watch/services/local_db.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:crime_watch/services/user_model.dart';
import 'screens/FirstSigninPage.dart';
import 'package:crime_watch/screens/MarkSafeSpot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crime_watch/screens/Homepage.dart';
import 'package:crime_watch/screens/add_contacts.dart';
import 'package:crime_watch/screens/MarkSafeSpot.dart';
import 'package:crime_watch/screens/share_location.dart';
import 'package:crime_watch/screens/FirstSigninPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  DatabaseHandler handler = DatabaseHandler();
  //bool userExists = false;
  List<UserModel> user = await handler.retrieveUsers();
  dynamic first;
  //first = SpotMarker();
  if (user.length != 0)
    first = Home(name: '${user[0].name}', image: '${user[0].image}');
  else
    first = SignIn();
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'HelveticaNow',
      ),
      home: Home(name:' ', image:' ')));
  //Home(name:' ', image:' ')));
  //EditContacts(userName: ' ', image: ' ',first:false )
  //SpotMarker()
  //ShareLocation(imageURL:' ')
  //SignIn()
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
        child: TextButton(
          child: Text('Welcome Screen'),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SpotMarker(),
                ));
          },
        ),
      ),
    );
  }
}
