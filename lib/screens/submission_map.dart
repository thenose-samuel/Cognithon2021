import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'submitCrime.dart';
import 'package:location/location.dart';

class SubmissionMap extends StatefulWidget {
  const SubmissionMap({Key? key}) : super(key: key);

  @override
  _SubmissionMapState createState() => _SubmissionMapState();
}

class _SubmissionMapState extends State<SubmissionMap> {
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;
  dynamic latitude, longitude;
  final LatLng _center = const LatLng(55.521563, -122.677433);
  Marker marker = Marker(markerId: const MarkerId('null'));
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
          zoomControlsEnabled: false,
          markers: {
            if (marker != null) marker,
          },
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          onLongPress: addMarker,
          // onCameraMove: (CameraPosition position) {
          //   setState(() {
          //     latitude = position.target.latitude;
          //     longitude = position.target.longitude;
          //   });
          // },
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 250,
            child: Text(
              (latitude == null)?'Select a location':'Latitude: $latitude',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.indigoAccent,
            margin: EdgeInsets.only(right: 200.0),
            padding: EdgeInsets.only(top: 10.0, left: 10.0),
          ),
          Container(
            width: 250,
            child: Text(
              (longitude == null)?'to view coordinates':'Longitude: $longitude',
              style: TextStyle(color: Colors.white),
            ),
            margin: EdgeInsets.only(right: 200.0),
            padding: EdgeInsets.only(bottom: 10.0, top: 10.0, left: 10.0),
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(25.0)),
                color: Colors.indigoAccent),
          )
        ]),
      ]),
    );
  }

/*
* Function to place a marker on the map
* */
  void addMarker(LatLng position) async {
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
      marker = Marker(
        markerId: const MarkerId('event'),
        position: position,
      );
    });
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
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: 15.0)));
/*###################################*/
  }
}
