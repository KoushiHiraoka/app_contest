import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'distance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Monitoring extends StatefulWidget {
  const Monitoring({Key? key}) : super(key: key);

  @override
  State<Monitoring> createState() => MonitoringState();
}


class MonitoringState extends State<Monitoring> {
  Position? currentPosition;
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
      currentPosition = await Geolocator.getCurrentPosition();
      _addMarkerFromFirestoreUser();
    });
  }


  Future<Map<String, dynamic>> getUserLocation(String docid) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
    .collection('user')
    .doc(docid)
    .get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    return {
      'latitude': userData['latitude'],
      'longitude': userData['longitude'],
    };
  }

  Future<Map<String, dynamic>> getUserDestination(String docid) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
    .collection('user')
    .doc(docid)
    .get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    return {
      'deslat': userData['deslat'],
      'deslng': userData['deslng'],

    };
  }
    

  void _addMarkerFromFirestoreUser() async {
    Map<String, dynamic> userLocation = await getUserLocation('currentlocation');
    Map<String, dynamic> userDestination = await getUserDestination('destination');

    print(userDestination['deslat']);
    print(userDestination['deslng']);
    print(userLocation['latitude']);
    print(userLocation['longitude']);

    final data = await getDistanceAndDuration(
      userDestination['deslat'],
      userDestination['deslng'],
      userLocation['latitude'],
      userLocation['longitude'],
    );
        setState(() {
      _walkingDistance = data['distanceWalking'] as String;
      _walkingDuration = data['durationWalking'] as String;
      _drivingDistance = data['distanceDriving'] as String;
      _drivingDuration = data['durationDriving'] as String;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('集合状況の確認')),
      body: Stack(
        children: [
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
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
                    const SizedBox(height: 8),
                    const SizedBox(width: 15,),
                    const Text(
                      '車:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    const SizedBox(width: 15,),
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
