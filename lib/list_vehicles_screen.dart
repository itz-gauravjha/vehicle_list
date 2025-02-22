import 'package:flutter/material.dart';
import 'package:vehicle_app/add_vehicle_screen.dart';
import 'api_service.dart';
import 'vehicle_model.dart';

class ListVehiclesScreen extends StatefulWidget {
  @override
  _ListVehiclesScreenState createState() => _ListVehiclesScreenState();
}

class _ListVehiclesScreenState extends State<ListVehiclesScreen> {
  late Future<List<Vehicle>> futureVehicles;

  @override
  void initState() {
    super.initState();
    futureVehicles = ApiService.getVehicles();
  }

  // Helper function to calculate the life of the vehicle
  int calculateVehicleLife(DateTime registrationDate) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(registrationDate);
    return difference.inDays ~/ 365; // Return age in years
  }

  // Helper function to determine the color of the car icon
  Color getCarIconColor(double mileage, int age) {
    if (mileage >= 15 && age <= 5) {
      return Colors.green; // Fuel efficient and low pollutant
    } else if (mileage >= 15 && age > 5) {
      return Colors.amber; // Fuel efficient but moderately pollutant
    } else {
      return Colors.red; // Not fuel efficient or high pollutant
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Vehicle>>(
        future: futureVehicles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No vehicles found'));
          } else {
            List<Vehicle> vehicles = snapshot.data!;
            return ListView(
              children: [
                // Header
                Container(
                  height: 120.0, // Height of the header
                  decoration: BoxDecoration(
                    color: Colors.blue, // Background color
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // White car icon
                        Icon(Icons.directions_car, color: Colors.white, size: 40.0),
                        SizedBox(width: 10.0), // Space between icon and text
                        // "Vehicle" text
                        Text(
                          'Vehicle',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto', // Use a custom font if needed
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // List of vehicles
                ...vehicles.map((vehicle) {
                  // Parse registrationDate from String to DateTime
                  DateTime registrationDate;
                  try {
                    registrationDate = DateTime.parse(vehicle.registrationDate);
                  } catch (e) {
                    // Handle invalid date format
                    registrationDate = DateTime.now(); // Fallback to current date
                  }

                  // Calculate vehicle age
                  int age = calculateVehicleLife(registrationDate);

                  // Determine car icon color
                  Color carIconColor = getCarIconColor(vehicle.milageKmPerLiter, age);

                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          // Car symbol on the left with dynamic color
                          Icon(Icons.directions_car, size: 50.0, color: carIconColor),
                          SizedBox(width: 16.0), // Space between icon and text
                          // Vehicle details on the right
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // First line: Name + Model (e.g., Tiago - XM)
                                Text(
                                  '${vehicle.vehicleName} - ${vehicle.model}',
                                  style: TextStyle(
                                      fontSize: 18.0, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4.0),
                                // Second line: Registration number (e.g., BR06PB0002)
                                Text(
                                  vehicle.registrationNo,
                                  style: TextStyle(fontSize: 14.0),
                                ),
                                SizedBox(height: 4.0),
                                // Third line: Life of vehicle (e.g., 2 yr)
                                Text(
                                  '$age yr',
                                  style: TextStyle(fontSize: 14.0),
                                ),
                                SizedBox(height: 4.0),
                                // Fourth line: Mileage (e.g., 15.5 km/l)
                                Text(
                                  '${vehicle.milageKmPerLiter} km/l',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddVehicleScreen()),
          ).then((_) {
            setState(() {
              futureVehicles = ApiService.getVehicles(); // Refresh the list
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}