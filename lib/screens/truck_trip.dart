import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/driver.dart';
import '../models/trip_details.dart';
import 'package:haulier_track_app/screens/truck_sched.dart';

import '../models/truck.dart'; // Update the import as needed

class TruckTripScreen extends StatefulWidget {
  final Function(TruckTrip) onTripUpdated;
  final List<TruckTrip> truckTrips;
  final List<Driver> drivers; // List of drivers
  final List<Truck> trucks; // List of trucks
  TruckTripScreen({
    required this.onTripUpdated, 
    required this.truckTrips,
    required this.drivers,
    required this.trucks,
    });

  TruckTripScreen.withData({
    required this.onTripUpdated,
    required this.truckTrips,
    required this.drivers,
    required this.trucks,
  });

  @override
  _TruckTripScreenState createState() => _TruckTripScreenState();
}

class _TruckTripScreenState extends State<TruckTripScreen> {
  final TextEditingController taskController = TextEditingController();
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final TextEditingController assignToController = TextEditingController();
  final TextEditingController truckIdController = TextEditingController();

  TruckTrip? editingTrip;

  List<TruckTrip> truckTrips = []; // Store truck trips

  @override
  void initState() {
    super.initState();
    _loadTruckTrips();
  }

  Future<void> _loadTruckTrips() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tripsJson = prefs.getString('truckTrips') ?? '[]';

