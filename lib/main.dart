import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:haulier_track_app/screens/signin.dart';
import 'package:haulier_track_app/screens/signup.dart';
import 'package:haulier_track_app/screens/truck_sched.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Haulier Tracking',
      routes: {
        '/DashboardScreen': (context) => DashboardScreen(truckTrips: []),
        // ... other routes ...
      },
      home: MainScreen(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          toolbarTextStyle: TextTheme(
            headline6: TextStyle(
              fontFamily: 'CustomFont',
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ).bodyText2,
          titleTextStyle: TextTheme(
            headline6: TextStyle(
              fontFamily: 'CustomFont',
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ).headline6,
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 199, 196, 180),
        title: Text(
          'Haulier Tracking',
          style: TextStyle(
            fontFamily: 'CustomFont',
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 24,
            shadows: [
              Shadow(
                color: const Color.fromARGB(255, 255, 255, 255)
                    .withOpacity(0.5), // Adjust the shadow color and opacity
                offset: Offset(2, 2), // Adjust the shadow offset
                blurRadius: 2, // Adjust the shadow blur radius
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background_image.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome \nto \nHaulier Tracking!',
                  style: TextStyle(
                    fontFamily: 'CustomFont',
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(221, 255, 255, 255),
                    letterSpacing:
                        1.2, // Increase letter spacing for a more professional look
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(
                            0.5), // Adjust the shadow color and opacity
                        offset: Offset(2, 2), // Adjust the shadow offset
                        blurRadius: 2, // Adjust the shadow blur radius
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 100),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary:
                        Color.fromARGB(255, 79, 77, 65), // Background color
                    onPrimary: Color.fromARGB(255, 218, 227, 215), // Text color
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5, // Shadow elevation
                  ),
                  child: Text('Login',
                      style: TextStyle(
                        fontFamily: 'CustomFont',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(
                                0.5), // Adjust the shadow color and opacity
                            offset: Offset(2, 2), // Adjust the shadow offset
                            blurRadius: 1, // Adjust the shadow blur radius
                          ),
                        ],
                      )),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 224, 232, 225),
                    onPrimary: Color.fromARGB(255, 0, 0, 0), // Text color
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5, // Shadow elevation
                  ),
                  child: Text('Sign Up',
                      style: TextStyle(
                        fontFamily: 'CustomFont',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(
                                0.5), // Adjust the shadow color and opacity
                            offset: Offset(2, 2), // Adjust the shadow offset
                            blurRadius: 1, // Adjust the shadow blur radius
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
