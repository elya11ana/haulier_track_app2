import 'package:flutter/material.dart';
import '../models/truck.dart';

class TruckDataProvider with ChangeNotifier {
  List<Truck> _trucks = [];

  List<Truck> get trucks => _trucks;

  void addTruck(Truck truck) {
    _trucks.add(truck);
    notifyListeners();
  }

  void updateTruck(int index, Truck truck) {
    _trucks[index] = truck;
    notifyListeners();
  }

  void deleteTruck(int index) {
    _trucks.removeAt(index);
    notifyListeners();
  }
}