    setState(() {
      truckTrips = (json.decode(tripsJson) as List)
          .map((tripMap) => TruckTrip.fromJson(tripMap))
          .toList();
    });
  }

  Future<void> _saveTruckTrips() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tripsJson = json.encode(truckTrips);
    await prefs.setString('truckTrips', tripsJson);
  }

  // DropdownButton value holders
  Driver? selectedDriver;
  Truck? selectedTruck;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 199, 196, 180),
        title: Text(
          'Truck Trips',
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
        centerTitle: true,
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
                color: Color.fromARGB(255, 213, 206, 206).withOpacity(0.5), // Adjust the opacity as needed
              ),
            ),
          ),

          // Existing UI
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField('Task', Icons.work, taskController),
                const SizedBox(height: 5),
                _buildTextField('From', Icons.location_on, fromController),
                const SizedBox(height: 5),
                _buildTextField('To', Icons.location_on, toController),
                const SizedBox(height: 5),
                _buildTextField('Distance (km)', Icons.confirmation_number, distanceController, TextInputType.number),
                const SizedBox(height: 5),
                _buildDateRow(),
                const SizedBox(height: 5),
                _buildTimeRow(),
                const SizedBox(height: 5),
                _buildTextField('Assign To', Icons.person, assignToController),
                const SizedBox(height: 5),
                _buildTextField('Truck ID', Icons.confirmation_number, truckIdController),
                const SizedBox(height: 5),
                _buildDriverDropdown(),
                const SizedBox(height: 5),
                _buildTruckDropdown(),
                const SizedBox(height: 5),
                _buildElevatedButton(),
                const SizedBox(height: 5),
                _buildCancelButton(),
                const SizedBox(height: 5),
                _buildTruckTripList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller, [TextInputType? inputType]) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Enter $label',
        prefixIcon: Icon(
          icon,
          size: 30,
          color: Color.fromARGB(255, 91, 81, 64),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16), // Adjust the padding as needed
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildDateRow() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Date: ${selectedDate.toLocal()}'.split(' ')[0],
            style: TextStyle(fontSize: 18),
          ),
        ),
        TextButton(
          onPressed: () => _selectDate(context),
          child: const Text('Select Date'),
        ),
      ],
    );
  }

  Widget _buildTimeRow() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Time: ${selectedTime.format(context)}',
            style: TextStyle(fontSize: 18),
          ),
        ),
        TextButton(
          onPressed: () => _selectTime(context),
          child: const Text('Select Time'),
        ),
      ],
    );
  }

  Widget _buildElevatedButton() {
    return ElevatedButton(
      onPressed: editingTrip != null ? _updateTruckTrip : _createTruckTrip,
      child: Text(editingTrip != null ? 'Update Truck Trip' : 'Create Truck Trip'),
      style: ElevatedButton.styleFrom(
        primary: Colors.green,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return ElevatedButton(
      onPressed: editingTrip != null ? _cancelEditing : null,
      child: const Text('Cancel Editing'),
      style: ElevatedButton.styleFrom(
        primary: Colors.orange,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildTruckTripList() {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.truckTrips.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.truckTrips[index].task),
            subtitle: Text(
              'From: ${widget.truckTrips[index].from}, To: ${widget.truckTrips[index].to}, Distance: ${widget.truckTrips[index].distance} km\n'
              'Date: ${widget.truckTrips[index].date.toLocal()} ${widget.truckTrips[index].time.format(context)}\n'
              'Assign To: ${widget.truckTrips[index].assignTo}, Truck ID: ${widget.truckTrips[index].truckId}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _startEditing(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteTruckTrip(index),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDriverDropdown() {
    return DropdownButton<Driver>(
      value: selectedDriver,
      hint: Text('Select Driver'),
      onChanged: (Driver? newValue) {
        setState(() {
          selectedDriver = newValue;
        });
      },
      items: widget.drivers.map((Driver driver) {
        return DropdownMenuItem<Driver>(
          value: driver,
          child: Text(driver.name),
        );
      }).toList(),
    );
  }

  Widget _buildTruckDropdown() {
    return DropdownButton<Truck>(
      value: selectedTruck,
      hint: Text('Select Truck'),
      onChanged: (Truck? newValue) {
        setState(() {
          selectedTruck = newValue;
        });
      },
      items: widget.trucks.map((Truck truck) {
        return DropdownMenuItem<Truck>(
          value: truck,
          child: Text('Truck ID: ${truck.truckId}, Brand: ${truck.brand}'),
        );
      }).toList(),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _createTruckTrip() {
    // Create a new truck trip
    TruckTrip newTrip = TruckTrip(
      task: taskController.text,
      from: fromController.text,
      to: toController.text,
      distance: double.tryParse(distanceController.text) ?? 0.0,
      date: selectedDate,
      time: selectedTime,
      assignTo: assignToController.text,
      truckId: truckIdController.text,
    );

    _saveTruckTrips();

    // Add the new trip to the list
    setState(() {
      truckTrips.add(newTrip);
    });

    // Clear input fields
    _clearInputFields();

    // Call the callback function with the new truck trip
    widget.onTripUpdated(newTrip);

    // Navigate to the previous screen
    Navigator.pop(context);

    // Access the selected driver and truck
    if (selectedDriver != null) {
      print('Selected Driver: ${selectedDriver!.name}');
    }

    if (selectedTruck != null) {
      print('Selected Truck: ${selectedTruck!.truckId}');
    }
  }

  void _updateTruckTrip() {
    // Update the editing trip with the new values
    editingTrip!.task = taskController.text;
    editingTrip!.from = fromController.text;
    editingTrip!.to = toController.text;
    editingTrip!.distance = double.tryParse(distanceController.text) ?? 0.0;
    editingTrip!.date = selectedDate;
    editingTrip!.time = selectedTime;
    editingTrip!.assignTo = assignToController.text;
    editingTrip!.truckId = truckIdController.text;

_saveTruckTrips();
    // Reset editingTrip
    setState(() {
      editingTrip = null;
    });

    // Clear input fields
    _clearInputFields();

    // Go back to the previous screen
    Navigator.pop(context);

    // Call the callback function with the updated truck trip
    widget.onTripUpdated(editingTrip!);
  }

  void _cancelEditing() {
    // Reset editingTrip
    setState(() {
      editingTrip = null;
    });

    // Clear input fields
    _clearInputFields();

    // Go back to the previous screen
    Navigator.pop(context);
  }

  void _deleteTruckTrip(int index) {
    // Delete the truck trip at the specified index
    setState(() {
      truckTrips.removeAt(index);
    });
    _saveTruckTrips();
  }

  void _startEditing(int index) {
    // Start editing the truck trip at the specified index
    setState(() {
      editingTrip = truckTrips[index];
    });

    // Load the editingTrip data into the input fields
    taskController.text = editingTrip!.task;
    fromController.text = editingTrip!.from;
    toController.text = editingTrip!.to;
    distanceController.text = editingTrip!.distance.toString();
    selectedDate = editingTrip!.date;
    selectedTime = editingTrip!.time;
    assignToController.text = editingTrip!.assignTo;
    truckIdController.text = editingTrip!.truckId;
  }

  void _clearInputFields() {
    // Clear input fields
    taskController.clear();
    fromController.clear();
    toController.clear();
    distanceController.clear();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
    assignToController.clear();
    truckIdController.clear();
  }
}
