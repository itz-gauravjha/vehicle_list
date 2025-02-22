import 'package:flutter/material.dart';
import 'package:vehicle_app/api_service_add.dart';
import 'package:vehicle_app/vehicle_model.dart'; // No prefix

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
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
      body: SingleChildScrollView(
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
              SizedBox(height: 16),
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
              SizedBox(height: 16),
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
              SizedBox(height: 16),
              TextFormField(
                controller: _registrationDateController,
                decoration: InputDecoration(
                  labelText: 'Registration Date (YYYY-MM-DD)',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the registration date';
                  }
                  return null;
                },
                readOnly: true,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _milageController,
                decoration: InputDecoration(labelText: 'Milage (km/liter)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the milage';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    double milage = double.tryParse(_milageController.text) ?? 0.0;

                    // Use the Vehicle class from vehicle_model.dart
                    Vehicle newVehicle = Vehicle(
                      vehicleName: _vehicleNameController.text,
                      model: _modelController.text,
                      registrationNo: _registrationNoController.text,
                      registrationDate: _registrationDateController.text,
                      milageKmPerLiter: milage,
                    );

                    try {
                      await ApiService.addVehicle(newVehicle);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Vehicle added successfully!')),
                      );
                      Navigator.pop(context);
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