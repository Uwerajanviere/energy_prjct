// Import necessary packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import your custom files
import 'provider/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/MyProjectsScreen.dart'; //

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyB2E3cIYu8HNqBhwQXRw94yL11dTwKZOOM",
        authDomain: "energy-invest-b1327.firebaseapp.com",
        projectId: "energy-invest-b1327",
        storageBucket: "energy-invest-b1327.appspot.com",
        messagingSenderId: "1084457651370",
        appId: "1:1084457651370:web:808c945e0187ee583f14d3",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/ownerDashboard': (context) => MyProjectsScreen(), // ✅ Added
      },
    );
  }
}
