import 'dart:async';
import 'package:crime_watch/services/mapStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:prompt_dialog/prompt_dialog.dart';
import 'package:crime_watch/services/data_handler.dart';


class SubmissionMap extends StatefulWidget {
  const SubmissionMap({Key? key}) : super(key: key);

  @override
  _SubmissionMapState createState() => _SubmissionMapState();
}

class _SubmissionMapState extends State<SubmissionMap> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => goToCurrentLocation());
  }
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController mapController;
  double _opacity = 0;
  dynamic latitude, longitude;
  dynamic description, rating;
  final LatLng _center = const LatLng(55.521563, -122.677433);
  Marker marker = Marker(markerId: const MarkerId('null'));

  @override
  Widget build(BuildContext context2) {
    return Scaffold(
      backgroundColor: Colors.teal[300],
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 160.0),
        child: FloatingActionButton(
          onPressed: () {
            goToCurrentLocation();
          },
          tooltip: 'Go to current location',
          backgroundColor: Colors.teal[800],
          child: Icon(
            Icons.gps_fixed_rounded,
            color: Colors.black,
          ),
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Mark a safe spot',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.teal[800],
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(
              top: 10.0, bottom: 20.0, left: 10.0, right: 10.0),
          child: Text(
            "Mark a safe spot by long tapping on the map so that our other users may benefit from it in the future.",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: Colors.teal[800]),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 150.0, top: 100.0, right: 12.0, left: 12.0),
            child: GoogleMap(
              zoomControlsEnabled: false,
              markers: {
                if (marker.markerId != MarkerId('null')) marker,
              },
              onMapCreated: (GoogleMapController controller) {
                controller.setMapStyle(Utils.mapStyle);
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
        Column(crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SingleChildScrollView(
                child: Opacity(
                  opacity: _opacity,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          "Rate the safety provided by this location",
                          style: TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.w400,
                              fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 50, left:50, bottom: 10.0,top:10.0),
                        child: Container(
                          //color: Colors.grey[800],
                          child: RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rate) {
                              print(rating);
                              rating = rate;
                            },
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                              onPressed: () async {
                                description = await prompt(
                                  context,
                                  title: Text('Description'),
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
                                  textCapitalization: TextCapitalization.words,
                                );
                                print(description);
                              },
                              child: Text("Add a short description?",
                                  style: TextStyle(
                                      color: Colors.teal[800], fontSize: 15.0, fontWeight: FontWeight.w600))),
                          RaisedButton(
                            onPressed: () async{
                              DatabaseService write = DatabaseService();
                              await write.writeToDatabase(latitude, longitude, rating,description);
                              print("Write successful");
                              description = null;
                              return showDialog(
                                  context: context2,
                                  builder: (ctx) => AlertDialog(
                                    content: Text("Successfully Added"),
                                    actions: [
                                      TextButton(
                                        onPressed: (){
                                          int count = 0;
                                          Navigator.of(context).popUntil((_) => count++ >= 2);
                                        },
                                        child: Text("Ok"),
                                      )
                                    ],
                                  )
                              );
                            },
                            child: Text('SUBMIT'),
                            color: Colors.teal[800],
                          )
                        ],
                      )
                    ],
                  ),
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
      _opacity = 1.0;
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
