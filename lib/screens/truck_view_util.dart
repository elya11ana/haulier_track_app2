import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TruckUtilizationAnalyticsScreen extends StatelessWidget {
  // Sample data for the completed task schedules
  final List<CompletedTask> completedTasks = [
    CompletedTask(truckId: 'A', totalTasks: 10, totalDistance: 500, totalDestinations: 5),
    CompletedTask(truckId: 'B', totalTasks: 15, totalDistance: 700, totalDestinations: 7),
    // Add more completed tasks as needed
  ];

  @override
  Widget build(BuildContext context) {
    // Calculate aggregated data
    Map<String, int> totalTasksMap = {};
    Map<String, double> totalDistanceMap = {};
    Map<String, int> totalDestinationsMap = {};

    for (CompletedTask task in completedTasks) {
      totalTasksMap[task.truckId] = (totalTasksMap[task.truckId] ?? 0) + task.totalTasks;
      totalDistanceMap[task.truckId] = (totalDistanceMap[task.truckId] ?? 0) + task.totalDistance;
      totalDestinationsMap[task.truckId] = (totalDestinationsMap[task.truckId] ?? 0) + task.totalDestinations;
    }

    // Prepare data for the pie chart
    List<PieChartSectionData> sections = totalTasksMap.keys.map((truckId) {
      return PieChartSectionData(
        //color: getRandomColor(), // Replace with your logic for assigning colors
        value: totalTasksMap[truckId]!.toDouble(),
        title: truckId,
        radius: 50,
        titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 199, 196, 180),
        title: Text(
          'Truck Utilization Analytics',
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
                color: Color.fromARGB(255, 110, 101, 101).withOpacity(0.5), // Adjust the opacity as needed
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Display truck utilization analytics data in a pie chart
                Container(
                  height: 300,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: sections,
                      borderData: FlBorderData(show: false),
                      centerSpaceColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Color getRandomColor() {
    // Replace this with your logic for assigning colors
    //return Color((0..0xFFFFFF).random() | 0xFF000000);
  //}
}

extension RandomColor on int {
  int random() => (this & 0xFF) * 0x5F357B70;
}

class CompletedTask {
  final String truckId;
  final int totalTasks;
  final double totalDistance;
  final int totalDestinations;

  CompletedTask({
    required this.truckId,
    required this.totalTasks,
    required this.totalDistance,
    required this.totalDestinations,
  });
}