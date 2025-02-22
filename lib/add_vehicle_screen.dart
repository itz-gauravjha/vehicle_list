import 'package:flutter/material.dart';
import 'api_service.dart';
import 'vehicle_model.dart';

class AddVehicleScreen extends StatefulWidget {
  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleNameController = TextEditingController();
  final _modelController = TextEditingController();
  final _registrationNoController = TextEditingController();
  final _registrationDateController = TextEditingController();
  final _milageController = TextEditingController();

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Default date
      firstDate: DateTime(2000), // Earliest selectable date
      lastDate: DateTime(2101), // Latest selectable date
    );
    if (picked != null) {
      setState(() {
        // Format the date as "YYYY-MM-DD" and set it in the controller
        _registrationDateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Vehicle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _vehicleNameController,
                decoration: InputDecoration(labelText: 'Vehicle Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the vehicle name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _modelController,
                decoration: InputDecoration(labelText: 'Model'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the model';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _registrationNoController,
                decoration: InputDecoration(labelText: 'Registration No'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the registration number';
                  }
                  return null;
                },
              ),
              // Date Picker Field
              TextFormField(
                controller: _registrationDateController,
                decoration: InputDecoration(
                  labelText: 'Registration Date (YYYY-MM-DD)',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context), // Open date picker
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the registration date';
                  }
                  return null;
                },
                readOnly: true, // Prevent manual editing
              ),
              TextFormField(
                controller: _milageController,
                decoration: InputDecoration(labelText: 'Milage (km/liter)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the milage';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Vehicle newVehicle = Vehicle(
                      vehicleName: _vehicleNameController.text,
                      model: _modelController.text,
                      registrationNo: _registrationNoController.text,
                      registrationDate: _registrationDateController.text,
                      milageKmPerLiter: double.parse(_milageController.text),
                    );

                    try {
                      await ApiService.addVehicle(newVehicle);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Vehicle added successfully!')),
                      );
                      Navigator.pop(context); // Go back to the previous screen
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to add vehicle: $e')),
                      );
                    }
                  }
                },
                child: Text('Add Vehicle'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _vehicleNameController.dispose();
    _modelController.dispose();
    _registrationNoController.dispose();
    _registrationDateController.dispose();
    _milageController.dispose();
    super.dispose();
  }
}