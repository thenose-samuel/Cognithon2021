import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:crime_watch/submitCrime.dart';
import 'package:location/location.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;
  var latitude, longitude;
  final LatLng _center = const LatLng(55.521563, -122.677433);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 25.0),
        child: FloatingActionButton(
          onPressed: () {
            goToCurrentLocation();
          },
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        SubmitCrime(latitude: latitude, longitude: longitude)));
              },
            )
          ]),
      body: Stack(children: [
        GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
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


  /*
  * Check if gps is enabled &&
  * Animate camera to current user location
  * */
  Future<void> goToCurrentLocation() async {
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
    });
    print("Successfully configured gps");
    print("$_locationData");
    /***********************/
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(latitude, longitude),zoom: 15.0)));
/*###################################*/
  }
}
