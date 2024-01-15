import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:haulier_track_app/models/driver.dart';
import 'package:haulier_track_app/models/truck.dart';

class TruckTrip {
  String task;
  String from;
  String to;
  double distance;
  DateTime date;
  TimeOfDay time;
  String assignTo;
  String truckId;

  TruckTrip({
    required this.task,
    required this.from,
    required this.to,
    required this.distance,
    required this.date,
    required this.time,
    required this.assignTo,
    required this.truckId, Driver? driver, Truck? truck,
  });

  // Convert TruckTrip object to a Map
  Map<String, dynamic> toJson() {
    return {
      'task': task,
      'from': from,
      'to': to,
      'distance': distance,
      'date': date.toIso8601String(),
      'time': '${time.hour}:${time.minute}', // Assuming TimeOfDay is used for time
      'assignTo': assignTo,
      'truckId': truckId,
    };
  }

  // Create a TruckTrip object from a Map
  factory TruckTrip.fromJson(Map<String, dynamic> json) {
    return TruckTrip(
      task: json['task'],
      from: json['from'],
      to: json['to'],
      distance: json['distance'],
      date: DateTime.parse(json['date']),
      time: _parseTimeOfDay(json['time']),
      assignTo: json['assignTo'],
      truckId: json['truckId'],
    );
  }

  // Helper method to parse time in the format "hh:mm"
  static TimeOfDay _parseTimeOfDay(String time) {
    List<String> parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
