import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'distance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Position? currentPosition;

  late GoogleMapController _controller;
  late StreamSubscription<Position> positionStream;
  final Set<Marker> _markers = {};

  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(33.5781, 130.2596),
    zoom: 10,
  );

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  String _walkingDistance = '';
  String _walkingDuration = '';
  String _drivingDistance = '';
  String _drivingDuration = '';

  @override
  void initState() {
    super.initState();

    Future(() async {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
    });

    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      currentPosition = position;
       if (position != null) {
    uploadLocation(position, 'currentlocation');//追加
  }
    });
  }





  void _addMarker(LatLng tapPosition) async {
  if (currentPosition != null) {
    final data = await getDistanceAndDuration(
      currentPosition!.latitude,
      currentPosition!.longitude,
      tapPosition.latitude,
      tapPosition.longitude,
    );
       if (tapPosition != null) {
    uploadtapLocation(tapPosition, 'destination');//追加
  }
    setState(() {
      _walkingDistance = data['distanceWalking'] as String;
      _walkingDuration = data['durationWalking'] as String;
      _drivingDistance = data['distanceDriving'] as String;
      _drivingDuration = data['durationDriving'] as String;
      _markers.clear();  // 既存のマーカーを全て削除
      _markers.add(
        Marker(
          markerId: MarkerId(tapPosition.toString()),
          position: tapPosition,
        ),
      );
    });
  }
}

//追加
void uploadLocation(position, docid) async {
  CollectionReference users = FirebaseFirestore.instance.collection('user');
//ユーザーの位置情報を更新する
  await users.doc(docid).set({
    'latitude': position.latitude,
    'longitude': position.longitude,
  }, SetOptions(merge: true));  // 他の情報を消さずに情報を追加
}//

void uploadtapLocation(tapPosition, docid) async {
  CollectionReference users = FirebaseFirestore.instance.collection('user');
//ユーザーの位置情報を更新する
  await users.doc(docid).set({
    'deslat': tapPosition.latitude,
    'deslng': tapPosition.longitude,
  }, SetOptions(merge: true));  // 他の情報を消さずに情報を追加
}//



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('現在地を確認')),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
             _controller = controller;
            },
            markers: _markers,
            onTap: _addMarker, // 変更：1タップでピンを追加
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '徒歩:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Text('距離: $_walkingDistance'),
                    Text('時間: $_walkingDuration'),
                    const SizedBox(height: 12),
                    const Text(
                      '車:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Text('距離: $_drivingDistance'),
                    Text('時間: $_drivingDuration'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
