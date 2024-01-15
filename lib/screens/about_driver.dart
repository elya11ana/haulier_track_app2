import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/driver.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutDriverPage extends StatefulWidget {
  @override
  _AboutDriverPageState createState() => _AboutDriverPageState();
}

class _AboutDriverPageState extends State<AboutDriverPage> {
  List<Driver> drivers = [];

  @override
  void initState() {
    super.initState();
    _loadDrivers();
  }

  Future<void> _loadDrivers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String driversJson = prefs.getString('drivers') ?? '[]';

    setState(() {
      drivers = (json.decode(driversJson) as List)
          .map((driverMap) => Driver.fromJson(driverMap))
          .toList();
    });
  }

  Future<void> _saveDrivers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String driversJson = json.encode(drivers);
    await prefs.setString('drivers', driversJson);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 199, 196, 180),
        title: Text(
          'Driver List',
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
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background_image.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: _buildDriverListView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDriverDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildDriverListView() {
    return drivers.isEmpty
        ? Center(
            child: Text('No drivers added yet. Tap the "+" button to add a driver.'),
          )
        : ListView.builder(
            itemCount: drivers.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 3.0,
                  child: ListTile(
                    title: Text('Name: ${drivers[index].name}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Age: ${drivers[index].age}'),
                        Text('Phone: ${drivers[index].phoneNo}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditDriverDialog(drivers[index]);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteDriver(index);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }

  // Function to show the add driver details dialog
  Future<void> _showAddDriverDialog() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    TextEditingController phoneNoController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add Driver Details',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: phoneNoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        // Create a new driver with entered details
                        var newDriver = Driver(
                          name: nameController.text,
                          age: int.parse(ageController.text),
                          phoneNo: phoneNoController.text,
                        );

                        setState(() {
                          drivers.add(newDriver);
                        });

                        _saveDrivers(); // Save the updated list of drivers

                        Navigator.of(context).pop();
                      },
                      child: Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to show the edit driver details dialog
  Future<void> _showEditDriverDialog(Driver driver) async {
    TextEditingController nameController = TextEditingController(text: driver.name);
    TextEditingController ageController = TextEditingController(text: driver.age.toString());
    TextEditingController phoneNoController = TextEditingController(text: driver.phoneNo);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Edit Driver Details',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: ageController,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: phoneNoController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        // Update the driver with edited details
                        setState(() {
                          driver.name = nameController.text;
                          driver.age = int.parse(ageController.text);
                          driver.phoneNo = phoneNoController.text;
                        });

                        _saveDrivers(); // Save the updated list of drivers


                        Navigator.of(context).pop();
                      },
                      child: Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to delete a driver
  void _deleteDriver(int index) {
    setState(() {
      drivers.removeAt(index);
    });

    _saveDrivers(); // Save the updated list of drivers
  }
}


