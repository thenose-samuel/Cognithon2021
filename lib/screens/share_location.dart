import 'package:crime_watch/screens/add_contacts.dart';
import 'package:crime_watch/services/contacts_db.dart';
import 'package:crime_watch/services/contacts_model.dart';
import 'package:crime_watch/services/message_handler.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:prompt_dialog/prompt_dialog.dart';

class ShareLocation extends StatefulWidget {
  final String imageURL;

  ShareLocation({Key? key, required this.imageURL}) : super(key: key);

  @override
  _ShareLocationState createState() => _ShareLocationState(imageURL);
}

class _ShareLocationState extends State<ShareLocation> {
  String imageURL;
  _ShareLocationState(this.imageURL);
  List<ContactsModel> contacts = [];
  String locationStatus = "Tap on the text above to get your location";
  String? message = "This is a call for help!";
  double? latitude, longitude;

  ContactsHandler handler = ContactsHandler();
  void initState() {
    loadContacts();
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditContacts(first: false, image: imageURL, userName: "",),
                  )).then((context) {
                setState(() {
                  loadContacts();
                });
              });
            },
            icon: Icon(Icons.edit),
          )
        ],
        title: Text('Notify Contacts',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(imageURL),
                      fit: BoxFit.fill,
                    )),
                child: Text('') //child: Image.network(imageURL)),
                ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text(
                "These are the contacts you have listed that will receive the message",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                ),
              ),
            ),
            Container(
              height: 250,
              child: ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final name = contacts[index].name;
                    final number = contacts[index].number;
                    return Column(
                      children: [
                        // Show a red background as the item is swiped away.
                        ListTile(
                          title: Text(number),
                          subtitle: Text('$name'),
                        ),
                      ],
                    );
                  }),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  locationStatus = "Fetching please wait..";
                });
                await getLocation();
              },
              child: Text(
                'Fetch location',
                style: TextStyle(color: Colors.teal),
              ),
            ),
            Text(
              /*(latitude != null)
                ? 'Location fetched'
                : 'Tap on text above to get your location'*/
              locationStatus,
              style: TextStyle(color: Colors.black54, fontSize: 17),
            ),
            TextButton(
                onPressed: () async {
                  message = (await prompt(
                    context,
                    title: Text('Custom message'),
                    initialValue: '',
                    isSelectedInitialValue: false,
                    textOK: Text('Done'),
                    textCancel: Text('Cancel'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    minLines: 1,
                    maxLines: 3,
                    autoFocus: true,
                    obscureText: false,
                    obscuringCharacter: '•',
                    barrierDismissible: true,
                    //textCapitalization: TextCapitalization.words,
                  ))!;
                  print(message);
                  setState(() {});
                },
                child: Text("Add a custom message?",
                    style: TextStyle(
                        color: Colors.teal,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600))),
            // Text(
            //   "This is what your message currently contains:",
            //   style: TextStyle(
            //     color: Colors.black54,
            //     fontSize: 17,
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 10.0),
            //   child: Text(
            //     "<Your location data>",
            //     style: TextStyle(
            //       color: Colors.black54,
            //     ),
            //   ),
            // ),
            // Text((message != null) ? "${message}" : "")
            RaisedButton(
              onPressed: () async {
                SendSms messageHandler = SendSms();
                String content =
                    "Location link: https://www.google.com/maps/search/?api=1&query=$latitude" +
                        "," +
                        "$longitude Message: $message";
                dynamic response;
                for (int i = 0; i < contacts.length; i++) {
                  String number = "+91${contacts[i].number}";
                  response = await messageHandler.sendMessage(number, content);
                }

                if (response == 201) {
                  _showDialog(context);
                }
              },
              color: Colors.teal,
              child: SizedBox(
                width: 250,
                child: Text(
                  "Share GPS location",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loadContacts() async {
    contacts = await handler.retrieve();
    print(contacts[0].number);
    setState(() {});
  }

  Future<void> getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    late PermissionStatus _permissionGranted;
    late LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    setState(() {
      latitude = _locationData.latitude;
      longitude = _locationData.longitude;
      locationStatus = "Location fetched. You can continue.";
    });
    print("Successfully configured gps");
    print("$_locationData");
  }
}

void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text("Sent Successfully"),
        content: new Text(""),
        actions: <Widget>[
          new FlatButton(
            child: new Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
