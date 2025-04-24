import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/project_model.dart';
import '../services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UploadProjectScreen extends StatefulWidget {
  @override
  _UploadProjectScreenState createState() => _UploadProjectScreenState();
}

class _UploadProjectScreenState extends State<UploadProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  final _goalAmountController = TextEditingController();
  String _selectedType = 'solar';

  final _dbService = DatabaseService();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final newProject = Project(
          id: Uuid().v4(),
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          type: _selectedType,
          location: _locationController.text.trim(),
          goalAmount: double.parse(_goalAmountController.text.trim()),
          currentAmount: 0,
          ownerEmail: user.email ?? '',
          ownerId: user.uid,
        );

        await _dbService.uploadProject(newProject);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Project Uploaded!")),
        );

        Navigator.pushReplacementNamed(context, '/my-projects');
      }
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Color(0xFF4CAF50)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF4CAF50), width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Upload Project"),
        centerTitle: true,
        backgroundColor: Color(0xFF4CAF50),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          width: 400, // <-- limit width here
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Create a Green Project',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tell us about your sustainable energy idea.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                  SizedBox(height: 32),

                  TextFormField(
                    controller: _titleController,
                    decoration: _inputDecoration('Title', Icons.title),
                    validator: (val) => val!.isEmpty ? 'Enter title' : null,
                  ),
                  SizedBox(height: 16),

                  TextFormField(
                    controller: _descController,
                    decoration: _inputDecoration('Description', Icons.description),
                    maxLines: 3,
                    validator: (val) => val!.isEmpty ? 'Enter description' : null,
                  ),
                  SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    items: ['solar', 'wind', 'hydro'].map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedType = value!),
                    decoration: _inputDecoration('Project Type', Icons.category),
                  ),
                  SizedBox(height: 16),

                  TextFormField(
                    controller: _locationController,
                    decoration: _inputDecoration('Location', Icons.location_on),
                    validator: (val) => val!.isEmpty ? 'Enter location' : null,
                  ),
                  SizedBox(height: 16),

                  TextFormField(
                    controller: _goalAmountController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration('Goal Amount (USD)', Icons.attach_money),
                    validator: (val) => val!.isEmpty ? 'Enter amount' : null,
                  ),
                  SizedBox(height: 32),

                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4CAF50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Submit Project',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
