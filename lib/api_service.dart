import 'dart:convert';
import 'package:http/http.dart' as http;
import 'vehicle_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final baseUrl = dotenv.get('BASE_URL');
class ApiService {
  
  // Fetch all vehicles
  static Future<List<Vehicle>> getVehicles() async {
    final response = await http.get(Uri.parse('$baseUrl/api/vehicles'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((vehicle) => Vehicle.fromJson(vehicle)).toList();
    } else {
      throw Exception('Failed to load vehicles');
    }
  }

  // Add a new vehicle
  static Future<void> addVehicle(Vehicle vehicle) async {
    final jsonPayload = json.encode(vehicle.toJson());
    print('Sending JSON payload: $jsonPayload');

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonPayload,
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 201) {
      throw Exception('Failed to add vehicle: ${response.body}');
    }
  }
}