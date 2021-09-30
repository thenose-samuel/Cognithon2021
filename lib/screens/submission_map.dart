import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
  double _opacity = 0.5;
  dynamic latitude, longitude;
  final LatLng _center = const LatLng(55.521563, -122.677433);
  Marker marker = Marker(markerId: const MarkerId('null'));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 145.0),
        child: FloatingActionButton(
          onPressed: () {
            goToCurrentLocation();
          },
          tooltip: 'Go to current location',
          backgroundColor: Colors.purpleAccent,
          child: Icon(
            Icons.gps_fixed_rounded,
            color: Colors.black,
          ),
        ),
      ),
      // drawer: Drawer(
      //     child: ListView(
      //   padding: EdgeInsets.zero,
      //   children: [
      //     const DrawerHeader(
      //       decoration: BoxDecoration(color: Colors.purple),
      //       child: Text("Crime Watch"),
      //     )
      //   ],
      // )),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {},
        ),
        title: const Text(
          'Mark a safe spot',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.black,
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.done_rounded),
        //     onPressed: () {
        //       Navigator.of(context).push(MaterialPageRoute(
        //           builder: (context) =>
        //               SubmitCrime(latitude: latitude, longitude: longitude)));
        //     },
        //   )
        // ]
      ),
      body: Stack(children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 150.0, top: 150.0),
            child: GoogleMap(
              zoomControlsEnabled: false,
              markers: {
                if (marker.markerId != MarkerId('null')) marker,
              },
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              onLongPress: addMarker,
            ),
          ),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 10.0, bottom: 20.0, left: 10.0, right: 10.0),
            child: Text(
              "Mark a safe spot by long tapping on the map so that our other users may benifit from it in the future.",
              style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
          ),
          Container(
            width: 250,
            child: Text(
              (latitude == null) ? 'Select a location' : 'Latitude: $latitude',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.indigoAccent,
            margin: EdgeInsets.only(right: 200.0),
            padding: EdgeInsets.only(top: 10.0, left: 10.0),
          ),
          Container(
            width: 250,
            child: Text(
              (longitude == null)
                  ? 'to view coordinates'
                  : 'Longitude: $longitude',
              style: TextStyle(color: Colors.white),
            ),
            margin: EdgeInsets.only(right: 200.0),
            padding: EdgeInsets.only(bottom: 10.0, top: 10.0, left: 10.0),
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(25.0)),
                color: Colors.indigoAccent),
          ),
          Container(
            height: 320,
          ),
          Opacity(
            opacity: _opacity,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Rate the safety provided by this location",
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 20),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 70, left: 70),
                  child: RatingBar.builder(
                    initialRating: 5,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: Text("Add a short description?",
                            style:
                                TextStyle(color: Colors.purple, fontSize: 15.0))),
                    RaisedButton(
                      onPressed: () {},
                      child: Text('SUBMIT'),
                      color: Colors.purple,
                    )
                  ],
                )
              ],
            ),
          ),
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
