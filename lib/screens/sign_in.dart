import 'package:flutter/material.dart';
import 'package:crime_watch/services/sign_in.dart';


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
      backgroundColor: Colors.black,
      // floatingActionButton: Opacity(
      //   opacity: opacityVal,//(loggedIn)?setState((){opacityVal = 1.0}):setState((){opacityVal = 0.0}),
      //   child: FloatingActionButton.extended(
      //     onPressed: () {},
      //     backgroundColor: Colors.purple,
      //     label: Text(
      //       "Continue",
      //       style: TextStyle(
      //         fontSize: 20,
      //         fontWeight: FontWeight.w400,
      //         color: Colors.black,
      //       ),
      //     ),
      //     icon: Icon(Icons.arrow_forward_ios_rounded,
      //     color: Colors.black,),
      //   ),
      // ),
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome to \n <App Name>",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  "Some placeholder text about the app",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.00),
                child: Text(
                  "Press the button below to sign in using your google account",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: RaisedButton(
                  color: Colors.purple,
                  onPressed: () {
                    _signIn.signup(context);
                    print("SIGN IN");
                  },
                  child: Column(
                    children: [
                      if(!loggedIn)Text(
                        "SIGN IN",
                        style: TextStyle(fontSize: 20),
                      )
                      else Text(
                        "SUCCESS!",
                        style: TextStyle(fontSize: 20),
                      ),

                    ],
                  )
                ),

              ),
              if(loggedIn) Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Text(
                  "Press the button below continue to the next step!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),

    );
  }
}
