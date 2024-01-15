import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import '../models/truck.dart';

class TruckListViewPage extends StatefulWidget {
  @override
  _TruckListViewPageState createState() => _TruckListViewPageState();
}

class _TruckListViewPageState extends State<TruckListViewPage> {
  List<Truck> trucks = [];
  
  @override
  void initState() {
    super.initState();
    _loadTrucks();
  }

  Future<void> _loadTrucks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? trucksJson = prefs.getString('trucks');

    if (trucksJson != null) {
      List<dynamic> truckList = json.decode(trucksJson);
      setState(() {
        trucks = truckList.map((truckMap) => Truck.fromJson(truckMap)).toList();
      });
    }
  }

  Future<void> _saveTrucks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String trucksJson = json.encode(trucks);
    prefs.setString('trucks', trucksJson);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 199, 196, 180),
        title: Text(
          'Truck List',
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
            child: _buildTruckListView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTruckDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTruckListView() {
    return trucks.isEmpty
        ? Center(
            child: Text('No trucks added yet. Tap the "+" button to add a truck.'),
          )
        : ListView.builder(
            itemCount: trucks.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 3.0,
                  child: ListTile(
                    title: Text(
                      'Truck ID: ${trucks[index].truckId}\nTruck Brand: ${trucks[index].brand}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Plate Number: ${trucks[index].plateNumber}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditTruckDialog(trucks[index]);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteTruck(index);
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

  Future<void> _showAddTruckDialog() async {
    TextEditingController truckIdController = TextEditingController();
    TextEditingController brandController = TextEditingController();
    TextEditingController plateNumberController = TextEditingController();

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
              color: Color.fromARGB(255, 211, 205, 193),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add Truck Details',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: truckIdController,
                  decoration: InputDecoration(
                    labelText: 'Truck ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: brandController,
                  decoration: InputDecoration(
                    labelText: 'Truck Brand',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: plateNumberController,
                  decoration: InputDecoration(
                    labelText: 'Plate Number',
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
                      onPressed: () async {
                        var newTruck = Truck(
                          truckId: truckIdController.text,
                          brand: brandController.text,
                          plateNumber: plateNumberController.text,
                        );

                        setState(() {
                          trucks.add(newTruck);
                        });

                        await _saveTrucks(); // Save the trucks after adding a new one

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

  Future<void> _showEditTruckDialog(Truck truck) async {
    TextEditingController truckIdController =
        TextEditingController(text: truck.truckId);
    TextEditingController brandController =
        TextEditingController(text: truck.brand);
    TextEditingController plateNumberController =
        TextEditingController(text: truck.plateNumber);

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
                  'Edit Truck Details',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: truckIdController,
                  decoration: InputDecoration(
                    labelText: 'Truck ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: brandController,
                  decoration: InputDecoration(
                    labelText: 'Truck Brand',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: plateNumberController,
                  decoration: InputDecoration(
                    labelText: 'Plate Number',
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
                        setState(() {
                          truck.truckId = truckIdController.text;
                          truck.brand = brandController.text;
                          truck.plateNumber = plateNumberController.text;
                        });

                        _saveTrucks();

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

  void _deleteTruck(int index) {
    setState(() {
      trucks.removeAt(index);
    });

    _saveTrucks();
  }
}
