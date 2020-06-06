import 'dart:async';
import 'dart:math' show cos, sqrt, asin;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:agglo/Helper/FirebaseHelper.dart';
import 'package:agglo/Screens/NavigatorPage.dart';
import 'package:agglo/styles/AggloColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:agglo/components/Marker.dart';
import 'package:agglo/model/Choice.dart';
import 'package:agglo/model/Constant.dart';
import 'package:agglo/model/Store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class MapView extends StatefulWidget {
  final String idCard;

  MapView({Key key, @required this.idCard}) : super(key: key);

  @override
  MapViewState createState() => MapViewState();
}

const double CAMERA_ZOOM = 20;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;

class MapViewState extends State<MapView> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _position;
  LatLng myLocation;
  List<LatLng> points = List();

  double pinPillPosition = -200;

  final Map<MarkerId, Marker> _markers = Map();
  // this will hold the generated polylines
  Set<Polyline> _polylines = {};
// this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];
// this is the key object - the PolylinePoints
// which generates every polyline between start and finish
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPIKey = "AIzaSyBaMa_XCvvAfkZW6LGh-dZWj2HmlcKab9M";

  List<Store> stores;
  final List<DropdownMenuItem> items = [];

  Store _selectedStore;

  final Stream myStream = FirebaseHelper.listenForChanges();
  var subscription;
  Future<void> _future;

  @override
  void initState() {
    super.initState();
    _future = setUp().whenComplete(() {
      stores.forEach((element) {
        items.add(DropdownMenuItem(
          child: Text(element.name),
          value: element,
        ));
      });
      subscription = myStream.listen((data) {
        var _newStoreUpdate;
        setState(() {
          //validar si cambio la tienda seleccionada
          _newStoreUpdate = data;
          print(
              "la tienda ${stores[stores.indexOf(stores.firstWhere((element) => element.name == data.name))].name} se actualizo");

          if (_selectedStore.name == _newStoreUpdate.name) {
            _selectedStore = data;
          }
          stores[stores.indexOf(
                  stores.firstWhere((element) => element.name == data.name))] =
              data;

          sortAll(stores, 0, stores.length - 1, myLocation);
        });

        if (_selectedStore.compareTo(stores.first) > 0) {
          _showDialog(stores.first);
        }
      });
    });
  }

  void _showDialog(Store s) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Sugerencia:"),
          content: new Text("Hemos encontrado una tienda con un riesgo menor"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Aceptar"),
              onPressed: () {
                setState(() {
                  _selectedStore = s;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogSearch() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Selecciona un establecimiento:"),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      decoration:
                          InputDecoration(suffixIcon: Icon(Icons.search)),
                    ),
                  ),
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,

                    children: [
                      ListTile(title: Text("AA"),selected: true, leading: Icon(Icons.store),),
                      ListTile(title: Text("BB"),selected: false, leading: Icon(Icons.store),),

                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Aceptar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> setUp() async {
    print("set up");
    stores = await FirebaseHelper.getStores();

    //Location
    Position p = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    myLocation = LatLng(p.latitude, p.longitude);

    //SORTING
    sortAll(stores, 0, stores.length - 1, myLocation);
    _selectedStore = stores.first;

    generateMarkers();

    pinPillPosition = 10;

    _position = CameraPosition(
        target: myLocation,
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: FutureBuilder(
          future: _future,
          builder: (context, data) {
            if (stores == null || _position == null) {
              return Center(child: CircularProgressIndicator());
            }
            Color myColor =
                _selectedStore.getRisk() <= 9 ? Colors.white : Colors.black;
            return Stack(
              children: <Widget>[
                Container(
                  constraints: BoxConstraints.expand(),
                  child: SizedBox(
                      width: MediaQuery.of(context)
                          .size
                          .width, // or use fixed size like 200
                      height: MediaQuery.of(context).size.height,
                      child: GoogleMap(
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        compassEnabled: false,
                        zoomControlsEnabled: false,
                        polylines: _polylines,
                        mapType: MapType.normal,
                        markers: Set.of(_markers.values),
                        initialCameraPosition: _position,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                          setPolylines();
                        },
                        onTap: onMapTap,
                      )),
                ),
                //Appbar
                AnimatedPositioned(
                  duration: Duration(milliseconds: 200),
                  bottom: pinPillPosition,
                  right: 10,
                  left: 10,
                  child: Card(
                    color: const Color(0xffffffff),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white70, width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      //first
                      children: [
                        ListTile(
                          leading: GestureDetector(
                            child: CircleAvatar(
                              radius: 20,
                              child: Text(_selectedStore.name.substring(0, 1)),
                            ),
                            onTap: () {
                              setState(() {
                                _position = CameraPosition(
                                    target: _selectedStore.location,
                                    zoom: CAMERA_ZOOM,
                                    tilt: CAMERA_TILT,
                                    bearing: CAMERA_BEARING);
                              });
                            },
                          ),
                          title: Text(
                            '${_selectedStore.name}',
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 16,
                              color: const Color(0xff000000),
                              fontWeight: FontWeight.w700,
                              height: 1.25,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          subtitle: Text(
                            '${_selectedStore.name}',
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 12,
                              color: const Color(0xff000000),
                            ),
                            textAlign: TextAlign.left,
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.find_replace),
                            onPressed: () {
                              setState(() {
                                sortAll(
                                    stores, 0, stores.length - 1, myLocation);
                                _selectedStore = stores.first;
                              });
                            },
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(left: 15, right: 15, bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: (_selectedStore.getRisk() >= 9)
                                ? Colors.amber
                                : Colors.red,
                            border: Border.all(
                                width: 1.0, color: const Color(0x00000000)),
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0x29000000),
                                  offset: Offset(0, 3),
                                  blurRadius: 8)
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 30, right: 30, top: 7, bottom: 7),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Column(
                                  children: [
                                    Icon(
                                      Icons.people,
                                      color: myColor,
                                      size: 19,
                                    ),
                                    Text(
                                      "${_selectedStore.people}",
                                      style: TextStyle(color: myColor),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Tamaño',
                                      style: TextStyle(
                                        fontFamily: 'Segoe UI',
                                        fontSize: 14,
                                        color: myColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text('${_selectedStore.size}',
                                        style: TextStyle(color: myColor)),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Distancia',
                                      style: TextStyle(
                                        fontFamily: 'Segoe UI',
                                        fontSize: 14,
                                        color: myColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                        '${num.tryParse(_selectedStore.calculateDistance(myLocation).toStringAsFixed(2))} M.',
                                        style: TextStyle(color: myColor)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Apbar
                Positioned(
                  top: 30,
                  right: 10,
                  left: 10,
                  child: Container(
                    height: height * 0.10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                          width: 1.0, color: const Color(0x00000000)),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0x29000000),
                            offset: Offset(0, 3),
                            blurRadius: 8)
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: PopupMenuButton(
                              icon: SvgPicture.string(
                                stringSVGStore,
                                width: 24,
                                height: 24,
                                allowDrawingOutsideViewBox: true,
                              ),
                              itemBuilder: (BuildContext context) {
                                return choices.map((Choice choice) {
                                  return PopupMenuItem<Choice>(
                                    value: choice,
                                    child: Text(choice.title),
                                  );
                                }).toList();
                              }),
                        ),
                        Flexible(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              onTap: () {
                                _showDialogSearch();
                              },
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.search)),
                              enableInteractiveSelection: false,
                              readOnly: true,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              child: CircleAvatar(
                                backgroundColor: AggloColors.primaryColor,
                                child: Text('A'),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            NavigatorPage(
                                              idCard: widget.idCard,
                                            )));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void generateMarkers() {
    stores.forEach((element) {
      final markerId = MarkerId(_markers.length.toString());
      final marker = Marker(
        onTap: () {
          setState(() {
            pinPillPosition = 10;
            _selectedStore = stores.firstWhere((element) =>
                calculateDistance(
                    element.location, _markers[markerId].position) ==
                0);
          });
        },
        markerId: markerId,
        position: element.location,
      );
      setState(() {
        _markers[markerId] = marker;
      });
    });
  }

  setPolylines() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints?.getRouteBetweenCoordinates(
        googleAPIKey,
        PointLatLng(myLocation.latitude, myLocation.longitude),
        PointLatLng(_selectedStore.location.latitude,
            _selectedStore.location.longitude));

    if (result.points.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates);

      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      _polylines.add(polyline);
    });
  }

  void onMapTap(LatLng pos) {
    print(_markers.length);
    print(pos);
  }

  Future<Uint8List> painterToBitmap(String label) async {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    MarkerPaint paint = MarkerPaint(label, 19, "");
    paint.paint(canvas, Size(300, 1000));
    final ui.Image image = await recorder.endRecording().toImage(300, 70);
    final ByteData byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData.buffer.asUint8List();
  }

  void sortAll(List<Store> list, int l, int r, LatLng pos) {
    stores.sort(
        (a, b) => a.calculateDistance(pos).compareTo(b.calculateDistance(pos)));
    stores.sort();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onMarkerTapped(Marker marker) {
    var selectedMarker =
        _markers[marker.markerId]; // here you will get your id.
    debugPrint(selectedMarker.toString());
  }

  double calculateDistance(LatLng pos1, LatLng pos2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((pos2.latitude - pos1.latitude) * p) / 2 +
        c(pos1.latitude * p) *
            c(pos2.latitude * p) *
            (1 - c((pos2.longitude - pos1.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }
}
