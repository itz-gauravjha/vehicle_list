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
        title: Text('Add Vehicle', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildTextField(_vehicleNameController, 'Vehicle Name', Icons.directions_car),
                      SizedBox(height: 20),
                      _buildTextField(_modelController, 'Model', Icons.model_training),
                      SizedBox(height: 20),
                      _buildTextField(_registrationNoController, 'Registration No', Icons.confirmation_number),
                      SizedBox(height: 20),
                      _buildDateField(context),
                      SizedBox(height: 20),
                      _buildTextField(_milageController, 'Milage (km/liter)', Icons.speed),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
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
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to add vehicle: $e')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text('Add Vehicle', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildDateField(BuildContext context) {
    return TextFormField(
      controller: _registrationDateController,
      decoration: InputDecoration(
        labelText: 'Registration Date (YYYY-MM-DD)',
        prefixIcon: Icon(Icons.calendar_today, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select the registration date';
        }
        return null;
      },
      readOnly: true,
      onTap: () => _selectDate(context),
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