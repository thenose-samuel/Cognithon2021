import 'dart:async';
import 'package:crime_watch/screens/MarkSafeSpot.dart';
import 'package:crime_watch/services/mapStyle.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:crime_watch/services/data_handler.dart';

import 'add_contacts.dart';

class Home extends StatefulWidget {
   String name, image;
   Home({Key? key, required this.name, required this.image}) : super(key: key);

  @override
  _HomeState createState() => _HomeState(name, image);
}

class _HomeState extends State<Home> {
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;
  dynamic latitude = 55.521563, longitude = -122.677433;
  bool loaded = false;
  late List<Marker> markerList = <Marker>[];
  dynamic markers;
  Map<dynamic, dynamic> data = {};
  late String name, image;
  _HomeState(this.name, this.image);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      int index = name.indexOf(' ');
      name = name.substring(0, index);
      goToCurrentLocation();
      getMarkers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 150.0),
        child: FloatingActionButton(
          backgroundColor: Colors.purple,
          child: Icon(
            Icons.location_on_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            goToCurrentLocation();
          },
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text('Welcome back, $name'),
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 150.0),
            child: GoogleMap(
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                controller.setMapStyle(Utils.mapStyle);
                _controller.complete(controller);
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(latitude, longitude),
                zoom: 1.0,
              ),
              markers: markerList.toSet(),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditContacts(),
                      ));
                },
                color: Colors.purple,
                child: SizedBox(
                  width: 250,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.share_rounded),
                      ),
                      Text(
                        "Share your location",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      getMarkers();
                    },
                    child: Text(
                      "Refresh Markers",
                      style: TextStyle(
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditContacts(),
                            ));
                      },
                      child: Text(
                        "Edit saved contacts",
                        style: TextStyle(
                          color: Colors.purple,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SpotMarker(),
                      ));
                },
                color: Colors.purple,
                child: SizedBox(
                  width: 250,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.location_on_rounded),
                      ),
                      Text(
                        "Mark a safe spot",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
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
    /***********************/
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: 15.0)));
/*###################################*/
  }

  Future<void> getMarkers() async {
    final databaseRef = FirebaseDatabase.instance.reference();
    await databaseRef.once().then((DataSnapshot snapshot) {
      var marker = snapshot.value['Markers'];
      int count = 0;
      marker.forEach((key, value) {
        print(value);
        LatLng position = LatLng(
            double.parse(value['latitude']), double.parse(value['longitude']));
        String rating = value['rating'].toString();
        String desc = value['description'].toString();
        Marker mark = Marker(
            markerId: MarkerId('$count'),
            position: position,
            infoWindow: InfoWindow(
              title: 'Safety rating: $rating/5.0',
              snippet: desc,
            ),
        );
        markerList.add(mark);
        count++;
      });
      setState(() {
        loaded = true;
      });
      print(markerList);
    });
  }
}


