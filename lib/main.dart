// Import necessary packages
import 'package:firebase_core/firebase_core.dart'; // For initializing Firebase
import 'package:flutter/foundation.dart'; // Provides platform check (e.g., isWeb)
import 'package:flutter/material.dart'; // Main Flutter UI package
import 'package:provider/provider.dart'; // For state management using Provider

// Import your custom files
import 'provider/auth_provider.dart'; // Authentication logic using ChangeNotifier
import 'screens/auth/login_screen.dart'; // Login screen UI
import 'screens/auth/register_screen.dart'; // Register screen UI
import 'screens/home_screen.dart'; // Home screen UI after login

void main() async {
  // Ensure Flutter engine is initialized before calling any async code
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase differently depending on the platform
  if (kIsWeb) {
    // Web requires specific Firebase options
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
    // Mobile platforms can use default initialization
    await Firebase.initializeApp();
  }

  // Start the Flutter application with providers
  runApp(
    MultiProvider(
      providers: [
        // Provide an instance of AuthProvider for authentication state
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(), // Main widget of the app
    ),
  );
}

// The root widget of the app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove debug banner from UI
      initialRoute: '/login', // Default screen shown at startup
      routes: {
        '/login': (context) => LoginScreen(), // Route to login screen
        '/register': (context) => RegisterScreen(), // Route to register screen
        '/home': (context) => HomeScreen(), // Route to home screen after login
      },
    );
  }
}
