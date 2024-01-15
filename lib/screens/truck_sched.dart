import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:haulier_track_app/screens/signin.dart';
import '../main.dart';
import '../models/trip_details.dart';
import 'package:haulier_track_app/screens/profile_management.dart';
import 'package:haulier_track_app/screens/truck_trip.dart';
import 'package:haulier_track_app/screens/truck_view_util.dart';
import 'package:haulier_track_app/screens/about_driver.dart';

import 'about_truck.dart';
import 'truck_update_move.dart';

class DashboardScreen extends StatefulWidget {
  final List<TruckTrip> truckTrips;

  DashboardScreen({required this.truckTrips, TruckTrip? selectedTrip});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TruckTrip? selectedTrip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 199, 196, 180),
        title: Text(
          'Dashboard',
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
      ),
      drawer: _buildDrawer(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/images/background_image.jpg"), // Replace with your image asset path
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSelectedTripCard(selectedTrip),
                SizedBox(height: 10),
                _buildTruckTripList(widget.truckTrips),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: Container(
        color: Color.fromARGB(255, 184, 176, 134),
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      // You may need to fetch the user's profile picture
                      // child: Image.network('url_to_user_profile_picture'),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigate to Profile Management screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileManagementScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'User',
                        style: TextStyle(
                          color: Color.fromARGB(255, 105, 83, 50),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildDrawerItem(Icons.dashboard, 'Dashboard', () {
              Navigator.pop(context);
              // Navigate to Dashboard screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardScreen(
                    truckTrips: widget.truckTrips,
                  ),
                ),
              );
            }),
            _buildDrawerItem(Icons.local_shipping, 'Truck List', () {
              Navigator.pop(context);
              // Navigate to Truck List screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TruckListViewPage(),
                ),
              );
            }),
            _buildDrawerItem(Icons.person, 'Driver List', () {
              Navigator.pop(context);
              // Navigate to Driver List screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutDriverPage(),
                ),
              );
            }),
            _buildDrawerItem(Icons.schedule, 'Truck Trips', () {
              Navigator.pop(context);
              // Navigate to Truck Trips screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TruckTripScreen(
                    onTripUpdated: (TruckTrip updatedTrip) {
                      _handleTripUpdated(updatedTrip);
                    },
                    truckTrips: widget.truckTrips, drivers: [], trucks: [],
                  ),
                ),
              );
            }),
            _buildDrawerItem(Icons.local_shipping, 'Truck Update Movement', () {
              Navigator.pop(context);
              // Navigate to Truck List screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateTruckMovementScreen(),
                ),
              );
            }),
            _buildDrawerItem(Icons.analytics, 'Reports & Analytics', () {
              Navigator.pop(context);
              // Navigate to Reports & Analytics screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TruckUtilizationAnalyticsScreen(),
                ),
              );
            }),
            _buildDrawerItem(Icons.logout, 'Logout', () {
              _showLogoutConfirmationDialog();
              //Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildSelectedTripCard(TruckTrip? trip) {
    if (trip == null) {
      return Container();
    }

    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Trip Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Task: ${trip.task}'),
            Text('From: ${trip.from}'),
            Text('To: ${trip.to}'),
            Text('Distance: ${trip.distance} km'),
            Text('Date: ${trip.date.toLocal()} ${trip.time.format(context)}'),
            Text('Assign To: ${trip.assignTo}'),
            Text('Truck ID: ${trip.truckId}'),
          ],
        ),
      ),
    );
  }

  Widget _buildTruckTripList(List<TruckTrip> trips) {
    return Expanded(
      child: ListView.builder(
        itemCount: trips.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Truck ID: ${trips[index].truckId}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Task: ${trips[index].task}'),
                  Text('From: ${trips[index].from}'),
                  Text('To: ${trips[index].to}'),
                  Text('Distance: ${trips[index].distance} km'),
                  Text(
                      'Date: ${trips[index].date}, ${trips[index].time.format(context)}'),
                  Text('Assign To: ${trips[index].assignTo}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => _startEditing(trips[index]),
                        child: Text('Edit'),
                      ),
                      TextButton(
                        onPressed: () => _deleteTruckTrip(index),
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _startEditing(TruckTrip trip) {
    setState(() {
      selectedTrip = trip;
    });

    // You can also navigate to an edit screen with the selected trip
    // For example:
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TruckTripScreen(onTripUpdated: _handleTripUpdated, truckTrips: [], drivers: [], trucks: [],),
      ),
    );
  }

  // Callback function to handle trip updates from TruckTripScreen
  void _handleTripUpdated(TruckTrip updatedTrip) {
    // Check if it's a new trip or an update
    if (selectedTrip != null) {
      // Existing trip was updated
      int index = widget.truckTrips.indexOf(selectedTrip!);
      setState(() {
        widget.truckTrips[index] = updatedTrip;
        selectedTrip = null;
      });
    } else {
      // New trip was added
      setState(() {
        widget.truckTrips.add(updatedTrip);
      });
    }
  }

  void _deleteTruckTrip(int index) {
    // Add a confirmation dialog if needed
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Truck Trip'),
          content: Text('Are you sure you want to delete this truck trip?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                // Delete the truck trip
                _deleteTruckTripConfirmed(index);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTruckTripConfirmed(int index) {
    setState(() {
      widget.truckTrips.removeAt(index);
      selectedTrip = null;
    });
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                // Perform logout logic here (if needed)
                _performLogout();
                // Navigate to the login screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                ); // Close the dialog
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _performLogout() {
    // Perform any necessary logout logic here
    // For example, clear user credentials, navigate to the login screen, etc.

    // Display a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('successfully logged out.'),
        duration: Duration(seconds: 3),
      ),
    );

    // Navigate to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
