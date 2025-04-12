import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/project_model.dart';
import '../services/database_service.dart';

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
      final newProject = Project(
        id: Uuid().v4(),
        title: _titleController.text,
        description: _descController.text,
        type: _selectedType,
        location: _locationController.text,
        goalAmount: double.parse(_goalAmountController.text),
        currentAmount: 0,
      );
      await _dbService.uploadProject(newProject);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Project Uploaded!")));
      Navigator.pop(context);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Project")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: _titleController, decoration: InputDecoration(labelText: 'Title'), validator: (val) => val!.isEmpty ? 'Enter title' : null),
              TextFormField(controller: _descController, decoration: InputDecoration(labelText: 'Description'), validator: (val) => val!.isEmpty ? 'Enter description' : null),
              DropdownButtonFormField(
                value: _selectedType,
                items: ['solar', 'wind', 'hydro'].map((type) => DropdownMenuItem(value: type, child: Text(type.toUpperCase()))).toList(),
                onChanged: (value) => setState(() => _selectedType = value!),
                decoration: InputDecoration(labelText: 'Project Type'),
              ),
              TextFormField(controller: _locationController, decoration: InputDecoration(labelText: 'Location'), validator: (val) => val!.isEmpty ? 'Enter location' : null),
              TextFormField(controller: _goalAmountController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Goal Amount'), validator: (val) => val!.isEmpty ? 'Enter amount' : null),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: Text('Submit Project')),
            ],
          ),
        ),
      ),
    );
  }
}
