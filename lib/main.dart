import 'package:app_contest/home.dart';
import 'package:app_contest/map.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'monitoring.dart';

// main関数を非同期にします
void main() async {
  // Flutterのウィジェットがすべて読み込まれるのを待ちます
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebaseを初期化します
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/map',
      builder: (context, state) => const MapSample(),
    ),
    GoRoute(
      path: '/monitoring',
      builder: (context, state) => const Monitoring(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Google Maps Demo',
      routerConfig:  _router,
    );
  }
}


