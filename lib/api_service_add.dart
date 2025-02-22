import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'vehicle_model.dart';
final baseUrl = dotenv.get('BASE_URL');
class ApiService {
  static Future<void> addVehicle(Vehicle vehicle) async {
    final url = Uri.parse('$baseUrl/api/vehicles/'); // Replace with your API endpoint
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(vehicle.toJson()),
    );

    if (response.statusCode != 201) { // Assuming 201 is the success status code
      throw Exception('Failed to add vehicle: ${response.body}');
    }
  }
}