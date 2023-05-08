import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'distance.dart';

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
    target: LatLng(33.8391, 132.7655),
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
    });
  }

  void _addMarker(LatLng tapPosition) async {
    if (currentPosition != null) {
      print("=====addMarker=====");
      print(currentPosition);
      print(tapPosition);
      final data = await getDistanceAndDuration(
        currentPosition!.latitude,
        currentPosition!.longitude,
        tapPosition.latitude,
        tapPosition.longitude,
      );
      setState(() {
        print("=====addMarker setState()=====");
        print(data);
        _walkingDistance = data['distanceWalking'] as String;
        _walkingDuration = data['durationWalking'] as String;
        _drivingDistance = data['distanceDriving'] as String;
        _drivingDuration = data['durationDriving'] as String;
        _markers.add(
          Marker(
            markerId: MarkerId(tapPosition.toString()),
            position: tapPosition,
          ),
        );
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Distance and Duration')),
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
