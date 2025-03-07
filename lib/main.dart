import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/loading_screen.dart'; // Ensure this file exists
import 'package:mad/providers/favourite_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        appId: '1:687025568382:android:bbafdb91dff967f247b62f',
        apiKey: 'AIzaSyAv-ixINvy84G_agSe2WsZ53dEZpMcCbQ8', // Restrict this key in Firebase settings!
        projectId: 'easy-idama-1234',
        messagingSenderId: '687025568382',
        storageBucket: 'easy-idama-1234.firebasestorage.app',
      ),
    );
    print("🔥 Firebase Initialized");
  } catch (e) {
    print("❌ Firebase Initialization Error: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FavoritesProvider()),
      ],
      child: MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home:  LoadingScreen(), // ✅ Ensure LoadingScreen is the first screen
    );
  }
}
