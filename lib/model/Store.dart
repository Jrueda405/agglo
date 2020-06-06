import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Store implements Comparable<Store> {
  String name;
  LatLng location;
  int people;
  String size;
  int area;

  Store({this.name, this.location, this.people, this.size, this.area});

  factory Store.fromSnapshot(DataSnapshot snapshot) {
    return Store(
      name: snapshot.value["name"],
      location: LatLng(snapshot.value["location"]['latitude'] as double,
          snapshot.value["location"]['longitude'] as double),
      people: snapshot.value["people"],
      size: snapshot.value["size"],
      area: snapshot.value["area"] as int,
    );
  }

  Map<String, dynamic> toJson(Store instance) => <String, dynamic>{
        'name': instance.name,
        'location': instance.location,
        'people': instance.people,
        'size': instance.size,
        'area': instance.area,
      };

  factory Store.fromJson(Map<dynamic, dynamic> json) {
    return Store(
        name: json["name"],
        location: LatLng(json["location"]['latitude'] as double,
            json["location"]['longitude'] as double),
        people: json["people"],
        size: json["size"],
        area: json["area"] as int);
  }

  @override
  int compareTo(Store other) {
    if (this.people.compareTo(other.people) == 0) {
      return 0;
    } else {
      return this.people - other.people;
    }
  }

  double calculateDistance(LatLng other) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((other.latitude - this.location.latitude) * p) / 2 +
        c(this.location.latitude * p) *
            c(other.latitude * p) *
            (1 - c((other.longitude - this.location.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  double getRisk() {
    if (people != 0) {
      return area / people;
    } else {
      return 0;
    }
  }
}
