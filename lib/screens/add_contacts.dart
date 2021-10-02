import 'package:crime_watch/services/contacts_db.dart';
import 'package:crime_watch/services/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class EditContacts extends StatefulWidget {
  const EditContacts({Key? key}) : super(key: key);

  @override
  _EditContactsState createState() => _EditContactsState();
}

class _EditContactsState extends State<EditContacts> {
  // final _formKey = GlobalKey<FormState>();
  // final _formKey2 = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final _controller2 = TextEditingController();
  ContactsHandler handler = ContactsHandler();

  List<ContactsModel> contacts = [];
  @override

  void initState(){
    refresh();
    super.initState();
  }

  late String name;
  late String number;

  @override
  Widget build(BuildContext context) {
    const title = 'Edit Contacts';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(title),
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
                          cursorColor: Colors.purple,
                          decoration: InputDecoration(
                            hintText: "Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          controller: _controller,
                          onChanged: (value) {
                            name = value;
                            print(name);
                          },
                        ),
                      ),
                      Container(
                        width: 200,
                        child: TextField(
                          cursorColor: Colors.purple,
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
                    color: Colors.purple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                  )
                ],
              ),
            ),
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
                            await delete(index);
                            refresh();
                            // Then show a snackbar.
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('$number deleted')));
                          },
                          // Show a red background as the item is swiped away.
                          background: Container(color: Colors.red),
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
      // floatingActionButtonLocation: FloatingActionButtonLocation.sTop,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){},
      //   backgroundColor: Colors.purple,
      //   child: Icon(Icons.add, color: Colors.black,),
      // ),
    );
  }

  Future<void> delete(int index) async{
    await handler.delete(index);
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
