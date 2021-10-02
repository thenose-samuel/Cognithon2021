import 'package:crime_watch/services/contacts_db.dart';
import 'package:flutter/material.dart';



class ShareLocation extends StatefulWidget {

  final String imageURL;

   ShareLocation({Key? key, required this.imageURL}) : super(key: key);

  @override
  _ShareLocationState createState() => _ShareLocationState(imageURL);
}

class _ShareLocationState extends State<ShareLocation> {

  String imageURL;
  _ShareLocationState(this.imageURL);

  ContactsHandler handler = ContactsHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notify Contacts'),
      ),
      body: Image.network(imageURL),
    );
  }
}
