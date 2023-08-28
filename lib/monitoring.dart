import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'distance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart'; 


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
  String _username = '';

 
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


  Future<Map<String, dynamic>> getUserLocation() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
    .collection('Location')
    .doc(userId)
    .get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    return userData['currentlocation'] as Map<String, dynamic>; 
   }

  Future<Map<String, dynamic>> getUserDestination() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
    .collection('Location')
    .doc(userId)
    .get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
   return userData['destination'] as Map<String, dynamic>;
   }
   
  Future<String> getUserName() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    return userData['username'] as String;
}
    
    
    
  void _addMarkerFromFirestoreUser() async {
    Map<String, dynamic> userLocation = await getUserLocation();
    Map<String, dynamic> userDestination = await getUserDestination();

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
      title: const Text('いまどこ？', style: TextStyle(color: Colors.black)),  // テキストカラーを黒に変更
      backgroundColor: Colors.white12, 
    ),
    body: SingleChildScrollView(  // スクロール可能にするためにSingleChildScrollViewを使用
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
              Text(
                'ユーザー名: $_username',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black), 
              ),
              const SizedBox(height: 4),
              const Text(
                '徒歩:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),  
              ),
              const SizedBox(height: 4),
              Text('距離: $_walkingDistance', style: TextStyle(color: Colors.black)), 
              Text('時間: $_walkingDuration', style: TextStyle(color: Colors.black)),  
              const SizedBox(height: 8),
              const SizedBox(width: 15,),
              const Text(
                '車:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black), 
              ),
              const SizedBox(height: 4),
              const SizedBox(width: 15,),
              Text('距離: $_drivingDistance', style: TextStyle(color: Colors.black)), 
              Text('時間: $_drivingDuration', style: TextStyle(color: Colors.black)),  
            ],
          ),
        ),
      ),
    ),
  );
}
}