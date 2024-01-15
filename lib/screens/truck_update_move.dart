import 'dart:ui';

import 'package:flutter/material.dart';

class UpdateTruckMovementScreen extends StatefulWidget {
  @override
  _UpdateTruckMovementScreenState createState() => _UpdateTruckMovementScreenState();
}

class _UpdateTruckMovementScreenState extends State<UpdateTruckMovementScreen> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController timestampController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 199, 196, 180),
        title: Text(
          'Update Truck Movement',
          style: TextStyle(
            fontFamily: 'CustomFont',
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 24,
            shadows: [
              Shadow(
                color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                offset: Offset(2, 2),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background 
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background_image.jpg'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Adjust the sigma values for the blur intensity
              child: Container(
                color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.5), // Adjust the opacity as needed
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    hintText: 'Enter the new location',
                    prefixIcon: Icon(
                      Icons.location_on,
                      size: 30,
                      color: Colors.green,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: timestampController,
                  decoration: InputDecoration(
                    labelText: 'Timestamp',
                    hintText: 'Enter the timestamp',
                    prefixIcon: Icon(
                      Icons.access_time,
                      size: 30,
                      color: Colors.green,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Add your logic to update truck movement here
                    updateTruckMovement(locationController.text, timestampController.text);
                  },
                  child: Text('Update Truck Movement'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Add your function to update the truck movement
  void updateTruckMovement(String location, String timestamp) {
    // Add logic to update the truck movement in your data model or database
    // For simplicity, let's just print the values for now
    print('Updated Truck Movement - Location: $location, Timestamp: $timestamp');

    // You can add further logic to update the truck movement in your app
    // For example, update the UI, send the data to a server, etc.
  }
}
