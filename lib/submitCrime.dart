import 'package:flutter/material.dart';

class SubmitCrime extends StatelessWidget {
  final latitude, longitude;
  SubmitCrime({Key? key, required this.latitude, required this.longitude})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text("Enter details"),
            centerTitle: true,
            backgroundColor: Colors.black,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.done_rounded))
            ],
          ),
          body: Form(),
    )
    );
  }
}
class Form extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //Build the form here
    );
  }
}
