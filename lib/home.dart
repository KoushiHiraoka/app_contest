import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference userRef = firestore.collection('user');
/*
Future<void> getData() async {
    DocumentSnapshot snapshot = await userRef.doc('vnBW9ZZJMfAwx0qTKmJf').get();
    if (snapshot.exists) {
      print('User data: ${snapshot.data()}');
    } else {
      print('User data not found!');
    }
  }
  */
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('待ち合わせアプリ'),
            ElevatedButton(
              onPressed: () {
                context.push('/map');
              },
              child: const Text('Mapを開く'),
            ),
            ElevatedButton(
              onPressed: () {
                context.push('/monitoring');
              },
              child: const Text('集合状況を確認する'),
            ),
          ],
        ),
      ),
    );
  }
}