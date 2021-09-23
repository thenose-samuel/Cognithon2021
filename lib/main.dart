import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:crime_watch/submitCrime.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoogleMapController mapController;
  var latitude, longitude;
  String _mapStyle = "none";
  final LatLng _center = const LatLng(55.521563, -122.677433);
  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/mapStyle.txt').then((string) {
      _mapStyle = string;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 25.0),
          child: FloatingActionButton(
            onPressed: () {},
            tooltip: 'Go to current location',
            backgroundColor: Colors.black,
            child: Icon(Icons.gps_fixed_rounded),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        drawer: Drawer(
            child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.purple),
              child: Text("Crime Watch"),
            )
          ],
        )),
        appBar: AppBar(
            centerTitle: true,
            title: const Text('Set Location'),
            backgroundColor: Colors.black,
            actions: [
              IconButton(
                icon: Icon(Icons.done_rounded),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SubmitCrime(latitude: latitude, longitude: longitude)));
                },
              )
            ]),
        body: Stack(children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              mapController.setMapStyle(_mapStyle);
            },
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            onCameraMove: (CameraPosition position) {
              setState(() {
                latitude = position.target.latitude;
                longitude = position.target.longitude;
              });
            },
          ),
          Center(
              child: IgnorePointer(
            child: Icon(
              Icons.location_on_rounded,
              color: CupertinoColors.black,
              size: 40,
            ),
          )),
          Column(children: [
            Text('Latitude: $latitude'),
            Text('Longitude: $longitude')
          ]),
        ]),
      );
  }
}
