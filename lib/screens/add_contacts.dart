import 'package:crime_watch/screens/Homepage.dart';
import 'package:crime_watch/services/contacts_db.dart';
import 'package:crime_watch/services/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:hexcolor/hexcolor.dart';

class EditContacts extends StatefulWidget {
  bool first;
  String userName, image;
  EditContacts({Key? key, required this.first, required this.userName, required this.image}) : super(key: key);

  @override
  _EditContactsState createState() => _EditContactsState(this.first, this.userName, this.image);
}

class _EditContactsState extends State<EditContacts> {
  // final _formKey = GlobalKey<FormState>();
  // final _formKey2 = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final _controller2 = TextEditingController();
  ContactsHandler handler = ContactsHandler();

  List<ContactsModel> contacts = [];
    bool first;
    String _name, image;
  _EditContactsState(this.first, this._name, this.image);
  @override

  void initState(){
    refresh();
    super.initState();
  }

  late String name;
  late String number;

  @override
  Widget build(BuildContext context) {

    String title;
    (first)?title = 'Add Contacts':title = 'Edit Contacts';
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        actions: [
          if(first) IconButton(
            onPressed: (){
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home(name: _name, image: image)));

            },
            icon: Icon(Icons.arrow_forward_ios_rounded)
          )
        ],
        centerTitle: true,
        title:  Text(title),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 200,
                        child: TextField(
                          cursorColor: Colors.teal[300],
                          decoration: InputDecoration(
                            hintText: "Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          controller: _controller,
                          onChanged: (value) {
                            name = value;
                          },
                        ),
                      ),
                      Container(
                        width: 200,
                        child: TextField(
                          cursorColor: Colors.teal[300],
                          decoration: InputDecoration(
                            hintText: "Contact no.",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          controller: _controller2,
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                            signed: false,
                          ),
                          onChanged: (value) {
                            number = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  MaterialButton(
                    onPressed: () async {
                      await addContact();
                    },
                    child: Icon(Icons.add),
                    color: Colors.teal[300],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                  )
                ],
              ),
            ),
            Text('Swipe a contact to the any side to delete', style: TextStyle(color: Colors.black54),),
            Container(
              height: 300,
              child: ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final name = contacts[index].name;
                    final number = contacts[index].number;
                    return Column(
                      children: [
                        Dismissible(
                          // Each Dismissible must contain a Key. Keys allow Flutter to
                          // uniquely identify widgets.
                          key: UniqueKey(),
                          // Provide a function that tells the app
                          // what to do after an item has been swiped away.
                          onDismissed: (direction) async {
                            // Remove the item from the data source
                            await delete(int.parse(number));
                            refresh();
                            // Then show a snackbar.
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('$number deleted')));
                          },
                          // Show a red background as the item is swiped away.
                          background: Container(color: Colors.teal[300]),
                          child: ListTile(
                            title: Text(number),
                            subtitle: Text('$name'),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),

    );
  }

  Future<void> delete(int number) async{
    //print(index);
    await handler.delete(number);
}
  void refresh() async{
    contacts = await handler.retrieve();
    print(contacts.length);
    setState((){});
  }

  Future<void> addContact() async {
    ContactsModel _contact = ContactsModel(name: '$name', number: '$number');
    Database db = await handler.initializeDB();
    await db.insert('contacts', _contact.toMap());
    refresh();
  }
}
