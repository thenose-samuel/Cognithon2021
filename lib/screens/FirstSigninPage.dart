import 'package:flutter/material.dart';
import 'package:crime_watch/services/sign_in.dart';
import 'package:hexcolor/hexcolor.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  SignInService _signIn = SignInService();
  bool loggedIn = false;
  double opacityVal = 1.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#312f31"),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, top: 100, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "     Welcome to",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 90.0),
                  child: Container(
                    child: Image.asset('lib/assets/logo.png'),
                    width: 220,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 15, right: 15),
              child: Column(
                children: [
                  Text(
                    "View safe spots around you,",
                    //TODO: see if you can 1. align the actual text (not tag) to the center, 2. change the colour of "View safe spots" , "Notify" "safety contacts", "Mark out safe spots"
                    //ill also try to figure this out, but in the morning
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Notify your GPS location to your choice of safety contacts and,",
                    //TODO: see if you can 1. align the actual text (not tag) to the center, 2. change the colour of "View safe spots" , "Notify" "safety contacts", "Mark out safe spots"
                    //ill also try to figure this out, but in the morning
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Mark out Safe Spots you discover for other users",
                    //TODO: see if you can 1. align the actual text (not tag) to the center, 2. change the colour of "View safe spots" , "Notify" "safety contacts", "Mark out safe spots"
                    //ill also try to figure this out, but in the morning
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.00),
              child: Center(
                child: Text(
                  "Sign in using a Google Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: RaisedButton(
                    color: HexColor("#b3dabb"),
                    onPressed: () {
                      _signIn.signup(context);
                      print("SIGN IN");
                    },
                    child: Column(
                      children: [
                        if (!loggedIn)
                          Text(
                            "SIGN IN",
                            style: TextStyle(fontSize: 20),
                          )
                        else
                          Text(
                            "SUCCESS!",
                            style: TextStyle(fontSize: 20),
                          ),
                      ],
                    )),
              ),
            ),
            if (loggedIn)
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Text(
                  "Press the button below continue to the next step!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
