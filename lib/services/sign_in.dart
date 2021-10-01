import 'package:crime_watch/screens/Homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:crime_watch/main.dart';
import 'package:crime_watch/screens/check_connection.dart';
import 'package:crime_watch/services/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'local_db.dart';

class SignInService{

  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> signup(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      dynamic result = await auth.signInWithCredential(authCredential);
      User? user = await result.user;
      if (result != null) {
        UserModel _user = UserModel(email: '${user!.email}', name: '${user.displayName}', image: '${user.photoURL}');
        /**
         * Inserting user into the db
         * */
        DatabaseHandler handler = DatabaseHandler();
        final Database db = await handler.initializeDB();
        await db.insert('user', _user.toMap());
        //#######
        List<UserModel> firstUser = await handler.retrieveUsers();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home(name: '${firstUser[0].name}', image: '${firstUser[0].image}',)));
      }  // if result not null we simply call the MaterialpageRoute,
      else{
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Error()));
      }
    }
    }
  }
